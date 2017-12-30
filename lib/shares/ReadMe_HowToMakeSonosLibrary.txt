README: how to set up a NAS Drive with audio files and shares for VMC Sonos system.

1. Original: Get a copy of World Wide Languages audio and video files (WWL_HDD) on local or external drive of your computer.
	a. using WWL_HHDD 2014
	b. add in extra files that we have collected previously
		$ ~/code/tag_munger/lib/updatesToWWL/update1_fromMasterWWL_to_LocalCopyWWL.sh
2. Local Copy:
	a. Copy original WWL_HDD to a temporary folder on that same drive, ready to be modified.
	b. Run fix_lib on local copy to create all customizations including duplicate files, meta data (change tagging), etc.
		$ cd ~/code/tag_munger
		$ bin/fix_lib.rb --help
		$ bin/fix_lib.rb --vmc_mods bin/hjwConfig.yml 
3. On NAS drive create Shared Folders:
	a. Manually create share folders listed in 'SonosShareList.txt', using NAS web interface.
		a1. use QFinder application to locate NAS drive on local network, click Connect, log in with administrator username/password.
		a2. click Connect to open NAS Web interface, log in with administrator username/password.
		a3. open Control Panel > Privilege Settings > Shared Folders.
		a4. use Create / Remove button to create and delete shared folders.
			Create > (paste share name)
				  Privilege: "only the system administrator has full access." + "Guest: Read only"
				  (use defaults everywhere else)
		
4. On NAS drive copy local files to Shared Folders:
	a. Rsync the local copy to the NAS drive, to the folders specified by 'makeSonosShareLinks.sh'
		# for QNAP NAS, use QFinder app to determine IP of NAS drive
		# rsync audio files command to NAS on 192.168.1.194
		update3_fromLocalSonosLibrary_to_NAS.sh 192.168.1.194
		#
	b. Rsync the 'makeSonosShareLinks.sh' to NAS drive and run, to create links in shares to NAS drive copy of library.]
        # rsync script command