#!/bin/bash

table_file=$1; channel=$2; ROOT_MASTER=$3

MESON=( uu us uc ss sc cc )
NT=( 128 64 56 48 40 36 32 28 24 20 16 ) 

# Source the functions
source ${ROOT_MASTER}/scripts/make-table/utils_table.sh

# Move into the configuration folder
cd ${ROOT_MASTER}/conf_test/${channel}

spc="    "
ROOT_CONF="${ROOT_MASTER}/conf_test"

# Print the channel header
print_channel ${channel} ${ROOT_MASTER}/${table_file}

for meson in ${MESON[@]}; do
    

    input_file="${ROOT_CONF}/${channel}/conf_${channel}_${meson}.dat"

    # Print meson 
    echo -e "${spc}${spc}& \$${meson}\$" >> \
        ${ROOT_MASTER}/${table_file}

    iter_nt=2
    for nt in ${NT[@]}; do
        
        res_nt=($(
            awk -v line=${iter_nt} \
                '( NR == line ) { 
                    print $2 " " $3 " " $4 " " $5 " " $6 
                }' \
                ${input_file}
        ))

        convert_tex ${res_nt[0]} ${res_nt[2]} ${res_nt[4]}
        ll_part="${ll_cell}${ll_text}(${res_nt[1]})"
        ss_part="${ss_cell}${ss_text}(${res_nt[3]})"
        echo -e "${spc}${spc}&${ll_part}&${ss_part} % ${nt}" >> \
            ${ROOT_MASTER}/${table_file}

        iter_nt=$(( ${iter_nt} + 1 ))
        if [ ${nt} == '16' ]; then
            echo -e "${spc}${spc}\\\\\\" >> \
                ${ROOT_MASTER}/${table_file}
        fi
    done
done

