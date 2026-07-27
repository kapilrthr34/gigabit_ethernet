module gmii_rx
(
    input  wire        rx_clk,
    input  wire        rst_n,

    input  wire [7:0]  rxd,
    input  wire        rx_dv,
    input  wire        rx_er
);
/*----------Main State Logic----------*/
localparam IDLE     = 3'd0;
localparam PREAMBLE = 3'd1;
localparam SFD      = 3'd2;
localparam DATA     = 3'd3;
localparam FCS      = 3'd4;
localparam DONE     = 3'd5;

reg [2:0]   state;
wire        w_frame_valid;

reg [2:0]   r_preamble_cnt;
reg [2:0]   r_crc_cnt;
reg [367:0] r_data_buff;
reg [5:0]   r_data_count = 'd0;
reg [31:0]  r_crc_buff = 'h0;

reg r_data_out    = 'h0;
reg r_data_valid  = 'b0;
reg r_frame_done  = 'b0;

reg [31:0] transmitted_crc;

always @(posedge rx_clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        state        <= IDLE;
        r_preamble_cnt <= 0;
        r_data_valid   <= 0;
        r_frame_done   <= 0;
        r_data_count <= 'd0;
        r_data_buff  <= 'd0;
        r_crc_cnt    <= 'd0;    
    end
    else begin
        r_data_valid <= 0;
        r_frame_done <= 0;

        case(state)
            IDLE: begin
                r_data_count    <= 'd0;
                r_preamble_cnt  <= 0; 
                r_crc_cnt       <= 'd0;       
                if(rx_dv == 'b1 && rxd == 'h55) begin
                    r_preamble_cnt <= r_preamble_cnt + 1;
                    state <= PREAMBLE;
                end
            end
            
            PREAMBLE: begin
                if(rx_dv == 'b1 && rxd == 'h55) begin
                    r_preamble_cnt <= r_preamble_cnt + 1;
    
                    if(r_preamble_cnt >= 6)
                        state <= SFD;
                    else
                        state <= PREAMBLE;
                end
            end
            
            SFD: begin
                if(rxd == 'hD5 && rx_dv == 'b1)
                    state <= DATA;
                else
                    state <= IDLE;
            end
            
            DATA: begin
                if(r_data_count >= 'd46) begin
                    r_data_count <= 'd0;
                    state <= FCS;
                end
                else begin
                    if(rx_dv == 'b1) begin
                        r_data_buff <= {r_data_buff[359:0], rxd};
                        r_data_out    <= rxd;
                        r_data_valid  <= 1'b1;
                        
                        r_data_count <= r_data_count + 'd1;
                    end
                end
            end
            
            FCS: begin
                if(r_crc_cnt >= 'd4) begin 
                    r_crc_cnt <= 'd0;
                    state <= DONE;
                end
                else begin
                    if (rx_dv == 'b1) begin
                        r_data_out    <= rxd;
                        r_crc_cnt   <= r_crc_cnt + 'd1;
                        r_crc_buff       <= {r_crc_buff[23:0], rxd};
                    end                    
                end 
            end
            
            DONE: begin
                r_frame_done <= 1'b1;
                state <= IDLE;
            end
    
            default:
                state <= IDLE;
        endcase
    end
end

assign w_frame_valid = (transmitted_crc == r_crc_buff);

/*-------Debug Signals (ILA on rx_clk domain)----------------*/
(* mark_debug = "true", keep= "true" *)  wire [7:0]  w_dbg_rxd       = rxd;       // RX data
(* mark_debug = "true", keep= "true" *)  wire        w_dbg_rx_dv     = rx_dv;     // RX data valid
(* mark_debug = "true", keep= "true" *)  wire        w_dbg_rx_er     = rx_er;     // RX error
(* mark_debug = "true", keep= "true" *)  wire [2:0]  w_dbg_rx_state  = state;     // FSM state (context / trigger)






endmodule