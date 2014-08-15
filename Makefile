.SUFFIXES:

.SUFFIXES: .html .pdf .docbook .docx .pmd

.PHONY: clean all

.SECONDARY: version-control-basics.pmd

PANDOC_FLAGS:=--number-sections -s -S

DOCUMENTCLASS:=article

USER_EMAIL:=acdsip61-pi@yahoo.com
USER_NAME:="Pi Student"
BASE_DEMO:=$(HOME)/snakes
BRANCH1:=master
BRANCH2:=make_rocks_R
BRANCH3:=use_curses_symbols

all: version-control-basics.pdf

clean:
	-rm *.fodt *.html *.opml *.tex *.pdf *.mmd *.pmd *.log *.dvi *.ist *.gl? *.dbk *.docx
	-rm -rf $(BASE_DEMO)

%.pmd: %.m4 utils.m4 $(MAKEFILE_LIST)
	-rm -rf $(BASE_DEMO)
	mkdir $(BASE_DEMO)
	tar -xzf game.tar.gz -C $(BASE_DEMO)
	m4 -D user_email=$(USER_EMAIL) -D user_name=$(USER_NAME) -D working_dir=$(BASE_DEMO) -D branch1=$(BRANCH1) -D branch2=$(BRANCH2) -D branch3=$(BRANCH3) -P $< > $@

%.pdf: %.pmd
	pandoc $(PANDOC_FLAGS) -V documentclass=$(DOCUMENTCLASS) --toc -t latex  $< -o $@

%.html: %.pmd
	pandoc $(PANDOC_FLAGS) $< -o $@

%.docx: %.pmd
	pandoc $(PANDOC_FLAGS) -t docx $< -o $@

%.docbook: %.pmd
	pandoc $(PANDOC_FLAGS) -t docbook $< -o $@

