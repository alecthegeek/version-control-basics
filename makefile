.SUFFIXES:

.SUFFIXES: .html .pdf

.PHONY: clean all

all: version-control-basics.html

clean:
	-rm *.html *.pdf


index.html : version-control-basics.mmd 
	mmd -t$(subst .,,$(suffix $@)) < $<  > $@

%.html %.pdf: %.mmd 
	mmd -t$(subst .,,$(suffix $@)) < $<  > $@
