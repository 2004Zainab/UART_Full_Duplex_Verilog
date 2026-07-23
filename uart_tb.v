module uart_tb;

reg clk;
reg reset;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_busy;
wire [7:0] rx_data;
wire rx_done;

full_duplex uut(
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .rx(tx),
    .tx(tx),
    .tx_busy(tx_busy),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

initial
begin
    clk = 1'b0;
    forever #10 clk = ~clk;
end

initial
begin
    reset = 1'b1;
    tx_start = 1'b0;
    tx_data = 8'h00;

    #100;
    reset = 1'b0;

    #200;

    tx_data = 8'h41;
    tx_start = 1'b1;
    #20;
    tx_start = 1'b0;

    wait(rx_done);

    #500;

    tx_data = 8'h55;
    tx_start = 1'b1;
    #20;
    tx_start = 1'b0;

    wait(rx_done);

    #500;

    tx_data = 8'hAA;
    tx_start = 1'b1;
    #20;
    tx_start = 1'b0;

    wait(rx_done);

    #500;

    tx_data = 8'h5A;
    tx_start = 1'b1;
    #20;
    tx_start = 1'b0;

    wait(rx_done);

    #1000;

    $stop;
end

initial
begin
    $display("----------------------------------------------");
    $display("Time\tTX\tBusy\tDone\tRX_Data");
    $display("----------------------------------------------");

    $monitor("%0t\t%b\t%b\t%b\t%h",
             $time,
             tx,
             tx_busy,
             rx_done,
             rx_data);
end

endmodule