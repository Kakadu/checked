TESTS = test001

TESTS_ENVIRONMENT = ./test.sh

clean-am:
	rm -f $(addsuffix .cmo, $(TESTS)) $(addsuffix .cmi, $(TESTS))
	rm -f *.log

BFLAGS = -w p -I ..
EXTRA_CMA = str.cma ../common.cma

$(TESTS): $(addsuffix .cmo, $(TESTS))
	$(OCAMLC) $(BFLAGS) -o $@ $(EXTRA_CMA) $<

%.cmo: %.ml
	$(OCAMLC) -c $(BFLAGS) $<
