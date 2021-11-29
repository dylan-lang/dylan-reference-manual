
CATALOGS?=schema/xhtml1/catalog.xml
XMLLINT?=SGML_CATALOG_FILES="${CATALOGS}" xmllint --catalogs --nonet
XSLTPROC?=STML_CATALOG_FILES="${CATALOGS}" xsltproc --catalogs --nonet

SOURCE_IMGS=$(wildcard source/images/*.png source/images/*.jpg)
SIMPLE_IMGS=$(patsubst source/images/%,simple/images/%,${SOURCE_IMGS})

SOURCE_HTML=$(wildcard source/*.html)
SIMPLE_HTML=$(patsubst source/%,simple/%,${SOURCE_HTML})

SIMPLE_OUT=output/drm-simple-a5.pdf output/drm-simple-a4.pdf

# extract section order from rewrite map
ORDERED_NAMES=Cover $(shell awk -f tools/order.awk source/rewrite-map.txt)

# lists of html files in source and simple form
ORDERED_SOURCE_HTML=$(patsubst %,source/%.html,${ORDERED_NAMES})
ORDERED_HTML=$(patsubst %,simple/%.html,${ORDERED_NAMES})

# default target
default: ${SIMPLE_OUT}

# XML linting
xmllint: ${SOURCE_HTML} ${SIMPLE_HTML}
	${XMLLINT} --noout --dtdattr $^
.PHONY: xmllint

# create output directory
output:
	mkdir -p output

# generate postscript from html
output/drm-simple-a4.ps: config/drm-simple-a4.rc output ${ORDERED_HTML} ${SIMPLE_IMGS}
	html2ps -e iso-8859-1 -f config/drm-simple-a4.rc -o $@ ${ORDERED_HTML}
output/drm-simple-a5.ps: config/drm-simple-a5.rc output ${ORDERED_HTML} ${SIMPLE_IMGS}
	html2ps -e iso-8859-1 -f config/drm-simple-a5.rc -o $@ ${ORDERED_HTML}

# generate a pdf from the postscript
output/drm-simple-a4.pdf: output/drm-simple-a4.ps
	ps2pdf -sPAPERSIZE=a4 $< $@
output/drm-simple-a5.pdf: output/drm-simple-a5.ps
	ps2pdf -sPAPERSIZE=a5 $< $@

# create simple directory
simple:
	mkdir -p simple

# create images directory
simple/images: simple
	mkdir -p simple/images

# link styles
simple/styles: source/styles simple
	ln -s ../source/styles simple/styles

# simplify the html documents
simple/%.html: source/%.html tools/simple.xsl simple
	${XSLTPROC} --html --encoding utf-8 -o $@ tools/simple.xsl $<

# flatten all png images so that the background is white
simple/images/%.png: source/images/%.png simple/images
	convert $< -background white -alpha remove -alpha off $@

# the book cover is jpeg - copy it over
simple/images/%.jpg: source/images/%.jpg simple/images
	cp $< $@

# cleanup rule
clean:
	rm -rf output simple
.PHONY: clean
