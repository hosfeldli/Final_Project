module NoteDecoder (
    input wire [7:0] octave,
    output reg [11:0] sprite_addr 
);

    always @(*) begin
        case (octave[3:0])
            4'd0: sprite_addr = 12'h000; // C
            4'd1: sprite_addr = 12'h010; // D
            4'd2: sprite_addr = 12'h020; // E
            4'd3: sprite_addr = 12'h030; // F
            4'd4: sprite_addr = 12'h040; // G
            4'd5: sprite_addr = 12'h050; // A
            4'd6: sprite_addr = 12'h060; // B
            default: sprite_addr = 12'h000; // Default to C
        endcase
    end

endmodule
