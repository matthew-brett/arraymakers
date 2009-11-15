""" Testing 

"""

import os

import numpy as np

from nose.tools import assert_true, assert_false, \
     assert_equal, assert_raises

from numpy.testing import assert_array_equal, assert_array_almost_equal

import arraymaker2

def py_make_1d_array(n, data, dt):
    return np.ndarray(shape=(n,), dtype=dt, buffer=data)

def test_arraymaker2():
    n = 10
    for dt_str in ('i2', 'u4', 'f8'):
        dt = np.dtype(dt_str)
        arr = np.arange(n, dtype=dt)
        arr_str = arr.tostring()
        a_py = py_make_1d_array(n, arr_str, dt)
        yield assert_false, a_py is arr
        yield assert_array_equal, arr, a_py
        a_pyx = arraymaker2.make_1d_array(n, arr_str, dt)
        yield assert_false, a_pyx is arr
        yield assert_array_equal, arr, a_pyx
    
