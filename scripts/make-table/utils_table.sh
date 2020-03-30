#!/bin/bash

function print_header() {
# Print the header of the tex table
echo "% Automatically generated table 

\\documentclass[10pt]{article}

\\usepackage{amsmath}              % Math symbols
\\usepackage{dsfont}               % Identity symbol
\\usepackage[table,xcdraw]{xcolor} % Table colors
\\usepackage{multirow}
\\usepackage{adjustbox}
\\usepackage[labelfont = bf]{caption}
\\usepackage{float}

\\usepackage[a4paper,margin=0.5in,landscape]{geometry}
\\usepackage{booktabs}

% User commands
% Define local-local and smeared-smeared
\\newcommand{\\loq}{{\\color[HTML]{006600}{ll}}}
\\newcommand{\\lon}{{\\color[HTML]{800080}{ll}}}
\\newcommand{\\smq}{{\\color[HTML]{006600}{ss}}}
\\newcommand{\\smn}{{\\color[HTML]{800080}{ss}}}
    
% Define rule separators colours
\\newcommand{\\rrule}{{\\color{red}\\vrule}}

% Cell colours
\\newcommand{\\rcell}{\\cellcolor[HTML]{F7CB4A}}
\\newcommand{\\ocell}{\\cellcolor[HTML]{FBAFB5}}
\\newcommand{\\gcell}{\\cellcolor[HTML]{92D2D6}}

\\begin{document}

\\begin{table}[H]
    \\centering
    \\Large
" > $1
}

function print_caption() {
# Print the caption and initialise the table
echo -e "
    \\\\caption{
        Table containing the trustworthiness of the hyperbolic cosine
        ansatz in the mesonic sector. The calculation has been
        carried out in all available channels, defined by the states
        \$0^{++}, 0^{+-}, 1^{--}, 1^{++}, 1^{+-}\$. We define our
        confidence in the ansatz by comparing the mass obtained
        solving the hyperbolic cosine equation and the sliding window
        fit results. A {\\\\color[HTML]{92D2D6}{blue cell}} means that
        both results are compatible, that is, between errors, the
        result obtained from solving the cosh and the sliding window
        calculation are compatible. Moreover, a clear plateau has to
        be present. A  {\\\\color[HTML]{92D2D6}{blue cell}} cell can be
        trusted. A {\\\\color[HTML]{FBAFB5}{pink cell}} denotes
        \\\\textit{proceed with caution}, which means that a plateau is
        present but with few points defining it. In this case, the
        cosh-mass and the sliding window mass differ but the
        difference is \\\\textit{small by eye}. A
        {\\\\color[HTML]{F7CB4A}{yellow cell}} means that both masses
        are not compatible and no plateau is clear.  Besides, for
        each temperature and flavour, there are two results. One
        corresponding to local-local sources, denoted by \\\\textit{ll}
        (left hand side), the other to smeared-smeared \\\\textit{ss}
        (right hand side).  Provided that in a given temperature both
        text colours \\\\textit{ll} and \\\\textit{ss} have this
        combination of colours \\\\loq = \\\\smq, then both sources
        converge to the same mass. If both colours are different in
        the following sequence \\\\loq, \\\\smn, then they differ but the
        difference is \\\\textit{small}.  If both colours are different,
        \\\\lon = \\\\smn, then both methods generate different sources.
        The results extracted are defined subjectively, but they can
        serve as a guide for following actions. Check the plots
        attached with the data from which these results were
        generated.
    }
    \\\\vspace{0.5cm}
    \\\\begin{adjustbox}{max width=\\\\textwidth}
    \\\\begin{tabular}{@{}cc|cc|cc|cc|cc|cc|cc|cc|cc|cc|cc|cc@{}}
        & & \\\\multicolumn{22}{c}{\$N_\\\\tau\$} \\\\\\\\
        \\\\midrule
        & 
        & \\\\multicolumn{2}{c}{\$128\$}
        & \\\\multicolumn{2}{c}{\$64\$} 
        & \\\\multicolumn{2}{c}{\$56\$} 
        & \\\\multicolumn{2}{c}{\$48\$} 
        & \\\\multicolumn{2}{c}{\$40\$} 
        & \\\\multicolumn{2}{c}{\$36\$} 
        & \\\\multicolumn{2}{c}{\$32\$} 
        & \\\\multicolumn{2}{c}{\$28\$} 
        & \\\\multicolumn{2}{c}{\$24\$} 
        & \\\\multicolumn{2}{c}{\$20\$} 
        & \\\\multicolumn{2}{c}{\$16$} \\\\\\\\
" >> $1
}

function print_foot() {
# Print footer of the file
echo "
    \\end{tabular}
    \\end{adjustbox}
\\end{table}
\\end{document}
" >> $1
}

function convert_tex() {
# Transform data into tex format

# Transform ll cell colour
case $1 in
    'G') ll_cell="\\gcell" ;;
    'O') ll_cell="\\ocell" ;;
    'R') ll_cell="\\\\rcell" ;;
esac
# Transform ss cell colour
case $2 in
    'G') ss_cell="\\gcell" ;;
    'O') ss_cell="\\ocell" ;;
    'R') ss_cell="\\\\rcell" ;;
esac
# Generate colours in text
case $3 in 
    '1') ll_text="\\loq"; ss_text="\\smq" ;;
    '0') ll_text="\\lon"; ss_text="\\smn" ;;
esac
}

function print_channel() {
# Print the channel header
case $1 in 
    'g5') 
        chan="{\$\\gamma_5 \\equiv 0^{-+}\$}";
        name="Pseudoscalar" ;;
    'vec') 
        chan="{\$\\gamma_\\mu \\equiv 1^{--}\$}";
        name="Vector" ;;
    'ax_plus') 
        chan="{\$\\gamma_\\mu\\gamma_5 \\equiv 1^{++}\$}";
        name="Axial plus" ;;
    'ax_minus') 
        chan="{\$\\gamma_i\\gamma_j \\equiv 1^{+-}\$}";
        name="Axial minus" ;;
    'g0') 
        chan="{\$\\mathds{1} \\equiv 0^{-+}\$}" 
        name="Scalar" ;;
esac
# Generate the header for the channel
spc="    "
echo "${spc}% ${name}" >> $2
echo "${spc}\\multirow{6}{*}${chan}" >> $2
}
