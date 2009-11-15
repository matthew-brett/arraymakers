# See: http://wiki.cython.org/tutorials/numpy

from python cimport Py_INCREF, Py_DECREF

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

dts = {4:'u2',
       5:'i4',
       3:'i2'}


def read_numeric(stream):
    cdef:
        cnp.uint32_t mdtype
        cnp.uint32_t byte_count
    d1 = stream.read(4)
    cdef char * ptr = d1
    mdtype = (<cnp.uint32_t*>ptr)[0]
    d1 = stream.read(4)
    ptr = d1
    byte_count = (<cnp.uint32_t*>ptr)[0]
    data = stream.read(byte_count)
    ptr = data
    mod8 = byte_count % 8
    if mod8:
        stream.seek(8-mod8, 1)
    dt = np.dtype(dts[mdtype])
    cdef cnp.npy_intp el_count = byte_count // dt.itemsize
    #return np.ndarray(shape=(el_count,), dtype = dt, buffer = data)
    Py_INCREF(<object> dt)
    Py_INCREF(<object> data)
    narr = PyArray_NewFromDescr(&PyArray_Type,
                                 dt,
                                 1,
                                 &el_count,
                                 NULL,
                                 <void *>ptr,
                                 0,
                                 <object>NULL)
    PyArray_Set_BASE(narr, data)
    return narr, data
    

def another_array(cnp.ndarray arr not None):
    cdef cnp.dtype dt = np.dtype('i2')
    cdef cnp.ndarray narr
    cdef cnp.npy_intp dims[1]
    cdef char *ptr
    data = arr.astype(dt).tostring()
    ptr = data
    dims[0] = 10
    Py_INCREF(<object> dt)
    Py_INCREF(<object> data)
    narr = PyArray_NewFromDescr(&PyArray_Type,
                                 dt,
                                 1,
                                 dims,
                                 NULL,
                                 ptr,
                                 0,
                                 <object>NULL)
    PyArray_Set_BASE(narr, data)
    return narr
