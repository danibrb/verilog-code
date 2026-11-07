/*
* LED Switch Module
*/

module led_sw(
    input wire sw,
    output wire led
);

assign led = sw;

endmodule
