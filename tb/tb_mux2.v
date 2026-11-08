`timescale 1ns/10ps

module tb_mux2;

    // --- Parametri del test ---
    localparam CLK_PERIOD = 10;        // 10 ns → 100 MHz

    // --- Segnali del DUT (Device Under Test) ---
    reg         a       = 1'b0;
    reg         b       = 1'b0;
    reg         sel     = 1'b0;
    wire        y;

    // --- Istanza del DUT ---
    mux2 dut (
        .a      (a),
        .b      (b),
        .sel    (sel),
        .y      (y)
    );

    initial begin
        $dumpfile("build/dump.vcd");
        $dumpvars(0, tb_mux2);
        $display("TEST INIZIATO");
        for (integer i = 0; i < 8; i = i + 1) begin
            {sel, a, b} = i[2:0];
            #CLK_PERIOD;
            if (y !== (sel ? b : a)) begin
                $display("ERRORE t=%0t sel=%b a=%b b=%b y=%b", $time, sel, a, b, y);
            end
        end
        $display("TEST COMPLETATO");
        $finish;
    end

endmodule 
