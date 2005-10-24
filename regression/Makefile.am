# OCaml parser flags
P4FLAGS := -pp "$(CAMLP4O) $(PARSER_INCLUDES) pr_o.cmo pa_log.cmo $(LOG)"

# bytcode compiling flags
BFLAGS = -w p $(MODULE_INCLUDES) $(P4FLAGS) $(DEBUG)

TESTS = test001

TESTS_ENVIRONMENT = ./test.sh

clean-am:
	rm -f $(addsuffix .cmo, $(TESTS)) $(addsuffix .cmi, $(TESTS))
	rm -f *.log

$(TESTS): $(addsuffix .cmo, $(TESTS))
	$(OCAMLC) $(BFLAGS) -o $@ $(EXTRA_CMA) ../checked.cma $<

%.cmo: %.ml
	$(OCAMLC) -c -I .. $(BFLAGS) $<
