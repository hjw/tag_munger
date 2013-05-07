#!/usr/bin/env ruby

# test out code snippets
require 'fileutils'
require 'taglib'
require 'pp'
#library_root = "./"
LIBRARY_ROOT = "./"
def dupes_dir()
  sonos_dupes_dir= LIBRARY_ROOT + "Sonos Customizations"
  if !File.exists?(sonos_dupes_dir) then
    puts "#{sonos_dupes_dir} does not seem to exist.... creating it."
    Dir.mkdir(sonos_dupes_dir)
  end
  return sonos_dupes_dir
end
dryrun = false
Dir.glob("#{LIBRARY_ROOT}**/*.mp3") do |file_name|
  if dryrun then
    puts "#{file_name} "
  else
    ok = TagLib::FileRef.open(file_name) do |f|
      tag = f.tag
      tag.album = "_LongCourseServers"
      f.save
    end
  end
end

### puts "beginning workers metta section."
### WORKERS_METTA_DIR="Workers Metta v.2005"
### orig_metta_dir= LIBRARY_ROOT + WORKERS_METTA_DIR
### # set album tag for original worker's metta files to be Worker's Metta
### if File.exists?(orig_metta_dir) then
###   Dir.glob(orig_metta_dir + "/*.mp3") do |file_name|
###     ok = TagLib::FileRef.open(file_name) do |f|
###       tag = f.tag
###       tag.album = "_Worker's Metta"
###       tag.track = 50
###       f.save
###     end
###   end
### else
###   puts "uh-oh. #{orig_metta_dir} does not seem to exist."
###   exit
### end
