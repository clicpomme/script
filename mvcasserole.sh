#!/bin/sh
# Richard Charbonneau
# 22-09-2015
# clicpomme.com
# mv /Users/Shared/FONTS_ORFE ~/Documents/
chmod -R 777 /Users/Shared/ORFE_Lanceur.fmp12
currentUser=`ls -l /dev/console | awk '{ print $3 }'`
mv /Users/Shared/ORFE_Lanceur.fmp12 /Users/$currentUser/Desktop/ORFE_Lanceur.fmp12