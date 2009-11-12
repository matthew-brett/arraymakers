# See: http://wiki.cython.org/tutorials/numpy

from python cimport Py_INCREF, Py_DECREF

import numpy as np
cimport numpy as cnp

cdef extern from "numpy/arrayobject.h":
        cdef void import_array()
        int PyArray_ISCARRAY(cnp.ndarray instance )
        cdef cnp.ndarray PyArray_FromArray(cnp.ndarray, cnp.dtype, int )
        int NPY_CARRAY
        int NPY_FORCECAST

# Initialize numpy entry points
import_array()

''' Keep in mind that the Numpy C API has a strange convention where
most entry points which take a "dtype" reference "steal" a reference to
the dtype (they Py_DECREF the dtype), so if you wish to use one of those
entry points you will need to do a Py_INCREF of the dtype before passing
it into the entry point: '''


def another_array(cnp.ndarray arr not None):
    cdef cnp.dtype dt = np.dtype('i2')
    cdef cnp.ndarray narr
    Py_INCREF(<object> dt)
    narr = PyArray_FromArray(arr, dt, NPY_CARRAY|NPY_FORCECAST)
    return narr
