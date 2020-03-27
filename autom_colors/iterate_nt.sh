#!/bin/bash

# NT=( 128 64 56 48 40 36 32 28 24 20 16 )
NT=( 128 64 56 48 40 36 32 28 24 16 ) # 56 48 40 36 32 28 24 20 16 )
# NT=( 28 24 20 16 ) # 56 48 40 36 32 28 24 20 16 )

for nt in ${NT[@]}; do

    echo "I am inside ${nt}"
    # Move into the directory
    cp ./diff_calc.py ${nt}/
    cd ${nt}

    # Get the name of files to pass to the python script
    file_eff_ll=$( ls effMass_*_ll_* )
    file_fit_ll=$( ls cleanfit_ll* )

    # Call the python script
    python ./diff_calc.py ${file_eff_ll} ${file_fit_ll}

    rm ./diff_calc.py
    cd ../
    

done
