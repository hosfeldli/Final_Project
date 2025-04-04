module testbench;
    // Testbench signals
    reg clk; // 100 MHz clock
    reg reset; // Reset signal
    reg [7:0] octave; // 8-bit octave input
    wire hsync; // VGA horizontal sync
    wire vsync; // VGA vertical sync
    wire [2:0] rgb; // VGA color output (3 bits for monochrome)
    
    integer file;

    // Instantiate the NoteDisplay (Top-Level) module
    NoteDisplay uut (
        .clk(clk),
        .reset(reset),
        .octave(octave),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );

    // Generate the 100 MHz clock
    initial begin
        clk = 0;
        repeat (1_000_000) begin
            #5 clk = ~clk; // Toggle clock every 5 ns (100 MHz)
        end
    end

    // Open a file to store the simulation results
    initial begin
        file = $fopen("./bin/simulation_data.txt", "w");
        if (file) $fdisplay(file, "Time,hsync,vsync,rgb");
    end

    // Capture and log data at each positive clock edge
    always @(posedge clk) begin
        if (file) begin
            $fdisplay(file, "%0t,%b,%b,%b", $time, hsync, vsync, rgb);
        end
    end

    // Stop the simulation after some time
    initial begin
        reset = 0;
        octave = 8'b00000000; // Start with note C (octave 0)
        
        // Apply reset (hold for 5 cycles)
        reset = 1;
        #50 reset = 0;

        // Test different octave values (simulate note changes)
        #100 octave = 8'b00000001; // D

        // Wait and stop
        #1_000_000 $stop;
    end

    // Close the file when done
    initial begin
        #1_000_010 if (file) $fclose(file);
    end
endmodule