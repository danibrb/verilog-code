`timescale 1ns/10ps
module cnt_mod8(Q, RSTb, CK);
output [2:0] Q;
input RSTb, CK;

reg [2:0] Q;

always @(posedge CK)
    if( RSTb == 0 )
        Q <= 3'd0;
    else
        Q <= Q + 3'd1;
endmodule
