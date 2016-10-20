OCAMLBUILD_FLAGS =
OCAMLBUILD_FLAGS += -use-ocamlfind

LIB = fcomb

.PHONY: clean install lib lib-byte lib-native test uninstall utop

lib: lib-byte lib-native

lib-byte:
	ocamlbuild ${OCAMLBUILD_FLAGS} ${LIB}.cma

lib-native:
	ocamlbuild ${OCAMLBUILD_FLAGS} ${LIB}.cmxa

clean:
	ocamlbuild ${OCAMLBUILD_FLAGS} -clean

test: fcomb_print_tests.byte fcomb_scan_tests.byte
	@for test in $^; do	\
		echo ==== $$test ====;	\
		./$$test --slow 5;	\
	done

utop: lib-byte
	utop -I _build -safe-string

install: lib
	ocamlfind install ${LIB}	\
		*.mli	\
		META	\
		_build/*.a	\
		_build/*.cma	\
		_build/*.cmi	\
		_build/*.cmx	\
		_build/*.cmxa

uninstall:
	ocamlfind remove ${LIB}


%.byte: %.ml
	ocamlbuild ${OCAMLBUILD_FLAGS} $@

%.d.byte: %.ml
	ocamlbuild ${OCAMLBUILD_FLAGS} $@

%.native: %.ml
	ocamlbuild ${OCAMLBUILD_FLAGS} $@

%_tests.ml: %.ml
	qtest -o $@ extract $<
