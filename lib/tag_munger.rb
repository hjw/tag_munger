#!/usr/bin/env ruby

require 'fileutils'
require 'taglib'
require 'pp'

###########################################
# TagMunger is a class that we use to manipulate mp3 tags.
# It uses the external library 'taglib' and has a number of
# methods which are very specific to the things that VMC chooses
# to do to mimic the old minidisc organization when using
# the Sonos system.
class TagMunger
  
  #########################################
  # The TagMunger object defaults to work on the current directory
  # and to have non-destructive behavior. You can, of course pass in parameters
  # to override this behavior
  def initialize(library_root=".", dry_run=true)
    @library_root = library_root
    @dry_run = dry_run
  end

  ########################################
  # Display the album,artist and track tags for 
  # mp3 files in the library. You can pass in an array
  # of strings with the tags that you'd like to check.
  #
  # This method simply outputs to stdout.
  #
  # Prints out the file name, and then the requested tags
  # for each mp3 file in the library directory tree
  def browseLibrary(which_tags)
    file_list = []
    tags = [ "album", "artist", "track"]
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
  #########################################
  # Global fixing of album tags. (Runs in the librayr_root directory tree)
  #
  # Set all mp3 files that start with D## to have an 
  # album tag of D##_courseType.  
  # 
  # The course type is scraped from the file name.
  #
  # ie: fix_album_tags sets album tag to *D01_10d* for a file named *D01_1910_Disc_English_10d.mp3*
  def fix_album_tags
    file_list = []
    file_list = select_files("#{@library_root}/**/D[0-9][0-9]_*.mp3")

    album_name = ""
    temp_hash = {}

    # create album_name from file name 
    # "D09_0855_GS_10d.mp3" gets album "D09_10d"
    file_list.each do |name|
      w = (File.basename(name)).split("_")
      album_name = [ w[0],  w[-1].chomp(".mp3")].join("_")
      temp_hash[name] = album_name
    end

    if !@dry_run then
      puts "New album data prepared, now hold on while I write it into the #{file_list.count} mp3 files."
      temp_hash.each do |file_name, album_tag|
        ok = TagLib::FileRef.open(file_name) do |f|
          tag = f.tag
          tag.album = album_tag
          f.save
        end
        if ok == false then
          puts "uh-oh.  There was a problem saving / openning #{file_name}"
        end
      end
    else #@dry_run == true
      puts "You are in dry run mode.\nIf you weren't in dry run mode the following changes would be made:"
      pp temp_hash.sort
    end
    puts "finished the global album name fix."
  end #end.fix_album_tags
  private

  def select_files(match_string)
    file_list=[]
    Dir.glob(match_string) do |name|
      file_list << name
    end
    if file_list.length == 0
      pp "empty file list from root: #{@library_root}"
    else
      pp "file_list is #{file_list.count} long."
    end
    file_list
  end
end
