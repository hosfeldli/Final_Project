module sdp_memory #(
    parameter WIDTH = 240,      // Screen width
    parameter HEIGHT = 240      // Screen height
)(
    input wire clk,                     // System clock
    input wire we,                      // Write enable
    input wire [$clog2(WIDTH*HEIGHT)-1:0] wr_addr,  // Write address
    input wire [$clog2(WIDTH*HEIGHT)-1:0] rd_addr,  // Read address
    input wire data_in,                  // Data input (1-bit per pixel)
    output reg data_out                   // Data output (1-bit per pixel)
);

    // Memory storage (1 bit per pixel)
    reg memory [0:WIDTH*HEIGHT-1];  

    // Write operation
    always @(posedge clk) begin
        if (we) begin
            memory[wr_addr] <= data_in;
        end
    end

    // Read operation
    always @(posedge clk) begin
        data_out <= memory[rd_addr];
    end

endmodule
