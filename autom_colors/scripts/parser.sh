function print_help() {
    printf "USE: In order to use the script, run the following
    command.
                bash master.sh -p p0,p1,...,p0 
    Information about each parameter can be retrieved by using the
    command 'bash master.sh -ip'.
    " 
    exit 1
}

function print_info() {
    printf "INFORMATION: In order to run the code 8 parameters have
    to be provided. They have to be provided in the same order
    everytime. They are always in the same order and they represent:

        1. Percentage of divergence that we are keen to accept
        between ll and ss fit data to say they are equal or not.
        2. Percentage of the data we would like to use to say if ll
        and ss are equal or not. 
        3. Percentage of divergence that we are keen to accept
        between the effective masss and the sliding fit data to say
        if they agree or not.
        4. Difference in height between two adjacent points that we
        set to say two points belong to a plateau. The value provided
        represents the percentage in the slope.
        5. Percentage of the total data that has to be compatible
        according to parameter (3) in order to set this cell as a
        green cell.
        6. Percentage of the total data that has to belong to a
        plateau according to parameter (4) in order to set this cell
        as a green cell.
        7. Percentage of the total data that has to be compatible
        according to parameter (3) in order to set this cell as a
        orange cell.
        8. Percentage of the total data that has to belong to a
        plateau according to parameter (4) in order to set this cell
        as a orange cell.


        NOTE: The parameters must hold the following property,
                            5 > 7 and 6 > 8
    "
    exit 1
}

function parse_params() {
    PARAMS=$1
    PARAMS=($( echo $PARAMS | sed 's/,/ /g' ))
    # Set the parameters
    p0=${PARAMS[0]}; p1=${PARAMS[1]}; p2=${PARAMS[2]};
    p3=${PARAMS[3]}; p4=${PARAMS[4]}; p5=${PARAMS[5]};
    p6=${PARAMS[6]}; p7=${PARAMS[7]}; p8=${PARAMS[8]};
}

function set_defaults() {
    p0=0.2; p1=0.5; p2=0.2; p3=0.01; p4=0.4; p5=0.4; p6=0.1; p7=0.1
}
