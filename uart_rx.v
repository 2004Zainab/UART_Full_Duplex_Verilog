module receiver(
    input clk,
    input reset,
    input rx_en,
    input rx,
    output reg [7:0] rx_data,
    output reg rx_done

);
parameter IDLE  = 3'd0;
parameter START = 3'd1;
parameter DATA  = 3'd2;
parameter STOP  = 3'd3;
parameter DONE  = 3'd4;
reg [2:0] state;
reg [7:0] data_reg;
reg [2:0] bit_count;
reg [3:0] sample_count;

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin
        state <= IDLE;
        rx_data <= 8'd0;
        data_reg <= 8'd0;
        bit_count <= 3'd0;
        sample_count <= 4'd0;
        rx_done <= 1'b0;
    end

    else
    begin

        rx_done <= 1'b0;

        case(state)

        IDLE:
        begin
            bit_count <= 3'd0;
            sample_count <= 4'd0;

            if(rx == 1'b0)
                state <= START;
        end

        START:
        begin
            if(rx_en)
            begin
                if(sample_count == 4'd7)
                begin
                    sample_count <= 4'd0;

                    if(rx == 1'b0)
                        state <= DATA;
                    else
                        state <= IDLE;
                end
                else
                    sample_count <= sample_count + 1'b1;
            end
        end

        DATA:
        begin
            if(rx_en)
            begin
                if(sample_count == 4'd15)
                begin
                    sample_count <= 4'd0;

                    data_reg[bit_count] <= rx;

                    if(bit_count == 3'd7)
                    begin
                        bit_count <= 3'd0;
                        state <= STOP;
                    end
                    else
                        bit_count <= bit_count + 1'b1;
                end
                else
                    sample_count <= sample_count + 1'b1;
            end
        end

        STOP:
        begin
            if(rx_en)
            begin
                if(sample_count == 4'd15)
                begin
                    sample_count <= 4'd0;

                    if(rx == 1'b1)
                    begin
                        rx_data <= data_reg;
                        state <= DONE;
                    end
                    else
                        state <= IDLE;
                end
                else
                    sample_count <= sample_count + 1'b1;
            end
        end

        DONE:
        begin
            rx_done <= 1'b1;
            state <= IDLE;
        end

        default:
            state <= IDLE;

        endcase

    end

end

endmodule