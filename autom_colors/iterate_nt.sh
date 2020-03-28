#!/bin/bash

channel="g5"
NT=( 128 64 56 48 40 36 32 28 24 20 16 )
MESON=( uu us uc ss sc cc )

mkdir -p conf_test
ROOT=$( pwd )

for meson in ${MESON[@]}; do
    
    echo "I am inside ${meson}"
    echo "# N_t Cell_ll Plat_ll Cell_ss Plat_ss Compt" > \
        ./conf_test/conf_${channel}_${meson}.dat

    for nt in ${NT[@]}; do

        # Move into the directory
        cp ./diff_calc.py ${meson}/${nt}/
        cd ${meson}/${nt}

        # Get the name of files to pass to the python script
        file_eff_ll=$( ls effMass_*_ll_* )
        file_fit_ll=$( ls cleanfit_ll* )
        file_eff_ss=$( ls effMass_*_ss_* )
        file_fit_ss=$( ls cleanfit_ss* )

        # Call the python script
        res=($( 
            python ./diff_calc.py ${file_eff_ll} ${file_fit_ll} \
                ${file_eff_ss} ${file_eff_ss}
        ))
        ll_part="${res[0]} ${res[1]}"
        ss_part="${res[2]} ${res[3]}"

        echo "${nt} ${ll_part} ${ss_part} ${res[4]}" >> \
            ${ROOT}/conf_test/conf_${channel}_${meson}.dat

        rm ./diff_calc.py
        cd ../../
    done
done
