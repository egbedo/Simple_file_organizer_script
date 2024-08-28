#!/bin/bash

# Ensure the target directory exists
if [ ! -d "organized_files" ]; then
    mkdir "organized_files"
fi

touch log.txt
log_file="log.txt"




#function to move the files based on their extensions with logging and conflict handling
function move_files(){
    for file in *; do
        if [ -f "$file" ]; then
            ext="${file##*.}"
            filename=$(basename "$file")
            case "$ext" in
                jpg|png|gif|PNG)
                    mkdir -p "organized_files/Images"
                    mv "$file" "organized_files/Images/"
                    echo "Moved $filename to Images" >> $log_file
                    ;;
                    
                pdf|docx|txt|xlsx|pptx|html|css|js)
                    mkdir -p "organized_files/Documents"
                    mv "$file" "organized_files/Documents/"
                    echo "Moved $filename to Documents" >> $log_file
                    ;;
                mp4|avi|mkv)
                    mkdir -p "organized_files/Videos"
                    mv "$file" "organized_files/Videos/"
                    echo "Moved $filename to Videos" >> $log_file
                    ;;
                mp3|wav|flac)
                    mkdir -p "organized_files/Music"
                    mv "$file" "organized_files/Music/"
                    echo "Moved $filename to Music" >> $log_file
                    ;;
                zip|tar.gz|rar)
                    mkdir -p "organized_files/Archives"
                    mv "$file" "organized_files/Archives/"
                    echo "Moved $filename to Archives" >> $log_file
                    ;;
                *)
                    mkdir -p "organized_files/Others"
                    mv "$file" "organized_files/Others/"
                    echo "Moved $filename to Others" >> $log_file
                    ;;
            esac
        fi
    done
}
# Call the function
move_files

#check for duplicate files
function check_duplicates(){
    for file in *; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            if [ -f "organized_files/Images/$filename" ] || [ -f "organized_files/Documents/$filename" ] || [ -f "organized_files/Videos/$filename" ] || [ -f "organized_files/Music/$filename" ] || [ -f "organized_files/Archives/$filename" ] || [ -f "organized_files/Others/$filename" ]; then
                echo "Duplicate file $filename found" >> $log_file
            fi
        fi
    done
}
# Call the function
check_duplicates

#Customizable file extensions and target directories via a configuration file.
if [ -f "config.txt" ]; then
    while IFS= read -r line
    do
        ext=$(echo $line | cut -d' ' -f1)
        dir=$(echo $line | cut -d' ' -f2)
        for file in *; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                if [ "${filename##*.}" == "$ext" ]; then
                    mkdir -p "organized_files/$dir"
                    mv "$file" "organized_files/$dir/"
                    echo "Moved $filename to $dir" >> $log_file
                fi
            fi
        done
    done < "config.txt"
fi