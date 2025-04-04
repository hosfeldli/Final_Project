# Compiler and Simulation Tools
VLOG = iverilog
VVP = vvp
WAVE = gtkwave

# Directories
SRC_DIR = src
BIN_DIR = bin

# Project Files
SRC = $(wildcard $(SRC_DIR)/*.v)
TB = tb/tb_NoteDisplay.v
OUT = $(BIN_DIR)/simv
WAVE_FILE = $(BIN_DIR)/waveform.vcd

# Compile Verilog files
compile: $(BIN_DIR)
	$(VLOG) -o $(OUT) $(SRC) $(TB)

# Run simulation
run: compile
	$(VVP) $(OUT)

# Open waveform in GTKWave
wave:
	$(WAVE) $(WAVE_FILE) &

# Clean up generated files
clean:
	rm -rf $(BIN_DIR)
