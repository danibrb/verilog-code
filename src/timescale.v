/*
* Timescale Module
*/

module timescale(
    input wire clk,
    output reg [31:0] count
);

    always @(posedge clk)
    begin
        count <= count + 1;
    end 
endmodule
