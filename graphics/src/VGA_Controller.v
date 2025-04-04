module VGA_Controller (
    input wire clk,
    input wire reset,
    output reg hsync,
    output reg vsync,
    output reg [9:0] pixel_x,
    output reg [9:0] pixel_y
);

    // VGA 320x240 Timings
    localparam H_ACTIVE = 320;
    localparam H_FRONT_PORCH = 8;
    localparam H_SYNC_PULSE = 96;
    localparam H_BACK_PORCH = 40;
    localparam H_TOTAL = H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;

    localparam V_ACTIVE = 240;
    localparam V_FRONT_PORCH = 2;
    localparam V_SYNC_PULSE = 2;
    localparam V_BACK_PORCH = 25;
    localparam V_TOTAL = V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count == H_TOTAL - 1) begin
                h_count <= 0;
                if (v_count == V_TOTAL - 1) begin
                    v_count <= 0;
                end else begin
                    v_count <= v_count + 1;
                end
            end else begin
                h_count <= h_count + 1;
            end
        end
    end

    always @(posedge clk) begin
        if (h_count < H_ACTIVE)
            pixel_x <= h_count;
        else
            pixel_x <= 0;

        if (v_count < V_ACTIVE)
            pixel_y <= v_count;
        else
            pixel_y <= 0;

        if (h_count >= (H_ACTIVE + H_FRONT_PORCH) && h_count < (H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE))
            hsync <= 0;
        else
            hsync <= 1;

        if (v_count >= (V_ACTIVE + V_FRONT_PORCH) && v_count < (V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE))
            vsync <= 0;
        else
            vsync <= 1;
    end


endmodule
