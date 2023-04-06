#!/bin/bash
iterations=$1 # Total number of times to run program.
N=$2 # Number of simulations being run at the same time.
workingDirectory=$(pwd)

# Create 1000 copies of source file.
counter=1
while  [ $counter -le $iterations ]
do
    values=`python3 revisedAngleCalculator.py` # Randomly generated angle values.
    cp ${workingDirectory}/511OnAxisResponse.source Source${counter}.source # Make a copy of the source file.
    sed -e "s/0  0/${values}/"  Source${counter}.source # Edit copy of source file
    counter=$((counter + 1))
done

count=0
# Runs cosima on all files that are .source files
sourceFiles=$(find . -type f -name "*[0-9].source")
for filename in ${sourceFiles}; do
    command="cosima -z $filename &"
    eval $command
    sleep 1 # Pauses before execution of command.
    count=$((count + 1))
    if [ $(($count%$N)) -eq 0 ]
    then
        wait
    fi
done
wait

# Delete all source files now that cosima is done running.
find . -type f -name "*[0-9].source" -delete

# Find all files that are .sim.gz files
simFiles=$(find . -type f -name "*[0-9].id1.sim.gz")

count=0
# Run revan command
for filename in ${simFiles}; do
    command="revan -g ComptonSphere.geo.setup -f $filename --io -a -n &" # -n used to hide GUI
    eval $command
    sleep 1
    count=$((count + 1))
    if [ $(($count%$N)) -eq 0 ]
    then
        wait
    fi
done
wait

# Delete all .sim.gz files now that revan is done running.
rm *.sim.gz

# Run the DataSpaceExtractor command
count=0
traFiles=$(find . -type f -name "*[0-9].id1.tra.gz")
for filename in ${traFiles}; do
    pythonCommand="python3 DataSpaceExtractor.py -f $filename -o ComptonSphere.geo.setup &"
    eval $pythonCommand
    sleep 1
    count=$((count + 1))
    if [ $(($count%$N)) -eq 0 ]
    then
        wait
    fi
done
wait

rm *.tra.gz

mkdir simulationResults
# Loop to move files to the simulationResults folder
pklFiles=$(find . -type f -name "*[0-9].id1.tra.gz.pkl")
for filename in ${pklFiles}; do
    mv $filename ${workingDirectory}/simulationResults
done
