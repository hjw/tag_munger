#!/usr/bin/env ruby

############################
# =fix_lib.rb
#
# code to do the library customizations
# necessary for using the worldwide tape library on 
# the Sonos system.
#
# A small utility which will let you display album and track 
# tag information from mp3 files and will allow you to apply
# our album name generator for mp3 files in the "tape library"
# 
# It is the morning chantings directory within the customizations directory
# that should be included in 10 day courses. 
#
# For non-10day courses you should include the morning chantings directory
# from the regular tape library tree.

require 'optparse'
#require_relative '../lib/tag_munger' #the class that handles our munging
require_relative '../lib/vmc_sonos_customizations' #the class that handles our munging

VERSION="version 0.0.1"

my_options = {}
# defaults
my_options[:directory] = "."
my_options[:interactive] = true
directory_names = {}

###############################################
# Do the full set of vmc customizations to a tape
# library.
#
# This function reads directory locations in from an options
# file. Does a certain number of sanity checks on those locations
# and then calls the various class methods of VMCTapeLibCustomizations
# in the necessary order to acheive the desired tagging and duplications.
#
# These re-tags and duplications are all done in an attempt to mimic 
# the old mini-disc and sd groupings of course files.
#################################################
def full_tapelibrary_massage(option_file_name, interactive)
  require 'yaml'
  directory_names =YAML::load_file(option_file_name)

  if interactive
    puts "\nthe following directory values were read from #{option_file_name}:"
    directory_names.each do |key, value|
      puts "#{key}= #{value}"
    end
  end

  uh_oh_flag = false
  puts "\nlooking for the directories specified in your input file..."
  directory_names.each do |key, value|
    if !Dir.exists?(value)
      puts"!!!! #{key}:  #{value} cannot be found."
      uh_oh_flag = true
    end 
  end

###   if uh_oh_flag
###     raise IOError
###   else
###     puts "I've found all of the directories that you specified."
###   end
  directory_names["library_root"].chomp("/") #remove the trailing / if there is one

  VMCTapeLibCustomizations.am_chantings_duplicate(directory_names["am_chant_src_dir"], directory_names["am_chant_cust_dir"], interactive)
  VMCTapeLibCustomizations.std_album_tag_fix(directory_names["library_root"],interactive)

  VMCTapeLibCustomizations.am_chantings_album(directory_names["am_chant_src_dir"], interactive)
  VMCTapeLibCustomizations.dohas(directory_names["dohas_dir"], interactive)
  VMCTapeLibCustomizations.gongs(directory_names["gongs_dir"], interactive)
  VMCTapeLibCustomizations.group_sittings(directory_names["group_sittings_dir"], interactive)
  VMCTapeLibCustomizations.hindi(directory_names["hindi_instr_src_dir"], directory_names['hindi_instr_cust_dir'], interactive)

  VMCTapeLibCustomizations.metta_mods(directory_names["workers_metta_dir"], interactive)
  VMCTapeLibCustomizations.one_day_course(directory_names["one_day_dir"], interactive)
  VMCTapeLibCustomizations.set_discourse_track_numbers(directory_names["library_root"], interactive)
  VMCTapeLibCustomizations.special_chantings(directory_names["special_chantings_dir"], interactive)
end

def parse_command_line(options)
  if ARGV.count == 0 #print help text if no options supplied
    ARGV << "--help"
  end

  opts = OptionParser.new do |opts|
    opts.banner = "\nUsage: fix_lib [options] \n" +
                  "\t\t***fix_lib defaults to interactive mode***\n" +
                  "\t\t***Use --quiet to avoid the interactive prompts***\n\n" +
                  "\t\t***--vmc_mods does our full set of tape library modifications and can only be run with the one other option: --quiet ***\n" +
                  "\t\t***--std_album_fix option searches recursively for all files under the given directory,\n" +
                  "\t\t\tall other options act on the given directory only.\n"
    opts.version = VERSION

    opts.on( "-s","--quiet", 
            "\n\t\t Run in non-interactive mode. All actions will be taken without prompting.\n\n") do |prompt|
      options[:interactive] = false
    end

    opts.on( "-r DIRNAME","--report DIRNAME", 
            "\n\t\t Spit out all mp3 files in the directory tree under DIRNAME and their tags.\n\n") do |directory|
      options[:report] = directory
    end

    opts.on( "--am_chantings DIRNAME", 
            "\n\t\t Give the mp3 files in DIRNAME the album tag _10Day Morning Chantings.\n\n") do |directory|
      options[:morning_chantings] = directory
    end

    opts.on( "--dup_am_chantings FROM_DIRNAME,TO_DIRNAME", 
            "\n\t\t Copy the morning chantings from FROM_DIRNAME to TO_DIRNAME and set their album tags to that they show up in the 10d course daily albums.\n\n") do |directories|
      a = Array.new(directories.split(/,/))
      if a.count != 2
        puts "incorrect arguments for --dup_am_chantings option"
        exit
      end
      options[:am_from] = a[0]
      options[:am_to] = a[1]
    end

    opts.on( "--discourses DIRNAME", 
            "\n\t\t Set the track number for the discourse files to a very large number.\n\n") do |directory|
      options[:discourses] = directory
    end

    opts.on( "--dohas DIRNAME", 
            "\n\t\t Give the mp3 files in DIRNAME the album tag _Dohas.\n\n") do |dohas_directory|
      options[:dohas] = dohas_directory
    end

    opts.on( "--gongs DIRNAME", 
            "\n\t\t Give the mp3 files in DIRNAME the album tag _Gongs.\n\n") do |directory|
      options[:gongs] = directory
    end

    opts.on( "--hindi_pdis FROM_DIRNAME,TO_DIRNAME", 
            "\n\t\t Copy PDI's from FROM_DIRNAME to TO_DIRNAME and give them the album tag of _10D_Hindi_PDIs.\n\n") do |directories|
      a = Array.new(directories.split(/,/))
      if a.count != 2
        puts "incorrect arguments for --hindi_pdis option"
        exit
      end
      options[:hindi_from] = a[0]
      options[:hindi_to] = a[1]
    end

    opts.on( "--one_day DIRNAME", 
            "\n\t\t Give the mp3 files in DIRNAME the album tag 'One Day Course'.\n\n") do |directory|
      options[:one_day] = directory
    end
    opts.on( "--sittings DIRNAME", 
            "\n\t\t Give the mp3 files in DIRNAME the album tag _Group Sittings\n\n") do |directory|
      options[:group_sittings] = directory
    end

    opts.on( "--sp_chantings DIRNAME", 
            "\n\t\t Give the mp3 files in DIRNAME the album tag  _Special Chantings\n\n") do |directory|
      options[:special_chantings] = directory
    end

    opts.on( "--std_album_fix DIRNAME", 
            "\n\t\t Run the mp3 files under DIRNAME through our standard album name algorithm. (a file named D01_1910_Disc_English_10d.mp3 will be given an album tag of  D01_10d.\n\n") do |directory|
      options[:std_album_fix] = directory
    end

    opts.on( "-c","--vmc_mods FILENAME", 
            "\n\t\tDo the tape library-to-sonos customizations. Reading the filename " +
               "constants from the file <FILENAME>\n\n") do |file_name|
      options[:customize] = file_name
               end
    
  end 
    
  begin # enclose the commandline parsing in a rescue clause so that I can output
        # some custom error messages
    opts.parse!
  rescue OptionParser::MissingArgument, OptionParser::InvalidOption
    puts "\n---> There is a problem with one of your command line arguments. Please check your options.<---\n"
    puts opts.help
    raise
  end
