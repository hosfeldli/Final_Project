module int_vga (
    input wire clk,           // Clock input
    input wire reset,         // Reset input
    output wire hsync,        // Horizontal sync output
    output wire vsync,        // Vertical sync output
    output wire [3:0] red,    // Red color output
    output wire [3:0] green,  // Green color output
    output wire [3:0] blue    // Blue color output
);

    // VGA 240p resolution parameters
    parameter H_DISPLAY = 320;  // Horizontal display width
    parameter H_FRONT = 16;     // Horizontal front porch
    parameter H_SYNC = 96;      // Horizontal sync pulse
    parameter H_BACK = 48;      // Horizontal back porch
    parameter V_DISPLAY = 240;  // Vertical display height
    parameter V_FRONT = 10;     // Vertical front porch
    parameter V_SYNC = 2;       // Vertical sync pulse
    parameter V_BACK = 33;      // Vertical back porch

    // Calculated parameters
    parameter H_TOTAL = H_DISPLAY + H_FRONT + H_SYNC + H_BACK;
    parameter V_TOTAL = V_DISPLAY + V_FRONT + V_SYNC + V_BACK;

    reg [9:0] h_count = 0;  // Horizontal counter
    reg [9:0] v_count = 0;  // Vertical counter

    // Horizontal sync generation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_count <= 0;
        end else if (h_count == H_TOTAL - 1) begin
            h_count <= 0;
        end else begin
            h_count <= h_count + 1;
        end
    end

    // Vertical sync generation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            v_count <= 0;
        end else if (h_count == H_TOTAL - 1) begin
            if (v_count == V_TOTAL - 1) begin
                v_count <= 0;
            end else begin
                v_count <= v_count + 1;
            end
        end
    end

    // Generate sync signals
    assign hsync = (h_count >= (H_DISPLAY + H_FRONT) && h_count < (H_DISPLAY + H_FRONT + H_SYNC)) ? 0 : 1;
    assign vsync = (v_count >= (V_DISPLAY + V_FRONT) && v_count < (V_DISPLAY + V_FRONT + V_SYNC)) ? 0 : 1;

    // Generate color signals (simple test pattern)
    assign red = (h_count < H_DISPLAY && v_count < V_DISPLAY) ? 4'b1111 : 4'b0000;
    assign green = (h_count < H_DISPLAY && v_count < V_DISPLAY) ? 4'b0000 : 4'b0000;
    assign blue = (h_count < H_DISPLAY && v_count < V_DISPLAY) ? 4'b0000 : 4'b0000;

endmodule