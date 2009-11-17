import numpy as np

import arraymaker2
import sturlabench

def py_make_1d_array(n, data, dt):
    return np.ndarray(shape=(n,), dtype=dt, buffer=data)

n = 50
dt = np.dtype('f4')
data = np.arange(n, dtype=dt).tostring()

