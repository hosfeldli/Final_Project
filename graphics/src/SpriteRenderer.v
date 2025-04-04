module SpriteRenderer (
    input wire [9:0] pixel_x,
    input wire [9:0] pixel_y,
    input wire sprite_pixel,
    output reg [2:0] rgb
);

    always @(*) begin
        if (pixel_x >= 140 && pixel_x < 148 &&
            pixel_y >= 100 && pixel_y < 108) begin
            rgb = (sprite_pixel) ? 3'b111 : 3'b000;
        end else begin
            rgb = 3'b000;
        end
    end

endmodule
