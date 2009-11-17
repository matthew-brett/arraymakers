# See: http://wiki.cython.org/tutorials/numpy

import numpy as np
cimport numpy as cnp

cdef dict _kwargs = {'shape':(50,),'dtype':np.dtype('f4'),'buffer':None}
cdef object _ndarray = np.ndarray
cdef cnp.npy_intp _size = 50
cdef cnp.dtype _dt = np.dtype('f4')
cdef object _data = None

def make_local_1d_array(cnp.npy_intp size, object data, cnp.dtype dt):

   global _kwargs, _size, _dt, _data, _ndarray

   if (size != _size):
      _kwargs['shape'] = (size,)
      _size = size

   if (dt is not _dt):
      _kwargs['dtype'] = dt
      _dt = dt

   if (data is not _data):
      _kwargs['buffer'] = data
      _data = data

   return _ndarray(**_kwargs)

