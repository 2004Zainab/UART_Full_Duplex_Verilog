module transmitter(
    input clk,
    input reset,
    input tx_en,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

reg [1:0] state;
reg [7:0] data_reg;
reg [2:0] bit_count;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        state <= IDLE;
        tx <= 1'b1;
        tx_busy <= 1'b0;
        data_reg <= 8'd0;
        bit_count <= 3'd0;
    end
    else
    begin
        case(state)

        IDLE:
        begin
            tx <= 1'b1;
            tx_busy <= 1'b0;
            bit_count <= 3'd0;

            if(tx_start)
            begin
                tx_busy <= 1'b1;
                data_reg <= tx_data;
                state <= START;
            end
        end

        START:
        begin
            if(tx_en)
            begin
                tx <= 1'b0;
                state <= DATA;
            end
        end

        DATA:
        begin
            if(tx_en)
            begin
                tx <= data_reg[0];
                data_reg <= data_reg >> 1;

                if(bit_count == 3'd7)
                begin
                    bit_count <= 3'd0;
                    state <= STOP;
                end
                else
                begin
                    bit_count <= bit_count + 1'b1;
                end
            end
        end

        STOP:
        begin
            if(tx_en)
            begin
                tx <= 1'b1;
                tx_busy <= 1'b0;
                state <= IDLE;
            end
        end

        default:
        begin
            state <= IDLE;
            tx <= 1'b1;
            tx_busy <= 1'b0;
        end

        endcase
    end
end

endmodule