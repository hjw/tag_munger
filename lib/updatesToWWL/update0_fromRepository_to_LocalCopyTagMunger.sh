# copy from ~/code/tag_munger to DharaWWL (VMC's silver 2.5 inch portable hard disk), create new folder tag_munger
# to create or update the tag_munger utilities.
rsync -avz --exclude=.git --exclude=.DS_Store --delete-excluded ~/code/tag_munger /Volumes/DharaWWL/

echo 'Now TAG MUNGER UTILTIES should be on DharaWWL silver 1gb portable HD'
echo 'To tag the local "SonosLibrary"'
echo 'If git repostory "tag_munger" was not updated, get the lastest version and re-run'