#!/bin/bash 

# Master script to do everything
source ./scripts/parser.sh
source ./scripts/make-table/utils_table.sh

# Create an argument parser

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key=$1
    case $key in
        -n|--name_table)
            name_table=$1
            ;;
        -h|--help)
            print_help
            shift; shift; 
            ;;
        -ip|--info-params)
            print_info
            shift; shift;
            ;;
        -p|--params)
            parse_params ${2}
            PARSED="1"
            shift; shift;
            ;;
        -t|--table-only)
            TABLE_ONLY="1"
            shift; shift;
            ;;
        *)
            POSITIONAL+=($1)
            shift
            ;;
    esac

done

# If no parameters are parsed, set defaults
[ -z ${PARSED} ] && set_defaults

mkdir -p TABLES

[ -z ${name_table} ] && name_table="results"
table_file="TABLES/table_${name_table}.tex"

# Initialise table file
print_header ${table_file}
print_caption ${table_file}

# First page of the table file

echo "\\vspace*{\\fill}" >> ${table_file}
print_table ${table_file} H
print_header_table ${table_file}

for chan in g5 vec ax_plus ax_minus g0; do

    echo "I am producing the data for ${chan}"

    args="${chan} $(pwd) $p0 $p1 $p2 $p3 $p4 $p5 $p6 $p7"
    [ -z ${TABLE_ONLY} ] && \
        eval "bash ./scripts/iterate_nt.sh  ${args}"

    bash ./scripts/make-table/gen_table.sh \
        ${table_file} ${chan} $(pwd)

    [ ${chan} == "g5" ] || [ ${chan} == "vec" ] || \
    [ ${chan} == "ax_plus" ] || [ ${chan} == "ax_minus" ] &&
        echo "    \\midrule" >> ${table_file}

    [ ${chan} == "g0" ] && \
        echo "    \\bottomrule" >> ${table_file}
done

print_close_table ${table_file}
echo "\\vfill" >> ${table_file}
echo "\\end{document}" >> ${table_file}

# Compile the file in case you have pdflatex
[ ! -z $( command -v pdflatex ) ] && ( pdflatex ${table_file} )
[ ! -z $( command -v pdflatex ) ] && ( rm *.log *.aux  )
[ ! -z $( command -v pdflatex ) ] && ( mv *.pdf TABLES  )



