#!/usr/bin/env ruby

require 'fileutils'
require 'taglib'
require 'pp'

class TagMunger
  def initialize(library_root)
    @library_root = library_root
  end

  def browseLibrary(which_tags)
    file_list = []
    tags = [ "album", "track"]
    if which_tags
      tags.select! { |t| which_tags.include?(t)}
    end
    pp "Tags being checked for are: #{tags}"

    Dir.glob("#{@library_root}/**/*.mp3") do |name|
      file_list << name
    end

    if file_list.length == 0
      pp "No .mp3 files found below root: #{@library_root}"
    else
      pp "Found #{file_list.count} mp3 files below #{File.expand_path(@library_root)}."
    end

    file_list.each do |name|
      ok = TagLib::FileRef.open(name) do |f|
        output = "#{name} --> "
        tags.each do |t|
          output << " #{t}: #{f.tag.send(t)}"
        end
        puts output
      end
      if ok == false then
        puts "uh-oh. There was a problem opening #{name}"
      end
    end

  end
end
