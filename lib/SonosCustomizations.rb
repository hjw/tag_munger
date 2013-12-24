#!/usr/bin/env ruby

require 'fileutils'
#require 'taglib'
require 'pp'

###########################################
# TapeLibCustomizations is a class that we use to manipulate the international
# tape library to better suit our puposes.
# It has a number of
# methods which are very specific to the things that VMC chooses
# to do to mimic the old minidisc organization when using
# the Sonos system.
class TapeLibCustomizations

  #########################################
  # The TapeLibCustomizations object defaults to work on the current directory
  # and to have non-destructive behavior. You can, of course pass in parameters
  # to override this behavior ----> this function is currently
  # duplicated in the TagMunger class and should be refactored <-----
  def initialize(library_root=".", dry_run=true)
    @library_root = library_root
    @dry_run = dry_run
  end

  ########################################
  # Check for a directory called Sonos-Customizations
  # and create if it doesn't exhist. If it does exhist
  # print out it's contents.
  # returns true if the directory exhists or is successfully
  # created.
  def custom_directory?
     # directory exists?
       # print dir path and contents
       # return true
     # else create directory
  end 

  ########################################
  # Print report of the passed in directory tree
  # List non-mp3 files.
  # List mp3 files that do not match "#{@library_root}/**/D[0-9][0-9]_*.mp3"
  # List mp3 files that DO match "#{@library_root}/**/D[0-9][0-9]_*.mp3"
  #   matches are currently found using a private select method
  #   which happens to use Dir.glob to find the files
  def lib_browser
  end

  #######################################
  # Create copies of the desired files and puts 
  # them into the customizations directory.
  #
  # Also customizes their mp3 metadata tags.
  def fill_customization_director
  end

  #######################################
  # beginning of private class file
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
