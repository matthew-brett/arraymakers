# See: http://wiki.cython.org/tutorials/numpy

from python cimport Py_INCREF

cdef extern from "Python.h":
    ctypedef struct PyTypeObject:
        pass

import numpy as np
cimport numpy as cnp

cdef extern from "numpy/arrayobject.h":
    PyTypeObject PyArray_Type
    object PyArray_NewFromDescr(PyTypeObject *subtype,
                                cnp.dtype newdtype,
                                int nd,
                                cnp.npy_intp* dims,
                                cnp.npy_intp* strides,
                                void* data,
                                int flags,
                                object parent)

cdef extern from "workaround.h":
    void PyArray_Set_BASE(cnp.ndarray arr, object obj)
                                     
# NOTE: numpy MUST be initialized before any other code is executed.
cnp.import_array()


def make_local_1d_array(cnp.npy_intp size, object data, cnp.dtype dt):
    cdef object _kwargs = {'shape':  (size,),  'dtype':dt,  'buffer':data}
    cdef object _ndarray = np.ndarray
    arr = _ndarray(**_kwargs)
