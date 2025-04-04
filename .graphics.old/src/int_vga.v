module int_vga (
    input wire clk,           // Clock input (25 MHz)
    input wire reset,         // Reset input
    output wire hsync,        // Horizontal sync output
    output wire vsync,        // Vertical sync output
    output reg [3:0] red,     // Red color output
    output reg [3:0] green,   // Green color output
    output reg [3:0] blue,    // Blue color output
    input wire [3:0] in_red,  // External red input
    input wire [3:0] in_green,// External green input
    input wire [3:0] in_blue  // External blue input
);

    // VGA 240p (NTSC-like) resolution timing parameters
    parameter H_DISPLAY = 320;  // Active horizontal pixels
    parameter H_FRONT = 8;      // Horizontal front porch
    parameter H_SYNC = 48;      // Horizontal sync pulse width
    parameter H_BACK = 24;      // Horizontal back porch
    parameter V_DISPLAY = 240;  // Active vertical pixels
    parameter V_FRONT = 2;      // Vertical front porch
    parameter V_SYNC = 2;       // Vertical sync pulse width
    parameter V_BACK = 15;      // Vertical back porch

    // Total screen size including blanking
    parameter H_TOTAL = H_DISPLAY + H_FRONT + H_SYNC + H_BACK;  // 400 pixels
    parameter V_TOTAL = V_DISPLAY + V_FRONT + V_SYNC + V_BACK;  // 259 lines

    // Counters
    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;

    // Horizontal sync generation
    always @(posedge clk or posedge reset) begin
        if (reset)
            h_count <= 0;
        else if (h_count == H_TOTAL - 1)
            h_count <= 0;
        else
            h_count <= h_count + 1;
    end

    // Vertical sync generation
    always @(posedge clk or posedge reset) begin
        if (reset)
            v_count <= 0;
        else if (h_count == H_TOTAL - 1) begin
            if (v_count == V_TOTAL - 1)
                v_count <= 0;
            else
                v_count <= v_count + 1;
        end
    end

    // Sync signals (active low)
    assign hsync = (h_count >= (H_DISPLAY + H_FRONT) && h_count < (H_DISPLAY + H_FRONT + H_SYNC)) ? 0 : 1;
    assign vsync = (v_count >= (V_DISPLAY + V_FRONT) && v_count < (V_DISPLAY + V_FRONT + V_SYNC)) ? 0 : 1;

    // Use testbench-controlled inputs for colors
    always @(posedge clk) begin
        if (h_count < H_DISPLAY && v_count < V_DISPLAY) begin
            red   <= in_red;
            green <= in_green;
            blue  <= in_blue;
        end else begin
            red   <= 4'b0000;
            green <= 4'b0000;
            blue  <= 4'b0000;
        end
    end

endmodule
