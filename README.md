Tag Munger

This is the project where I am taking the monolithic, scripts that
were used to "fix" the tape library for better Sonos use and making 
them into a usable class library with usable executables.

The files that are currently relevant are:

bin/tag_munger (the executable
ruby script which provides command line options for accessing the functionality
of the TagMunger object)

lib/tag_munger.rb is the file that provides the TagMunger object. The idea
is that it should provide the functionality that we need when massaging the
tape library. Include this file to use TagMunger objects. This is what
is being done in bin/tag_munger.

First project is the tag_munger executable which allows some basic browsing
and "fixing" of the album tags so that the are grouped by course day.

As a reminder: We muck about with the album tags for the tape library files so 
that we can mimic the minidisc setup, where each day is its own disk/album.

You can run the rdoc command from the root directory of this code to generate
documentation. The nicest wat to view it is to open the generated doc/index.html
file with your browser.
