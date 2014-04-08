#!/bin/sh
# Create or updates file links in shared volumes of Sonos Sound Library
# 	Designed to be copied to QNAP TS-112 NAS drive and run locally via ssh
#	Complains if shared folder does not exist; does not complain if link source does not exist
#
### NOTE: ln options available on QNAP TS-112 NAS
#	-s	make symbolic links instead of hard links
#	-f	remove existing destination files
#	-n	don't dereference symlinks, ok to link to another link
# find $SHAREDIR -type l -delete # erase old links NOTE: -delete does not work on NAS, how to safely remove obsolete links?

# 2014-01-02 CDM File Created, based on 2012 library, for use with WWL 2013
# 2014-04-08 CDM Updates in progress for 2014 library

# Base directories and common files
#   NOTE: we are expecting links below should not have a trailing slash
SHAREBASE='/share/HDA_DATA' # Destination: base directory of shared folders where we create links
AUDIOBASE='/share/HDA_DATA/AudioLibrary' # Source: base directory of audio library
GONG_FOR_SONOS_ALARM=$AUDIOBASE/'Sonos Customizations/VMC gong/gong_sonos_alarm.mp3' # has silence at start and end for Sonos alarm use
STD_BENEFITS_OF_DS=$AUDIOBASE/'Dhamma Service/Benefits of Dhamma Service/D10_2030_English_Benefits_of_D.Service.mp3'
STD_GROUP_SITTINGS=$AUDIOBASE/'Groupsittings/GSs English-only/' # album with group sittings for between courses
STD_SPECIAL_CHANTINGS=$AUDIOBASE/'Special Chantings'
STD_WORKERSMETTA=$AUDIOBASE/'Workers Metta/Workers Metta 2005' # all languages of Workers Metta
STD_MORNING_CHANTINGS=$AUDIOBASE/'10 Day Morning Chantings' # tagged with "10 Day Morning Chanting" for a separate album
MIXED_IN_MORNING_CHANTINGS=$AUDIOBASE/'Sonos Customizations/10 Day Morning Chantings' # "_10d" added to file name so they go to correct Dxx_10d album
MIXED_IN_HINDI_PDI=$AUDIOBASE/'Sonos Customizations/10D_Hindi_PDI' # to add to Dxx_10d albums that may have other languages

#
PROGNAME="`/usr/bin/basename $0`"
FATAL="$PROGNAME: fatal:"

#--- check source
if [ ! -d $AUDIOBASE ]
then
	echo "$FATAL folder $AUDIOBASE does not exist"; exit 100
fi

#--- make BetweenCourses links
SHAREDIR="$SHAREBASE/BetweenCourses"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  "$STD_GROUP_SITTINGS"
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
	ln -sfn  "$STD_WORKERSMETTA"
	ln -sfn  "$STD_MORNING_CHANTINGS"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 1Day_EN links
SHAREDIR="$SHAREBASE/1Day_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'1 Day Course Sets' # 1D English-only -> /share/HDA_DATA/BarryLibrary/1 Day Course Sets/1D English-only/
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
	ln -sfn  "$STD_WORKERSMETTA"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 3Day_EN links
SHAREDIR="$SHAREBASE/3Day_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'3 Day Course Sets/3D Burmese/3D English Discourses'
	ln -sfn  $AUDIOBASE/'3 Day Course Sets/3D Burmese/3D English Instructions'
	ln -sfn  "$STD_BENEFITS_OF_DS"
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
	ln -sfn  "$STD_WORKERSMETTA"
	ln -sfn  "$STD_MORNING_CHANTINGS" # chantings in a separate album for 3 Day
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 3Day_Burmese_EN links
SHAREDIR="$SHAREBASE/3Day_Burmese_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'3 Day Course Sets/3D Burmese/3D Burmese Instructions'
	ln -sfn  $AUDIOBASE/'3 Day Course Sets/3D Burmese/3D Burmese Discourses'
	ln -sfn  $AUDIOBASE/'3 Day Course Sets/3D English-only/3D English Discourses'
	ln -sfn  "$STD_BENEFITS_OF_DS"
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
	ln -sfn  "$STD_WORKERSMETTA"
	ln -sfn  "$STD_MORNING_CHANTINGS" # chantings in a separate album for 3 Day
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 10Day_EN links
SHAREDIR="$SHAREBASE/10Day_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D English-only/10D English Discourses'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D English-only/10D English Instructions'
	ln -sfn  "$MIXED_IN_MORNING_CHANTINGS"
	ln -sfn  "$MIXED_IN_HINDI_PDI"
	ln -sfn  "$STD_BENEFITS_OF_DS"
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
	ln -sfn  "$STD_WORKERSMETTA"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 10D_Burmese_EN links
