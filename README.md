---
title: Tests on the confidence of the cosh ansatz in the mesonic sector
author: Sergio Chaves García-Mascaraque
geometry: "left=3cm, right=3cm"
---

# `To dos`

> - [ ] -> Calculate the plost with `Est mass` for all channels. \
> - [ ] -> Quantify the difference between cosh-mass and fit-mass. \
> - [ ] -> Quantify where the plateau starts. \
> - [ ] -> Reformat the histogramming procedure.

# Description

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
    N\_\tau = \{ 128, 64, 56, 48, 40, 36, 32, 28, 24, 20, 16 \}.
    \nonumber
\end{equation}
Note that the temperature and the time extent are related by $T =
\frac{1}{N\_\tau\cdot a\_\tau}$.

The flavour structures available are,
\begin{center}
    fs = \{ uu, us, uc, ss, sc, cc \}.
\end{center}

The types of source available are,
\begin{center}
    src = \{ ll, ss \}.
\end{center}

## Notation used.
In the plots and results inside, there are three main results shown.
We will proceed to explain them,

### Cosh equation-solved mass ("Effective mass").
In the plots or tables found in this repository, you can find the
terms _cosh-mass_, _hyperbolic cosine mass_, _effective mass_ and
similar. All these terms belong to the same class. We define the
hyperbolic cosine equation-solved mass ("effective mass") as the mass
extracted from solving the following equation,
\begin{equation}
    \frac{\cosh\Big( m \cdot ( \tau - N_\tau / 2 ) \Big)}
         {cosh\Big( m \cdot ( \tau + a_\tau - N_\tau / 2 ) \Big)} =
    \frac{C(\tau)}{C(\tau + a_\tau)},
\end{equation}
where $\tau$ is the time in lattice units, $m$ is the mass, $N\_\tau$
is the temporal extent and $C(\tau)$ is the correlation function
(data) evaluated at time $\tau$. 

### Sliding window fit mass.
The term _sliding window fit mass_ corresponds to the mass extracted
by fitting the correlation function data $C(\tau)$ to a _cosh_ anstaz
of the form,
\begin{equation}
    f(A, m) = \cosh\Big( m \cdot ( \tau - N_\tau / 2 ) \Big).
\end{equation}
The raw data $C(\tau)$ has a range from $[0,N\_\tau-1]$. We define a
window $[\tau\_0,N\_\tau-\tau\_0]$, with $\tau\_0$ belonging to
$\tau\_0 \in [0, N\_\tau/2 -1]$. The _sliding_ corresponds to iterate
this process by shrinking the window, that is $\tau\_0 \to \tau\_0 +
n \cdot a\_\tau$ and $N\_\tau - \tau \to N\_\tau - \tau - \cdot
a\_\tau$. For each window we obtain an estimate on the mass.

### Estimate of the mass.
The term _est mass_ or _estimation of the mass_ corresponds to the
following process in a given channel, temperature, source and flavour
structure,

1. We collect all the sliding window fit results as a function of the
   window used.
2. The data is then binned into several bins.
3. We take the most repeated bin as our estimate for the mass.
4. The value of the mass is then the average of all the values inside
   the most repeated bin.
5. The error is the maximum between the average of the statistical
   erros inside the bin or the following estimation of the systematic
   error,
\begin{equation}
    \Delta\,m = \frac{1}{2} \Big[ \text{max}( Values ) - \text{min}(
    Values ),
\end{equation}
    where `Values` is the set of values inside the most populated bin
    in the histogram.

> **This process has to be reanalysed to make it more robust.**

# Repository

## `scripts/` folder
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
