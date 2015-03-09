#! /bin/sh

#original script: http://pclosmag.com/html/Issues/201308/page02.html

n=1
corm=$(zenity --list --radiolist --column="Select" --column="Action" --title="Copy Or Move" --width=200 --height=175 --text="Select which activity you\nwould like to perform:" TRUE Copy FALSE Move)
   if [ $? == 1 ]; then
      exit
   fi

dest="$(zenity --file-selection --directory)"

if [ $corm == "Copy" ]; then

  for file in "$@"; do
    if [ ! -e "$file" ]; then
        continue
    fi
       cp -r "$file" "$dest"
       echo $(($n * 100 / $#))
       echo "# Copying file: $file"
       let "n = n+1"

    done | (zenity  --progress --title "Copying Files..." --percentage=0 --auto-close --auto-kill)

elif [ $corm == "Move" ]; then

  for file in "$@"; do
    if [ ! -e "$file" ]; then
        continue
    fi
       mv "$file" "$dest"
       echo $(($n * 100 / $#))
       echo "# Moving file: $file"
       let "n = n+1"

    done | (zenity  --progress --title "Moving Files..." --percentage=0 --auto-close --auto-kill)

fi

exit 0
