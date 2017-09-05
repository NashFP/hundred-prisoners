all: how_long prisoner

how_long: how_long.ml
	ocamlopt -o how_long how_long.ml

prisoner: Prisoner.ml run_tests.ml
	ocamlopt -c Prisoner.mli Prisoner.ml
	ocamlopt -o prisoner Prisoner.cmx run_tests.ml

clean:
	rm *.o *.cmi *.cmx
