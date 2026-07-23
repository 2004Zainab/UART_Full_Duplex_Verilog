module full_duplex(
    input clk,
    input reset,

    input tx_start,
    input [7:0] tx_data,

    input rx,

    output tx,
    output tx_busy,

    output [7:0] rx_data,
    output rx_done
);

wire tx_en;
wire rx_en;

baudgen baud_generator(
    .clk(clk),
    .reset(reset),
    .tx_en(tx_en),
    .rx_en(rx_en)
);

transmitter tx_unit(
    .clk(clk),
    .reset(reset),
    .tx_en(tx_en),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

receiver rx_unit(
    .clk(clk),
    .reset(reset),
    .rx_en(rx_en),
    .rx(rx),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

endmodule