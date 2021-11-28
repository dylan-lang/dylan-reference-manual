
SOURCE_IMGS=$(wildcard source/images/*.png source/images/*.jpg)
SIMPLE_IMGS=$(patsubst source/images/%,simple/images/%,${SOURCE_IMGS})

SOURCE_HTML=$(wildcard source/*.html)
SIMPLE_HTML=$(patsubst source/%,simple/%,${SOURCE_HTML})

SIMPLE=simple/images simple/styles ${SIMPLE_HTML}

ORDERED_HTML = \
simple/Cover.html \
simple/Title.html \
simple/Copyrights.html \
simple/Contents.html \
simple/Preface.html \
simple/Introduction.html \
simple/Background_and_Goals.html \
simple/Language_Overview.html \
simple/Manual_Notation.html \
 \
simple/Syntax.html \
simple/Syntax_Overview.html \
simple/Libraries_and_Modules.html \
simple/Bindings.html \
simple/Bodies.html \
simple/Definitions.html \
simple/Macros_Syntax.html \
simple/Local_Declarations.html \
simple/Expressions.html \
simple/Statements.html \
simple/Parameter_Lists_Syntax.html \
simple/Lexical_Syntax.html \
simple/Special_Treatment_of_Names.html \
simple/Top-Level_Definitions.html \
simple/Dylan_Interchange_Format.html \
simple/Naming_Conventions.html \
simple/Program_Structure.html \
simple/Modules.html \
simple/Libraries.html \
 \
simple/Program_Control.html \
simple/Program_Control_Overview.html \
simple/Function_Calls.html \
simple/Operators.html \
simple/Assignment.html \
simple/Conditional_Execution.html \
simple/Iteration.html \
simple/Nonlocal_Exits_and_Cleanup_Clauses.html \
simple/Multiple_Values.html \
simple/Order_of_Execution.html \
 \
simple/Types_and_Classes.html \
simple/Types_and_Classes_Overview.html \
simple/Type_Protocol.html \
simple/Classes.html \
simple/Slots.html \
simple/Instance_Creation_and_Initialization.html \
simple/Singletons.html \
simple/Union_Types.html \
simple/Limited_Types.html \
 \
simple/Functions.html \
simple/Functions_Overview.html \
simple/Parameter_Lists.html \
simple/Method_Dispatch.html \
simple/Operations_on_Functions.html \
 \
simple/Conditions.html \
simple/Conditions_Background.html \
simple/Conditions_Overview.html \
simple/Signalers_Conditions_and_Handlers.html \
simple/Exception_Handling.html \
simple/Condition_Messages.html \
simple/Introspective_Operations_on_Conditions.html \
 \
simple/Collections.html \
simple/Collections_Overview.html \
simple/Collection_Keys.html \
simple/Iteration_Stability_and_Natural_Order.html \
simple/Mutability.html \
simple/Collection_Alteration_and_Allocation.html \
simple/Collection_Alignment.html \
simple/Defining_a_New_Collection_Class.html \
simple/Tables.html \
simple/Element_Types.html \
simple/Limited_Collection_Types.html \
 \
simple/Sealing.html \
simple/Sealing_Overview.html \
simple/Explicitly_Known_Objects.html \
simple/Declaring_Characteristics_of_Classes.html \
simple/Declaring_Characteristics_of_Generic_Functions.html \
simple/Define_Sealed_Domain.html \
 \
simple/Macros.html \
simple/Macros_Overview.html \
simple/Extensible_Grammar.html \
simple/Macro_Names.html \
simple/Rewrite_Rules.html \
simple/Patterns.html \
simple/Pattern_Variable_Constraints.html \
simple/Templates.html \
simple/Auxiliary_Rule_Sets.html \
simple/Hygiene.html \
simple/Rewrite_Rule_Examples.html \
 \
simple/Built-In_Classes.html \
simple/Built-In_Classes_Overview.html \
simple/Object_Classes.html \
simple/Type_Classes.html \
simple/Simple_Object_Classes.html \
simple/Number_Classes.html \
simple/Collection_Classes.html \
simple/Function_Classes.html \
simple/Condition_Classes.html \
 \
simple/Built-In_Functions.html \
simple/Built-In_Functions_Overview.html \
simple/Constructing_and_Initializing_Instances.html \
simple/Equality_and_Comparison.html \
simple/Arithmetic_Operations.html \
simple/Coercing_and_Copying_Objects.html \
simple/Collection_Operations.html \
simple/Reflective_Operations_on_Types.html \
simple/Functional_Operations.html \
simple/Function_Application.html \
simple/Reflective_Operations_on_Functions.html \
simple/Operations_on_Conditions.html \
 \
simple/Other_Built-In_Objects.html \
simple/Other_Built-In_Objects_Defined.html \
 \
simple/Built-In_Macros_and_Special_Definitions.html \
simple/Built-In_Macros_and_Special_Definitions_Overview.html \
simple/Definition_Macros.html \
simple/Local_Declaration_Macros.html \
simple/Statement_Macros.html \
simple/Function_Macros.html \
 \
simple/BNF.html \
simple/Lexical_Grammar.html \
simple/Phrase_Grammar.html \
simple/Exported_Names.html \
simple/Glossary.html \
simple/Index.html \
simple/Colophon.html \
simple/Errata.html


# default target
default: drm-a5.pdf drm-a4.pdf

# XML linting
xmllint: ${SOURCE_HTML}
	SGML_CATALOG_FILES=schema/xhtml1/catalog.xml \
		xmllint --nonet --noout --catalogs --dtdattr $^
.PHONY: xmllint

# generate postscript from html
drm-a4.ps: config/drm-a4.rc simple/images ${ORDERED_HTML} ${SIMPLE_IMGS}
	html2ps -f config/drm-a4.rc -o $@ ${ORDERED_HTML}
drm-a5.ps: config/drm-a5.rc simple/images ${ORDERED_HTML} ${SIMPLE_IMGS}
	html2ps -f config/drm-a5.rc -o $@ ${ORDERED_HTML}

# generate a pdf from the postscript
drm-a4.pdf: drm-a4.ps
	ps2pdf -sPAPERSIZE=a4 $< $@
drm-a5.pdf: drm-a5.ps
	ps2pdf -sPAPERSIZE=a5 $< $@

# directory creation
simple:
	mkdir -p simple

# create image directory
simple/images: simple
	mkdir -p simple/images

# link styles
simple/styles: source/styles simple
	ln -s ../source/styles simple/styles

# process the files to remove headers and footers
	awk -f tools/remove-nav.awk $< > $@
simple/%.html: source/%.html simple

# flatten all png images so that the background is white
simple/images/%.png: source/images/%.png simple/images
	convert $< -background white -alpha remove -alpha off $@

# the book cover is jpeg - copy it over
simple/images/%.jpg: source/images/%.jpg simple/images
	cp $< $@

# cleanup rule
clean:
	rm -f drm-a4.ps drm-a4.pdf drm-a5.ps drm-a5.pdf
	rm -rf simple
.PHONY: clean
