#!/usr/bin/env ruby
# frozen_string_literal: true

# Update the rePossess cask only after a complete, verified stable release.
require_relative "binary_formula"

REPO = "mattt/rePossess"
CASK = "Casks/repossess.rb"

release = JSON.parse(BinaryFormula.gh(REPO, "release", "view", "--json", "tagName,isDraft,isPrerelease,assets"))
tag = release["tagName"]
if release["isDraft"] || release["isPrerelease"] || !/\A\d+\.\d+\.\d+\z/.match?(tag)
  raise "Expected a stable MAJOR.MINOR.PATCH release"
end

current = File.read(CASK)
previous = /^  version "(\d+\.\d+\.\d+)"$/.match(current)
raise "The cask has no version line" unless previous
if (BinaryFormula.version_parts(previous[1]) <=> BinaryFormula.version_parts(tag)) == 1
  raise "Refusing to downgrade the cask"
end
if previous[1] == tag
  puts "#{tag}: cask already current"
  exit
end

archive = "rePossess-#{tag}.zip"
checksum = "#{archive}.sha256"
names = release["assets"].map { |asset| asset["name"] }
unless ([archive, checksum] - names).empty?
  puts "#{tag}: waiting for #{archive} and #{checksum}"
  exit
end

actual = Dir.mktmpdir do |tmp|
  BinaryFormula.download(REPO, tag, checksum, tmp)
  match = /\A([0-9a-f]{64})  #{Regexp.escape(archive)}\n?\z/.match(File.read(File.join(tmp, checksum)))
  raise "Malformed #{checksum}" unless match

  BinaryFormula.download(REPO, tag, archive, tmp)
  digest = Digest::SHA256.file(File.join(tmp, archive)).hexdigest
  raise "Checksum mismatch for #{archive}" if digest != match[1]

  digest
end

updated = current.sub(/^  version ".*"$/) { %(  version "#{tag}") }
updated = updated.sub(/^  sha256 ".*"$/) { %(  sha256 "#{actual}") }
File.write(CASK, updated)
puts "Updated repossess to #{tag}"
BinaryFormula.write_output(tag)
