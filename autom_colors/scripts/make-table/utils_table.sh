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

" > $1
}

function print_table() {
# Print the beginning of a table
echo "
\\begin{table}[$2]
    \\centering
" >> $1
}

function print_header_table() {
echo "
    \\begin{adjustbox}{max width=\\textwidth}
    \\begin{tabular}{@{}cc|cc|cc|cc|cc|cc|cc|cc|cc|cc|cc|cc@{}}
        & & \\multicolumn{22}{c}{\$N_\\tau\$} \\\\
        \\midrule
        & 
        & \\multicolumn{2}{c}{\$128\$}
        & \\multicolumn{2}{c}{\$64\$} 
        & \\multicolumn{2}{c}{\$56\$} 
        & \\multicolumn{2}{c}{\$48\$} 
        & \\multicolumn{2}{c}{\$40\$} 
        & \\multicolumn{2}{c}{\$36\$} 
        & \\multicolumn{2}{c}{\$32\$} 
        & \\multicolumn{2}{c}{\$28\$} 
        & \\multicolumn{2}{c}{\$24\$} 
        & \\multicolumn{2}{c}{\$20\$} 
        & \\multicolumn{2}{c}{\$16$} \\\\
" >> $1
}
function print_close_table() {
# Print close of table
echo "
    \\end{tabular}
    \\end{adjustbox}
\\end{table}
" >> $1
}

function print_caption() {
# Print the caption and initialise the table

# Variables of the system
thresh_eq=$2; perc_data=$3
thresh_int=$4; thresh_plt=$5
green_0=$6; green_1=$7
orange_0=$8; orange_1=$9

# Print the caption
echo "
\\textbf{Automatic table: } Table containing the estimation of the
trustworthiness in the mesonic sector data for the FASTSUM
collaboration when using an hyperbolic cosine ansatz. The table below
collects the results for all possible channels available \$\{ 0^{++},
0^{+-}, 1^{--}, 1^{++}, 1^{+-}\}\$, all flavour structures available
\$\{ uu, us, uc, ss, sc, cc \}\$, all temperatures and choices of
sources. The sources available are \\textit{local-local} (ll) and
\\textit{smeared-smeared} (ss).

\\noindent A selected row and column in the table below corresponds
to a temperature (column) and a channel/flavour structure (row). For
each temperature and channel/flavour structure, there are two cells,
the left one corresponds to local-local sources (ll) and the right
one corresponds to smeared-smeared (ss).

\\noindent For each cell, we do have two kinds of data. One of them
is the \\textit{effective mass}, which is the mass solution of this
equation,
\\begin{equation}
    \\frac{\\cosh\\Big( m \\cdot ( \\tau - N_\\tau / 2 ) \\Big)}
         {cosh\\Big( m 
             \\cdot ( \\tau + a_\\tau - N_\\tau / 2 ) \\Big)} =
    \\frac{C(\\tau)}{C(\\tau + a_\\tau)}.
\\end{equation}
\\noindent The other one is a fitted mass corresponding to a
\\textit{sliding window fit}. This means that we start at a given
Euclidean time \$\\tau_0\$ and we fit over the range, \$[\\tau_0,
N_\\tau - \\tau_0]\$. The following window will be the one
corresponding to shrinking by one lattice spacing the previous
window, \$\\tau_0 \\to \\tau_0 + a_\\tau\$  and \$N_\\tau - \\tau_0
\\to N_\\tau - \\tau_0 - a_\\tau\$.

\\noindent The colour of the cell, the colour of each text (ll/ss)
and the number inside parenthesis are defined as,
\\begin{enumerate}
\\item The colour of the cell is defined by a combination of how
similar the effective mass and the sliding window mass are and how
many points of the total belong to a plateau.
\\item The number inside parenthesis is the Euclidean time \$\\tau\$
in which the plateau starts.
\\item If two adjacent ll/ss have colours \\loq/\\smq, then
ll and ss for that row and column are compatible. If they have
colours \\lon/\\smn, then they are not compatible.
\\end{enumerate}

\\noindent The algorithm to set the plateau is the following (Alg 1):
\\begin{enumerate}
\\item We calculate the slope of each point by using,
    \\begin{equation}
        m(\\tau_i) = m(\\tau_i + 1) - m(\\tau_i)
    \\end{equation}
\\item The plateau is the first point such that,
    \\begin{equation}
        | m(\\tau_i) | \\leq ${thresh_plt} 
    \\end{equation}
\\end{enumerate}

\\noindent The algorithm to set how close the effective mass and the
fitted mass are is the following (Alg 2):
\\begin{enumerate}
\\item We calculate the ratio at each point between the effective
mass and the fitted mass,
    \\begin{equation}
        R(\\tau_i) = \\frac{m_{eff}(\\tau_i)}{m_{fit}(\\tau_i)}
    \\end{equation}
\\item We calculate the beginning of the plateau using the algorithm
above.
\\item We collect all points that hold,
    \\begin{equation}
        1 - ${thresh_int} \\leq R(\\tau_i) \\leq 1 + ${thresh_int}
        \\quad
        \\text{and}
        \\quad
        \\ \\tau_i - P \\leq -2,
    \\end{equation}
    where P is the index of the plateau. It is calculated using a
    threshold of ${thresh_plt}.
\\end{enumerate}

\\noindent The algorithm to define if local-local and smeared-smeared
are equal for a given row/column is the following (Alg 3):
\\begin{enumerate}
\\item  We calculate the ratio for each time using,
    \\begin{equation}
        \\hat{R}(\\tau_i) = 
            \\frac{m^{ll}_{fit}(\\tau_i)}{m^{ss}_{fit}(\\tau_i)}
    \\end{equation}
\\item We select a percentage of the data. In particular the
\$${perc_data}\\%\$. 
\\item They are equal if the following statement is true,
    \\begin{equation}
        1 - ${thresh_eq} \\leq | \\sum_{i =
        ${perc_data}N_\\tau}^{N_\\tau/2} \\hat{R}(\\tau_i)) \\leq 
        1 + ${thresh_eq}.
    \\end{equation}
