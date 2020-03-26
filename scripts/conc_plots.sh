#!/bin/bash
case $1 in
    'g5') chan='g5';;
    'vec') chan='vec' ;;
    'ax_plus') chan='ax_plus' ;;
    'ax_minus') chan='ax_minus' ;;
    'g0' ) chan='g0' ;;
    *) echo 'ERROR: Channel provided not defined.'; exit 1 ;;
esac

for meson in uu us uc ss sc cc; do
    cd $meson
    pdfunite $( ls * | sort -Vr ) plot_${meson}_llss_coshfit_$chan.pdf
    cd ../
done
