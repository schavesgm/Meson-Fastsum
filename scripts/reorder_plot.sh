#!/bin/bash

# Control input 
case $1 in 
    'cosh') echo "You are using cosh"; ansatz='cosh' ;;
    'cosh-void') echo "You are using cosh-void"; ansatz='void' ;;
    *) echo "ERROR: Wrong input."; exit 1 ;;
esac

case $2 in 
    'g5') echo "Analysing Pseudoscalar"; chan='0^{-+}' ;;
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

# Get the estimation of the mass
min_ll=$( echo "$4 - $5" | bc -l )
min_ss=$( echo "$6 - $7" | bc -l )
max_ll=$( echo "$4 + $5" | bc -l )
max_ss=$( echo "$6 + $7" | bc -l )

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

min_ll=${min_ll}
min_ss=${min_ss}
max_ll=${max_ll}
max_ss=${max_ss}

set xlabel '\$\\tau \\quad || \\quad \\tau \\to N_\\tau - \\tau\$'
set ylabel '\$M_{cosh} \\cdot a_\\tau \\quad || \\quad M_{fit} \\cdot a_\\tau\$'

set style line 1 lt rgb '#FFA500' lw 1 pt 1
set style line 2 lt rgb '#B8261C' lw 1 pt 2
set style line 3 lt rgb '#98FFA07A' lw 1 pt 2
set style line 4 lt rgb '#39ADA0' lw 1 pt 3
set style line 5 lt rgb '#307C63' lw 1 pt 4
set style line 6 lt rgb '#98BAD078' lw 1 pt 4

set style line 11 lc rgb '#808080' lt 1
set border 3 back ls 11
set tics nomirror

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

set style increment user

set title '\$${meson} - ${chan} - ${nt}x32\$'
set xrange [1:]
set yrange [0:]

plot fit_ss u 1:2:3 w yerr title sprintf( 'Fit ss' ), \\
    effMass_ss u 1:2:3 w yerr title sprintf( 'Cosh ss' ), \\
    min_ss w filledcurves y1=max_ss title sprintf( 'Est ss' ), \\
    fit_ll u 1:2:3 w yerr title sprintf( 'Fit ll' ), \\
    effmass_ll  u 1:2:3 w yerr title sprintf( 'Cosh ll' ), \\
    min_ll w filledcurves y1=max_ll title sprintf( 'Est ll' )
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

    iterNT=1
    # Iterate over temperatures
    for nt in ${NT[@]}; do

        # Create the temperature folder
        nt_folder=${m_folder}/${nt}
        mkdir -p ${nt_folder}

        # Get estimation for Local-local mass
        file_ll=$( ls mass/${meson}/params_${meson}_*_ll_* )
        est_mass_ll=($( 
            awk -v line=${iterNT} \
            '(NR == line) { print $2 " " $3 } ' ${file_ll} 
        ))
        mass_ll=${est_mass_ll[0]}
        stde_ll=${est_mass_ll[1]}

        # Get estimation for Local-local mass
        file_ss=$( ls mass/${meson}/params_${meson}_*_ss_* )
        est_mass_ss=($( 
            awk -v line=${iterNT} \
            '(NR == line) { print $2 " " $3 } ' ${file_ss} 
        ))
        mass_ss=${est_mass_ss[0]}
        stde_ss=${est_mass_ss[1]}

        # Move to following NT
        iterNT=$(( ${iterNT} + 1 ))

        # Move data from effective mass into nt_folder
        cp eff_mass/${meson}/${nt}x32/*/effMass* ${nt_folder}

        # Move data from fit into nt_folder. Careful with sources
        for tsource in ${SOURCE[@]}; do
            loc_clean=${ansatz}/${tsource}/${nt}/${meson}/cleaned*
            cp ${loc_clean} ${nt_folder}/cleanfit_${tsource}.${2}
        done

        # Plot the data 
        (cd ${nt_folder} && \
        plot_it ${meson} ${chan} ${nt} \
                ${mass_ll} ${stde_ll} ${mass_ss} ${stde_ss})
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
    (cd Plots/${meson} && \
        pdfunite $( ls * | sort -Vr ) \
            plot_${meson}_llss_coshfit_${2}.pdf)
done
cd ../
