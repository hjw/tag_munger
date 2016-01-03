#!/usr/bin/env ruby

require 'fileutils'
#require_relative 'media_editor'
require 'taglib'
require 'pp'

###########################################
# VMCTapeLibCustomizations is a module that we use to manipulate the international
# tape library to better suit our puposes.
# It has a number of
# methods which are very specific to the things that VMC chooses
# to do to mimic the old minidisc organization when using
# the Sonos system.
module VMCTapeLibCustomizations

#  include MediaEditor
  
   ########################################
   #
   # We need to access Morning Chantings files in two different ways:
   #   1. as part of a 10 day course, properly shown in the day's album
   #   2. as a separate 10DayMorningChantings album for use between courses,
   #     during long courses and any other courses.
   #
   # This function is meant to set the album tag of the original morning chantings
   # files to _10Day Morning Chantings. Use the am_chantings_duplicate function to 
   # create copies of the morning chanting files that will show up in the 10day course daily albums.
   #
   # <em>When re-tagging the whole tape library you must run this funciton *after* the std_album_tag_fix</em>
   #  
   ############################################
   def self.am_chantings_album(am_chantings_dir, interactive)
     easy_album_change(am_chantings_dir, "_10Day Morning Chantings", interactive)
   end

   ###########################################
   # Create a separate copy of the morning chanting
   # files for integration into the standard 10day course
   # albums. Sets these duplicated files' album tag to correspond
   # to the course day on which they are played. Also sets
   # the track number to 1 so that they appear first on that day's album.
   #
   ###########################################
   def self.am_chantings_duplicate(orig_am_chantings_dir, new_am_chantings_dir,interactive = true)
     make_change = true
     if interactive
       make_change = false
       puts "Creating a duplicate of the morning chanting files for 10day courses."
       puts "Copying the chanting files from below: #{orig_am_chantings_dir}"
       puts "to: #{new_am_chantings_dir}"
       puts "OK? (y,n, q) "
       answer = gets.chomp
       case answer
       when /\by\b|\byes\b/i # matches yes or y case insensitive
         make_change = true
       when /\bn\b|\bno\b/i # matches n or no
         puts "OK, I won't do the duplication of the morning chanting files right now."

       when /\bq\b|\bquit\b/i # matches q or quit
         puts "OK. Exiting program."
         raise SystemExit, "User requested quit while copying the morning chanting files from #{orig_am_chantings_dir} to #{new_am_chantings_dir}."
       end
     end

     if make_change
       puts "copying morning chanting files to #{new_am_chantings_dir} "
       file_list = select_files("#{orig_am_chantings_dir}/*.mp3")

       if file_list.count >= 1 # if there are files in the from directory
         begin
           FileUtils.mkdir(new_am_chantings_dir) #create the new_am_chantings_dir, but don't bomb out if it already exists
         rescue Errno::EEXIST
           puts "#{new_am_chantings_dir} already exists, copying morning chanting files to it. This will overwrite any files in #{new_am_chantings_dir} "
         end
         FileUtils.cp(file_list, new_am_chantings_dir)

         puts "setting the track number to 1 and changing the names of the duplicated morning chantings files."
         file_list = select_files("#{new_am_chantings_dir}/*.mp3")
         if file_list.count == 0
           raise IOError, "No mp3 files found under #{new_am_chantings_dir}. Exiting program"
         end
           
         set_metadata(file_list, {"track" =>1})

         file_list.each do |file_name|
           # Not sure why we do this. Match data will match any file 
           # doesn't end with a one or two digit number followed by d.mp3
           # ie: <anything>_##d.mp3 or <anything>_#d.mp3
           #  if we are trying to match <anything>_10d.mp3 whe should match 
           #  it with /.*_10d.mp3$/
           #don't add _10d to the name if it's already there
           if !( /.*_\d{1,2}d.mp3$/.match(file_name) )
             FileUtils.mv file_name, file_name.sub(".mp3","_10d.mp3")
           end
         end
       else # no mp3 files in the from directory, assume incorrect input to this function and raise an error
         raise IOError, "No files matching *.mp3 were found in the morning chantings directory #{orig_am_chantings_dir}."
       end
     end
     
     if make_change
       puts "finished duplicating the morning chantings files and adding _10d to their name fix."
       if interactive
         puts "\n\nHere's a listing of the duplicated morning chantings dir #{new_am_chantings_dir}"
         system("ls '#{new_am_chantings_dir}'")
       end
     else
       puts"No changes were made during am_chantings_duplicate."
     end

   end

  ########################################
  # Check for a directory called Sonos-Customizations
  # and create if it doesn't exist. If it does exist
  # print out it's contents.
  # returns true if the directory exists or is successfully
  # created.
  # report on the existance and location of the 
  # SonosCustomizations directory
  #
  # this is horrible code (multiple return points) FIXME
  #####################################
  def self.customization_dir_exists?(lib_root,customization_dir_name)
    custom_dirs = select_files("#{lib_root}/**/#{customization_dir_name}") 
    desired_cust_dir = File.join(lib_root, customization_dir_name)
    number_of_dirs_found = custom_dirs.count

    if number_of_dirs_found == 0
      puts "I don't see a #{customization_dir_name} directory in the directory tree below #{lib_root}"
      puts "creating #{@customization_dir} "
      Dir.mkdir(desired_cust_dir)
      return true

    elsif number_of_dirs_found >=2
      print "Uh-oh, I found more than one directory in my search.\n\n"
      custom_dirs.each { |x| File.directory?(x) ? (puts "\t #{x} (Directory)"): (puts "\t #{x} (not a directory)")}
      print "\nPlease resolve this problem before running this program again.\n\n"
      exit (-1)

    else
      puts "Found\n #{custom_dirs[0]}containing the following files and directories:"
      treeList = []
      Dir.glob("#{custom_dirs[0]}/**/*") { |a| treeList << a}
      treeList.sort!
      treeList.each {|x| File.directory?(x) ? (puts "(d)  #{x}") : (puts"(f)  #{x}")}
      return true
    end
  end
 
