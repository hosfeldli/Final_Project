
module memory_graphics (
    input wire clk,
    input wire [15:0] addr,  // 16-bit address for larger memory
    input wire we,           // Write enable
    input wire data_in,      // Data input (0 or 1)
    output reg data_out      // Data output (0 or 1)
);

    // Memory array to store enough bits for a 240x240 screen
    reg [0:57599] memory;  // 240 * 240 = 57600 bits

    always @(posedge clk) begin
        if (we) begin
            // Write data to memory
            memory[addr] <= data_in;
        end
        // Read data from memory
        data_out <= memory[addr];
    end

endmodule