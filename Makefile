.SUFFIXES:

.SUFFIXES: .html .pdf

.PHONY: clean all includes

export USER_EMAIL:=acdsip61-pi@yahoo.com
export USER_NAME:="Pi Student"
export BASE_DEMO:=$(HOME)/snakes
export BRANCH1:=master
export BRANCH2:=make_rocks_R

export DEV_DIR:=$(CURDIR)

# mmdxsltbase=$(HOME)/Library/Application Support/MultiMarkdown/bin


all: version-control-basics.pdf version-control-basics.html

clean:
	-rm *.fodt *.html *.opml *.tex *.pdf *.mmd *.pmd *.log *.dvi *.ist *.gl?
	-rm -rf includes

%.pmd: %.m4 includes
	m4 -I./includes -P $< > $@

%.pdf: %.pmd
	pandoc -s -S -t latex  $< -o $@

%.html: %.pmd
	pandoc -s -S -$< -o $@

includes:
	./createIt.sh

