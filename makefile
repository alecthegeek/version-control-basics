.SUFFIXES:

.SUFFIXES: .html .pdf

.PHONY: clean all

all: version-control-basics.html

clean:
	-rm *.html *.pdf

%.html %.pdf: %.mmd 
	mmd -t$(subst .,,$(suffix $@)) < $<  > $@
