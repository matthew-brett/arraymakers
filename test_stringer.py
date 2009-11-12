""" Testing 

"""

import os

import numpy as np

from nose.tools import assert_true, assert_false, \
     assert_equal, assert_raises

from numpy.testing import assert_array_equal, assert_array_almost_equal

import pyximport; pyximport.install()

import stringer

def test_string_copy():
    s = 'a\x00string'
    s2 = stringer.copy_string(s)
    yield assert_false, s is s2
    yield assert_equal, s, s2
    
