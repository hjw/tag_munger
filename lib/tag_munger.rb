#!/usr/bin/env ruby

require 'fileutils'
require_relative 'media_editor'
require 'pp'

###########################################
# TagMunger is a class that we use to manipulate mp3 tags.
# It uses the external library 'taglib' and has a number of
# methods which are very specific to the things that VMC chooses
# to do to mimic the old minidisc organization when using
# the Sonos system.
class TagMunger
  include MediaEditor
  
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
    tags = [ "album", "artist", "track", "title"]
    if which_tags
      tags.select! { |t| which_tags.include?(t)}
    end

    file_list = select_files("#{@library_root}/**/*.mp3")

    if file_list.length == 0
      puts "No .mp3 files found below root: #{@library_root}"
    else
      puts "#{file_list.count} mp3 files found below root: #{@library_root}"
    end

    print_metadata(file_list, tags)
  end

  ################################################################
  # Interactively edit tags. Given a file name,
  # displays tag info, prompts for tag to edit, changes that tag.
  #
  def interactive_edit(fileName)
    file_list = []
    tags = [ "title","album", "artist", "track", "genre"]

    quit = "n"
    until quit == "q"
      puts "Current metadata for file:"
      print_metadata(fileName, tags)

      print "What tag would you like to change? (#{tags.join(", ")}): "
      tag_name = gets.chomp
      print "What would you like to set it to? "
      tag_value = gets.chomp
      set_metadata(fileName, {tag_name  =>tag_value})

      puts "Current metadata for file is now: "
      print_metadata(fileName, tags)

      print "Quit [q], or continue [c]? "
      quit = gets.chomp
    end

  end

  #########################################
  # Global fixing of album tags. (Runs in the librayr_root directory tree)
  #
  # Set all mp3 files that start with D## to have an 
  # album tag of D##_courseType.  
  # 
  # The course type is scraped from the last word in the file name (after the last '_" underbar and before the final '.').
  #
  # ie: fix_album_tags sets album tag to *D01_10d* for a file named *D01_1910_Disc_English_10d.mp3*
  def fix_album_tags
    file_list = []
    file_list = select_files("#{@library_root}/**/D[0-9][0-9]_*.mp3")

    album_name = ""
    temp_hash = {}

    # create album_name from file name 
    # "D09_0855_GS_10d.mp3" gets album "D09_10d"
    # "D09_0855_GS_STP.mp3" gets album "D09_STP"
    file_list.each do |name|
      w = (File.basename(name)).split("_")
      album_name = [ w[0],  w[-1].chomp(".mp3")].join("_")
      temp_hash[name] = album_name
    end

    if !@dry_run then
      puts "New album data prepared, now hold on while I write it into the #{file_list.count} mp3 files."
      temp_hash.each do |file_name, album_tag|
        set_metadata(file_name, album:album_tag)
      end
    else #@dry_run == true
      puts "You are in dry run mode.\nIf you weren't in dry run mode the following changes would be made:"
      pp temp_hash.sort
    end
    puts "finished the global album name fix."
  end #end.fix_album_tags

  #####################################
  # set_album(file_list,album)
  #
  # takes an array of file names (full path)
  # and sets their album tag to be albumj
  # ##################################
  def set_album(file_list, album_name)
    set_metadata(file_list, album:album_name)
  end

  #####################################
  # set_track(file_list,track_num)
  #
  # takes an array of file names (full path)
  # and sets their track tag to be track_num
  # ##################################
  def set_track(file_list, track_num)
    set_metadata(file_list, track:track_num)
  end
  
  private

  def select_files(match_string)
    file_list=[]
    Dir.glob(match_string) do |name|
      file_list << name
    end
    if file_list.length == 0
      puts "empty file list from root: #{@library_root}"
    else
      puts "file_list is #{file_list.count} long."
    end
    file_list
  end

end
