#!/bin/bash

# Script to plot the correlation functions for 
# flavour/temperature/source
chan=$1

case ${chan} in 
    'g5') state="0^{+-}" ;;
    'vec') state="1^{--}" ;;
    'ax_plus') state="1^{++}" ;;
    'ax_minus') state="1^{+-}" ;;
    'g0') state="0^{++}" ;;
esac

state="0^{+-}"

MESON=( uu us uc ss sc cc )
NT=( 128 64 56 48 40 36 32 28 24 20 16 )
SOURCE=( ll ss )

function plot_it() {
meson=$1; state=$2; src=$3

printf "
file_128=system( 'ls rescaled_128x32.*' )
file_64=system( 'ls rescaled_64x32.*' )
file_56=system( 'ls rescaled_56x32.*' )
file_48=system( 'ls rescaled_48x32.*' )
file_40=system( 'ls rescaled_40x32.*' )
file_36=system( 'ls rescaled_36x32.*' )
file_32=system( 'ls rescaled_32x32.*' )
file_28=system( 'ls rescaled_28x32.*' )
file_24=system( 'ls rescaled_24x32.*' )
file_20=system( 'ls rescaled_20x32.*' )
file_16=system( 'ls rescaled_16x32.*' )

set style line  1 lt 1 lc rgb '#7e2f8e' # purple
set style line  2 lt 1 lc rgb '#987e2f8e' # purple
set style line  3 lt 1 lc rgb '#352a87' # blue
set style line  4 lt 1 lc rgb '#98352a87' # blue
set style line  5 lt 1 lc rgb '#0f5cdd' # blue
set style line  6 lt 1 lc rgb '#980f5cdd' # blue
set style line  7 lt 1 lc rgb '#1481d6' # blue
set style line  8 lt 1 lc rgb '#981481d6' # blue
set style line  9 lt 1 lc rgb '#06a4ca' # cyan
set style line 10 lt 1 lc rgb '#9806a4ca' # cyan
set style line 11 lt 1 lc rgb '#2eb7a4' # green
set style line 12 lt 1 lc rgb '#982eb7a4' # green
set style line 13 lt 1 lc rgb '#87bf77' # green
set style line 14 lt 1 lc rgb '#9887bf77' # green
set style line 15 lt 1 lc rgb '#d1bb59' # orange
set style line 16 lt 1 lc rgb '#98d1bb59' # orange
set style line 17 lt 1 lc rgb '#fec832' # orange
set style line 18 lt 1 lc rgb '#98fec832' # orange
set style line 19 lt 1 lc rgb '#d95319' # orange
set style line 20 lt 1 lc rgb '#98d95319' # orange
set style line 21 lt 1 lc rgb '#a2142f' # red
set style line 22 lt 1 lc rgb '#98a2142f' # red

set style increment user

set xlabel '\$\\\\frac{\\\\tau}{N_\\\\tau}\$'
set ylabel '\$\\\\frac{1}{N_\\\\tau}\\\\cdot \\\\log\\\\frac{C(\\\\tau}{C(0)}\$'
set title '\$${meson} - ${state} - ${src}\$'
set ylabel offset -0.75,0,0

set key above

# Set the back style
set style line 25 lc rgb '#808080' lt 1
set border 3 back ls 25
set tics nomirror

set style line 26 lc rgb '#808080' lt 0 lw 1
set grid back ls 26

# Plot the data
plot file_128 u 1:2:3 w yerr title '128', \\
    file_128 u 1:2 w l notitle, \\
    file_64 u 1:2:3 w yerr title '64', \\
    file_64 u 1:2 w l notitle, \\
    file_56 u 1:2:3 w yerr title '56', \\
    file_56 u 1:2 w l notitle, \\
    file_48 u 1:2:3 w yerr title '48', \\
    file_48 u 1:2 w l notitle, \\
    file_40 u 1:2:3 w yerr title '40', \\
    file_40 u 1:2 w l notitle, \\
    file_36 u 1:2:3 w yerr title '36', \\
    file_36 u 1:2 w l notitle, \\
    file_32 u 1:2:3 w yerr title '32', \\
    file_32 u 1:2 w l notitle, \\
    file_28 u 1:2:3 w yerr title '28', \\
    file_28 u 1:2 w l notitle, \\
    file_24 u 1:2:3 w yerr title '24', \\
    file_24 u 1:2 w l notitle, \\
    file_20 u 1:2:3 w yerr title '20', \\
    file_20 u 1:2 w l notitle, \\
    file_16 u 1:2:3 w yerr title '16', \\
    file_16 u 1:2 w l notitle
" > plot_it.gn
}

# Create folder to hold the data
mkdir -p plot_corr
ROOT=$( pwd )

for src in ${SOURCE[@]}; do
    
    # Create the folder to hold the source
    mkdir -p plot_corr/${src}
    for mes in ${MESON[@]}; do

        # Create the folder to hold the meson
        mkdir -p plot_corr/${src}/${mes}

        for nt in ${NT[@]}; do

            # Get the correlation function data
            file_name=$( cd ./cosh/${src}/${nt}/${mes}/; ls best*.dat )
            # Get the first value of the plot
            # Copy the file into the processing folder
            cp ./cosh/${src}/${nt}/${mes}/best*.dat \
                plot_corr/${src}/${mes}

            # Process the file
            cd ./plot_corr/${src}/${mes}

            first_point=($( head -n 2 ${file_name} | tail -n 1 ))
            res_val=${first_point[1]}; res_err=${first_point[2]}

            res_name="rescaled_${nt}x32.${mes}_${src}.${chan}"
            # Rescale everything
            awk -v nt=${nt} -v rval=${res_val} -v rerr=${res_err} \
                'NR > 1 { 
                    print $1/nt " " (1/nt) * log($2/rval) " " \
                    (1/nt) * sqrt ( \
                        (rerr/rval) ** 2 + \
                        ($3/$2) ** 2 - \
                        ($3*rerr)/($2*rval) )
                }' ${file_name} \
                > ${res_name}
            rm best*_${nt}x32.*
            cd ${ROOT}
        done
        # Now plot the data
        cd  plot_corr/${src}/${mes}/
        plot_it ${mes} ${state} ${src}
        name_save="plot_corrNorm_${meson}_${chan}_${src}.pdf"
        gnp2tex -f plot_it.gn -s ${name_save}
        rm plot_it.gn
        cd ${ROOT}
    done
done


