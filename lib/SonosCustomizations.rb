#!/usr/bin/env ruby

require 'fileutils'
#require 'taglib'
require 'pp'

#####################################################
# Previously the library massaging was done by a big
# monolithic ruby script. It used the following steps:
#
# 1. create a Morning Chantings directory in the customizations dir
#   a. copy the 10day chanting files to that dir and change their filename
#      so that they get picked up by the global album name setter function.
# 2. run  global album tag setter code
#      this finds all files matching
#      "D[#][#]*.mp3"  ( start with D##, end with .mp3 )
#      and gives them and album tag of D##_<courseType>
#      ie: makes file D01_1910_Disc_English_10d.mp3 
#      have the album name D01_10d
# 3. Set track number of all discourse files to be 200.
#      this is done to insure that all the discourses show up as the last
#      track in the day's album.
# 4. Set the album name of the original morning chanting files to be
#      10 Day Chantings.
# 5. Set all files in the Groupsittings folder to be grouped by language
#    ie E_Group Sittings or H_Group Sittings
# 6. Set Dohas files to have the album tag "Dohas"
# 7. Set regular (sutas/satip/tik) special chantings to have album "Special_Chanting"
# 8. Set Gong files to be in a _Gong album (under bar inluded to keep at top of list)
# 9. Put Worker's metta files into a Workers_Metta album
# 10.Check that 30/45 day course files have proper album tags and that the 45dayA course has a different album name.
#
# #################
# FYI:
# current tape library name scheme:
#   STP : Satipatthana
#   TSC : Teacher's Self Course
#   SPL or 10dSpl : Special 10
###########################
# SpecialChantings/Tikapatthana-U_Ba_Khin.mp3
# needs to be included in every course
# --> duplication doesn't solve the problem.
# --> instead, include the file in each course, It will show up
# --> in an album called Special Chantings.
###########################

###########################
# STP (Satipatthana course) needs to have the chanting 
# from Special Chantings/Satipatthana_Sutta_Jan_1985_wSM.mp3
# included in every day. but not the other daily chantings
# from the 10day
#
###########################
# Special Chantings/Satipatthana_Sutta_Jan_1985_WSM.mp3 file needs to be duplicated
# and renamed with D01 to D09 prefix
# and given respective album title.
# Duplicates need to reside in their own STPdupes directory
# which needs to be included in the satipatthana library
###########################

##########################
#  3 Day course should have a chanting album
#  containing all chantings with the album title tag of Chanting
#
##########################
##################

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

  ########################################
  # Morning Chantings:
  #
  # We give an album tag of Morning_Chantings to the morning chanting files
  # in their original tape library location. These are meant to be used
  # during non-10day courses (workperiods, long courses, 9-days, 3-days etc).
  #
  # We also create a 10DayChantings directory within the customizations
  # directory. We create copies of the 10Day Morning chantings, set
  # their track number to be 1  and change their
  # name to end with _10d.mp3 (so that the global album
  # name sections acts on them).
  # These chanting files in the customizations directory  are meant 
  # to be included in 10 day courses.
  def morning_chanting
  end

  #########################################
  # Set track number of all discourse files to be 200.
  # this high track number is necessary because of high track numbers
  # associated with long course file (45 day course has tracks in the 100's).
  # There is an expectation that all files with a filename containing
  # _Disc_ are discourse file.
  #
  # this is being done to ensure that the discourses show up last on the 
  # days album.
  #
  # There is redundancy between this section and the global album name
  # section. That is on purpose, because the global album name 
  # loop takes a long time. If we only need to modify the track
  # number of the discourse files, the code below allows us to
  # do that more quickly then if we process all D##_*.mp3 files.
  #
###
  #This code was copied from the old procedural file and needs to be
  #fixed and or checked so that it works within the context of the 
  #  TapeLibCustomizations class
##  def set_discourse_track_numbers
##    puts "beginning the giant global discourse track fix."
##    file_list = []
##    library_root = "./"
##
##    Dir.glob(library_root + "**/D[0-9][0-9]_*_Disc_*.mp3") do |name|
##      file_list << name
##    end
##    if file_list.length == 0
##      pp "empty file list from root: #{library_root}"
##    else
##      pp file_list if DRY_RUN
##      pp "file_list is #{file_list.count} long."
##    end
##    puts "got the file list. Beginning to set the track numbers."
##    file_list.each do |file_name|
##      ok = TagLib::FileRef.open(file_name) do |f|
##        tag = f.tag
##        tag.track = 200
##        f.save
##      end
##      if ok == false then
##        puts "uh-oh.  There was a problem saving / opening #{file_name}"
##      end
##    end
##    puts "finished the giant global discourse track fix."
##  end

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
