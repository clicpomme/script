#!/bin/bash
# Richard Charbonneau Clicpomme 2015
UserList=`dscl . list /Users UniqueID | awk '$2 > 501 { print $1 }'` 

for u in $UserList ; 
do
if [ -d /Users/$u/ ]; then
results=`du -sh /Users/$u/ | grep -v \ | grep -v "\.plist" | awk '{print $1}'`
else results= "N/A"
fi
echo $u $results
done

