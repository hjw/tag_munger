#!/usr/bin/env ruby

require 'optparse'

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
    options[:browse] = flags
  end

  opts.on("-d LIBRARY_ROOT","--directory LIBRARY_ROOT", "Where to find the mp3 files") do |library_root|
    options[:directory] = library_root
  end

  opts.on("--albums", "Deal with album info") do |a|
    options[:albums] = a
  end
  
end.parse!

##p options
##p ARGV


