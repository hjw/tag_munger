#!/usr/bin/env ruby

#$LOAD_PATH.push File.expand_path("../../lib",__FILE__)
require 'optparse'
require_relative '../lib/futest'
require_relative '../lib/tag_munger'

VERSION="version 0.0.1"

options = {}
# defaults
options[:directory] = "."


OptionParser.new do |opts|
  opts.banner = "Usage: tag_utility.rb [options]"
  opts.version = VERSION

  opts.on("-b [FLAGS]","--browse [FLAGS]",\
          "\n\t\tDisplay the current mp3 metadata.\n\t\tTakes optional, comma separated list of tags you're interested in (album,track)") do |flags|
    #options.inplace = true
    #options.extension = flags || ''
    options[:browse] = flags || true
  end

  opts.on("-d LIBRARY_ROOT","--directory LIBRARY_ROOT", "Where to find the mp3 files") do |library_root|
    options[:directory] = library_root
  end

  opts.on("--albums", "Deal with album info") do |a|
    options[:albums] = a
  end
  
end.parse!

Futest.greet
p options
p ARGV

tagger = TagMunger.new(options[:directory])
if options[:browse].class == String
  which_tags =  options[:browse].split(",")
end

p "which_tags: #{which_tags}"

tagger.browseLibrary(which_tags)

