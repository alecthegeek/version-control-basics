.SUFFIXES:

.SUFFIXES: .html .pdf .docbook .docx .pmd .odt

.PHONY: clean all publish_all publish_odt publish_docx publish_html  publish_pdf publish_README

.SECONDARY: version-control-basics.pmd

PANDOC_FLAGS:=--number-sections -s -S

DOCUMENTCLASS:=article

USER_EMAIL:=acdsip61-pi@yahoo.com
USER_NAME:="Pi Student"
BASE_DEMO:=$(HOME)/snakes
BRANCH1:=master
BRANCH2:=make_rocks_R
BRANCH3:=use_curses_symbols

PUBLISH_DIR:=~/Copy/Public/version-control-basics

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

publish_all: publish_pdf publish_html publish_odt publish_docx publish_README

publish_pdf: $(PUBLISH_DIR)/version-control-basics.pdf  publish_README

publish_odt: $(PUBLISH_DIR)/version-control-basics.odt  publish_README

publish_docx: $(PUBLISH_DIR)/version-control-basics.docx  publish_README

publish_html: $(PUBLISH_DIR)/version-control-basics.html  publish_README

publish_README: $(PUBLISH_DIR)/README

$(PUBLISH_DIR)/version-control-basics.html: version-control-basics.html images/*
	-mkdir $(PUBLISH_DIR)
	cp --parents images/* $< $(PUBLISH_DIR)

$(PUBLISH_DIR)/%: %
	-mkdir $(PUBLISH_DIR)
	cp $<  $@

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

images/*: version-control-basics.html

%.docx: %.pmd
	pandoc $(PANDOC_FLAGS) -t docx $< -o $@

%.odt: %.pmd
	pandoc $(PANDOC_FLAGS) -t odt $< -o $@

