module top(

    input CLOCK_50_B5B,
    input KEY0,

    input UART_RX,
    output UART_TX,

    output [7:0] LEDR

);

reg tx_start;
reg [7:0] tx_data;

wire tx_busy;
wire [7:0] rx_data;
wire rx_done;

full_duplex uart0(

    .clk(CLOCK_50_B5B),
    .reset(~KEY0),

    .tx_start(tx_start),
    .tx_data(tx_data),

    .rx(UART_RX),

    .tx(UART_TX),
    .tx_busy(tx_busy),

    .rx_data(rx_data),
    .rx_done(rx_done)

);

always @(posedge CLOCK_50_B5B or negedge KEY0)
begin
    if(!KEY0)
    begin
        tx_start <= 1'b0;
        tx_data <= 8'd0;
    end
    else
    begin
        tx_start <= 1'b0;

        if(rx_done && !tx_busy)
        begin
            tx_data <= rx_data;
            tx_start <= 1'b1;d
        end
    end
end

assign LEDR = rx_data;

endmodule