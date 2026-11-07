`timescale 1ns/10ps
module tb_cnt_mod8;
  reg CK, RSTb;
  wire [2:0] Q;
  reg [2:0] expected;
  integer i, errors;

  cnt_mod8 dut(Q, RSTb, CK);

  // clock con periodo 10 ns (cfr. slide 13)
  initial CK = 0;
  always #5 CK = ~CK;

  // modello di riferimento
  always @(posedge CK)
    if (RSTb == 0) expected <= 3'd0;
    else           expected <= expected + 3'd1;

  initial begin
    $dumpfile("build/dump.vcd");
    $dumpvars(0, tb_cnt_mod8);
    errors = 0;
    RSTb = 0;
    repeat (2) @(posedge CK);        // il reset sincrono richiede almeno un fronte
    @(negedge CK);
    if (Q !== 3'd0) begin
      $display("ERRORE dopo reset: Q=%0d", Q);
      errors = errors + 1;
    end
    RSTb = 1;
    for (i = 0; i < 20; i = i + 1) begin   // oltre due giri completi
      @(negedge CK);
      if (Q !== expected) begin
        $display("ERRORE t=%0t Q=%0d atteso=%0d", $time, Q, expected);
        errors = errors + 1;
      end
    end
    if (errors == 0) $display("TEST SUPERATO");
    $finish;
  end
endmodule
