#!/bin/bash
N=$1 # Number of files to be unpickled
directory=$(pwd)
mkdir unpickledFiles

# For each pickle file, run the unpickle.py file and move the output file to the unpickledFiles directory
for i in $( seq 1 $N )
do
    touch unpickled${i}.txt
    python3 unpickle.py ${directory}/simulationResults/FlatContinuumIsotropic.inc${i}.id1.tra.gz.pkl ${directory}/unpickled${i}.txt
    mv unpickled${i}.txt unpickledFiles/unpickled${i}.txt
done