.SUFFIXES:

.SUFFIXES: .html .pdf .docbook .docx .pmd .odt

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

ifeq ($(_system_name),OSX)
	SED_CMD:=gsed
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		SED_CMD:=sed
	else
		${error OS Not Supported}
	endif
endif

all: version-control-basics.pdf

clean:
	-rm *.fodt *.html *.opml *.tex *.pdf *.md *.mmd *.pmd *.log *.dvi *.ist *.gl? *.dbk *.docx *.odt
	-rm -rf $(BASE_DEMO) images

%.pmd: %.m4 utils.m4 $(MAKEFILE_LIST)
	-rm -rf $(BASE_DEMO) images ; mkdir $(BASE_DEMO) images
	tar -xzf game.tar.gz -C $(BASE_DEMO)
ifdef DEBUG
	m4 -D m4_sed=$(SED_CMD) -D user_email=$(USER_EMAIL) -D user_name=$(USER_NAME) -D working_dir=$(BASE_DEMO) -D branch1=$(BRANCH1) -D branch2=$(BRANCH2) -D branch3=$(BRANCH3) -P $<
else
	m4 -D m4_sed=$(SED_CMD) -D user_email=$(USER_EMAIL) -D user_name=$(USER_NAME) -D working_dir=$(BASE_DEMO) -D branch1=$(BRANCH1) -D branch2=$(BRANCH2) -D branch3=$(BRANCH3) -P $< > $@
endif

%.md: %.pmd
	pandoc $(PANDOC_FLAGS)  -t markdown_github $< -o $@

%.pdf: %.pmd
	pandoc $(PANDOC_FLAGS) -V documentclass=$(DOCUMENTCLASS) --toc -t latex  $< -o $@

%.html: %.pmd
	pandoc $(PANDOC_FLAGS) $< -o $@

%.docx: %.pmd
	pandoc $(PANDOC_FLAGS) -t docx $< -o $@

%.odt: %.pmd
	pandoc $(PANDOC_FLAGS) -t odt $< -o $@

