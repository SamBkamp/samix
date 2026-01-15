DEVICE := AT28C256
BIN_FILE := rom.bin
SRC := samux.s screen.s init.s util.s print_stack.s print_splash.s ditdah.s

rom.bin:${SRC}
	vasm -Fbin -dotdir -wdc02 -o $@ $<
install:rom.bin
	minipro -p ${DEVICE} -w ${BIN_FILE} -u


.PHONY: install
