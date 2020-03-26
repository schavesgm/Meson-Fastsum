---
title: Tests on the confidence of the cosh ansatz in the mesonic sector
author: Sergio Chaves García-Mascaraque
geometry: "left=3cm, right=3cm"
---

This folder contains scripts and results to study the validity of a
cosh ansatz fit in the extraction of effective mass as a function of
the temperature in anysotropic lattices. The data studied belongs to
the Fastsum collaboration. 

The channels available are,
\begin{center}
    chan = \{ g5, vec, ax\_plus, ax\_minus, g0 \}
\end{center}

The temperatures studied correspond to the following time extents,
\begin{equation}
    N\_\tau = \{ 128, 64, 56, 48, 40, 36, 32, 28, 24, 20, 16 \}
    \nonumber
\end{equation}

The flavour structures available are,
\begin{center}
    fs = \{ uu, us, uc, ss, sc, cc \}
\end{center}

The types of source available are,
\begin{center}
    src = \{ ll, ss \}
\end{center}

# `scripts/` folder
We store all the scripts to generate the plots and the table of
confidence. 

1. **reorder\_plot.sh**: This script generates the plots automatically
   for a given channel provided the data is in the expected format
   and contained in the expected folder.

    1. The mass extracted from the cosh ansatz has to be located
        inside a folder called `eff_mass`. The distribution and names
        of the files in the folder has to be,
```
eff_mass/fs/$N_\tau$x32/src/effMass_chan_src_N_\taux32.fs
```
    2. The sliding window fit data has to be allocated in a folder
       called `cosh`. The distribution and names of the files in the
       folder has to be,
```
cosh/src/N_\tau/fs/cleaned_chan.fs_*.dat
```
    The script will then generate the data inside a folder called 
    `JointData_cosh`. All the results generated are inside that
    folder.
