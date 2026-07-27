`timescale 1ns / 1ps

module mdio(
input               clk, // 100 MHz input clk
input               rst,
input       [4:0]   phy_addr,
input       [4:0]   reg_addr,
input               wr_init,
input               rd_init,
input       [15:0]  wr_data,

output  reg [15:0]  rd_data = 'd0,
output  reg         wr_done = 'd0,
output  reg         rd_done = 'd0,
output  reg         mdc     = 'd0,
inout               mdio              
);



/*---------Generate MDC---------------*/
localparam MDC_CLK_COUNT = 40;
reg                             r_mdc       = 'd0;
reg                             r_mdc_fe    = 'd0;
reg                             r_mdc_re    = 'd0;
reg [$clog2(MDC_CLK_COUNT)-1:0] r_mdc_count = 'd0;
always@(posedge clk) begin 
    if(rst) begin 
        r_mdc       <= 'd0;
        r_mdc_fe    <= 'd0;
        r_mdc_re    <= 'd0;
        r_mdc_count <= 'd0;
    end
    else begin 
        if(r_mdc_count == MDC_CLK_COUNT-1) begin 
            r_mdc_fe    <= 'd1;
            r_mdc       <= 'd0;
            r_mdc_count <= 'd0;           
        end
        else if(r_mdc_count == (MDC_CLK_COUNT/2)-1) begin 
            r_mdc_re    <= 'd1;
            r_mdc       <= 'd1;
            r_mdc_count <= r_mdc_count + 1;
        end
        else begin 
            r_mdc_re    <= 'd0;
            r_mdc_fe    <= 'd0;
            r_mdc_count <= r_mdc_count + 1;
        end
    end
end
/*------------------------------------*/

/*-----Capture Rising Edge of Write Transaction----*/
reg wr_init_d  = 'd0;
reg wr_init_dd = 'd0;
wire w_wr_init_re;
always@(posedge clk) begin 
    wr_init_d <= wr_init;
    wr_init_dd <= wr_init_d;
end
assign w_wr_init_re = wr_init_d && (~wr_init_dd);
/*-------------------------------------------------*/

/*-----Capture Rising Edge of Read Transaction----*/
reg rd_init_d  = 'd0;
reg rd_init_dd = 'd0;
wire w_rd_init_re;
always@(posedge clk) begin 
    rd_init_d  <= rd_init;
    rd_init_dd <= rd_init_d;
end
assign w_rd_init_re = rd_init_d && (~rd_init_dd);
/*-------------------------------------------------*/

/*----------Main State Logic----------*/
localparam  [31:0] PREAMBLE_BITS = {32{1'b1}};
localparam  [1:0]  START_BITS    = 2'b01;
localparam  [1:0]  WR_OP_BITS    = 2'b01;
localparam  [1:0]  RD_OP_BITS    = 2'b10; 
localparam  [1:0]  TA_BITS       = 2'b10;
localparam         TOTAL_BITS    = 64; 
localparam         TX_READ_BITS  = TOTAL_BITS - 18;

/*---------- Registers ----------*/
reg [$clog2(TOTAL_BITS):0]      r_bit_count  = 'd0;
reg [TOTAL_BITS-1:0]            r_tx_reg     = 'd0;             
reg                             r_mdio_en    = 'd0;
reg                             r_mdio_out   = 'd0;
reg  [17:0]                     r_rd_data    = 'd0;
localparam S_IDLE  = 'd0;
localparam S_WRITE = 'd1;
localparam S_READ  = 'd2;
reg [1:0] sm_main  = S_IDLE;


always@(posedge clk) begin 
    if(rst) begin 
        sm_main     <= S_IDLE;
        r_bit_count <= 'd0;
        r_tx_reg    <= 'd0;
        r_mdio_en   <= 'd0;
        r_mdio_out  <= 'd0;
        wr_done     <= 'd0; 
        rd_done     <= 'd0;
        rd_data     <= 'd0;
        r_rd_data   <= 'd0;
    end
    else begin 
        case(sm_main)
            S_IDLE : begin 
                wr_done     <= 'd0;
                r_mdio_en   <= 'd0;
                r_mdio_out  <= 'd0;
                r_bit_count <= 'd0;
                rd_done     <= 'd0;
                r_rd_data   <= 'd0;
                if(w_wr_init_re) begin 
                    sm_main  <= S_WRITE;
                    r_tx_reg <= {PREAMBLE_BITS,START_BITS,WR_OP_BITS,phy_addr,reg_addr,TA_BITS,wr_data}; 
                end
                else if(w_rd_init_re) begin 
                    sm_main <= S_READ;
                    r_tx_reg <= {PREAMBLE_BITS,START_BITS,RD_OP_BITS,phy_addr,reg_addr,18'd0};
                end
                else begin 
                    sm_main <= S_IDLE;
                end
            end
            
            S_WRITE : begin 
                r_mdio_en <= 1'b1;
                if(r_bit_count == TOTAL_BITS+1) begin 
                    wr_done     <= 'd1;
                    r_bit_count <= 'd0;
                    sm_main     <= S_IDLE;
                end
                else begin 
                    if(r_mdc_fe) begin 
                        r_bit_count <= r_bit_count + 1;
                        r_mdio_out  <= r_tx_reg[63];
                        r_tx_reg    <= r_tx_reg << 1'b1;
                    end
                end
            end
            
            S_READ : begin 
                if(r_bit_count == TOTAL_BITS+1) begin 
                    rd_done     <= 'd1;
                    r_bit_count <= 'd0;
                    rd_data     <= r_rd_data[15:0];
                    sm_main     <= S_IDLE;
                end
                else begin 
                    if(r_bit_count < TX_READ_BITS) begin 
                        if(r_mdc_fe) begin 
                            r_mdio_en   <= 1'b1;
                            r_bit_count <= r_bit_count + 1;
                            r_mdio_out  <= r_tx_reg[63];
                            r_tx_reg    <= r_tx_reg << 1'b1;                            
                        end    
                    end
                    else begin 
                        if(r_mdc_re) begin 
//                            r_rd_data[0]    <=  mdio;
//                            r_rd_data       <= r_rd_data << 1'b1; 
                            r_rd_data <= {r_rd_data[16:0], mdio};
                            r_mdio_en       <= 1'b0;
                            r_bit_count     <= r_bit_count + 1;                            
                        end
                    end
                end
            end
            default : begin 
                sm_main <= S_IDLE;
            end
        endcase
    end
end
/*------------------------------------*/

/*--------Assign Outputs-------------*/
always@(posedge clk) begin 
    mdc <= r_mdc;
end
assign mdio = r_mdio_en ? r_mdio_out : 1'bz;
/*-----------------------------------*/

/*-------Debug Signals----------------*/
(* mark_debug = "true", keep= "true", dont_touch = "true" *) wire                        w_dbg_mdio_tx    = r_mdio_out;
(* mark_debug = "true", keep= "true", dont_touch = "true" *) wire                        w_dbg_mdio_rx    = mdio;
(* mark_debug = "true", keep= "true", dont_touch = "true" *) wire                        w_dbg_mdio_en    = r_mdio_en;
(* mark_debug = "true", keep= "true", dont_touch = "true" *) wire                        w_dbg_mdc        = mdc;
(* mark_debug = "true", keep= "true", dont_touch = "true" *) wire                        w_dbg_mdc_re     = r_mdc_re;
(* mark_debug = "true", keep= "true", dont_touch = "true" *) wire                        w_dbg_mdc_fe     = r_mdc_fe;
(* mark_debug = "true", keep= "true", dont_touch = "true" *) wire [1:0]                  w_dbg_sm_main    = sm_main;
(* mark_debug = "true", keep= "true", dont_touch = "true" *) wire                        w_dbg_wr_done    = wr_done;
(* mark_debug = "true", keep= "true", dont_touch = "true" *) wire                        w_dbg_rd_done    = rd_done;
(* mark_debug = "true", keep= "true", dont_touch = "true" *) wire [$clog2(TOTAL_BITS):0] w_dbg_bit_count  = r_bit_count;
(* mark_debug = "true", keep= "true", dont_touch = "true" *) wire [17:0]                 w_dbg_r_rd_data  = r_rd_data;
(* mark_debug = "true", keep= "true", dont_touch = "true" *) wire [15:0]                 w_dbg_rd_data    = rd_data;
(* mark_debug = "true", keep= "true", dont_touch = "true" *) wire [63:0]                 w_dbgr_tx_reg    = r_tx_reg;

/*------------------------------------*/

endmodule
