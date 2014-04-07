#!/usr/bin/env ruby

require 'taglib'

module MediaEditor

  ###############################################
  # print out the requested metadata / tag data for
  # the passed in media files
  #
  # The format of this printout is easily readable
  # with YAML. Please do not change it without
  # testing that our checker utilities still function.
  #################################################
  def print_metadata(file_list, tag_list)
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
  def  set_metadata( file_list, tag_hash)
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

end
