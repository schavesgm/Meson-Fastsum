import sys
import numpy as np
import matplotlib.pyplot as plt

def equal_or_not( data_ll, data_ss, thresh = 0.2 ):
    ''' 
    Function to check if the data corresponding to ll and ss converge
    to the same value with some threshold. The data corresponds to
    the sliding window fit mass.

    Arguments:
        data_ll ( np.array ):
            Array containing the data for the local local sources.
        data_ss ( np.array ):
            Array containing the data for the smeared smeared 
            sources.
        thresh ( float ) [optional]:
            Threshold that we accept to be equal, which means,
                        abs( ratio ) <= 1 + thresh
    Returns:
        yes_no ( int ):
            Returns a zero if they are not equal, a one if they are
            equal.
    '''

    # Calculate the ratio among the data -- element-wise
    ratio = abs( data_ll / data_ss )

    # Check the average of the data
    begin_count = int( ratio.shape[0] / 2 )
    yes_no = 1 - thresh <= abs( np.mean( ratio[begin_count:] ) ) \
        <= 1 + thresh

    return int( yes_no )

def points_interval( data_num, data_den, thresh = [0.2, 0.1] ):
    ''' 
    Function to obtain the number of points that hold the following
    propery,
            1 - thres <= data_eff[i] / data_fit[i] <= 1 + thresh
    Arguments:
        data_num ( np.array ):
            Data corresponding to the numerator.
        data_den ( np.array ):
            Data corresponding to the denominator.
        thres ( float ) [optional]:
            Threshold that defines the interval. The larger it is,
            the easier it is to have points on the interval.
    Returns:
        points ( integer ):
            Number of points whose ratio is inside the interval.
    '''

    assert( data_num.shape[0] == data_den.shape[0] )
    assert( len( thresh ) == 2 )
    assert( thresh[0] > 0 and thresh[1] > 0 )

    thresh_int, thresh_plt = thresh

    ratio = np.abs( data_num / data_den )
    plat_index = index_startplat( data_den, thresh_plt )
    # Get points with distance between threshold
    points = [ index for index, value \
            in enumerate( ratio, 1 ) \
            if 1 - thresh_int <= value <= 1 + thresh_int and
            index - plat_index > -2 ] # A distance of 2 around plat

    return len( points )


def index_startplat( data, thresh = 0.01 ):
    '''
    Function to obtain the start of a plateau given some data. The
    index is calculated using the following procedure,
    1. We calculate the slope of each point by using,
                    slope[i] = data[i+1] - data[i]
    2. We define the plateau as the first point such that the slope
    is smaller than a threshold percentage. Default is 1%.

    Arguments:
        data ( numpy array ):
            Numpy array containing the data to be analysed.
        thres ( float ) [optional]:
            Threshold that defines the plateau, the larger it is, the
            easier it is to define the beginning of the plateau.
    Returns:
        plat_index ( integer ):
            Beginning of the plateau in the data. If no plateau is
            found, an index 0 will be returned -> There is no clear
            plateau in this data.
    '''
    assert( thresh > 0 )

    # Calculate the slope on each point
    slope = np.empty( data.shape[0] - 1 )
    for i in range( data.shape[0] - 1 ):
        slope[i] = data[i+1] - data[i]

    plat_init = None
    for index, value in enumerate( slope, 1 ):
        # This is the definition of the plateau
        if abs( value ) <= thresh:
            plat_init = index
            break

    if plat_init is None:
        plat_init = data.shape[0]

    return plat_init

def decide_color( data_eff, data_fit, thresh = [0.20, 0.01],
        green = [0.4, 0.4], orange = [0.10,0.10] ):
    
    '''
    Function to trustworthiness of the data. The trustworthiness is
    defined as a combination of how different the effective mass and
    the sliding window fit mass are and how many points we have of
    plateau. We define three types of cells, green, orange and red.

    Green colour is defined as follows:
        1. The number of points inside the interval,
            1 - thres <= data_eff[i] / data_fit[i] <= 1 + thresh
        is larger than the variable 'gr_ratio'.
        2. The data shows a plateau that contains more enough points
        so that,
            len(data) - index_plateau  / len(data) > green_plat
    '''
    
    thresh_int, thresh_plt = thresh

    # Sizes 
    size_eff = data_eff.shape[0]
    size_fit = data_fit.shape[0]
    
    # Get the number of points inside the interval
    num_points = points_interval( data_eff, data_fit, thresh )

    # Get the starting point of the plateau
    plat_fit = index_startplat( data_fit, thresh_plt )

    frac_ratio = num_points / data_fit.shape[0]
    frac_plat_fit = ( size_fit - plat_fit ) / size_fit

    # Choose the color
    col = choose_color( frac_ratio, frac_plat_fit, green, orange )

    return col, plat_fit


def choose_color( frac_ratio, frac_plat, green, orange ):
    '''
    Function to choose the color of cell.
    Arguments:
        frac_ratio (float):
            Fraction of points inside the interval defined.
        frac_plat (float):
            Fraction of points that lie inside a plateau.
        green (float):
            Percentage of data that defines a green cell.
        orange (float):
            Percentage of data that defines an orange cell.
    '''
    # assert( green > 0 and orange > 0 )
    # assert( orange < green )

    if frac_ratio >= green[0] and frac_plat >= green[1]: 
        colour = 'G'
    elif orange[0] <= frac_ratio < green[0] or \
         orange[1] <= frac_plat < green[1]:
        colour = 'O'
    else:
        colour = 'R'

    return colour


# Get file names
fit_file_ll = sys.argv[1] 
fit_file_ss = sys.argv[2] 
eff_file_ll = sys.argv[3] 
eff_file_ss = sys.argv[4] 

# Load the ll files
data_eff_ll = np.loadtxt( eff_file_ll, skiprows = 1 )
data_fit_ll = np.loadtxt( fit_file_ll )

# Clean the data for ll
init_fit, end_fit = int( data_fit_ll[0,0] ), int( data_fit_ll[-1,0] )
data_eff_ll = data_eff_ll[init_fit:end_fit+1,:]

# Load the ss files
data_eff_ss = np.loadtxt( eff_file_ss, skiprows = 1 )
data_fit_ss = np.loadtxt( fit_file_ss )

# Clean the data for ll
init_fit, end_fit = int( data_fit_ss[0,0] ), int( data_fit_ss[-1,0] )
data_eff_ss = data_eff_ss[init_fit:end_fit+1,:]

# Decide the color for both values
col_ll, plat_fit_ll =  \
    decide_color( data_eff_ll[:,1], data_fit_ll[:,1] )

col_ss, plat_fit_ss =  \
    decide_color( data_eff_ss[:,1], data_fit_ss[:,1] )

# Decide whether ll and ss are equal or not

# Clean the data for both files
init = int( max( data_fit_ll[0,0], data_fit_ss[0,0] ) )
end = int( min( data_fit_ll[-1,0], data_fit_ss[-1,0] ) )

data_fit_ss = data_fit_ss[init:end,:]
data_fit_ll = data_fit_ll[init:end,:]

yes_no = equal_or_not( data_fit_ll[:,1], data_fit_ss[:,1] )

print( col_ll, plat_fit_ll, col_ss, plat_fit_ss, yes_no )
