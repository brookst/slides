SHELL = /bin/bash

latexfile   = slides
pdffile     = tim_brooks
TEX         = pdflatex
img_src_dir = img_src
img_dir     = img

img_src     = $(wildcard $(img_src_dir)/*.svg)
img         = $(patsubst $(img_src_dir)/%.svg, $(img_dir)/%.pdf, $(img_src))

all: $(pdffile).pdf

$(pdffile).pdf: $(latexfile).aux $(latexfile).nav
	while ($(TEX) $(latexfile) ; \
	grep -q "Rerun to get cross" $(latexfile).log ) do true ; \
        done
	mv $(latexfile).pdf $(pdffile).pdf

$(img_dir)/%.pdf: $(img_src_dir)/%.svg | $(img_dir)
	inkscape -D -z --file=$< --export-pdf=$@

$(latexfile).aux $(latexfile).nav: $(img) $(latexfile).tex #$(latexfile).bbl
	$(TEX) $(latexfile)

$(img_dir):
	mkdir -p $(img_dir)

images: $(img)

clean:
	rm -f *.aux *.log *.nav *.out *.snm *.toc $(img) $(pdffile).pdf
