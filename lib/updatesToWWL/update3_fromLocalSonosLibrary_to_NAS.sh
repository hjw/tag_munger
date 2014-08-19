# copy to AV1 NAS from DharaWWL silver 1gb portable HD
#   --destination folder must already exist
#   --creating folder with QNAP web interface.  QFinder -> Admin -> Access Rights > Share Folders
#   --we are using these:
#	/share/HDA_DATA/SonosLibrary  (holds DharaWWL/SonosLibrary/*)
#	/share/HDA_DATA/VideoLibrary  (holds DharaWWL/MP4_Files/*)
#   /share/HDA_DATA/iPodLibrary   (holds DharaWWL/WWL_Exceptions/*)
#
WWL_FOLDER='WWD_2014'
NAS_IP='192.168.1.191'
rsync -avz --exclude=.DS_Store /Volumes/DharaWWL/SonosLibrary/* admin@$NAS_IP:/share/HDA_DATA/SonosLibrary
rsync -avz --exclude=.DS_Store /Volumes/DharaWWL/$WWL_FOLDER/MP4_Files_10D_STP_General/* admin@$NAS_IP:/share/HDA_DATA/VideoLibrary
rsync -avz --exclude=.DS_Store /Volumes/DharaWWL/$WWL_FOLDER/WWL_HDD/* admin@$NAS_IP:/share/HDA_DATA/iPodLibrary

# Next:
echo 'Next: create all remaining folders in SonosShareList.txt with QNAP web interface'
echo 'Then: run makeSonosShareLinks.sh to create links in all remaining folders (remaining folders link to SonosLibrary)'
echo '      share/HDA_DATA/SonosLibrary/Sonos\ Customizations/Sonos\ Share\ Info/makeSonosShareLinks.sh'

