#!/bin/bash
# Script to generate Fluxbox Menu for Linux

# This program is free software: you can redistribute it and/or modify it under the terms version 3 of the License, or (at your option) any later version.
# See the GNU General Public License for more details.
#    Please, see http://www.gnu.org/licenses/.

mint="/usr/share/applications/*.desktop"
tmpMenu=$(mktemp /tmp/fbm.XXXXX) || { echo "Error creating temp"; exit 1; }
fbMenu="$HOME/.fluxbox/Categories/auto"

for category in $(grep "^Categories=" $mint | cut -d"=" -f2 | cut -d";" -f1 | sort | uniq | grep -vE "^[0-9][0-9]-[0-9][0-9]"); do
	echo "[submenu] ($(echo $category | sed 's/-/ /g;s/\b\(.\)/\u\1/g')) <$HOME/.fluxbox/icons/categories/$category.png> " >> $tmpMenu
	for app in $(grep -m1 "^Categories=${category:0:2}" $mint | cut -d":" -f1); do
		appTerm=`grep -m1 "^Terminal=" $app | cut -d"=" -f 2`
		appCat=`grep -m1 "^Categories=" $app | cut -d"=" -f 2 | cut -d";" -f 1`
		appExec=`grep -m1 "^Exec=" $app | cut -d"=" -f 2`
		appName=`grep -m1 "^Name=" $app | cut -d"=" -f 2`
		appIcon=`grep -m1 "^Icon=" $app | cut -d"=" -f 2`
		if [ "$appTerm" == "false" ]; then
			echo "   [exec] ($appName) {$appExec} </usr/share/icons/Mint-Y/apps/48/$appIcon.png> " >> $tmpMenu
		else
			appExec=$(echo $appExec | cut -d'"' -f2 | cut -d";" -f1)
			echo "   [exec] ($appName) {gnome-terminal -e '$appExec'} </usr/share/icons/Mint-Y/apps/48/$appIcon.png>" >> $tmpMenu
		fi
	done
	echo "[end]" >> $tmpMenu
done

cp $tmpMenu $fbMenu
exit 0
