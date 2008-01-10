# define macros that creates temporary files
if MINGW32
    MKTEMP=$(top_srcdir)/config/mktemp.sh
else
    MKTEMP=mktemp
endif

PARSER_INCLUDES += -I +camlp4

.PHONY: doc
# check if style.css already exists to avoid everytime generation
doc: html/style.css

# use different preprocessors for OCaml and CamlP4 sources
html/style.css:
	test -d html || mkdir html
	dump1=`$(MKTEMP) ocamldoc.XXXXXX` && \
	dump2=`$(MKTEMP) ocamldoc.XXXXXX` && \
	$(OCAMLDOC) $(MODULE_INCLUDES) $(P4FLAGS) -rectypes -dump "$$dump1" \
	    -pp "$(CAMLP4O) $(PARSER_INCLUDES) pa_log.cmo $(LOG)" \
	    -I $(top_srcdir)/src -I $(top_srcdir)/camlp4 \
	    $(top_srcdir)/src/*.mli $(top_srcdir)/src/*.ml && \
	$(OCAMLDOC) -I +camlp4 $(MODULE_INCLUDES) $(P4FLAGS) -rectypes -dump "$$dump2" \
	    -pp "$(CAMLP4R) $(PARSER_INCLUDES) pr_o.cmo" \
	    -I $(top_srcdir)/src -I $(top_srcdir)/camlp4 \
	    $(top_srcdir)/camlp4/*.ml && \
	$(OCAMLDOC) -load "$$dump1" -load "$$dump2" -d html -html && \
	rm -f "$$dump1" "$$dump2"

# default clean
clean-am:
	rm -fR html/*.html html/*.css

