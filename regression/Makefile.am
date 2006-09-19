TESTS = test001 test002

TESTS_ENVIRONMENT = $(srcdir)/test.sh

include $(top_srcdir)/m4/Makefile.am.vars

PARSER_INCLUDES += -I $(top_srcdir)/camlp4
MODULE_INCLUDES += -I $(top_srcdir)/src

EXTRA_CMA += $(PACKAGE).cma

# OCaml parser call with flags
AM_P4FLAGS = -pp "$(CAMLP4O) $(PARSER_INCLUDES) pr_o.cmo pa_checked.cmo pa_log.cmo $(LOG)"

TARGET = 

CLEAN_EXTRA += $(addsuffix .cmi, $(TESTS)) $(addsuffix .cmo, $(TESTS))
CLEAN_EXTRA += $(addsuffix $(EXEEXT), $(TESTS))
CLEAN_EXTRA += *.diff *.log

include $(top_srcdir)/m4/Makefile.am.targets

# do not call ocamldep
.depend:
	touch .depend

# Rules to build tests
%: %.ml
	$(OCAMLC) $(BFLAGS) $(EXTRA_CMA) $(P4FLAGS) -o $@$(EXEEXT) $<

include $(top_srcdir)/m4/Makefile.am.rules
