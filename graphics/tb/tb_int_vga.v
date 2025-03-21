`timescale 1ns / 1ps

module tb_int_vga;

    reg clk = 0;
    reg reset = 1;
    wire hsync, vsync;
    wire [3:0] red, green, blue;

    // Instantiate the VGA module
    int_vga uut (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue)
    );

    // Clock generation (25 MHz for 240p VGA)
    always #20 clk = ~clk;  // 25MHz Clock (40ns period)

    integer file;
    
    initial begin
        // Open file to store VGA output
        file = $fopen("./bin/vga_output.txt", "w");
        if (file == 0) begin
            $display("Error: Could not open file!");
            $finish;
        end

        // Enable waveform dump for debugging
        $dumpfile("./bin/tb_int_vga.vcd");
        $dumpvars(0, tb_int_vga);

        // Reset sequence
        #50 reset = 0;

        // Run simulation for enough time to capture a full frame
        #2000000;

        // Close file and finish simulation
        $fclose(file);
        $finish;
    end

    // Variables to determine line positions
    localparam NUM_LINES = 6;
    localparam LINE_SPACING = 240 / (NUM_LINES + 1);  // Even spacing
    integer i;

    // Capture visible pixel data and draw black lines
    always @(posedge clk) begin
        if (hsync == 1 && vsync == 1) begin  // Only log visible pixels
            // Default color: White
            reg [7:0] pixel_r = 255;
            reg [7:0] pixel_g = 255;
            reg [7:0] pixel_b = 255;

            // Draw 6 black horizontal lines
            for (i = 1; i <= NUM_LINES; i = i + 1) begin
                if (uut.v_count == i * LINE_SPACING) begin
                    pixel_r = 0;
                    pixel_g = 0;
                    pixel_b = 0;
                end
            end

            $fwrite(file, "%d %d %d %d %d\n", uut.h_count, uut.v_count, pixel_r, pixel_g, pixel_b);
        end
    end

endmodule
