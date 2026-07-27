`timescale 1ns / 1ps

module gmii_tx(
input               clk,
input               rst,
input       [47:0]  src_addr,
input       [47:0]  dest_addr,
input       [15:0]  eth_type,
input       [31:0]  crc,
input               tx_en,   
output reg [7:0]    gmii_txd   = 8'd0,
output reg          gmii_tx_en = 1'b0,
output reg          gmii_tx_er = 1'b0,
output reg          tx_done    = 'd0 
);

/*-----Capture Falling Edge of Tx En----------------*/
reg tx_en_d  = 'd0;
reg tx_en_dd = 'd0;
wire w_tx_en_fe;
always@(negedge clk) begin 
    tx_en_d     <= tx_en;
    tx_en_dd    <= tx_en_d;
end
assign w_tx_en_fe = (~tx_en_d) && (tx_en_dd);
/*-------------------------------------------------*/

/*--------2-d Array for Packet--------------------*/
localparam FRAME_BYTES = 72;
integer ii;
reg [7:0] frame_mem [0:FRAME_BYTES-1];
initial begin

    // Preamble
    frame_mem[0] = 8'h55;
    frame_mem[1] = 8'h55;
    frame_mem[2] = 8'h55;
    frame_mem[3] = 8'h55;
    frame_mem[4] = 8'h55;
    frame_mem[5] = 8'h55;
    frame_mem[6] = 8'h55;

    // SFD
    frame_mem[7] = 8'hD5;

    // "Hello Ethernet"
    frame_mem[22] = "H";
    frame_mem[23] = "e";
    frame_mem[24] = "l";
    frame_mem[25] = "l";
    frame_mem[26] = "o";
    frame_mem[27] = " ";
    frame_mem[28] = "E";
    frame_mem[29] = "t";
    frame_mem[30] = "h";
    frame_mem[31] = "e";
    frame_mem[32] = "r";
    frame_mem[33] = "n";
    frame_mem[34] = "e";
    frame_mem[35] = "t";
/*------------------------------------*/

// Pad payload to 46 bytes
    for(ii=36; ii<68; ii=ii+1) begin
        frame_mem[ii] = 8'h00;
    end
end
/*------------------------------------------------*/

reg [$clog2(FRAME_BYTES+1)-1:0] r_byte_count = 'd0;
localparam S_IDLE           = 'd0;
localparam S_CREATE_PACKET  = 'd1;
localparam S_SEND_PACKET    = 'd2;
reg [1:0] sm_main = S_IDLE;
always@(negedge clk) begin 
    if(rst) begin 
        sm_main         <= S_IDLE;
        gmii_txd        <= 8'd0; 
        gmii_tx_en      <= 1'b0; 
        gmii_tx_er      <= 1'b0; 
        tx_done         <= 'd0;
        r_byte_count    <= 'd0;
    end
    else begin 
        case(sm_main)
            S_IDLE : begin 
                gmii_txd        <= 'd0;
                gmii_tx_en      <= 'd0;
                gmii_tx_er      <= 'd0;
                r_byte_count    <= 'd0;
                tx_done         <= 'd0;
                if(w_tx_en_fe) begin 
                    sm_main     <= S_CREATE_PACKET; 
                end
            end
            
            S_CREATE_PACKET : begin 
                {frame_mem[8],frame_mem[9],frame_mem[10],frame_mem[11],frame_mem[12],frame_mem[13]}     <= dest_addr;
                {frame_mem[14],frame_mem[15],frame_mem[16],frame_mem[17],frame_mem[18],frame_mem[19]}   <= src_addr;
                {frame_mem[20],frame_mem[21]}                                                           <= eth_type;
                {frame_mem[71],frame_mem[70],frame_mem[69],frame_mem[68]}                               <= crc;
                sm_main                                                                                 <= S_SEND_PACKET;
            end
            
            S_SEND_PACKET : begin 
                if(r_byte_count == FRAME_BYTES) begin 
                    gmii_txd        <= 'd0;
                    gmii_tx_en      <= 'd0; 
                    gmii_tx_er      <= 'd0;
                    r_byte_count    <= 'd0; 
                    tx_done         <= 'd1;
                    sm_main         <= S_IDLE;    
                end
                else begin 
                    gmii_txd        <= frame_mem[r_byte_count];
                    gmii_tx_en      <= 'd1;
                    gmii_tx_er      <= 'd0;
                    r_byte_count    <= r_byte_count + 1;
                    sm_main         <= S_SEND_PACKET;
                end
            end
            
            default : begin 
                sm_main <= S_IDLE;
            end
        endcase
    end
end

/*------Debug Section-------*/
(* mark_debug = "true" , keep = "true" *) wire [7:0]    w_dbg_gmii_txd    = gmii_txd   ;
(* mark_debug = "true" , keep = "true" *) wire          w_dbg_gmii_tx_en  = gmii_tx_en ;
(* mark_debug = "true" , keep = "true" *) wire          w_dbg_gmii_tx_er  = gmii_tx_er ;
(* mark_debug = "true" , keep = "true" *) wire          w_dbg_tx_done     = tx_done    ;
/*--------------------------*/
endmodule
