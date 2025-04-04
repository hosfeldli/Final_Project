module vga_buffer #(
    parameter WIDTH = 240,      // Screen width
    parameter HEIGHT = 240      // Screen height
)(
    input wire clk,             // System clock (100 MHz)
    input wire pixel_clk,       // VGA pixel clock (~6.29 MHz)
    input wire we,              // Write enable for memory
    input wire [15:0] wr_addr,  // Write address
    input wire data_in,         // Data input (1-bit per pixel)
    
    input wire [$clog2(WIDTH*HEIGHT)-1:0] rd_addr,  // Read address from VGA
    output reg vga_pixel,        // Output pixel to VGA
    output wire [15:0] vga_x,    // X coordinate of pixel
    output wire [15:0] vga_y,    // Y coordinate of pixel
    
    // VGA sync and color signals
    input wire hsync,            // Horizontal sync input
    input wire vsync,            // Vertical sync input
    output reg [3:0] red,       // Red color output
    output reg [3:0] green,     // Green color output
    output reg [3:0] blue       // Blue color output
);

    // Memory interface
    reg [0:WIDTH-1] scanline_buffer;  // Stores one row of pixels
    reg [$clog2(WIDTH)-1:0] x_counter = 0;
    reg [$clog2(HEIGHT)-1:0] y_counter = 0;

    // Memory instance (SDP RAM)
    sdp_memory #(
        .WIDTH(WIDTH),
        .HEIGHT(HEIGHT)
    ) frame_memory (
        .clk(clk),
        .we(we),
        .wr_addr(wr_addr),
        .rd_addr(rd_addr),
        .data_in(data_in),
        .data_out(scanline_buffer[x_counter])  // Read data into buffer
    );

    // Load scanline on new row
    always @(posedge clk) begin
        if (x_counter == WIDTH - 1) begin
            x_counter <= 0;
            if (y_counter < HEIGHT - 1)
                y_counter <= y_counter + 1;
            else
                y_counter <= 0;
        end else begin
            x_counter <= x_counter + 1;
        end
    end

    // Output pixel at VGA clock speed
    always @(posedge pixel_clk) begin
        vga_pixel <= scanline_buffer[x_counter];
        // Assign the monochrome color to all RGB channels
        red   <= {4{vga_pixel}};
        green <= {4{vga_pixel}};
        blue  <= {4{vga_pixel}};
    end

    assign vga_x = x_counter;
    assign vga_y = y_counter;

endmodule
