.SUFFIXES:

.SUFFIXES: .html .pdf

.PHONY: clean all

.SECONDARY: version-control-basics.pmd

DOCUMENTCLASS:=article

USER_EMAIL:=acdsip61-pi@yahoo.com
USER_NAME:="Pi Student"
BASE_DEMO:=$(HOME)/snakes
BRANCH1:=master
BRANCH2:=make_rocks_R

all: version-control-basics.pdf

clean:
	-rm *.fodt *.html *.opml *.tex *.pdf *.mmd *.pmd *.log *.dvi *.ist *.gl? *.dbk *.docx
	-rm -rf $(BASE_DEMO)

%.pmd: %.m4 utils.m4 $(MAKEFILE_LIST)
	-rm -rf $(BASE_DEMO)
	mkdir $(BASE_DEMO)
	tar -xzf game.tar.gz -C $(BASE_DEMO)
	find $(BASE_DEMO) -type f -exec dos2unix {} \;
	m4 -D user_email=$(USER_EMAIL) -D user_name=$(USER_NAME) -D working_dir=$(BASE_DEMO) -D branch1=$(BRANCH1) -D branch2=$(BRANCH2) -P $< > $@

%.pdf: %.pmd
	pandoc -V documentclass=$(DOCUMENTCLASS) --toc -s -S -t latex  $< -o $@

%.html: %.pmd
	pandoc -s -S $< -o $@

%.docx: %.pmd
	pandoc -s -S -t docx $< -o $@

%.dbk: %.pmd
	pandoc -s -S -t docbook $< -o $@