###   ########################################
###   # Print report of the passed in directory tree
###   # List non-mp3 files.
###   # List mp3 files that do not match "#{@library_root}/**/D[0-9][0-9]_*.mp3"
###   # List mp3 files that DO match "#{@library_root}/**/D[0-9][0-9]_*.mp3"
###   #   matches are currently found using a private select method
###   #   which happens to use Dir.glob to find the files
###   def self.lib_report(lib_root)
###     file_list = []
###     file_list = select_files("#{lib_root}/**/*")
### 
###     pp "^^^^^^^^^^^^^^^^^^^^^^^^^"
###     pp "The following mp3 files which do not seem to belong to courses:"
###     mp3_files= file_list.select {|f| /.*\.mp3$/ =~ f}
###     puts mp3_files.reject { |f|  /D\d{2}.*\.mp3$/ =~ f}
###     pp "^^^^^^^ end of list of non-course mp3 files ^^^^^^^^^^^^^^^^^^"
### 
###     pp "^^^^^^^^^^^^^^^^^^^^^^^^^"
###     pp "The following files will be put into course albums:"
###     puts mp3_files.select { |f|  /D\d{2}.*\.mp3$/ =~ f}
###     pp "^^^^^^^ end of list of course mp3 files ^^^^^^^^^^^^^^^^^^"
### 
###     pp "^^^^^^^^^^^^^^^^^^^^^^^^^"
###     pp "These are the non-mp3 files in the library:"
###     puts file_list.reject { |f|  /.*\.mp3$/ =~ f } # selects all file which do not end with .mp3 suffix
###   end
### 

   ########################################
   # dohas(dohas_directory)
   #
   # Tag dohas files as being part of the _Dohas
   # album.
   #
   #####################################
   def self.dohas(work_dir, interactive)
     easy_album_change(work_dir, "_Dohas", interactive)
   end
   
   #######################################
   #
   # Set all gong related files
   # to belong to the album _Gongs for 
   # easy access
   #######################################
   def self.gongs(work_dir, interactive)
     easy_album_change(work_dir,"_Gongs", interactive)
   end

   #######################################
   #
   # Set all continuous groups sittings files
   # to belong to the album _Group Sittings for 
   # easy access / between course use
   #######################################
   def self.group_sittings(work_dir, interactive)
     easy_album_change(work_dir,"_Group Sittings", interactive)
   end

   ########################################
   #
   # Make a duplicate copy of (hindi) pdi's to customization
   # directory and tag as it's own album _Hindi PDI
   # album.
   #
   # 10D_Hindi_PDI (directory name)
   # from_dir should be lib_root/10D Hindi-only, since the
   # function is using the following glob to select the files:
   # <tt> /**/D[0-9][0-9]\_2030_*10d.mp3 </tt>
   #
   # Notice that in the glob string we are only checking for mp3 files
   # whose filename starts with a day number and which contain 2030, signifying
   # that they are meant to be played at 8:30pm (the time that PDI's are usually
   # played). This is clearly a pretty fragile function.
   #
   #####################################
   def self.hindi(from_dir, to_dir, interactive=true)
     make_change = true
     puts "in hindi. from_dir= #{from_dir}, to_dir= #{to_dir}"
     if Dir.exists?(from_dir)
       puts "from_dir exists"
       if interactive
         make_change = false
         puts "Creating a duplicate of the Hindi PDIs for 10day courses."
         puts "Copying pdi's from below: #{from_dir}"
         puts "to: #{to_dir}"
         puts "OK? (y,n, q) "
         answer = gets.chomp
         case answer
         when /\by\b|\byes\b/i # matches yes or y case insensitive
           make_change = true
         when /\bn\b|\bno\b/i # matches n or no
           puts "OK, I won't do the duplication of the Hindi PDI's right now."

         when /\bq\b|\bquit\b/i # matches q or quit
           puts "OK. Exiting program."
           raise SystemExit, "User requested quit while copying hindi pdi's from #{from_dir} to #{to_dir}."
         end
       end

       if make_change
         puts "copying hindi PDI's to #{to_dir} "
         file_list = select_files("#{from_dir}/**/D[0-9][0-9]_2030_*10d.mp3")
         if file_list.count >= 1
           begin
             FileUtils.mkdir(to_dir) #create the to_dir, but don't bomb out if it already exists
           rescue Errno::EEXIST
             puts "#{to_dir} already exists, copying hindi PDI's to it. This will overwrite any files in #{to_dir} "
           end
           file_list.each do |f|
             FileUtils.cp(f, to_dir)
           end
           file_list = select_files("#{to_dir}/*.mp3")
           puts "about to set the metadata for #{file_list.count} hindi pdis."
           file_list.each do |f|
             set_metadata(f, {"album" => "_Hindi PDIs"})
           end
         else
           raise IOError, "No files matching D[0-9][0-9]_2030_*10d.mp3 were found in the Hindi PDI directory #{from_dir}."
         end
       end
     else
       raise IOError, "Hindi PDI directory #{from_dir} could not be found."
     end
   end


   ########################################
   # 
   # Tag workers metta files as being part of the workers metta
   # album.
   #
   # Set the tracknumber for the english file to be 1.
   #####################################
   def self.metta_mods( work_dir, interactive )
     fix_tracks = easy_album_change(work_dir, "_Workers Metta", interactive)
     if fix_tracks
       file_list = select_files("#{work_dir}/*.mp3")
       if file_list.count == 0
         raise IOError, "No workers metta files found under #{work_dir}. Exiting."
       end
       set_metadata(file_list, { "track" => 50})
       set_metadata("#{work_dir}/2105_WM_English_2005.mp3", {"track" => 1} ) #set english workers metta to be first track
     end
   end

   ########################################
   # Tag  files in the one day course directory
   # as being part of the One Day Course
   # album.
   #
   # Since one day courses exist in different
   # languages we need to find the files to tag recursively
   # and cant just use easy_album_change (which only handles mp3 files in 
   # the directory passed in.
   #
   #####################################
   def self.one_day_course(work_dir, interactive)
     make_change = true
     puts "setting the album title for all one day course files under directory #{work_dir} to 'One Day Course'"
     file_list = []

     if Dir.exists?(work_dir)
       work_dir.chomp("/") #remove the trailing / if there is one

       file_list = select_files("#{work_dir}/**/*.mp3")
       if file_list.count ==  0
         puts "There were no mp3 files found under the directory #{work_dir}. So, no files were tagged with the album 'One Day Course'"
         return false
       end

       if interactive
         make_change = false
         print "Are you sure that you want to set the album for all #{file_list.count} one day course files under #{work_dir} to 'One Day Course'? (y,n,q): "
         answer = gets.chomp
         case answer
         when /\by\b|\byes\b/i # matches yes or y case insensitive
           make_change = true
         when /\bn\b|\bno\b/i # matches n or no
           puts "OK, I won't change the album for the files under the #{work_dir} to 'One Day Course'."

         when /\bq\b|\bquit\b/i # matches q or quit
           puts "OK. Exiting program."
           raise SystemExit, "User requested quit while setting the album tags to 'One Day Course' in #{work_dir}."
         end
       end

       if make_change
         set_metadata(file_list, {"album" => 'One Day Course'})
       end

     else
       raise IOError, "While setting the album tag to 'One Day Course', directory #{work_dir} could not be found."
     end
     return make_change
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
   def self.set_discourse_track_numbers(library_root,interactive = true)
     track_num = 200
     make_change = true
     puts "setting the track numbers for all discourse files ( named *_Disc_*) under directory #{library_root} to #{track_num}"
     file_list = []

     if Dir.exists?(library_root)
       library_root.chomp("/") #remove the trailing / if there is one

       file_list = select_files("#{library_root}/**/*_Disc_*.mp3")
       if file_list.count ==  0
         puts "There were no Discourse tracks found under the directory #{library_root}"
         return false
       end

       if interactive
         make_change = false
           print "Are you sure that you want to set the track numbers for all #{file_list.count} discourse files under #{library_root} to #{track_num}? (y,n,q): "
           answer = gets.chomp
           case answer
         when /\by\b|\byes\b/i # matches yes or y case insensitive
           make_change = true
         when /\bn\b|\bno\b/i # matches n or no
           puts "OK, I won't change the track numbers for the discourse files under the #{library_root} to #{track_num}."

         when /\bq\b|\bquit\b/i # matches q or quit
           puts "OK. Exiting program."
           raise SystemExit, "User requested quit while setting discourse tracks to #{track_num}."
         end
       end

       if make_change
         set_metadata(file_list, {"track" => track_num})
       end

     else
       raise IOError, "While setting track number to #{track_num}, directory #{library_root} could not be found."
     end
     return make_change
   end

   ########################################
   #
   # tag special chanting files as being part of the _Special_Chantings
   # album.
   #
   #####################################
   def self.special_chantings(work_dir, interactive)
     easy_album_change(work_dir, "_Special Chantings", interactive)
   end

  ############################################
  # Sets all mp3 files below the passed in directory, which 
  # start with D##, to have an album tag of D##_courseType.  
  # 
  # The course type is scraped from the file name.
  #
  # ie: a file named *D01_1910_Disc_English_10d.mp3* will be given
  # an album tag of  *D01_10d*
  ############################################
  def self.std_album_tag_fix(lib_root,dry_run = true)
    file_list = []
    raise IOError, "directory #{lib_root} can't be found" unless Dir.exists?(lib_root)
    file_list = select_files("#{lib_root}/**/D[0-9][0-9]_*.mp3")
    if file_list.count == 0
      raise IOError, "No files under #{lib_root} seem to match the glob #{lib_root}/**/D[0-9][0-9]_*.mp3"
    end
    album_name = ""
    temp_hash = {}

    # create album_name from file name 
    # "D09_0855_GS_10d.mp3" gets album "D09_10d"
    file_list.each do |name|
      w = (File.basename(name)).split("_")
      album_name = [ w[0],  w[-1].chomp(".mp3")].join("_")
      temp_hash[name] = album_name
    end

    if !dry_run then
      temp_hash.each do |file_name, album_tag|
        set_metadata(file_name, {"album" => album_tag})
      end
    else     
      puts "The standard album fix function interprets interactive mode as a dry run mode."
      puts "None of the standard album fixes were made."
      puts "If you weren't in dry run mode the following changes would be made:"
      pp temp_hash.sort
    end
    puts "finished the standard album name fix."
  end

  #######################################
  # Print out every mp3 file below the passed
  # in directory and it's tags
  #####################################
  def self.report(root_dir)
    file_list = []
    tags = [ "album", "artist", "track", "title"]
    file_list = select_files("#{root_dir}/**/*.mp3")

    if file_list.length == 0
      puts "No .mp3 files found below root: #{root_dir}"
       raise IOError, "empty file list found with match string: #{match_string}"
    end

    print_metadata(file_list, tags)
  end

  #######################################
  # Set all mp3 files in the work_dir to have the album tag of album_name.
  # Asks for confirmation depending on the interactive flag (confirmation required 
  # if interactive = true).
   #
   def self.easy_album_change(work_dir, album_name, interactive = true)
     make_change = true
     if Dir.exists?(work_dir)
       file_list = select_files("#{work_dir}/*.mp3")
       if file_list.count == 0
         raise IOError, "No mp3 files were found under the #{work_dir}. Exiting"
       end

       if interactive
         make_change = false
         print "Are you sure that you want to set the album for all #{file_list.count} files in #{work_dir} to #{album_name}? (y,n,q): "
         answer = gets.chomp
         case answer
         when /\by\b|\byes\b/i # matches yes or y case insensitive
           make_change = true
         when /\bn\b|\bno\b/i # matches n or no
           puts "OK, I won't change the album names in the #{work_dir} to #{album_name}."

         when /\bq\b|\bquit\b/i # matches q or quit
           puts "OK. Exiting program."
           raise SystemExit, "User requested quit while setting album to #{album_name}."
         end
       end

       if make_change
         set_metadata(file_list, {"album" => album_name})
       end

     else
       raise IOError, "While setting album to #{album_name}, directory #{work_dir} could not be found."
     end
     return make_change
   end
   
   #######################################
   # Takes a glob type string and returns
   # an array of files which match it.
   #
   # Does no error handling. Simply returns
   # an empty array if there are no matches.
   def self.select_files(match_string)
     file_list=[]
     Dir.glob(match_string) do |name|
       file_list << name unless File.directory?(name)
     end
     file_list
   end

  #################################################
  # Takes a file name or list of file names as well
  # as a hash of tags and values and sets the tags
  # to the values for each file. The keys for the hash
  # should be strings, although there's a little error
  # checking included in the function to turn the key into
  # a string.
  #
  # The function uses the .send method to set the
  # metadata tag. In order to do that it has to append
  # "=" to the tag name, so "album" becomes "album=".
  # there's a bit of fussing to make this work, the 
  # hash key is converted to a string, if it isn't one,
  # and then "=" is added to it. 
  # 
  ##############################################
  def  self.set_metadata( file_list, tag_hash)
    file_list = [*file_list] # make sure file_list is an array
    file_list.each do |file_name|
      if File.exist?(file_name) 
        ok = TagLib::FileRef.open(file_name) do |f|
          tag = f.tag
          tag_hash.each do |tag_name, value|

            # make sure that the tag_nam (hash key) is a string and then add = to it
            if tag_name.class != String
              tag_name = tag_name.to_s
            end
            tag_name += "="

            if tag.respond_to?(tag_name)
              tag.send(tag_name, value)
            else
              puts "can't modify tag #{tag_name}"
            end
          end
          f.save
        end
        if ok == false then
          puts "uh-oh. There was a problem saving/opening #{f}, it's tags were not modified."
        end
      else
        puts "file #{file_name} does not exist, so its tags were not updated."
      end
    end
  end

  ###############################################
  # Print out the requested metadata / tag data for
  # the passed in media files
  #
  # The format of this printout is easily readable
  # with YAML. Please do not change it without
  # testing that our checker utilities still function.
  #################################################
  def self.print_metadata(file_list, tag_list)
    file_list = [*file_list]
    tag_list = [*tag_list]
    file_list.each do |name|
      ok = TagLib::FileRef.open(name) do |f|
        output = "#{name}: \n"
        tag_list.each do |t|
          output << "   #{t}: #{f.tag.send(t)}\n"
        end
        puts output
      end
      if ok == false then
        puts "uh-oh. There was a problem opening #{name}"
      end
    end
  end

  private_class_method :select_files
  private_class_method :set_metadata
  private_class_method :easy_album_change
  private_class_method :print_metadata

end
