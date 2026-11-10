# frozen_string_literal: true

# Shared release check and verification for the update scripts.
require "digest"
require "json"
require "open3"
require "tmpdir"

module BinaryFormula
  CHECKSUM_LINE = /\A([0-9a-f]{64})  ([A-Za-z0-9._-]+)\z/
  STABLE_TAG = /\Av\d+\.\d+\.\d+\z/

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

  # Updates Formula/<name>.rb after a complete, verified stable release.
  #
  # previous:         regexp whose first group is the version in the formula
  # first_release_ok: wait quietly when the repository has no release,
  #                   and treat a missing formula as empty
  # archives:         ->(tag, version) { {target => archive name} }
  # manifest:         ->(tag, version) { checksum manifest name }
  # waiting, exactly: phrases for the "waiting" and manifest error messages
  # render:           ->(version, archives, checksums) { formula text }
  def update(repo:, name:, previous:, first_release_ok:, archives:, manifest:, waiting:, exactly:, render:)
    release = release_info(repo, first_release_ok)
    return unless release

    tag = release["tagName"]
    if release["isDraft"] || release["isPrerelease"] || !STABLE_TAG.match?(tag)
      raise "Expected a stable vMAJOR.MINOR.PATCH release"
    end

    version = tag[1..]
    formula_path = "Formula/#{name}.rb"
    current = first_release_ok && !File.exist?(formula_path) ? "" : File.read(formula_path)
    old = previous.match(current)
    raise "Refusing to downgrade the formula" if old && (version_parts(old[1]) <=> version_parts(version)) == 1

    names = release["assets"].map { |asset| asset["name"] }
    manifest_name = manifest.call(tag, version)
    archive_names = archives.call(tag, version)
    unless (([manifest_name] + archive_names.values) - names).empty?
      puts "#{tag}: waiting for #{waiting} and #{manifest_name}"
      return
    end

    Dir.mktmpdir do |tmp|
      download(repo, tag, manifest_name, tmp)
      checksums = parse_checksums(File.read(File.join(tmp, manifest_name)))
      raise "Checksum manifest must describe exactly #{exactly}" if checksums.keys.sort != archive_names.values.sort

      formula = render.call(version, archive_names, checksums)
      if formula == current
        puts "#{tag}: formula already current"
        return
      end
      archive_names.each_value do |archive|
        download(repo, tag, archive, tmp)
        actual = Digest::SHA256.file(File.join(tmp, archive)).hexdigest
        raise "Checksum mismatch for #{archive}" if actual != checksums[archive]
      end
      File.write(formula_path, formula)
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
