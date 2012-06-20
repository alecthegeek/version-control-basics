.SUFFIXES:

.SUFFIXES: .html .pdf

.PHONY: clean all

export USER_EMAIL:=acdsip61-pi@yahoo.com
export USER_NAME:="Pi Student"
export BASE_DEMO:=$(HOME)/snakes
export BRANCH1:=master
export BRANCH2:=make_rocks_R

export DEV_DIR:=$(CURDIR)



mmdxsltbase=$(HOME)/Library/Application Support/MultiMarkdown/bin

all: index.html

clean:
	-rm *.html *.pdf *.tex includes/*

${wildcard ./includes/*}: createIt.sh
	./createIt.sh

index.html : version-control-basics.mmd ${wildcard ./includes/*} createIt.sh
	./createIt.sh
	m4 -I./includes -P $< > /tmp/$(<:.mmd=.m4)
	cd "$(mmdxsltbase)"  && ./mmd-xslt /tmp/$(<:.mmd=.m4)
	mv /tmp/$(<:.mmd=.html)  $@

%.html: %.mmd 
	cpp -I ./includes $< > $@
	cd "$(mmdxsltbase)"  && ./mmd-xslt ${realpath $<}
	mv $(<:.mmd=.html)  $@
# 	multimarkdown -t$(subst .,,$(suffix $@))  $<  -o $@
