# Meson data

In the folders contained in this root directory you can find data for
each channel, each folder corresponds to a channel. They are all
listed inside the file `meson_cheatsheet.pdf`.

* g5 - Pseudoscalar - Corresponds to 0-+
* vec - Vector - Corresponds to 1--
* ax_plus - Ax_plus - Corresponds to 1++
* ax_minus - Ax_minus - Corresponds to 1+-
* g0 - Scalar - Corresponds to 0++

Inside each folder you can find two subfolders named `ll` and `ss`.
They correspond to the type of sources used, local-local or
smeared-smeared. Inside each of them, you can find two subfolders
called `cosh` and `cosh-void`. They correspond to the ansatz used in
the calculation,

cosh = A * cosh( M * ( \tau - N\tau/2 ) ),
cosh-void = cosh + B,

where the term `B` is called the void. It can also appear as
transport coefficient. Inside each ansatz folder, you can find the
data for each parameter as a function of temperature. You can find a
collection of plots inside the `plots` folder.


