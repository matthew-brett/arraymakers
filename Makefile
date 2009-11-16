clean:
	-rm -rf build *.so *.pyc *.c

am1:
	-rm -rf build arraymaker1.so
	python setup.py build_ext --inplace

am2:
	-rm -rf build arraymaker2.so
	python setup2.py build_ext --inplace

sb:
	-rm -rf build sturlabench.so
	python setup3.py build_ext --inplace


test:
	nosetests -s test*

all: am1 am2 sb