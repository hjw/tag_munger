Tag Munger

This is the project where we are taking the monolithic, scripts that
were used to "fix" the tape library for better Sonos use and making 
them into a usable class library with usable executables.

First project is the tag_munger executable which allows some basic browsing
and "fixing" of the album tags so that the are grouped by course day.

bin/tag_munger (the executable ruby script which provides command line options 
for accessing the functionality of the TagMunger object)

bin/tag_munger --help 
will list out all of the possible tag_munger options.

For doing a full munging of the world wide tape library into a vmc/sonos tagged
library do the following:

$ cd ~/code/tag_munger
<edit bin/hjwConfig.yml so that the paths in there are correct>
$ bin/fix_lib.rb --vmc_mods bin/hjwConfig.yml

You can run the rdoc command from the root directory of this code to generate
documentation. The nicest wat to view it is to open the generated doc/index.html
file with your browser.

If you have just downloaded this code from a repository you will need to run

bundle install

in order to pull in all of the necessary ruby gems.
Often, there will be a problem installing the taglib-ruby gem because it
depends on the taglib library. On a mac, you can run the following commands:

brew install taglib
bundle install

--------------
lib/tag_munger.rb is the file that provides the TagMunger object. The idea
is that it should provide the functionality that we need when massaging the
tape library. Include this file to use TagMunger objects. This is what
is being done in bin/tag_munger.


As a reminder: At VMC we muck about with the album tags for the tape library 
files so that we can mimic the minidisc setup, where each day 
is its own disk/album.

