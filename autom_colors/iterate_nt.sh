#!/bin/bash

NT=( 128 64 56 48 40 36 32 28 24 20 16 )
MESON=( uu us uc ss sc cc )

for meson in ${MESON[@]}; do
    
    echo "I am inside ${meson}"
    for nt in ${NT[@]}; do

        echo "I am inside ${nt}"
        # Move into the directory
        cp ./diff_calc.py ${meson}/${nt}/
        cd ${meson}/${nt}

        # Get the name of files to pass to the python script
        file_eff_ll=$( ls effMass_*_ll_* )
        file_fit_ll=$( ls cleanfit_ll* )
        file_eff_ss=$( ls effMass_*_ss_* )
        file_fit_ss=$( ls cleanfit_ss* )

        # Call the python script
        res_ll=($( 
            python ./diff_calc.py ${file_eff_ll} ${file_fit_ll}
        ))
        res_ss=($( 
            python ./diff_calc.py ${file_eff_ss} ${file_fit_ss}
        ))
        echo "ll" ${res_ll[@]}
        echo "ss" ${res_ss[@]}

        rm ./diff_calc.py
        cd ../../
        
    done
    break
done
