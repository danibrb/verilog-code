`timescale 1ns/10ps

module tb_tick_gen_1s;

    reg clk;
    reg rst_b;
    reg enable;
    wire tick;

    tick_gen_1s dut (
        .clk(clk),
        .rst_b(rst_b),
        .enable(enable),
        .tick(tick)
    );

    // 50 MHz clock: 20 ns period
    always #10 clk = ~clk;

    initial begin
        $dumpfile("build/dump.vcd");
        $dumpvars(0, tb_tick_gen_1s);

        clk    = 0;
        rst_b  = 0;
        enable = 0;

        #100 rst_b  = 1;
        #100 enable = 1;
/*
        // 1 s of enabled time = 50,000,000 cycles = 1_000_000_000 ns
        #1_000_000_000 enable = 0;
        #1_000_000_000 enable = 1;
        #1_000_000_000 $finish;

*/
        // 1 us of enabled time = 50 cycles = 1_000 ns
        #1_000 enable = 0;
        #1_000 enable = 1;
        #1_000 $finish;
    end

    // Optional: observe each tick in the log
    initial
        forever @(posedge tick) $display("%0t ns: tick pulse", $time);

endmodule
