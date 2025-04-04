module NoteDisplay (
    input wire clk,           // 100 MHz system clock
    input wire reset,         // Reset signal
    input wire [7:0] octave,  // 8-bit octave input
    output wire hsync,        // VGA horizontal sync
    output wire vsync,        // VGA vertical sync
    output wire [2:0] rgb     // VGA 3-bit color output
);

    wire clk_vga;             // 12.5 MHz VGA pixel clock
    wire [9:0] pixel_x, pixel_y;
    wire [11:0] sprite_addr;  // Address for sprite memory
    wire sprite_pixel;        // Pixel data from sprite memory

    // Clock Divider: Generate 12.5 MHz VGA clock
    ClockDivider #(.DIVIDE_BY(8)) clk_div (
        .clk_in(clk),
        .reset(reset),
        .clk_out(clk_vga)
    );

    // VGA Controller: Generates sync and pixel positions
    VGA_Controller vga_ctrl (
        .clk(clk_vga),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );

    // Note Decoder: Maps octave input to a sprite address
    NoteDecoder note_decoder (
        .octave(octave),
        .sprite_addr(sprite_addr)
    );

    // Single-Port RAM: Stores note letter sprites
    SDPMem SDPMem (
        .rd_addr(sprite_addr[8:0]),
        .clk(clk_vga),
        .data_out(sprite_pixel),
        .reset(reset)
    );

    // Sprite Renderer: Draws note letters on VGA screen
    SpriteRenderer sprite_renderer (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .sprite_pixel(sprite_pixel),
        .rgb(rgb)
    );

endmodule