end

parse_command_line(my_options)
# OK, we got valid commandline options so now lets get to work:

# if the report option is specified, run it and then exit
if my_options.has_key?(:report)
  VMCTapeLibCustomizations.report(my_options[:report])
  exit
end


print "about to run options: "
puts my_options
# you cannot use the individual modification options if you have also specified the full shebang option
if my_options.has_key?(:customize)
  if my_options.count > 3
    puts "Please check your command line options."
    puts "If you have specified the --customize option, the only other option allowed it --quiet"
    exit
  end
  puts "about to run the full tapelibrary fix in quiet mode"
  full_tapelibrary_massage(my_options[:customize],my_options[:interactive])
end

if my_options.has_key?(:morning_chantings)
  VMCTapeLibCustomizations.am_chantings_album(my_options[:morning_chantings], my_options[:interactive])
end

if my_options.has_key?(:am_from)
  VMCTapeLibCustomizations.am_chantings_duplicate(my_options[:am_from],my_options[:am_to], my_options[:interactive])
end

if my_options.has_key?(:discourses)
  VMCTapeLibCustomizations.set_discourse_track_numbers(my_options[:discourses], my_options[:interactive])
end

if my_options.has_key?(:dohas)
  VMCTapeLibCustomizations.dohas(my_options[:dohas], my_options[:interactive])
end

if my_options.has_key?(:gongs)
  VMCTapeLibCustomizations.gongs(my_options[:gongs], my_options[:interactive])
end

if my_options.has_key?(:group_sittings)
  VMCTapeLibCustomizations.group_sittings(my_options[:group_sittings], my_options[:interactive])
end

if my_options.has_key?(:hindi_from)
  VMCTapeLibCustomizations.hindi(my_options[:hindi_from],my_options[:hindi_to], my_options[:interactive])
end

if my_options.has_key?(:one_day)
  VMCTapeLibCustomizations.one_day_course(my_options[:one_day], my_options[:interactive])
end

if my_options.has_key?(:report)
  VMCTapeLibCustomizations.report(my_options[:one_day])
end

if my_options.has_key?(:special_chantings)
  VMCTapeLibCustomizations.special_chantings(my_options[:special_chantings], my_options[:interactive])
end

if my_options.has_key?(:std_album_fix)
  VMCTapeLibCustomizations.std_album_tag_fix(my_options[:group_sittings], my_options[:interactive])
end

exit
### if my_options.has_key?(:browse)
###   if my_options[:browse].class == String
###     which_tags =  my_options[:browse].split(",")
###   end
###   tagger.browseLibrary(which_tags)
### end
### 
### if my_options.has_key?(:albums)
###   tagger.fix_album_tags
### end
### 
### if my_options.has_key?(:customize)
###   puts "--customize option was specified with  #{my_options[:customize]} as the config file.\nThis function is n beta."
### else
###   exit  # don't execute the code below this if customize wasn't specified
### end

##############################################################################
#### CODE BELOW HERE ONLY GETS EXECUTED IF customize OPTION WAS specified ####
##############################################################################

#########################################
#  here's a slick way to loop through the calls that we want to make, 
#  insuring that they are called in order, and that all of them are called, whether
#  you're running in interactive mode or not.
#
#  I think it might be too slick for non-ruby folks to easily understand, so I'm going
#  with command line options and prompts instead. 
#  Leaving this code here in case we want to switch to it at a future date (HW)
#
### my_stack = {"dohas"=> directory_names['dohas_dir'],
###              "hindi"=> [directory_names['hindi_instr_dir'],File.join(directory_names["custom_dir"], "10D_Hindi_PDI")]}
### my_stack.each do |f,p|
###   if p
###     VMCTapeLibCustomizations.send(f,*p)
###   else
###     VMCTapeLibCustomizations.send(f)
###   end
### end
### 
