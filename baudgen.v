module baudgen(
    input clk,
    input reset,
    output reg tx_en,
    output reg rx_en
);

parameter TX_DIV = 434;
parameter RX_DIV = 27;

reg [8:0] tx_count;
reg [5:0] rx_count;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        tx_count <= 0;
        rx_count <= 0;
        tx_en <= 0;
        rx_en <= 0;
    end
    else
    begin
        if(tx_count == TX_DIV-1)
        begin
            tx_count <= 0;
            tx_en <= 1'b1;
        end
        else
        begin
            tx_count <= tx_count + 1'b1;
            tx_en <= 1'b0;
        end

        if(rx_count == RX_DIV-1)
        begin
            rx_count <= 0;
            rx_en <= 1'b1;
        end
        else
        begin
            rx_count <= rx_count + 1'b1;
            rx_en <= 1'b0;
        end
    end
end

endmodule