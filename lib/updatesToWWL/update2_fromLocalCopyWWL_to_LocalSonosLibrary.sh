# make a local copy called SonosLibrary on DharaWWL silver 1gb portable HD, making slight rearrangements
WWL_FOLDER='WWL_2017'

mkdir -v /Volumes/DharaWWL/SonosLibrary
mkdir -v /Volumes/DharaWWL/SonosLibrary/Sonos\ Customizations/
mkdir -v /Volumes/DharaWWL/SonosLibrary/Sonos\ Customizations/Sonos\ Share\ Info

rsync -avz /Volumes/DharaWWL/VMC_Additional_Files/VMC\ Alarms /Volumes/DharaWWL/SonosLibrary/Sonos\ Customizations/
rsync -avz /Volumes/DharaWWL/tag_munger/lib/shares/* /Volumes/DharaWWL/SonosLibrary/Sonos\ Customizations/Sonos\ Share\ Info
rsync -avz /Volumes/DharaWWL/$WWL_FOLDER/WWL_mp3/* /Volumes/DharaWWL/SonosLibrary
#rsync -avz /Volumes/DharaWWL/$WWL_FOLDER/WWL_Exceptions/* /Volumes/DharaWWL/SonosLibrary/Additional\ Material

echo '---'
echo 'now run the taggging command, then updateToNAS.sh'