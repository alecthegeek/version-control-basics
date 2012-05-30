.SUFFIXES:

.SUFFIXES: .html .pdf

.PHONY: clean all


mmdxsltbase=$(HOME)/Library/Application Support/MultiMarkdown/bin

all: index.html

clean:
	-rm *.html *.pdf *.tex


index.html : version-control-basics.mmd
	cd "$(mmdxsltbase)"  && ./mmd-xslt ${realpath $<}
	# multimarkdown -t$(subst .,,$(suffix $@))  $<  -o $@

%.html %.pdf: %.mmd 
	multimarkdown -t$(subst .,,$(suffix $@))  $<  -o $@
