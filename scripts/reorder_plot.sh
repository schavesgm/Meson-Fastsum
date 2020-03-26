#!/bin/bash

# Control input 
case $1 in 
    'cosh') echo "You are using cosh"; ansatz='cosh' ;;
    'cosh-void') echo "You are using cosh-void"; ansatz='void' ;;
    *) echo "ERROR: Wrong input."; exit 1 ;;
esac

case $2 in 
    'g5') echo "Analysing Pseudoscalar"; chan='0^{+-}' ;;
    'vec') echo "Analysing Vector"; chan='1^{--}' ;;
    'ax_plus') echo "Analysing Axial_plus"; chan='1^{++}' ;;
    'ax_minus') echo "Analysing Axial_minus"; chan='1^{+-}' ;;
    'g0') echo "Analysing Scalar"; chan='0^{++}' ;;
    *) echo "ERROR: Wrong input"; exit 1 ;;
esac

function plot_it() {
# Function used to plot the data 

# Define title data
meson=$1
chan=$2
nt=$3

# Get the files to be plotted
ffile_ss=$( ls cleanfit_ss* )
ffile_ll=$( ls cleanfit_ll* )
efile_ss=$( ls effMass_*_ss_* )
efile_ll=$( ls effMass_*_ll_* )

echo "
fit_ss='${ffile_ss}'
fit_ll='${ffile_ll}'
effMass_ss='${efile_ss}'
effmass_ll='${efile_ll}'

set xlabel '\$\\tau \\quad || \\quad \\tau \\to N_\\tau - \\tau\$'
set ylabel '\$M_{cosh} \\cdot a_\\tau \\quad || \\quad M_{fit} \\cdot a_\\tau\$'

set style line 1 lt rgb '#3B4A6C' lw 1 pt 1
set style line 2 lt rgb '#9ABCDC' lw 1 pt 2
set style line 3 lt rgb '#7A9703' lw 1 pt 3
set style line 4 lt rgb '#6CCC7B' lw 1 pt 4

set style line 11 lc rgb '#808080' lt 1
set border 3 back ls 11
set tics nomirror

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

set style increment user

set title '\$${meson} - ${chan} - ${nt}x32\$'
set xrange [1:]

plot fit_ss u 1:2:3 w yerr title sprintf( 'Fit ss' ), \
    effMass_ss u 1:2:3 w yerr title sprintf( 'Cosh ss' ), \
    fit_ll u 1:2:3 w yerr title sprintf( 'Fit ll' ), \
    effmass_ll  u 1:2:3 w yerr title sprintf( 'Cosh ll' )
" > ./plot_it.gn
}

# We need to reorder the data into a new folder
mkdir -p JointData_${ansatz}

# Data to iterate
MESON=( uu us uc ss sc cc )
NT=( 128 64 56 48 40 36 32 28 24 20 16 )
SOURCE=( ll ss )

# Iterate over mesons
for meson in ${MESON[@]}; do
    
    # Create the meson folder inside JointData
    m_folder="JointData_${ansatz}/${meson}"
    mkdir -p ${m_folder}

    # Iterate over temperatures
    for nt in ${NT[@]}; do

        # Create the temperature folder
        nt_folder=${m_folder}/${nt}
        mkdir -p ${nt_folder}

        # Move data from effective mass into nt_folder
        cp eff_mass/${meson}/${nt}x32/*/effMass* ${nt_folder}

        # Move data from fit into nt_folder. Careful with sources
        for tsource in ${SOURCE[@]}; do
            loc_clean=${ansatz}/${tsource}/${nt}/${meson}/cleaned*
            cp ${loc_clean} ${nt_folder}/cleanfit_${tsource}.${2}
        done

        # Plot the data 
        (cd ${nt_folder} && plot_it ${meson} ${chan} ${nt})
        name_save="${nt}x32_${meson}_${2}.pdf"
        (cd ${nt_folder} && gnp2tex -f plot_it.gn -s ${name_save})
        (cd ${nt_folder} && rm plot_it.gn)
    done
done

# Move all plots into a single folder
mkdir -p JointData_${ansatz}/Plots
cd JointData_${ansatz}

for meson in ${MESON[@]}; do
    mkdir -p Plots/${meson}
    cp ${meson}/*/*.pdf Plots/${meson}

done
cd ../



