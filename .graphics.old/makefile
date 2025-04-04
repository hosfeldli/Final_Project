# Makefile for building the VGA interface project

# Compiler and flags
CC = iverilog
CFLAGS = -g2012

# Source files
SRC = ./tb/tb_graphics_buffer.v ./src/int_vga.v ./src/sdp_memory.v ./src/vga_buffer.v

# Output file
OUT = ./bin/tb_graphics_buffer

# VCD file for waveform
VCD = ./bin/tb_graphics_buffer.vcd

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

# View the simulation results using a Python script (optional, if you have one)
view: $(OUT)
	python3 ./tb/tb_visualize.py

# Clean up generated files
clean:
	rm -rf ./bin/*

.PHONY: all run wave view clean
