#!/bin/bash

channel=$1
ROOT_MASTER=$2

# Parameters 
# Equal or not parameters
p0=$3; p1=$4

# Decide color parameters
p2=$5; p3=$6
p4=$7; p5=$8
p6=$9; p7=${10}

# Iterate through NT and mesons
NT=( 128 64 56 48 40 36 32 28 24 20 16 )
MESON=( uu us uc ss sc cc )

# Folder to save all the conf files
save_fold="conf_test/${channel}"

# Move to ROOT_FOLDER
cd ${ROOT_MASTER} 

mkdir -p ${save_fold} 
ROOT=$( pwd )  # New root 

for meson in ${MESON[@]}; do
    
    echo "I am inside ${meson}"
    echo "# N_t Cell_ll Plat_ll Cell_ss Plat_ss Compt" > \
        ./${save_fold}/conf_${channel}_${meson}.dat

    for nt in ${NT[@]}; do

        # Move into the directory
        cp ./scripts/diff_calc.py DATA/${channel}/${meson}/${nt}/
        cd DATA/${channel}/${meson}/${nt}

        # Get the name of files to pass to the python script
        file_eff_ll=$( ls effMass_*_ll_* )
        file_fit_ll=$( ls cleanfit_ll* )
        file_eff_ss=$( ls effMass_*_ss_* )
        file_fit_ss=$( ls cleanfit_ss* )

        # Call the python script
        files_ll="${file_fit_ll} ${file_eff_ll}"
        files_ss="${file_fit_ss} ${file_eff_ss}"
        files="${files_ll} ${files_ss} "
        
        params="$p0 $p1 $p2 $p3 $p4 $p5 $p6 $p7"

        res=($( python ./diff_calc.py -f $files -p $params ))
        ll_part="${res[0]} ${res[1]}"
        ss_part="${res[2]} ${res[3]}"

        echo "${nt} ${ll_part} ${ss_part} ${res[4]}" >> \
            ${ROOT}/${save_fold}/conf_${channel}_${meson}.dat

        rm ./diff_calc.py
        cd ${ROOT}
    done
done
