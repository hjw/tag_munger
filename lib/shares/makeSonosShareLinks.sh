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

# Base directories
#   NOTE: the links below should not have a trailing slash
SHAREBASE='/share/HDA_DATA' # Destination: base directory of shared folders where we create links
AUDIOBASE='/share/HDA_DATA/SonosLibrary' # Source: base directory of audio library
# common and custom and important file and folder paths put here
GONG_FOR_SONOS_ALARM=$AUDIOBASE/'Sonos Customizations/VMC gong/gong_sonos_alarm.mp3' # has silence at start and end for Sonos alarm use
STD_BENEFITS_OF_DS=$AUDIOBASE/'Dhamma Service/Benefits of Dhamma Service/D10_2030_English_Benefits_of_D.Service.mp3'
STD_GROUP_SITTINGS=$AUDIOBASE/'Groupsittings/GSs English-only/' # album with group sittings for between courses
STD_SPECIAL_CHANTINGS=$AUDIOBASE/'Special Chantings'
STD_WORKERSMETTA=$AUDIOBASE/'Workers Metta/Workers Metta 2005' # all languages of Workers Metta
STD_MORNING_CHANTINGS=$AUDIOBASE/'10 Day Morning Chantings' # tagged with "10 Day Morning Chanting" for a separate album
TENDAY_MIXED_IN_MORNING_CHANTINGS=$AUDIOBASE/'Sonos Customizations/10 Day Morning Chantings' # "_10d" added to file name so they go to correct Dxx_10d album
TENDAY_HINDI_PDI=$AUDIOBASE/'Sonos Customizations/10D_Hindi_PDI' # tagged with "_Hindi_PDI" for a separate album, used in non-Hindi 10Day courses.
#
PROGNAME="`/usr/bin/basename $0`"
FATAL="$PROGNAME: fatal:"

#--- check source
if [ ! -d $AUDIOBASE ]
then
	echo "$FATAL folder $AUDIOBASE does not exist"; exit 100
fi

#--- make RequiredAudio links
SHAREDIR="$SHAREBASE/RequiredAudio"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  "$STD_GROUP_SITTINGS"
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
	ln -sfn  "$STD_WORKERSMETTA"
	ln -sfn  "$STD_MORNING_CHANTINGS"
	ln -sfn  "$STD_BENEFITS_OF_DS"
	ln -sfn  "$GONG_FOR_SONOS_ALARM"
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
	ln -sfn  "$TENDAY_MIXED_IN_MORNING_CHANTINGS"
	ln -sfn  $AUDIOBASE/'Dhamma Service/Benefits of Dhamma Service/D10_2030_English_Benefits_of_D.Service.mp3'
	ln -sfn  "$TENDAY_HINDI_PDI"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 10Day_Burmese_EN links
SHAREDIR="$SHAREBASE/10Day_Burmese_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Burmese/10D Burmese Discourses'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Burmese/10D E-Burmese Instructions'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D English-only/10D English Discourses'
	ln -sfn  "$TENDAY_MIXED_IN_MORNING_CHANTINGS"
	# no D10_2030_Burmese_Benefits_of_D.Service.mp3 exists
	ln -sfn  "$TENDAY_HINDI_PDI"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 10Day_Khmer_EN links
SHAREDIR="$SHAREBASE/10Day_Khmer_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Khmer/10D Khmer Discourses'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Khmer/10D E-Khmer Instructions'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D English-only/10D English Discourses'
	ln -sfn  "$TENDAY_MIXED_IN_MORNING_CHANTINGS"
	ln -sfn  "$STD_BENEFITS_OF_DS"
	ln -sfn  $AUDIOBASE/'Dhamma Service/Benefits of Dhamma Service/D10_2030_Khmer_Benefits_of_D.Service.mp3'
	ln -sfn  "$TENDAY_HINDI_PDI"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 10Day_Chinese_EN links  
#	 note: Mandarin_EN and Cantonese_EN audio files will be in the same album, unless AT searches by Folder
SHAREDIR="$SHAREBASE/10Day_Chinese_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Mandarin/10D E-Mandarin Instructions'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Mandarin/10D Mandarin Discourses'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Cantonese/10D Cantonese Discourses'
	#ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Cantonese/10D E-Cantonese Instructions'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D English-only/10D English Discourses'
	ln -sfn  "$TENDAY_MIXED_IN_MORNING_CHANTINGS"
	ln -sfn  "$STD_BENEFITS_OF_DS"
	ln -sfn  $AUDIOBASE/'Dhamma Service/Benefits of Dhamma Service/D10_2030_Mandarin_Benefits_of_D.Service.mp3'
	ln -sfn  $AUDIOBASE/'Dhamma Service/Benefits of Dhamma Service/D10_2030_Cantonese_Benefits_of_D.Service.mp3'
	ln -sfn  "$TENDAY_HINDI_PDI"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 10day_Thai_EN links
SHAREDIR="$SHAREBASE/10day_Thai_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Thai/10D E-Thai Instructions'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D Thai/10D Thai Discourses'
	ln -sfn  $AUDIOBASE/'10 Day Course Sets/10D English-only/10D English Discourses'
	ln -sfn  "$TENDAY_MIXED_IN_MORNING_CHANTINGS"
	ln -sfn  "$STD_BENEFITS_OF_DS"
	ln -sfn  $AUDIOBASE/'Dhamma Service/Benefits of Dhamma Service/D10_2030_Thai_Benefits_of_D.Service.mp3'
	ln -sfn  "$TENDAY_HINDI_PDI"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 1Day_EN links
