#!/bin/bash

nStep=1 
fileC=0
# Loop through cndb files in the cndb directory
for file in *.cndb/*.cndb; do
    # Check if the current item is a file
    if [ -f "$file" ]; then
      ((fileC++))
      echo "Working on: $file , number $fileC"
        # Feeding file to python code
          python cndb2dst.py -f "$file" -n "$nStep"
#        echo "--------------------------"
    fi
done
