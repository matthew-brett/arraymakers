""" Testing 

"""

import os

import numpy as np

from nose.tools import assert_true, assert_false, \
     assert_equal, assert_raises

from numpy.testing import assert_array_equal, assert_array_almost_equal

import arraymaker1

def test_arraymaker1():
    arr = np.arange(10, dtype='f8')
    narr = arraymaker1.another_array(arr)
    yield assert_false, arr is narr
    yield assert_array_equal, arr, narr
    narr = arraymaker1.another_array(arr)
    narr = arraymaker1.another_array(arr)
    narr = arraymaker1.another_array(arr)
    narr = arraymaker1.another_array(arr)
    narr = arraymaker1.another_array(arr)
    yield assert_array_equal, arr, narr
    
