#!/bin/bash

nStep=1
fileC=0
gfortran atm2dst.f90 -o atm2dst.exec

# Loop through pdb files in the pdb directory
for file in *.pdb/*.pdb; do
    # Check if the current item is a file
    if [ -f "$file" ]; then
      ((fileC++))
      echo "Working on: $file , number $fileC"
        # Feeding file to FORTRAN code
        ./atm2dst.exec "$file" "$nStep"
    fi
done
