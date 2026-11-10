# frozen_string_literal: true

require "digest"
require "json"
require "open3"
require "tmpdir"

module Release
  CHECKSUM_LINE = /\A([0-9a-f]{64})  ([A-Za-z0-9._-]+)\z/

  module_function

  def gh(repo, *args)
    out, status = Open3.capture2("gh", *args, "--repo", repo)
    raise "gh #{args.first(2).join(" ")} failed (exit #{status.exitstatus})" unless status.success?

    out
  end

  def version_parts(version)
    version.split(".").map(&:to_i)
  end

  def parse_checksums(text)
    checksums = {}
    text.each_line(chomp: true) do |line|
      match = CHECKSUM_LINE.match(line)
      raise "Malformed or duplicate checksum entry" if match.nil? || checksums.key?(match[2])

      checksums[match[2]] = match[1]
    end
    checksums
  end

  def download(repo, tag, pattern, dir)
    gh(repo, "release", "download", tag, "--pattern", pattern, "--dir", dir)
  end

  def release_info(repo, first_release_ok)
    JSON.parse(gh(repo, "release", "view", "--json", "tagName,isDraft,isPrerelease,assets"))
  rescue RuntimeError
    raise unless first_release_ok
    raise unless gh(repo, "release", "list", "--limit", "1").strip.empty?

    puts "#{repo}: waiting for the first release"
    nil
  end

  # Updates a formula or cask after a complete, verified stable release.
  #
  # path:             "Formula/name.rb" or "Casks/name.rb"
  # previous:         regexp whose first group is the version in that file
  # archives:         ->(version) { {target => archive name} }
  # manifest:         ->(version) { name of the file listing "HASH  NAME" lines }
  # render:           ->(version, archives, checksums) { file text }
  # prefix:           what comes before the version in the release tag
  # first_release_ok: wait quietly when the repository has no release,
  #                   and treat a missing file as empty
  def update(repo:, path:, previous:, archives:, manifest:, render:, prefix: "v", first_release_ok: true)
    release = release_info(repo, first_release_ok)
    return unless release

    tag = release["tagName"]
    if release["isDraft"] || release["isPrerelease"] || !/\A#{Regexp.escape(prefix)}\d+\.\d+\.\d+\z/.match?(tag)
      raise "Expected a stable #{prefix}MAJOR.MINOR.PATCH release"
    end

    version = tag.delete_prefix(prefix)
    name = File.basename(path, ".rb")
    kind = path.start_with?("Casks/") ? "cask" : "formula"
    current = first_release_ok && !File.exist?(path) ? "" : File.read(path)
    old = previous.match(current)
    raise "Refusing to downgrade the #{kind}" if old && (version_parts(old[1]) <=> version_parts(version)) == 1

    names = release["assets"].map { |asset| asset["name"] }
    manifest_name = manifest.call(version)
    archive_names = archives.call(version)
    missing = archive_names.values + [manifest_name] - names
    unless missing.empty?
      puts "#{tag}: waiting for #{missing.join(", ")}"
      return
    end

    Dir.mktmpdir do |tmp|
      download(repo, tag, manifest_name, tmp)
      checksums = parse_checksums(File.read(File.join(tmp, manifest_name)))
      if checksums.keys.sort != archive_names.values.sort
        raise "#{manifest_name} must list exactly #{archive_names.values.join(", ")}"
      end

      text = render.call(version, archive_names, checksums)
      if text == current
        puts "#{tag}: #{kind} already current"
        return
      end
      archive_names.each_value do |archive|
        download(repo, tag, archive, tmp)
        actual = Digest::SHA256.file(File.join(tmp, archive)).hexdigest
        raise "Checksum mismatch for #{archive}" if actual != checksums[archive]
      end
      File.write(path, text)
    end
    puts "Updated #{name} to #{tag}"
    write_output(version)
  end

  def write_output(version)
    output = ENV["GITHUB_OUTPUT"]
    return if output.nil? || output.empty?

    File.open(output, "a") do |handle|
      handle.write("changed=true\n")
      handle.write("version=#{version}\n")
    end
  end

  def asset_stanza(repo, version, name, sha256, pad)
    %(url "https://github.com/#{repo}/releases/download/v#{version}/#{name}"\n) +
      %(#{pad}sha256 "#{sha256}")
  end
end
