#!/usr/bin/env ruby

############################
# tag_utility.rb
# A small utility which will let you display album and track 
# tag information from mp3 files and will allow you to apply
# our album name generator for mp3 files in the "tape library"
# 

#$LOAD_PATH.push File.expand_path("../../lib",__FILE__)
require 'optparse'
require_relative '../lib/tag_munger' #the class that handles our munging

VERSION="version 0.0.1"

options = {}
# defaults
options[:directory] = "."
options[:dry_run] = true


OptionParser.new do |opts|
  opts.banner = "Usage: tag_utility.rb [options] ***Defaults to dry_run/report mode***\n\t\tSpecify --write-changes option to actually change tags"
  opts.version = VERSION

  opts.on("-b [FLAGS]","--browse [FLAGS]",\
          "\n\t\tDisplay the current mp3 metadata.\n\t\tTakes optional, comma separated list of tags you're interested in (album,track)") do |flags|
    options[:browse] = flags || true
  end

  opts.on("-d LIBRARY_ROOT","--directory LIBRARY_ROOT", "Where to find the mp3 files") do |library_root|
    options[:directory] = library_root
  end

  opts.on("-a","--albums", "Derive new album tag for mp3 files") do |a|
    # runs the generic album name generator. Does a dry run by default
    options[:albums] = a
  end

  opts.on("--write-changes", "Changes the tags in the files (takes you out of dry run mode)") do |w|
    options[:dry_run] = false
  end
  
end.parse!

tagger = TagMunger.new(options[:directory], options[:dry_run])

if options.has_key?(:browse)
  if options[:browse].class == String
    which_tags =  options[:browse].split(",")
  end
  tagger.browseLibrary(which_tags)
end

if options.has_key?(:albums)
  tagger.fix_album_tags
end

