# Makefile for building the VGA interface project

# Compiler and flags
CC = iverilog
CFLAGS = -g2012

# Source files
SRC = ./tb/tb_int_vga.v ./src/int_vga.v

# Output file
OUT = ./bin/tb_int_vga

# VCD file for waveform
VCD = ./bin/tb_int_vga.vcd

# Default target
all: $(OUT)

# Compile the Verilog files
$(OUT): $(SRC)
	$(CC) $(CFLAGS) -o $(OUT) $(SRC)

# Run the simulation
run: $(OUT)
	vvp $(OUT)

# View the waveform using GTKWave
wave: $(VCD)
	gtkwave $(VCD)

view: $(OUT)
	python3 ./tb/tb_visualize.py

# Clean up generated files
clean:
	rm -rf ./bin/*

.PHONY: all run view clean
