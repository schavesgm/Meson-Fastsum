#!/bin/bash

table_file='table_g5.tex'

MESON=( uu us uc ss sc cc )
NT=( 128 64 56 48 40 36 32 28 24 20 16 ) 

source ./utils_table.sh

# Print the header 
print_header ${table_file}

# Print the caption
print_caption ${table_file}

spc="    "

# Print the channel header
print_channel 'g5' $table_file

for meson in ${MESON[@]}; do
    
    input_file="./conf_g5_${meson}.dat"

    # Print meson 
    echo -e "${spc}${spc}& \$${meson}\$" >> ${table_file}

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
            ${table_file}

        iter_nt=$(( ${iter_nt} + 1 ))
        if [ ${nt} == '16' ]; then
            echo -e "${spc}${spc}\\\\\\" >> ${table_file}
        fi
    done

done

print_foot ${table_file}

