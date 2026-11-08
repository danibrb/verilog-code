// =============================================================================
// tb_cnt_bcd.v
// Testbench per cnt_bcd. NON viene sintetizzato: vive solo in simulazione.
// Pattern: clock generator + stimulus + self-checking con $display.
// =============================================================================

`timescale 1ns/1ps

module tb_cnt_bcd;

    // --- Parametri del test ---
    localparam CLK_PERIOD = 10;        // 10 ns → 100 MHz

    // --- Segnali del DUT (Device Under Test) ---
    reg         CK      = 1'b0;
    reg         RSTb    = 1'b0;
    reg         ENABLE  = 1'b0;
    reg         LOAD    = 1'b0;
    reg  [3:0]  DIN     = 4'b0000;
    wire [3:0]  COUNT;
    wire        TC;

    // --- Istanza del DUT ---
    // NB: connessione PER NOME (mai per posizione nei TB moderni).
    cnt_bcd #(
        .MOD(10),
        .WIDTH(4)
    ) dut (
        .CK     (CK),
        .RSTb   (RSTb),
        .ENABLE (ENABLE),
        .LOAD   (LOAD),
        .DIN    (DIN),
        .COUNT  (COUNT),
        .TC     (TC)
    );

    // --- Clock generator: toggola ogni CLK_PERIOD/2 ---
    initial CK = 1'b0;
    always #(CLK_PERIOD/2) CK = ~CK;

    // --- Variabili di monitoraggio ---
    integer errors = 0;
    integer checks  = 0;

    // --- Task riutilizzabile: controlla il valore atteso ---
    task check_count;
        input [3:0] expected;
        input [127:0] msg;
        begin
            checks = checks + 1;
            if (COUNT !== expected) begin
                $display("FAIL @ t=%0t  %s : COUNT=%0d  expected=%0d",
                         $time, msg, COUNT, expected);
                errors = errors + 1;
            end else begin
                $display("PASS @ t=%0t  %s : COUNT=%0d",
                         $time, msg, COUNT);
            end
        end
    endtask

    // --- Dump waveform per GTKWave / Questa ---
    initial begin
        $dumpfile("build/dump.vcd");
        $dumpvars(0, tb_cnt_bcd);
    end

    // --- Scenario di test ---
    initial begin
        $display("==================================================");
        $display(" Inizio simulazione tb_cnt_bcd");
        $display("==================================================");

        // 1) Reset iniziale per qualche ciclo
        RSTb   = 1'b0;
        ENABLE = 1'b0;
        LOAD   = 1'b0;
        DIN    = 4'h0;
        #(CLK_PERIOD * 3);
        @(posedge CK);   // allineo al fronte di clock
        #1;              // piccolo delta per lasciare stabilizzare
        check_count(4'd0, "dopo reset");

        // 2) Rilascia reset
        RSTb = 1'b1;
        @(posedge CK); #1;
        check_count(4'd0, "post reset release");

        // 3) Conta 0..9 e wrap-around a 0
        ENABLE = 1'b1;
        repeat(11) begin
            @(posedge CK); #1;
        end
        check_count(4'd1, "dopo 11 colpi con enable (0→1, wrap)");

        // 4) Hold: ENABLE=0 non deve contare
        ENABLE = 1'b0;
        @(posedge CK); #1;
        check_count(4'd1, "hold (ENABLE=0)");
        @(posedge CK); #1;
        check_count(4'd1, "hold 2");

        // 5) Load parallelo: imposta COUNT a 7
        LOAD = 1'b1;
        DIN  = 4'd7;
        @(posedge CK); #1;
        check_count(4'd7, "dopo load DIN=7");
        LOAD = 1'b0;

        // 6) Conta da 7 a 9 → wrap → 0, poi 1
        ENABLE = 1'b1;
        repeat(4) begin
            @(posedge CK); #1;
        end
        check_count(4'd1, "7→8→9→0→1");

        // 7) Verifica del TC (terminal count)
        // Portiamoci a COUNT=8 poi avanziamo di 1 per arrivare a 9
        ENABLE = 1'b0;
        LOAD  = 1'b1;
        DIN   = 4'd8;
        @(posedge CK); #1;
        LOAD  = 1'b0;
        ENABLE = 1'b1;
        @(posedge CK); #1;
        if (TC !== 1'b1) begin
            $display("FAIL @ t=%0t  TC deve essere 1 a COUNT=9", $time);
            errors = errors + 1;
        end else
            $display("PASS @ t=%0t  TC=1 a COUNT=9", $time);

        // --- Riassunto finale ---
        $display("--------------------------------------------------");
        $display("  Test eseguiti : %0d", checks);
        $display("  Errori        : %0d", errors);
        if (errors == 0)
            $display("  >>> TUTTI I TEST PASSATI <<<");
        else
            $display("  >>> FALLITI <<<");
        $display("--------------------------------------------------");

        $finish;
    end

    // --- Safety timeout: se qualcosa si blocca, esci comunque ---
    initial begin
        #(CLK_PERIOD * 1000);
        $display("TIMEOUT: simulazione bloccata");
        $finish;
    end

endmodule
