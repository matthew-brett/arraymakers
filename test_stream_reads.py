""" Testing 

"""
import cStringIO
import StringIO

import numpy as np

from nose.tools import assert_true, assert_false, \
     assert_equal, assert_raises

from numpy.testing import assert_array_equal, assert_array_almost_equal

import scipy.io.matlab.mio5 as mio5
import scipy.io.matlab.byteordercodes as boc

from arraymaker1 import read_numeric


def _make_tag(base_dt, val, mdtype, sde=False):
    ''' Makes a simple matlab tag, full or sde '''
    base_dt = np.dtype(base_dt)
    bo = boc.to_numpy_code(base_dt.byteorder)
    byte_count = base_dt.itemsize
    if not sde:
        udt = bo + 'u4'
        padding = 8 - (byte_count % 8)
        all_dt = [('mdtype', udt),
                  ('byte_count', udt),
                  ('val', base_dt)]
        if padding:
            all_dt.append(('padding', 'u1', padding))
    else: # is sde
        udt = bo + 'u2'
        padding = 4-byte_count
        if bo == '<': # little endian
            all_dt = [('mdtype', udt),
                      ('byte_count', udt),
                      ('val', base_dt)]
        else: # big endian
            all_dt = [('byte_count', udt),
                      ('mdtype', udt),
                      ('val', base_dt)]
        if padding:
            all_dt.append(('padding', 'u1', padding))
    tag = np.zeros((1,), dtype=all_dt)
    tag['mdtype'] = mdtype
    tag['byte_count'] = byte_count
    tag['val'] = val
    return tag


def _write_stream(stream, *strings):
    stream.truncate(0)
    for s in strings:
        stream.write(s)
    stream.seek(0)


def test_read_numeric():
    # make reader-like thing
    str_io = cStringIO.StringIO()
    # check simplest of tags
    for base_dt, val, mdtype in (
        ('u2', 30, mio5.miUINT16),
        ('i4', 1, mio5.miINT32),
        ('i2', -1, mio5.miINT16)):
        byte_code = '<'
        dt = np.dtype(base_dt).newbyteorder(byte_code)
        a = _make_tag(dt, val, mdtype, False)
        a_str = a.tostring()
        _write_stream(str_io, a_str)
        el, d = read_numeric(str_io)
        yield assert_equal, el, val
        # two sequential reads
        _write_stream(str_io, a_str, a_str)
        el, d = read_numeric(str_io)
        yield assert_equal, el, val
        el,d  = read_numeric(str_io)
        yield assert_equal, el, val
    
