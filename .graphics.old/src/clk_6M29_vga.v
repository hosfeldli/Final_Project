module clk_div_6M29 (
    input wire clk_in,    // 100 MHz input clock
    input wire reset,     // Active-high reset
    output reg clk_out    // ~6.25 MHz output clock
);

    reg [3:0] counter; // 4-bit counter for divide-by-16

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 4'b0;
            clk_out <= 1'b0;
        end else begin
            counter <= counter + 1;
            if (counter == 4'd15) begin
                clk_out <= ~clk_out; // Toggle the output clock
                counter <= 4'b0;
            end
        end
    end

endmodule
