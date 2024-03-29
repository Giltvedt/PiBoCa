#!/bin/bash

# PiBoCa (Pi Body Camera) v2023-02-12 https://github.com/Giltvedt/PiBoCa
#
# A small camera project connected to Raspberry Pi using gPhoto2 and processed with GraphicsMagick
# Controlled from the iPhone app Shortcuts.
# 
# The code is currently a bit primitive due to limited knowledge of bash scripting, but the most important thing is that it works for its intended purpose. January 2023 I started using ChatGPT to help improve my programming and scripting skills. It has undoubtedly made things easier to learn, increase knowledge, get new ideas and overcome obstacles. The motivation to continue is significantly greater now than when the project was last started. The contrast between googling for vague answers to having someone I can talk to and get comprehensive answers.
# 
# Variables for camera settings above and procedures in functions with argumens from `else if statements` below.

# Paths
basePATH=$HOME"/PiBoCa"
#basePATH=$(pwd)
pathDATE=`date "+%Y-%m"`
momentDATE=`date "+%Y%m%d_%H%M%S"`
imgdata="imgData"
imgdataPATHdate=$basePATH"/"$imgdata"/"$pathDATE
imgdataPATH=$basePATH"/"$imgdata""
tmpPATH=$basePATH"/tmp"
gpFileName=$imgdataPATH"/"$pathDATE"/"$momentDATE
# Image: Name and prefix
imgPREFIX=".jpg"
imgTMP="tmp"$imgPREFIX
imgLAST="last"$imgPREFIX
imgCURR="curr"$imgPREFIX
imgDIFF="diff"$imgPREFIX
# Settings
sleepTIME="3"
# Settings for GraphicsMagick
# Input:  '$ gm convert   -geometry $gmSCALE   -modulate $gmMODULATE -colorize $gmCURRcolor $imgCURR $imgLAST'
# Output: '$ gm convert   -geometry 40%        -modulate 130,0       -colorize 0,75,100     last.jpg last.jpg'
# Input:  '$ gm composite -dissolve $gmOPACITY $imgLAST              $imgCURR               $imgDIFF'
# Output: '$ gm composite -dissolve 50         last.jpg              curr.jpg               diff.jpg'
gmLASTcolor="100,75,0" # Blue
gmCURRcolor="0,75,100" # Red
gmSCALE="40%"
gmMODULATE="130,0"
gmOPACITY="50"

# Settings for gPhoto2, see 'man page' - http://www.gphoto.org/doc/manual/ref-gphoto2-cli.html
# Configurations specific for Canon PowerShot G9
# '$ gphoto2 --list-config' list available camera configurations
# '$ gphoto2 --list-all-config' receive available settings from camera
gphotoCONFIG="gphoto2 \
--quiet \
--set-config whitebalance=3 \
--set-config assistlight=1 \
--set-config iso=2 \
--set-config aperture=0 \
--set-config d01d=0 \
--set-config imagesize=0 \
--set-config zoom=0 \
--set-config flashmode=0 \
--set-config shootingmode=0 \
--set-config afdistance=1 \
--set-config shutterspeed=0 \
--set-config d01e=109 \
--set-config d006=0 \
--set-config d008=0 \
--capture-image-and-download"

# Passing arguments to bash function: https://linuxize.com/post/bash-functions/#passing-arguments-to-bash-functions

photoAdjust() {
	# Kommando og argument fyrt av iOS Shortcut.
	$gphotoCONFIG --filename $tmpPATH/$1-$imgTMP > /dev/null 2>&1 && \
	gm convert -geometry $gmSCALE -modulate $gmMODULATE -colorize $gmCURRcolor $tmpPATH/$1-$imgTMP $tmpPATH/$1-$imgCURR && \
	gm composite -dissolve $gmOPACITY $tmpPATH/$1-$imgLAST $tmpPATH/$1-$imgCURR $tmpPATH/$1-$imgDIFF && \
	cat $tmpPATH/$1-$imgDIFF

	# Linje 1 - gPhoto2: Skyt foto, lagre i TMP mappen, og mute.
	# Linje 2 - ImageMagick: Skaler ned, gjør om til sorthvitt og tint i rødt.
	# Linje 3 - ImageMagick: Miks forrige bilde (under) med siste bilde (over) med opacity til nytt bilde, mikset.
	# Linje 4 - cat: Print mikset bildet, snarvei i iOS appen mottar over på SSH og enkoder til bilde på hurtigvisning.
	# Kommando ferdig
}

