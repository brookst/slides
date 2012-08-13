#!/usr/bin/make -f
#
# Makefile for pdflatex projects
#
# Timothy Brooks 2012 <brooks@cern.ch>
#

SHELL = /bin/bash

latexfile   = slides
pdffile     = tim_brooks

img_dir     = img
img_src_dir = img_src

TEX         = pdflatex -halt-on-error -file-line-error
img  = $(patsubst $(img_src_dir)/%.svg, $(img_dir)/%.pdf, $(wildcard $(img_src_dir)/*.svg))
img += $(patsubst $(img_src_dir)/%.eps, $(img_dir)/%.pdf, $(wildcard $(img_src_dir)/*.eps))

all: $(pdffile).pdf

$(pdffile).pdf: $(latexfile).aux
	while ($(TEX) $(latexfile) ; \
	grep -q "Rerun to get cross" $(latexfile).log ) do true ; \
        done
	mv $(latexfile).pdf $(pdffile).pdf
	$(MAKE) tmpclean

$(latexfile).aux: $(img) $(latexfile).tex
	$(TEX) $(latexfile)

$(img_dir)/%.pdf: $(img_src_dir)/%.svg | $(img_dir)
	inkscape -D -z --file=$< --export-pdf=$@

$(img_dir)/%.pdf: $(img_src_dir)/%.eps | $(img_dir)
	epstopdf $< -o $@

$(img_dir):
	mkdir -p $(img_dir)

images: $(img)

clean: tmpclean
	rm -f $(latexfile).aux
	rm -f $(pdffile).pdf

tmpclean: logclean
	rm -f $(latexfile).nav $(latexfile).out $(latexfile).snm $(latexfile).toc

logclean:
	rm -f $(latexfile).log

imgclean:
	rm -f $(img)