SHAREDIR="$SHAREBASE/1Day_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'1 Day Course Sets/1D English-only' # 1D English-only -> /share/HDA_DATA/BarryLibrary/1 Day Course Sets/1D English-only/
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 3Day_EN links
SHAREDIR="$SHAREBASE/3Day_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'3 Day Course Sets/3D English-only/3D English Instructions'
	ln -sfn  $AUDIOBASE/'3 Day Course Sets/3D English-only/3D English Discourses'
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
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 3Day_Khmer_EN links
SHAREDIR="$SHAREBASE/3Day_Khmer_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'3 Day Course Sets/3D Khmer/3D Khmer Instructions'
	ln -sfn  $AUDIOBASE/'3 Day Course Sets/3D Khmer/3D Khmer Discourses'
	ln -sfn  $AUDIOBASE/'3 Day Course Sets/3D English-only/3D English Discourses'
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 9Day_EN links
echo TO-DO make links for 9Day_EN

#--- make STP_EN links
SHAREDIR="$SHAREBASE/STP_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
	ln -sfn  $AUDIOBASE/'STP Course Sets/STP English-only/STP English Instructions'
	ln -sfn  $AUDIOBASE/'STP Course Sets/STP English-only/STP English Discourses'
	ln -sfn  $AUDIOBASE/'Special Chantings/Satipatthana_Sutta_Jan_1985_wSM.mp3'
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
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make Teen_EN links
echo TO-DO make links for Teen_EN

#--- make Children_EN links
echo TO-DO make links for Children_EN

#--- make 10DaySpl_EN links
SHAREDIR="$SHAREBASE/10DaySpl_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
  ln -sfn $AUDIOBASE/'10 Day Special Course Sets/10D SPL English-only/10D SPL English Discourses' 
  ln -sfn $AUDIOBASE/'10 Day Special Course Sets/10D SPL English-only/10D SPL English Instructions' 
	ln -sfn  "$STD_SPECIAL_CHANTINGS/Tikapatthana-U_Ba_Khin.mp3"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 20Day_EN links
SHAREDIR="$SHAREBASE/20Day_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
  ln -sfn $AUDIOBASE/'20 Day Course Sets/20D English-only/20D English Discourses' 
  ln -sfn $AUDIOBASE/'20 Day Course Sets/20D English-only/20D English Instructions' 
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 30Day_EN links
SHAREDIR="$SHAREBASE/30Day_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
  ln -sfn $AUDIOBASE/'30 Day Course Sets [w.10Ds Anapana]/30D English-only [10A]/30D English Discourses [10A]' 
  ln -sfn $AUDIOBASE/'30 Day Course Sets [w.10Ds Anapana]/30D English-only [10A]/30D English Instructions [10A]' 
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 30Day_Khmer_EN links
SHAREDIR="$SHAREBASE/30Day_Khmer_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
  ln -sfn $AUDIOBASE/'30 Day Course Sets [w.10Ds Anapana]/30D Khmer [10A]/30D E-Khmer Instructions [10A]' 
  ln -sfn $AUDIOBASE/'30 Day Course Sets [w.10Ds Anapana]/30D English-only [10A]/30D English Discourses [10A]' 
  ln -sfn $AUDIOBASE/'30 Day Course Sets [w.10Ds Anapana]/30D Khmer [10A]/30D Khmer Discourses [10A]' 
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 45Day_EN links
SHAREDIR="$SHAREBASE/45Day_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
  ln -sfn $AUDIOBASE/'45 Day Course Sets [w.10Ds Anapana]/45D English-only [10A]/45D English Discourses [10A]' 
  ln -sfn $AUDIOBASE/'45 Day Course Sets [w.10Ds Anapana]/45D English-only [10A]/45D English Instructions [10A]' 
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 45Day_Khmer_EN links
SHAREDIR="$SHAREBASE/45Day_Khmer_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
  ln -sfn $AUDIOBASE/'45 Day Course Sets [w.10Ds Anapana]/45D Khmer [10A]/45D E-Khmer Instructions [10A]' 
  ln -sfn $AUDIOBASE/'45 Day Course Sets [w.10Ds Anapana]/45D English-only [10A]/45D English Discourses [10A]' 
  ln -sfn $AUDIOBASE/'45 Day Course Sets [w.10Ds Anapana]/45D Khmer [10A]/45D Khmer Discourses [10A]' 
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 45Day15A_EN links
SHAREDIR="$SHAREBASE/45Day15A_EN"
if [ -d $SHAREDIR ]
then
	cd $SHAREDIR; echo making links in $SHAREDIR
  ln -sfn $AUDIOBASE/'45 Day Course Sets [w.15Ds Anapana]/45D English-only [15A]/45D English Discourses [15A]' 
  ln -sfn $AUDIOBASE/'45 Day Course Sets [w.15Ds Anapana]/45D English-only [15A]/45D English Instructions [15A]' 
	ln -sfn  "$STD_SPECIAL_CHANTINGS"
else
	echo "$FATAL folder $SHAREDIR does not exist"; exit 100
fi

#--- make 60Day_EN links
echo TO-DO make links for 60Day_EN

#--- make LongCourseServers links
echo TO-DO make links for LongCourseServers

echo end of script
#------------------------------------------
