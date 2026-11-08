/*
* generate a tick signal every 1 second
*/

`timescale 1ns/10ps

module tick_gen_1s (
    input clk,
    input rst_b,
    input enable,
    output reg tick
);

    localparam integer CLK_FREQ = 50_000_000; // 50 MHz
    //localparam [31:0] MAX_COUNT = 32'd49_999_999; // count 0..49,999,999 = 50M cycles = 1 s
    //localparam [31:0] MAX_COUNT = CLK_FREQ - 1; // count 0..(CLK_FREQ-1) = CLK_FREQ cycles = 1 s
    localparam [31:0] MAX_COUNT = (CLK_FREQ - 1)/1_000_000; // for simulation purposes, count 0..(CLK_FREQ/1_000_000 - 1) = CLK_FREQ/1_000_000 cycles = 1 us
    reg [31:0] counter = 32'd0;

    always @(posedge clk) begin
        if (!rst_b) begin
            counter <= 32'd0;
            tick    <= 1'b0;
        end else if (enable) begin
            if (counter == MAX_COUNT) begin
                tick    <= 1'b1;
                counter <= 32'd0;
            end else begin
                tick    <= 1'b0;
                counter <= counter + 1'b1;
            end
        end else begin
            tick    <= 1'b0;      // drive tick low while disabled
            counter <= counter;  // hold the counter value when not enabled
        end
    end

endmodule
