#!/bin/bash

# This file is part of the Zimbra OpenPGP Zimlet project.
# Copyright (C) 2014-2016  Barry de Graaff
# 
# Bugs and feedback: https://github.com/Zimbra-Community/pgp-zimlet/issues
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses/.


# This script does some checks and creates a zip file for zimlet release

# check number of parameters in command
PARAMS=1
if [ $# -ne "$PARAMS" ]
then
  echo
  echo "Please specify version number, for example: 1.2.3"
  echo
  exit 1
fi



if grep --quiet $1 README.md; then
  echo "OK version number found in README.md" 
else
  echo "FAIL version number not found in README.md" 
  exit 0
fi

if grep --quiet $1 tk_barrydegraaff_zimbra_openpgp/tk_barrydegraaff_zimbra_openpgp.xml; then
  echo "OK version number found in tk_barrydegraaff_zimbra_openpgp/tk_barrydegraaff_zimbra_openpgp.xml" 
else
  echo "FAIL version number not found in tk_barrydegraaff_zimbra_openpgp/tk_barrydegraaff_zimbra_openpgp.xml" 
  exit 0
fi

echo "Create translations"
cat <<EOF > tk_barrydegraaff_zimbra_openpgp/lang.js
/* When adding a language for translation, you may git clone and copy paste from a language in the lang/ folder OR
* download a language from the lang/ folder do your translations and send your copy to lorenzo.milesi@yetopen.it
* 
* When editing, please open files in Geany http://www.geany.org/ or use and UTF-8 aware editor
* mode = Unix LF
* encoding = UTF-8
* Additionally you may wish to translate /help/index.html
* 
* New languages will be added to the Zimlet after review.
*/

/*
This file is part of the Zimbra OpenPGP Zimlet project.
Copyright (C) 2014-2016 Barry de Graaff

Bugs and feedback: https://github.com/Zimbra-Community/pgp-zimlet/issues

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.
*/


/*
 * THIS FILE IS AUTOMATICALLY GENERATED VIA THE BUILD.SH SCRIPT
 *      *** MANUAL CHANGES IN THIS FILE WILL BE PURGED ***
 */

tk_barrydegraaff_zimbra_openpgp.prototype.lang = function () {
tk_barrydegraaff_zimbra_openpgp.lang = [];
EOF

cat tk_barrydegraaff_zimbra_openpgp/lang/*.js >> tk_barrydegraaff_zimbra_openpgp/lang.js
echo -e "\n\r\n\r}" >> tk_barrydegraaff_zimbra_openpgp/lang.js

echo "Make a copy of the source"
rm -Rf /tmp/tk_barrydegraaff_zimbra_openpgp
mkdir /tmp/tk_barrydegraaff_zimbra_openpgp
cp -r -v tk_barrydegraaff_zimbra_openpgp /tmp/

echo "Remove _dev prefix"
grep -lZr -e "_dev/" "/tmp/tk_barrydegraaff_zimbra_openpgp/" | xargs -0 sed -i "s^_dev/^^g"

echo "Build release zip"
cd /tmp/tk_barrydegraaff_zimbra_openpgp
rm -Rf /tmp/tk_barrydegraaff_zimbra_openpgp/lang
zip -r tk_barrydegraaff_zimbra_openpgp.zip *

rm /tmp/tk_barrydegraaff_zimbra_openpgp.zip
mv /tmp/tk_barrydegraaff_zimbra_openpgp/tk_barrydegraaff_zimbra_openpgp.zip /tmp/tk_barrydegraaff_zimbra_openpgp.zip
rm -Rf /tmp/tk_barrydegraaff_zimbra_openpgp

echo 'All done, your release zip should be here: /tmp/tk_barrydegraaff_zimbra_openpgp.zip'


exit 0

# choose ^ for seperation of sed command, so ^ cannot be used to search and replace
#The character you put after ’s’ (s being substitute command) determines delimiter you want to use. So you can always specify delimiter that is not contained in your search string to avoid errors, and provide better readability compared to escaping forward slashes. In your case to search for http://www.example.com/oldpage.html and replace it with http://www.example.com/newpage.html you could use ‘_’ as separator:
#sed ’s_http://www.example.com/oldpage.html_http://www.example.com/newpage.html_g’



