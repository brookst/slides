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
img += $(patsubst $(img_src_dir)/%.png, $(img_dir)/%.png, $(wildcard $(img_src_dir)/*.png))
img += $(patsubst $(img_src_dir)/%.jpg, $(img_dir)/%.jpg, $(wildcard $(img_src_dir)/*.jpg))

all: $(pdffile).pdf

$(pdffile).pdf: $(latexfile).aux
	while ($(TEX) $(latexfile) ; \
	grep -q "Rerun to get cross" $(latexfile).log ) do true ; \
        done
	mv $(latexfile).pdf $(pdffile).pdf

$(latexfile).aux: $(img) $(latexfile).tex
	$(TEX) $(latexfile)

$(img_dir)/%.pdf: $(img_src_dir)/%.svg | $(img_dir)
	inkscape -D -z --file=$< --export-pdf=$@

$(img_dir)/%.pdf: $(img_src_dir)/%.eps | $(img_dir)
	epstopdf $< -o $@

$(img_dir)/%.png: $(img_src_dir)/%.png | $(img_dir)
	ln -s ../$< $@

$(img_dir)/%.jpg: $(img_src_dir)/%.jpg | $(img_dir)
	ln -s ../$< $@

$(img_dir):
	mkdir -p $(img_dir)

images: $(img)

clean:
	rm -f $(latexfile).lof $(latexfile).lot $(latexfile).log $(latexfile).nav $(latexfile).out $(latexfile).snm $(latexfile).toc
	rm -f $(latexfile).aux
	rm -f $(pdffile).pdf

imgclean:
	rm -f $(img)
