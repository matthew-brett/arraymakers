clean:
	-rm -rf build *.so

all: clean
	python setup.py build_ext --inplace

