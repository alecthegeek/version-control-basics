PROJECT_NAME:=version-control-basics

PANDOC_FLAGS:=--number-sections -s -S

DOCUMENTCLASS:=article

PUBLISH_LOC:=~/Box\ Sync/Public/$(PROJECT_NAME)

USER_EMAIL:=acdsip61-pi@yahoo.com
USER_NAME:="Pi Student"
BASE_DEMO:=$(HOME)/snakes
PROMPT_DIR:=${shell basename $(BASE_DEMO)}
BRANCH1:=master
BRANCH2:=make_rocks_R
BRANCH3:=use_curses_symbols

UNAME_S:=$(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	SED_CMD:=gsed
else
ifeq ($(UNAME_S),Linux)
		SED_CMD:=sed
else
		${error OS $UNAME_S not supported}
endif
endif

.SUFFIXES:

.SUFFIXES: .html .pdf .docbook .docx .pmd .odt

.PHONY: clean all static_images publish_all publish_odt publish_docx publish_html  publish_pdf publish_README publish_images

ifdef DEBUG
PANDOC_FLAGS+=--verbose	
else
.SECONDARY: $(PROJECT_NAME).pmd
endif

all: $(PROJECT_NAME).pdf

clean:
	-rm *.fodt *.html *.opml *.tex *.pdf *.md *.mmd *.pmd *.log *.dvi *.ist *.gl? *.dbk *.docx *.odt
	-rm -rf $(BASE_DEMO) images

publish_all: publish_pdf publish_html publish_odt publish_docx

publish_pdf: $(PUBLISH_LOC)/$(PROJECT_NAME).pdf  publish_README 

publish_odt: $(PUBLISH_LOC)/$(PROJECT_NAME).odt  publish_README 

publish_docx: $(PUBLISH_LOC)/$(PROJECT_NAME).docx  publish_README 

publish_html: $(PUBLISH_LOC)/$(PROJECT_NAME).html  publish_README publish_images

publish_README: $(PUBLISH_LOC)/README

publish_images: staticImages/* images/*
	test -d  $(PUBLISH_LOC) || mkdir -p $(PUBLISH_LOC)
	cp --parents $+ $(PUBLISH_LOC)

$(PUBLISH_LOC)/$(PROJECT_NAME).html: $(PROJECT_NAME).html publish_images
	test -d  $(PUBLISH_LOC) || mkdir -p $(PUBLISH_LOC)
	cp $< $(PUBLISH_LOC)

$(PUBLISH_LOC)/%: %
	test -d  $(PUBLISH_LOC) || mkdir -p $(PUBLISH_LOC)
	cp $< $(PUBLISH_LOC)

%.pmd: %.m4 utils.m4 staticImages/* $(MAKEFILE_LIST)
	-rm -rf $(BASE_DEMO) images /tmp/$(PROJECT_NAME) ; mkdir $(BASE_DEMO) images
	tar -xzf game.tar.gz -C $(BASE_DEMO)
#ifdef DEBUG
#	m4 -D m4_sed=$(SED_CMD) -D user_email=$(USER_EMAIL) -D user_name=$(USER_NAME) -D working_dir=$(BASE_DEMO) -D prompt_dir=$(PROMPT_DIR) -D branch1=$(BRANCH1) -D branch2=$(BRANCH2) -D branch3=$(BRANCH3) -P $< | tee $@
#else
	m4 -D m4_sed=$(SED_CMD) -D user_email=$(USER_EMAIL) -D user_name=$(USER_NAME) -D working_dir=$(BASE_DEMO) -D prompt_dir=$(PROMPT_DIR) -D branch1=$(BRANCH1) -D branch2=$(BRANCH2) -D branch3=$(BRANCH3) -P $< > $@
#	endif

%.md: %.pmd
	pandoc $(PANDOC_FLAGS)  $< -o $@

%.pdf: %.pmd
	pandoc $(PANDOC_FLAGS) -V documentclass=$(DOCUMENTCLASS) --toc -t latex  $< -o $@

%.html: %.pmd
	pandoc $(PANDOC_FLAGS) $< -o $@

%.docx: %.pmd
	pandoc $(PANDOC_FLAGS) -t docx $< -o $@

%.odt: %.pmd
	pandoc $(PANDOC_FLAGS) -t odt $< -o $@
