# Nucleom Data Bank Tools
 Python and FORTRAN codes to measure distances between atoms from .pdb, .cndb
or .pos files


## From PDB or POS
### atms2dst.f90
atms2dst.f90 is a FORTRAN program design to take as input either PDB files,
which contain positions of atoms next to the keyword ATOM, or pos files, which
only contain the cartesian positions of the arrange of atoms, and measures the
euclidian distance between pairs of atoms (I,I+nStep)

This program can be called directly:
Compilation: gfortran atm2dst.f90 -o atm2dst.exec     
Usage: ./atm2dst.exec inFile nStep
        inFile would be the input file.
        nStep is the array-distance between the atoms distance to measure.

This program can be called through runPDB.sh
By default, runPDB considers nStep==1, and that the files are located at a
directory named directoryName.pdb
Edit runPDB.sh to change nStep
Specify the directory where the PDB/pos files are located
Usage: ./runPDB.sh


## From CNDB 
### cndb2dst.py
cndb2dst.py is a python program design to take as CNDB files, save the
positions of the atoms of the last frame on a position file, and then call
atoms2dst.exec to measure the euclidian distances.

This program can be called directly:
Compilation: gfortran atm2dst.f90 -o atm2dst.exec     
Usage: ./cndb2dst.py -f inFile -n nStep
        inFile would be the CNDB input file.
        nStep is the array-distance between the atoms distance to measure.

This program can be called through runCNDB.sh
By default, runPDB considers nStep==1, and that the files are located at a
directory named directoryName.cndb
Edit runCNDB.sh to change nStep
Specify the directory where the CNDB files are located
Usage: ./runCNDB.sh
