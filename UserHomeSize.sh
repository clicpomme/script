#!/bin/bash
# Richard Charbonneau Clicpomme 2015
echo "<result>"

UserList=`dscl . list /Users UniqueID | awk '$2 > 501 { print $1 }'` 

for u in $UserList ; 
do
if [ -d /Users/$u/ ]; then
results=`du -sh /Users/$u/ | grep -v \ | grep -v "\.plist" | awk '{print $1}'`
else continue
fi
echo $u $results

done
echo "</result>"
exit 0
