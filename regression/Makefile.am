TESTS = test001 test002

TESTS_ENVIRONMENT = $(srcdir)/test.sh

#PARSER_INCLUDES += -I $(top_srcdir)/src
MODULE_INCLUDES += -I $(top_srcdir)/src

EXTRA_CMA += $(PACKAGE).cma

# OCaml parser call with flags
AM_P4FLAGS := -pp "$(CAMLP4O) $(PARSER_INCLUDES) pr_o.cmo ../camlp4/pa_checked.cmo pa_log.cmo $(LOG)"
#AM_P4FLAGS = -pp "$(CAMLP4R) $(PARSER_INCLUDES)"

# bytecode compiling flags
AM_BFLAGS = -w p $(MODULE_INCLUDES) $(DEBUG)
# native (optimized) compiling flags
AM_OFLAGS = -w p $(MODULE_INCLUDES) $(DEBUG)

clean-am:
	rm -f $(addsuffix .cmi, $(TESTS)) $(addsuffix .cmo, $(TESTS))
	rm -f $(addsuffix $(EXEEXT), $(TESTS))
	rm -f *.diff *.log

test001: test001.ml
	$(OCAMLC) $(BFLAGS) $(P4FLAGS) $(EXTRA_CMA) -o $@$(EXEEXT) $<

test002: test002.ml
	$(OCAMLC) $(BFLAGS) $(P4FLAGS) $(EXTRA_CMA) -o $@$(EXEEXT) $<