\\end{enumerate}

\\noindent Now, the colour-code of the cells will be explained. A
{\\color[HTML]{92D2D6}{blue cell}} means that the fraction of points
that are compatible between the effective mass and the fitted
mass fulfills,
\\begin{equation}
    N \\geq ${green_0} \\cdot \\frac{N_\\tau}{2},
\\end{equation}
where \$N\$ is the number of points result of (Alg 2). Moreover, the
remaining points after the definition of the plateau by (Alg 1) has
to fullfil,
\\begin{equation}
    ( 1 - \\frac{P}{N_\\tau/2} ) \\geq ${green_1}.
\\end{equation}
\\noindent A {\\color[HTML]{92D2D6}{blue cell}} cell can be trusted
in our definition. A {\\color[HTML]{FBAFB5}{pink cell}} denotes
\\textit{proceed with caution}. A {\\color[HTML]{FBAFB5}{pink cell}}
means that the number of points compatible between the effective mass
and the fitted mass belong to the following interval,
\\begin{equation}
    ${orange_0} \\cdot \\frac{N_\\tau}{2}\\leq N 
        \\leq ${green_0} \\cdot \\frac{N_\\tau}{2}.
\\end{equation}
\\noindent Besides, the number of points after the definition of the
plateau belong to the following interval,
\\begin{equation}
    ${orange_1} \\leq ( 1 - \\frac{P}{N_\\tau/2} ) \\leq ${green_1}.
\\end{equation}

\\noindent A {\\color[HTML]{F7CB4A}{yellow cell}} means the fraction
of effective mass and sliding fit points belong to,
\\begin{equation}
    N \\leq \\frac{N_\\tau}{2} \\cdot ${orange_0}.
\\end{equation}
The same for the plateau,
\\begin{equation}
    ( 1 - \\frac{P}{N_\\tau/2} ) \\leq ${orange_1}.
\\end{equation}
\\newpage
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
