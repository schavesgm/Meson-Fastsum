# Automatic generation of confidence tables.
---
Provided that generating a confidence table using _humans_ is not the
most feasible approach as we are good at committing bias errors, I
decided to generate a script to automatically generate these tables.

The choice of parameters to tune our table is arbitrary, therefore, I
decided to make them variables that can be input from the command
line. Given some parameters, `master.sh` will generate a table
representing the confidence of the data for all channels,
temperatures, flavour structures and sources. The results are
consistent with the parameters provided. A different choice of
parameters will, of course, affect the final result.

The idea is to make a plausible way of categorising the data
according to some beliefs/prior knowledge.

## Running the tool.
Running this tool is as easy as using the following command,
```bash
bash master.sh -p p0,p1,p2,p3,p4,p5,p6,p7
```
The values `p0,...,p7` are the input parameters of the algorithm.
They are 8, so there is room to play. If no flag `-p` is given, the
algorithm will be run with the following values,
```bash
p0=0.2; p1=0.5; p2=0.2; p3=0.01; p4=0.4; p5=0.4; p6=0.1; p7=0.1
```
Information about the script can be retrieved by using,
```bash
bash master -h
```
Information about the parameters can be obtained by using,
```bash
bash master -ip
```
After running the first command, you should obtain a `tex` file
inside the `TABLES`. The default name is `table_results.tex`. If you
wanted to give it another name, use the flag `-n` to change the
`result` part of the name to whatever you feel like. Provided you
have `pdflatex` implemented in your machine, the script will try
compiling the `tex` file into a `pdf` file.

One example of the result can be found inside `examples` folder.
Information about the algorithms used to generate the color codes can
be found inside. You can compare the automatic table to one created
by a human by comparing it to the table called `human_conf_table.pdf`
inside `examples`.
