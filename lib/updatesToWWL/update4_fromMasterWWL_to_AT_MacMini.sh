# copy from DharaWWL silver 1gb portable HD to VMC's mac minis in AT rooms
#    useful options to correct mistakes
#    --dry-run
#    --delete --delete-after --delete-excluded --exclude=.DS_Store
#
# make a local copy called SonosLibrary on DharaWWL silver 1gb portable HD, making slight rearrangements
PORTABLE='/Volumes/DharaWWL'
WWL_FOLDER='WWD_2015'
WWL_Exceptions ='WWL_Exceptions'
VMC_ADDITIONAL ='VMC_Additional_Files'
MP3_FOLDER='/Users/Shared/MP3\ Library'

mkdir -v $MP3_FOLDER
mkdir -v $MP3_FOLDER/$WWL_Exceptions
mkdir -v $MP3_FOLDER/$VMC_ADDITIONAL

#rsync -avz $PORTABLE/$WWL_FOLDER/WWL_HDD/* $MP3_FOLDER
#rsync -avz $PORTABLE/$WWL_FOLDER/$WWL_Exceptions/* $MP3_FOLDER/$WWL_Exceptions
rsync -avz $PORTABLE/$VMC_ADDITIONAL/* $MP3_FOLDER/$VMC_ADDITIONAL

# rsync -avz --delete-after --dry-run /Volumes/DharaWWL/WWD_2014/WWL_HDD /Users/Shared/MP3\ Library |less
# chmod -R g-w /Users/Shared/MP3\ Library/
# chmod -R o-w /Users/Shared/MP3\ Library/


#chmod -R g-w $MP3_FOLDER
#chmod -R o-w $MP3_FOLDER

echo 'Now ALL ORIGINAL FILES should be on DharaWWL silver 1gb portable HD'
echo 'Done.  Log in as AT and verify files are readable but not changeable.'