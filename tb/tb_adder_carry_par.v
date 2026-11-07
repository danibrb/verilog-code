/*
 * testbench for adder with carry propagation
 */

`timescale 1ns/10ps

module tb_adder_carry_par;
  parameter WIDTH = 8;

  localparam MAX = {WIDTH{1'b1}};

  reg  [WIDTH-1:0] a;
  reg  [WIDTH-1:0] b;
  reg              carry_in;
  wire [WIDTH-1:0] sum;
  wire             carry_out;

  integer errors = 0;
  integer i;

  adder_carry_par #(.WIDTH(WIDTH)) dut (
    .a(a),
    .b(b),
    .carry_in(carry_in),
    .sum(sum),
    .carry_out(carry_out)
  );

  // reference model + scoreboard
  task check;
    reg [WIDTH:0] expected;
    begin
      expected = a + b + carry_in;
      if ({carry_out, sum} !== expected) begin
        errors = errors + 1;
        $display("FAIL t=%0t: a=%0d b=%0d cin=%b -> sum=%0d cout=%b (expected %0d)",
                 $time, a, b, carry_in, sum, carry_out, expected);
      end
    end
  endtask

  initial begin
  
    $dumpfile("build/dump.vcd");
    $dumpvars(0, tb_adder_carry_par);
  
    // directed corner cases
    carry_in = 1'b0;
    a = 0;       b = 0;    #10 check;   // all zeros
    a = 1;       b = 1;    #10 check;
    a = MAX;     b = 0;    #10 check;   // max operand
    a = MAX;     b = 1;    #10 check;   // overflow
    a = MAX;     b = MAX;  #10 check;   // max + max
    a = 8'h55;   b = 8'hAA; #10 check;  // alternating bits

    carry_in = 1'b1;
    a = 0;       b = 0;    #10 check;   // carry-in only
    a = MAX;     b = MAX;  #10 check;   // max + max + 1
    a = MAX;     b = 0;    #10 check;

    // random stimulus
    for (i = 0; i < 100; i = i + 1) begin
      a = $random;
      b = $random;
      carry_in = $random;
      #10 check;
    end

    // summary
    if (errors == 0)
      $display("All tests PASSED.");
    else
      $display("%0d test(s) FAILED.", errors);

    $finish;
  end

endmodule
