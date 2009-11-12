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
cdef extern from "stdlib.h":
    void *memcpy(void *str1, void *str2, size_t n)

from python_string cimport PyString_FromStringAndSize, \
    PyString_AS_STRING, PyString_Size

cdef inline object pyalloc_v(Py_ssize_t n, void **pp):
    cdef object ob = PyString_FromStringAndSize(NULL, n)
    pp[0] = <void*> PyString_AS_STRING(ob)
    return ob

def copy_string(in_str):
    # For testing
    cdef:
        void *p
    cdef char  *s_ptr = in_str
    cdef Py_ssize_t n = PyString_Size(in_str)
    cdef object ob = pyalloc_v(n, &p)
    memcpy(p, s_ptr, n)
    return ob