photoShoot() {
	# Kommando og argument for å ta bilde, kopier til tmp og lag skalert blå tint versjon til sammenligning for neste bilde.
	$gphotoCONFIG --filename $gpFileName-$1$imgPREFIX > /dev/null 2>&1 && \
	lastFILE=$(find $imgdataPATH -type f -name "*.jpg" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1) && \
	gm convert -geometry $gmSCALE -modulate $gmMODULATE -colorize $gmLASTcolor $lastFILE $tmpPATH/$1-$imgLAST && \
	cat $lastFILE

	# Linje 1 - gPhoto2: Skyt foto og lagre i bildemappe, etter dagens år og måned 'YYYY-MM'.
	# Linje 2 - bash: Få komplett filbanen av siste bildet i gitt bildemappen. - Skriptet til variabel $lastFILE gir kun siste filen i en gitt mappe, men her trenger jeg få filen som inneholder "front", "side" eller "bak"    
	# Linje 3 - ImageMagick: Skaler ned, gjør om til sorthvitt og tint i blått.
	# Linje 4 - Cat: Print resultat som bekreftelse, snarvei i iOS appen mottar over på SSH og enkoder til bilde på hurtigvisning.
	# Kommando ferdig

	# Droppet - Linje x - cp: Kopier siste bildet til TMP mappen, overskrive eksisterende filen. - '$ cp $lastFILE $tmpPATH/$1-$imgLAST'
}

if [[ "$@" == testfront ]]; then
	photoAdjust "Front"
elif [[ "$@" == testside ]]; then
	photoAdjust "Side"
elif [[ "$@" == testbak ]]; then
	photoAdjust "Bak"
elif [[ "$@" == front ]]; then
	photoShoot "Front"
elif [[ "$@" == side ]]; then
	photoShoot "Side"
elif [[ "$@" == bak ]]; then
	photoShoot "Bak"
elif [[ "$@" == serie ]]; then
	$gphotoCONFIG --filename $gpFileName-Front$imgPREFIX > /dev/null 2>&1 && sleep $sleepTIME && \
	$gphotoCONFIG --filename $gpFileName-Side$imgPREFIX > /dev/null 2>&1 && sleep $sleepTIME && \
	$gphotoCONFIG --filename $gpFileName-Bak$imgPREFIX > /dev/null 2>&1

	# Idé - Få serie av bildene sendt til iPhone. Finn ut hvordan de 3 deles opp isteden for én fil - cat $gpFileName*-Front* && cat $gpFileName*-Side* && cat $gpFileName*-Bak*

elif [[ $1 == Face ]] && [[ $2 == Front ]] || [[ $2 == Angle ]] || [[ $2 == Side ]]; then
	$gphotoCONFIG --filename $tmpPATH/Face/$2-$imgTMP > /dev/null 2>&1 && \
	gm convert -geometry $gmSCALE -modulate $gmMODULATE -colorize $gmCURRcolor $tmpPATH/Face/$2-$imgTMP $tmpPATH/Face/$2-$imgCURR && \
	gm composite -dissolve $gmOPACITY $tmpPATH/Face/$2-$imgLAST $tmpPATH/Face/$2-$imgCURR $tmpPATH/Face/$2-$imgDIFF
	cat $tmpPATH/Face/$2-$imgDIFF
	
	# Conditions to check command start with following word such "Face" first. Then check second word is "Front" or "Side". Those are primary for naming files.
	# Line 1 - 'gphoto2' shoot photo to tmp folder.
	# Line 2 - 'gm' for scale down image resolution, greyscale and colorize it red as reference to compare with previous photo.
	# Line 3 - 'gm' for merge this current photo with previous photo below.
	# Line 4 - 'cat' image as base64 to transfer it over SSH for output as photo at iPhone trought Shortcut-app. (Should make it as option)
	# Done

elif [[ $1 == Save ]] && [[ $2 == Body ]] && [[ $3 == Front ]] || [[ $3 == Side ]] || [[ $3 == Back ]]; then
	# imageDATE=$momentDATE && \
	gm convert -geometry $gmSCALE -modulate $gmMODULATE -colorize $gmLASTcolor $tmpPATH/$3-$imgTMP $tmpPATH/$3-$imgLAST && \
	cp $tmpPATH/$3-$imgTMP $imgdataPATH/$momentDATE-$3$imgPREFIX

	# Condition to check command start with following word such "Save" first. Then check second word is "Body". And third word as "Front", "Side" and "Back". 
	# Line 1 - Save date and time when photo shoot, as variable. Use this when approved photos will be moved to other place.
	# Line 2 - 'gm' for scale down image resolution, greyscale and colorize it as blye as reference to compare with next photo.
	# Done

