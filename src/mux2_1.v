`timescale 1ns/10ps
module MUX2_1(out, a, b, sel);
output out;
input a, b, sel;

reg out;    // Commento

    always @(sel or a or b)
    begin
        if( sel == 0 )
            out <= a;
        else
            out <= b;
    end
/* Altro commento */
endmodule
