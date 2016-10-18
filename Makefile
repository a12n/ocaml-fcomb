OCAMLBUILD_FLAGS =
OCAMLBUILD_FLAGS += -use-ocamlfind

LIB = fcomb

.PHONY: clean install lib lib-byte lib-native uninstall utop

lib: lib-byte lib-native

lib-byte:
	ocamlbuild ${OCAMLBUILD_FLAGS} ${LIB}.cma

lib-native:
	ocamlbuild ${OCAMLBUILD_FLAGS} ${LIB}.cmxa

clean:
	ocamlbuild ${OCAMLBUILD_FLAGS} -clean

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
