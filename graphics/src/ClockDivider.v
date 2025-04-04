module ClockDivider #(parameter DIVIDE_BY = 8) (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);
    reg [3:0] counter = 0;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else if (counter == (DIVIDE_BY/2 - 1)) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule
