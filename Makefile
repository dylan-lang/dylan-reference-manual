
# XML catalog for all tools
CATALOGS?=schema/xhtml1/catalog.xml
# common command line for xmllint
XMLLINT?=SGML_CATALOG_FILES=${CATALOGS} xmllint --catalogs --nonet
# common command line for xsltproc
XSLTPROC?=STML_CATALOG_FILES=${CATALOGS} xsltproc --catalogs --nonet

# list of all source files
SOURCE_HTML=$(wildcard source/*.html)
# list of all source images
SOURCE_IMGS=$(wildcard source/images/*.png source/images/*.jpg)
# list of all fixed images
SIMPLE_IMGS=$(patsubst source/images/%,simple/images/%,${SOURCE_IMGS})
# list of all output files
SIMPLE_OUT=output/drm-simple-a5.pdf output/drm-simple-a4.pdf
# stylesheet for simple html output
SIMPLE_XSL=stylesheet/simple.xsl

# extract section order from rewrite map
ORDERED_NAMES=Cover $(shell awk -f tools/order.awk source/rewrite-map.txt)

# lists of html files in source and simple form
ORDERED_SOURCE_HTML=$(patsubst %,source/%.html,${ORDERED_NAMES})
ORDERED_SIMPLE_HTML=$(patsubst %,simple/%.html,${ORDERED_NAMES})

# query the map for the various docbook section types
CHAPTER_NAMES=$(shell tools/getsections.sh chapter)
APPENDIX_NAMES=$(shell tools/getsections.sh appendix)
SECTION_NAMES=$(shell tools/getsections.sh section)
SPECIAL_NAMES=Preface Colophon
ALL_NAMES=${CHAPTER_NAMES} ${SECTION_NAMES} ${APPENDIX_NAMES} ${SPECIAL_NAMES}
ORDERED_DBKS=$(patsubst %,docbook/%.dbk,${ALL_NAMES})

# default target
default: ${SIMPLE_OUT}

db: ${ORDERED_DBKS}

# XML linting
xmllint: ${SOURCE_HTML} ${ORDERED_SIMPLE_HTML}
	${XMLLINT} --noout --dtdattr $^
.PHONY: xmllint

# create output directory
output:
	mkdir -p output

# generate postscript from html
output/drm-simple-a4.ps: config/drm-simple-a4.rc output ${ORDERED_SIMPLE_HTML} ${SIMPLE_IMGS}
	html2ps -e iso-8859-1 -f config/drm-simple-a4.rc -o $@ ${ORDERED_SIMPLE_HTML}
output/drm-simple-a5.ps: config/drm-simple-a5.rc output ${ORDERED_SIMPLE_HTML} ${SIMPLE_IMGS}
	html2ps -e iso-8859-1 -f config/drm-simple-a5.rc -o $@ ${ORDERED_SIMPLE_HTML}

# generate a pdf from the postscript
output/drm-simple-a4.pdf: output/drm-simple-a4.ps
	ps2pdf -sPAPERSIZE=a4 $< $@
output/drm-simple-a5.pdf: output/drm-simple-a5.ps
	ps2pdf -sPAPERSIZE=a5 $< $@

# create simple directory
docbook:
	mkdir -p docbook

# simplify the html documents
docbook/%.dbk: source/%.html stylesheet/docbook.xsl docbook
	${XSLTPROC} --encoding utf-8 --html \
		--stringparam toplevel "$$(tools/getclass.sh $$(basename $@ .dbk))" \
		--stringparam children "$$(tools/getchildren.sh $$(basename $@ .dbk) | sed 's/\(.*\)/\1.dbk/' | tr '\n' ' ')" \
		-o $@ stylesheet/docbook.xsl \
		$<

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
simple/%.html: source/%.html ${SIMPLE_XSL} simple
	${XSLTPROC} --html --encoding utf-8 -o $@ ${SIMPLE_XSL} $<

# flatten all png images so that the background is white
simple/images/%.png: source/images/%.png simple/images
	convert $< -background white -alpha remove -alpha off $@

# the book cover is jpeg - copy it over
simple/images/%.jpg: source/images/%.jpg simple/images
	cp $< $@

# cleanup rule
clean:
	rm -rf output docbook simple
.PHONY: clean
