#!/bin/bash 

# Master script to do everything
name_table=$1

## Generate the header of the table file
source ./scripts/make-table/utils_table.sh

mkdir -p TABLES

[ -z ${name_table} ] && name_table="results"
table_file="TABLES/table_${name_table}.tex"

for chan in g5 vec ax_plus ax_minus g0; do

    echo "I am producing the data for ${chan}"

    # Generate the data if does not exist
    [ -d ./conf_test/${chan} ] || \
    bash ./scripts/iterate_nt.sh ${chan} $( pwd )

    bash ./scripts/make-table/gen_table.sh \
        ${table_file} ${chan} $(pwd)

    [ ${chan} == "g5" ] || [ ${chan} == "vec" ] || \
    [ ${chan} == "ax_plus" ] || [ ${chan} == "ax_minus" ] &&
        echo "    \\midrule" >> ${table_file}

    [ ${chan} == "g0" ] && \
        echo "    \\bottomrule" >> ${table_file}
done

# Initialise table file
# print_header ${table_file}
# print_caption ${table_file}
# 
# # First page of the table file
# print_table ${table_file} H
# print_header_table ${table_file}

# Iterate through firt page of table
# for chan in g5 vec ax_plus ax_minus g0; do
# 
#     echo "I am producing the data for ${chan}"
# 
#     # Generate the data if does not exist
#     [ -d ./conf_test/${chan} ] || \
#     bash ./scripts/iterate_nt.sh ${chan} $( pwd )
# 
#     bash ./scripts/make-table/gen_table.sh \
#         ${table_file} ${chan} $(pwd)
# 
#     [ ${chan} == "g5" ] || [ ${chan} == "vec" ] || \
#     [ ${chan} == "ax_plus" ] || [ ${chan} == "ax_minus" ] &&
#         echo "    \\midrule" >> ${table_file}
# 
#     [ ${chan} == "g0" ] && \
#         echo "    \\bottomrule" >> ${table_file}
# done
# print_close_table ${table_file}
# echo "\\end{document}" >> ${table_file}
