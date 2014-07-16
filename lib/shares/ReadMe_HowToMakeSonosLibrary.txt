README: how to set up a NAS Drive with audio files and shares for VMC Sonos system.

1. Original: Get a copy of World Wide Languages audio and video files (WWL_HDD) on local or external drive of your computer.
	a. using WWL_HHDD 2014
	b. add in extra files that we have collected previously
2. Local Copy:
	a. Copy original WWL_HDD to a temporary folder on that same drive, ready to be modified.
	b. Run fix_lib on local copy to create all customizations including duplicate files, meta data (change tagging), etc.
3. On NAS drive create Shared Folders:
	a. Manually create share folders listed in 'SonosShareList.txt', using NAS web interface.
		i. use QFinder to locate NAS drive on local network.
		ii. open NAS Web interface...
4. On NAS drive copy local files to Shared Folders:
	a. Rsync the local copy to the NAS drive, to the folders specified by 'makeSonosShareLinks.sh'
		# rsync audio files command
	b. Rsync the 'makeSonosShareLinks.sh' to NAS drive and run, to create links in shares to NAS drive copy of library.]
        # rsync script command