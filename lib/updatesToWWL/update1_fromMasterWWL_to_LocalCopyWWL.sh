# copy from TrueCrypt encrypted master to DharaWWL silver 1gb portable HD
#    useful options to correct mistakes
#    --dry-run
#    --delete --delete-after --delete-excluded --exclude=.DS_Store
#
rsync -avz /Volumes/NO\ NAME/* /Volumes/DharaWWL/  # creates WWD_2014 folder

#TO DO FOR 2014 -- save a copy of the file 'Sonos Customizations/VMC gong/gong_sonos_alarm.mp3'
# because it was created by hawley from a file from barry and is not in the audio library.

# copy from ~/code/tag_munger to DharaWWL, create new folder tag_munger
rsync -avz --exclude=.git --exclude=.DS_Store --delete-excluded ~/code/tag_munger /Volumes/DharaWWL/

echo 'Now ALL ORIGINAL FILES should be on DharaWWL silver 1gb portable HD'
echo 'Next run updateToLocalSonosLibrary.sh'