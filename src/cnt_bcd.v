// =============================================================================
// cnt_bcd.v
// Contatore BCD modulo-10 (0..9) con enable, load parallelo e reset sincrono.
// Template di riferimento — sostituisci la logica interna con la tua.
// =============================================================================

`timescale 1ns/1ps       // unita' 1 ns, precisione 1 ps

module cnt_bcd #(
    parameter MOD = 10,         // modulo del contatore (default BCD)
    parameter WIDTH = 4         // larghezza del bus (4 bit bastano fino a MOD=16)
)(
    input  wire             CK,      // clock
    input  wire             RSTb,    // reset attivo basso, SINCRONO (vedi always)
    input  wire             ENABLE,  // 1 = conta, 0 = hold
    input  wire             LOAD,    // 1 = carica DIN in sincrono col clock
    input  wire [WIDTH-1:0] DIN,     // dato parallelo per load
    output reg  [WIDTH-1:0] COUNT,   // valore corrente
    output wire             TC       // terminal count: 1 quando COUNT == MOD-1
);

    // --- Terminal count: logica combinatoria (continuous assignment) ---
    assign TC = (COUNT == MOD-1);

    // --- Logica sequenziale: UN solo always @(posedge CK) ---
    // Regola d'oro: ogni variabile assegnata in always deve essere `reg`.
    // Regola d'oro: reset SINCRONO dentro al always, NON in sensitivity list.
    always @(posedge CK) begin
        if (!RSTb)
            COUNT <= {WIDTH{1'b0}};            // reset a 0
        else if (LOAD)
            COUNT <= DIN;                       // load parallelo prioritario su enable
        else if (ENABLE) begin
            if (COUNT == MOD-1)
                COUNT <= {WIDTH{1'b0}};         // wrap-around
            else
                COUNT <= COUNT + 1'b1;
        end
        // else: hold (non scriviamo COUNT → mantiene il valore)
    end

endmodule
