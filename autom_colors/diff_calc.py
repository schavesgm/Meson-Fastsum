import sys
import numpy as np
import matplotlib.pyplot as plt

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


def index_startplat( data, thresh = 0.2 ):
    '''
    Function to obtain the start of a plateau given some data. The
    index is calculated using the following procedure,
    1. We calculate the average ratio from one point to all the
    consecutive ones, that's it
        rat[i] = ( 1 / N ) * \sum_{j=i+1}^{N} data[i] / data[j]
    2. We define the plateau as the first point such that the average
    ratio is a distance of 'thres' from the consecutive ones. If
    'thres' is 0.2 then the plateau will start at the first point
    such that its average ratio with all the consecutive ones holds,
                    0.80 <= rat[i] <= 1.20

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

    avg_ratio = np.empty( data.shape[0] - 1 )
    for i in range( data.shape[0] - 1 ):
        avg_ratio[i] = \
            abs( np.mean( data[i] / data[i+1:] ) )

    plat_init = None
    for index, value in enumerate( avg_ratio, 1 ):
        # This is the definition of the plateau
        if 1 - thresh <= value <= 1 + thresh:
            plat_init = index
            break

    if plat_init is None:
        plat_init = 0

    return plat_init

def decide_color( data_eff, data_fit, thresh = [0.15, 0.10],
        green = [0.3, 0.35], orange = 0.20 ):
    
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
    print( plat_fit, frac_plat_fit, green[1] )

    #print( frac_ratio, frac_plat_fit )
    choose_color( frac_ratio, frac_plat_fit, green, orange )
    pass

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

    # if frac_ratio >= green[0]: # and frac_plat >= green[1]:
    if frac_ratio >= green[0] and frac_plat >= green[1]: 
        print( 'GREEN' )
    else:
        print( 'NOT GREEN' ) 
    # elif orange <= frac_ratio <= green[0] and \
    #         orange <= frac_plat <= green[0]:
    #     print( 'It is an orange' )
    # else:
    #     print( 'It is a red' )

# Get the files
eff_file = sys.argv[1]
fit_file = sys.argv[2]

data_eff = np.loadtxt( eff_file, skiprows = 1 )
data_fit = np.loadtxt( fit_file )

# points_interval( data_eff[1:,1], data_fit[:,1] )
# print( index_startplat( data_eff[:,1] ) )
# print( points_interval( data_eff[1:,1], data_fit[:,1] ) )
decide_color( data_eff[1:,1], data_fit[:,1] )
