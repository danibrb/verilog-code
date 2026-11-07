`timescale 1ns/10ps
module tb_mux2_1;
  reg a, b, sel;
  wire out;
  integer i, errors;

  MUX2_1 dut(out, a, b, sel);

  initial begin
    $dumpfile("build/dump.vcd");
    $dumpvars(0, tb_mux2_1);
    errors = 0;
    for (i = 0; i < 8; i = i + 1) begin
      {sel, a, b} = i[2:0];
      #10;
      if (out !== (sel ? b : a)) begin
        $display("ERRORE t=%0t sel=%b a=%b b=%b out=%b", $time, sel, a, b, out);
        errors = errors + 1;
      end
    end
    if (errors == 0) $display("TEST SUPERATO");
    $finish;
  end
endmodule