elif [[ $1 == Save ]] && [[ $2 == Face ]] || [[ $3 == Front ]] || [[ $2 == Angle ]] || [[ $2 == Side ]]; then
	# imageDATE=$momentDATE && \
	gm convert -geometry $gmSCALE -modulate $gmMODULATE -colorize $gmLASTcolor $tmpPATH/Face/$3-$imgTMP $tmpPATH/Face/$3-$imgLAST && \
	cp $tmpPATH/Face/$3-$imgTMP $imgdataPATH/Face-$3/$momentDATE-$2$imgPREFIX

	# This should be optimized with above with similar function. Have to learn and test it out.
	# Condition to check command start with following word such "Save" first. Then check second word is "Face". And third word as "Front" and "Side". 
	# Line 1 - Save date and time when photo shoot, as variable. Use this when approved photos will be moved to other place.
	# Line 2 - 'gm' for scale down image resolution, greyscale and colorize it as blye as reference to compare with next photo.
	# Done

elif [[ "$@" == var ]]; then
	echo "- basePATH:         "$basePATH
	echo "- pathDATE:         "$pathDATE
	echo "- momentDATE:       "$momentDATE
	echo "- imgdata:          "$imgdata
	echo "- imgdataPATHdate:  "$imgdataPATHdate
	echo "- imgdataPATH:      "$imgdataPATH
	echo "- tmpPATH:          "$tmpPATH
	echo "- gpFileName:       "$gpFileName
	echo "- imgPREFIX:        "$imgPREFIX
	echo "- imgTMP:           "$imgTMP
	echo "- imgLAST:          "$imgLAST
	echo "- imgCURR:          "$imgCURR
	echo "- imgDIFF:          "$imgDIFF
	echo "- sleepTIME:        "$sleepTIME
	echo "- gmLASTcolor:      "$gmLASTcolor
	echo "- gmCURRcolor:      "$gmCURRcolor
	echo "- gmSCALE:          "$gmSCALE
	echo "- gmMODULATE:       "$gmMODULATE
	echo "- gmOPACITY:        "$gmOPACITY

elif [[ "$@" == tester ]]; then
	$gphotoCONFIG --filename $gpFileName-TEST$imgPREFIX && \
	lastFILE=$(find $imgdataPATH -type f -name "*.jpg" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1) && \
	cat $lastFILE

	# Test om kamera får tatt bildet og lagret det.

elif [[ "$@" == siste ]]; then
	lastFILE=$(find $imgdataPATH -type f -name "*.jpg" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1) && \
	cat $lastFILE

	# Få se siste bildet
	# Idé/forbedring, spesifikk for iOS Shortcuts;
	# - Få siste 12 filene (foran, side og bak)
	# - Evt filtrere etter
	#   - Foran, side eller bak
	#   - Gitt dato periode
	# - Del opp alle 12 linjer som liste
	# - Presenter som menyvalg
	# - Velg fra listen
	# - Kommander 'cat' fra filen
	# - Motta til hurtigvisning
	# - Ferdig

elif [[ "$@" == hvor ]]; then
	echo "PiBoca-mappen ligger på:" $basePATH

else
	echo "\
 _____ _ _____     _____     
|  _  |_| __  |___|     |___ 
|   __| | __ -| . |   --| .'|
|__|  |_|_____|___|_____|__,| - Kjente ikke igjen argumentet, forventer følgende:"; # https://patorjk.com/software/taag/#p=display&f=Rectangles&t=PiBoca
	echo " "
	echo "- [front,side,bak]     : Ta bilde fra [front,side,bak]";
	echo "- [test,side,bak]front : Ta bilde nå av [front,side,bak] og sammenligne plasseringen mot siste bildet.";
	echo "- serie                : Ta bildeserie på 3 bilder med N sekunder mellom.";
	echo "- hvor                 : Hvor er skriptet lagret?";
	echo "- var                  : Print alle variabler.";
	echo "- tester               : Sjekk om kamera gjør som det skal.";
	echo "- siste                : iOS Shortcuts feature: Hent bilde fra siste registrering. Rådump for visning på iOS.";
fi
