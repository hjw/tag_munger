# copy to AV1 NAS from DharaWWL silver 1gb portable HD
#   --destination folder must already exist
#   --creating folder with QNAP web interface.  QFinder -> Admin -> Access Rights > Share Folders
#   --we are using these:
#	/share/HDA_DATA/SonosLibrary  (holds DharaWWL/SonosLibrary/*)
#	/share/HDA_DATA/VideoLibrary  (holds DharaWWL/MP4_Files/*)
#   /share/HDA_DATA/iPodLibrary   (holds DharaWWL/WWL_Exceptions/*)
#
SOURCE_VOLUME="/Volumes/DharaWWL"
WWL_FOLDER='WWD_2014'
NAS_IP="$1" # e.g. 192.168.1.191
#
if [ $# -ne 1 ]
then
    echo "Syntax: $0 {NAS IP address or host name}"
    echo "Copy tagged Sonos Libraries from local volume to NAS drive"
    echo "Uses 'rsync' to update files in SonosLibrary, VideoLibrary, and iPodLibrary folders on NAS, 
    echo "Removes files not found on source folders.
    echo "Example: $0 192.168.1.123"
    exit
fi

echo "------------ update SonosLibrary -----------------"
rsync -avz --exclude=.DS_Store --delete --delete-excluded $SOURCE_VOLUME/SonosLibrary/* admin@${NAS_IP}:/share/HDA_DATA/SonosLibrary
echo "------------ update VideoLibrary -----------------"
rsync -avz --exclude=.DS_Store --delete --delete-excluded $SOURCE_VOLUME/$WWL_FOLDER/MP4_Files_10D_STP_General/* admin@${NAS_IP}:/share/HDA_DATA/VideoLibrary
echo "------------ update iPodLibrary -----------------"
rsync -avz --exclude=.DS_Store --delete --delete-excluded $SOURCE_VOLUME/$WWL_FOLDER/WWL_HDD/* admin@${NAS_IP}:/share/HDA_DATA/iPodLibrary
echo "------------ Next... -----------------"

# Next:
echo 'Next: create all remaining folders in SonosShareList.txt with QNAP web interface'
echo 'Then: run makeSonosShareLinks.sh to create links in all remaining folders (remaining folders link to SonosLibrary)'
echo '      share/HDA_DATA/SonosLibrary/Sonos\ Customizations/Sonos\ Share\ Info/makeSonosShareLinks.sh'

