#Author: Gustavo Bravo
#First compile FORTRAN code: gfortran atoms2dst.f90 -o atoms2dst.exec
#How to call: ./atoms2dst.exec fileName distStep
#   fileName: name of the file to measure distance between atoms
#   distStep: integer steps to take between atoms to measure
# This program takes as input CNDB files, and measures the distances
#   of the atoms positions in the last frame, in case we have a
#   trajectory
# The output of this program is fileName.dst, with the last four
#  character elemnts replaced by .dst (read SUBROUTINE length on atoms2dst.f90)
#Import packages
from OpenMiChroM.CndbTools import cndbTools as cndbT
import numpy as np
import argparse
import subprocess

#Retrieve input and output name of files
parser = argparse.ArgumentParser(description="Converting from *.cndb to Atoms file")
parser.add_argument(
    "-f",
    metavar="input-file-CNDB-frames",
    help="cndb file",
    action="store",
    dest="arg_fName",
    required=True,
)
parser.add_argument(
    "-n",
    metavar="input-distance-step",
    help="distance step",
    action="store",
    dest="arg_nStep",
    required=True,
)
#Rename files names and step or easier writing/reading
nStep  = parser.parse_args().arg_nStep  
inFile = parser.parse_args().arg_fName
ouFile = inFile[:-5]+'.pos'

#initialize cndbt
c=cndbT()

#Load cndb file
c.load(inFile)

#Retrieve number of frames and beads
test=c.xyz(frames=[1,None,1],beadSelection=None)
nFrames=test.shape[0]
nAtoms =test.shape[1]

#grab all positions form last frame. flatten to save to file
pos=c.xyz(frames=[nFrames,None,1],beadSelection=None)
flat=pos.reshape((-1, pos.shape[-1]))

#for n in range(3): #Sanity check
#    print(pos[0,nAtoms-1,n])
np.savetxt(ouFile,flat)
#Compile and call FORTRAN program atm2dst.f90
#subprocess.run(["gfortran","atm2dst.f90","-o","atm2dst.exec"])
subprocess.run(["./atm2dst.exec",ouFile,nStep])
#subprocess.run(["rm","-fr",ouFile])
print('cndb2dst.py finish!')
