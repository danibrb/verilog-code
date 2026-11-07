/*
* parametrizable adder with carry in and carry out
*/
`timescale 1ns/10ps

module adder_carry_par #(
    parameter WIDTH = 8
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input carry_in,
    output [WIDTH-1:0] sum,
    output carry_out
);

assign {carry_out, sum} = a + b + carry_in;
endmodule
