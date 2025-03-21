module clk(
    input wire clk_in,    // Input clock
    input wire reset,     // Reset signal
    output reg clk_out    // Output clock
);

    reg [1:0] counter;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 2'b0;
            clk_out <= 1'b0;
        end else begin
            counter <= counter + 1;
            if (counter == 2'b11) begin
                clk_out <= ~clk_out;
                counter <= 2'b0;
            end
        end
    end

endmodule