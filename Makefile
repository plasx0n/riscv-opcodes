EXTENSIONS := "rv*" "unratified/rv*"
ISASIM_H := ../riscv-isa-sim/riscv/encoding.h
PK_H := ../riscv-pk/machine/encoding.h
ENV_H := ../riscv-tests/env/encoding.h
OPENOCD_H := ../riscv-openocd/src/target/riscv/encoding.h
INSTALL_HEADER_FILES := $(ISASIM_H) $(PK_H) $(ENV_H) $(OPENOCD_H)

default: everything

.PHONY : everything
everything:
	@./parse.py -c -go -chisel -sverilog -rust -latex -spinalhdl $(EXTENSIONS)

.PHONY : encoding.out.h
encoding.out.h:
	@./parse.py -c $(EXTENSIONS)

.PHONY : custom
custom:
	@./parse.py -custom $(EXTENSIONS)
 
.PHONY : custom_full
custom_full:
	@./parse.py -custom 'rv_polar' 'rv_ldpc' 'rv_ldpcnb' 'rv_turbo'
	# riscv64-unknown-elf-gcc insn_lib_test.c
	# rm a.out

.PHONY : inst.chisel
inst.chisel:
	@./parse.py -chisel $(EXTENSIONS)

.PHONY : inst.go
inst.go:
	@./parse.py -go $(EXTENSIONS)

.PHONY : latex
latex:
	@./parse.py -latex $(EXTENSIONS)

.PHONY : inst.sverilog
inst.sverilog:
	@./parse.py -sverilog $(EXTENSIONS)

.PHONY : inst.rs
inst.rs:
	@./parse.py -rust $(EXTENSIONS)

.PHONY : clean
clean:
	rm -f inst* priv-instr-table.tex encoding.out.h riscv-opc.out.c insn_lib_test.c spike_encoding

.PHONY : install
install: everything
	set -e; for FILE in $(INSTALL_HEADER_FILES); do cp -f encoding.out.h $$FILE; done

.PHONY: instr-table.tex
instr-table.tex: latex

.PHONY: priv-instr-table.tex
priv-instr-table.tex: latex

.PHONY: inst.spinalhdl
inst.spinalhdl:
	@./parse.py -spinalhdl $(EXTENSIONS)