SHAREDIR="$SHAREBASE/10D_Burmese_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Burmese/10D Burmese Discourses'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Burmese/10D E-Burmese Instructions'
	ln -sfn  "$MIXED_IN_MORNING_CHANTINGS"
	#ln -sfn  "$MIXED_IN_HINDI_PDI"
	ln -sfn  "$STD_BENEFITS_OF_DS"
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
	ln -sfn  "$STD_WORKERSMETTA"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 10D_Khmer_EN links
SHAREDIR="$SHAREBASE/10D_Khmer_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Khmer/10D Khmer Discourses'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Khmer/10D E-Khmer Instructions'
	ln -sfn  "$MIXED_IN_MORNING_CHANTINGS"
	#ln -sfn  "$MIXED_IN_HINDI_PDI"
	ln -sfn  $AUDIOBASE/'Dhamma Service/Benefits of Dhamma Service/D10_2030_Khmer_Benefits_of_D.Service.mp3'
	ln -sfn  "$STD_BENEFITS_OF_DS"
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
	ln -sfn  "$STD_WORKERSMETTA"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 10D_Chinese_EN links  
#	 note: Mandarin_EN and Cantonese_EN audio files will be in the same album, unless AT searches by Folder
SHAREDIR="$SHAREBASE/10D_Chinese_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Mandarin/10D Mandarin Discourses'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Mandarin/10D E-Mandarin Instructions'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Cantonese/10D Cantonese Discourses'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Cantonese/10D E-Cantonese Instructions'
	ln -sfn  "$MIXED_IN_MORNING_CHANTINGS"
	#ln -sfn  "$MIXED_IN_HINDI_PDI"
	ln -sfn  "$STD_BENEFITS_OF_DS"
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
	ln -sfn  "$STD_WORKERSMETTA"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make STP_EN links
SHAREDIR="$SHAREBASE/STP_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'STP Course Sets/STP English-only/STP English Instructions'
	# ln -sfn  $AUDIOBASE/'STP Course Sets/STP English-only/STP English Discourses'  #TO-DO add these when correct tagging is added
	ln -sfn  $AUDIOBASE/'Special Chantings/Satipatthana_Sutta_Jan_1985_wSM.mp3'
	ln -sfn  "$STD_BENEFITS_OF_DS"
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
	ln -sfn  "$STD_WORKERSMETTA"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make STP_Burmese_EN links
SHAREDIR="$SHAREBASE/STP_Burmese_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'STP Course Sets/STP Burmese/STP E-Burmese Instructions'
	ln -sfn  $AUDIOBASE/'STP Course Sets/STP Burmese/STP Burmese Discourses'
	ln -sfn  $AUDIOBASE/'Special Chantings/Satipatthana_Sutta_Jan_1985_wSM.mp3'
	#ln -sfn  $AUDIOBASE/'Dhamma Service/Benefits of Dhamma Service/D10_2030_Burmese_Benefits_of_D.Service.mp3'  # does not exist in Burmese
	ln -sfn  "$STD_BENEFITS_OF_DS"
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
	ln -sfn  "$STD_WORKERSMETTA"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make STP_Khmer_EN links
SHAREDIR="$SHAREBASE/STP_Khmer_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'STP Course Sets/STP Khmer/STP E-Khmer Instructions'
	ln -sfn  $AUDIOBASE/'STP Course Sets/STP Khmer/STP Khmer Discourses'
	ln -sfn  $AUDIOBASE/'Special Chantings/Satipatthana_Sutta_Jan_1985_wSM.mp3'
	ln -sfn  $AUDIOBASE/'Dhamma Service/Benefits of Dhamma Service/D10_2030_Khmer_Benefits_of_D.Service.mp3'
	ln -sfn  "$STD_BENEFITS_OF_DS"
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
	ln -sfn  "$STD_WORKERSMETTA"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi


# end of script