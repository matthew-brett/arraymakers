# From http://codespeak.net/pipermail/cython-dev/2008-April/000691.html
# http://docs.python.org/c-api/cobject.html
# http://docs.python.org/extending/extending.html#using-cobjects

cdef extern from "stdlib.h":
    ctypedef unsigned long size_t
    void *memcpy(void *str1, void *str2, size_t n)
    void *malloc(size_t size)
    void free(void *ptr)

cdef extern from "Python.h":
    object PyCObject_FromVoidPtr(void *, void (*)(void*))

cdef inline void *memnew(size_t n):
    if n == 0: n = 1
    return malloc(n)

cdef inline void memdel(void *p):
    if p != NULL: free(p)

cdef inline object memalloc(size_t n, void **pp):
    cdef object cob
    cdef void *p = memnew(n)
    if p == NULL: raise MemoryError
    try:    cob = PyCObject_FromVoidPtr(p, memdel)
    except: memdel(p); raise
    pp[0] = p
    return cob
