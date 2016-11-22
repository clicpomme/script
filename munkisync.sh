#!/bin/bash

#  2016 Clicpomme
# www.clicpomme.com
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0s
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

MUNKI_USER_SOURCE=munkiadmin
MUNKI_REPO_SOURCE=~/
MUNKI_HOST_SOURCE=munki.EXAMPLE.COM
MUNKI_REPO_TARGET=~/
RSYNC_EXCLUDE="\
	--exclude=.** \
	--exclude=pkgs/local/ \
	--exclude=pkgsinfo/local/ \
	--exclude=manifests/ \
	--exclude=catalogs/ \
	--exclude=log/ \
	--exclude=dev/ \
	--exclude=tmp/ \
	"

RSYNC_OPTIONS="-aHSpv --delete-during  $RSYNC_EXCLUDE $RSYNC_INCLUDE $@"
#RSYNC_OPTIONS="-aHSpv --delete-during --bwlimit=64 $RSYNC_EXCLUDE $RSYNC_INCLUDE $@"

if [[ ! -d ~/log ]]; then
	mkdir ~/log
fi

echo "munkisync started: $(date)" > ~/log/munkisync.log 2>&1
/usr/bin/rsync $RSYNC_OPTIONS $MUNKI_USER_SOURCE@$MUNKI_HOST_SOURCE:$MUNKI_REPO_SOURCE $MUNKI_REPO_TARGET >> ~/log/munkisync.log 2>&1
$HOME/bin/makecatalogs ~ >> ~/log/munkisync.log 2>&1
echo "munkisync ended: $(date)" >> ~/log/munkisync.log 2>&1
