#!/bin/bash

# Check if a file is provided as a parameter
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Store the filename provided as a parameter
filename=$1

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo "File $filename does not exist."
    exit 1
fi

# Delete the line "#include <stdio.h>" from the file
sed -i '/#include <stdio.h>/d' "$filename"

# Find the line number containing "int main"
main_line=$(grep -n "int[[:space:]]*main" "$filename" | cut -d ':' -f 1)

# Check if "int main" exists in the file
if [ -z "$main_line" ]; then
    echo "Line 'int main' not found in $filename."
    exit 1
fi

# Add includes stdio.h
echo -e "/*" >> $filename.hidemain
echo -e "#include <stdio.h>" >> $filename.hidemain

# Extract everything from "int main" to the end of the file
sed -n "${main_line},\$p" "$filename" >> $filename.hidemain
echo -e "*/" >> $filename.hidemain

# Delete everything from "int main" to the end of the file
sed -i '/int[[:space:]]*main/,$d' "$filename"

# Add adjusted main to original
cat $filename.hidemain >> $filename && rm $filename.hidemain

exit
