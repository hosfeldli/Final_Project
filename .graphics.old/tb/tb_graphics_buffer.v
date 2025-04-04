module tb_graphics_buffer;

    // Clock and reset signals
    reg clk;                   // 100 MHz clock
    reg reset;                 // Reset signal
    reg pixel_clk;             // 6.29 MHz pixel clock

    // VGA signals
    wire hsync, vsync;
    wire [3:0] red, green, blue;
    
    // Memory and buffer interface signals
    reg [15:0] wr_addr;        // Write address for memory
    reg we;                    // Write enable for memory
    reg data_in;               // Data input (black = 0)
    wire [15:0] rd_addr;       // Read address from VGA
    wire vga_pixel;            // VGA pixel data output

    // Instantiating the memory_graphics and vga_buffer modules
    sdp_memory memory_inst (
        .clk(clk),
        .we(we),
        .wr_addr(wr_addr),  // ✅ Match with sdp_memory module
        .rd_addr(rd_addr),  // ✅ Match with sdp_memory module
        .data_in(data_in),
        .data_out(data_out)
    );


    vga_buffer #(
        .WIDTH(240),
        .HEIGHT(240)
    ) buffer_inst (
        .clk(clk),
        .pixel_clk(pixel_clk),
        .we(we),
        .wr_addr(wr_addr),
        .data_in(data_in),
        .rd_addr(rd_addr),
        .vga_pixel(vga_pixel),
        .vga_x(),
        .vga_y(),
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue)
    );

    int_vga vga_inst (
        .clk(clk),                 // 25 MHz clock input for VGA timing
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue),
        .in_red(4'b0000),          // Black
        .in_green(4'b0000),        // Black
        .in_blue(4'b0000)          // Black
    );

    // Clock generation (100 MHz and 6.29 MHz for pixel clock)
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    always begin
        pixel_clk = 0; #159;  // 6.29 MHz pixel clock
        pixel_clk = 1; #159;
    end

    // Testbench initialization
    initial begin
        // Initialize signals
        reset = 1;
        we = 0;
        wr_addr = 16'b0;
        data_in = 0;

        // Wait for some time and then deassert reset
        #20;
        reset = 0;

        // Write black (0) to all memory locations (240x240 = 57600 pixels)
        we = 1;
        for (wr_addr = 0; wr_addr < 57600; wr_addr = wr_addr + 1) begin
            data_in = 0; // Write black pixel (0)
            #10;          // Simulate a delay between writes
        end

        // Turn off write enable after writing all data
        we = 0;

        // Simulate for some time to let VGA output data
        #1000;

        // End simulation
        $finish;
    end

    // Monitoring outputs
    initial begin
        $monitor("At time %t, vga_pixel = %b, red = %b, green = %b, blue = %b", $time, vga_pixel, red, green, blue);
    end

endmodule
