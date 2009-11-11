# http://docs.python.org/c-api/string.html
# http://wiki.cython.org/enhancements/arraytypes
# http://codespeak.net/pipermail/cython-dev/2008-April/000406.html

'''
This is actually the same solution that popped into my mind when I  
first read your question, and I think it is a very good one. Using  
string objects is particularly interesting because the they are  
highly optimized (for example, the buffer allocation is done as part  
of the object allocation). I would probably have it take a void**  
rather than make an allocator specific to ints. If people like this  
idea, I could add such a function to Sage. Maybe it would even be  
worthwhile adding it to Cython (in one of the included header files).
'''

from python_string cimport PyString_FromStringAndSize, PyString_AS_STRING

cdef inline object pyalloc_i(int size, int **i):
    if size < 0: size = 0
    cdef Py_ssize_t n = size * sizeof(int)
    cdef object ob = PyString_FromStringAndSize(NULL, n)
    i[0] = <int*> PyString_AS_STRING(ob)
    return ob

def foo(sequence):
    cdef int size = len(sequence),
    cdef int *buf = NULL
    cdef object tmp = pyalloc_i(size, &buf)
