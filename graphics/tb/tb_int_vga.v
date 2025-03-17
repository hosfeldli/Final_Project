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

        // Run simulation for some frames
        #2000000;  // Adjust based on how many frames you want

        // Close file and finish simulation
        $fclose(file);
        $finish;
    end

    // Capture visible pixel data
    always @(posedge clk) begin
        if (hsync == 1 && vsync == 1) begin  // Only log visible pixels
            $fwrite(file, "%d %d %d %d %d\n", uut.h_count, uut.v_count, 
                    red * 17, green * 17, blue * 17);  // Scale 4-bit color to 8-bit
        end
    end

endmodule
