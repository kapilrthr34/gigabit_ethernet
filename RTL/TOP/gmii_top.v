`timescale 1ns / 1ps

module gmii_top(
input               clk_in1_p,
input               clk_in1_n,

output              mdc_0,
inout               mdio_0,
output              mdc_1,
inout               mdio_1,
output              phy_rst_0,
output              phy_rst_1,

output [7:0]        gmii_txd,
output              gmii_tx_en,
output              gmii_tx_er,
output              gmii_tx_clk,

/*   rcvr ports */
input wire          eth_rx_clk,
input wire [7:0]    eth_rxd,
input wire          eth_rx_dv,
input wire          eth_rx_er
);


/*------Clock Generation----------------*/
wire w_clk_100;
wire w_clk_125;

clk_gen u_clk_gen
(
.clk_100(w_clk_100),        // output clk_100
.clk_125(w_clk_125),        // output clk_125
.clk_in1_p(clk_in1_p),      // input clk_in1_p
.clk_in1_n(clk_in1_n)
);
assign gmii_tx_clk = w_clk_125;
/*-------------------------------------*/



/*------MDIO Instantiation---------------------------------------*/
wire            w_rst_100;
wire [4:0]      phy_addr;
wire [4:0]      reg_addr;
wire            wr_init;
wire            rd_init;
wire [15:0]     wr_data;

wire [15:0]     rd_data_0;
wire            wr_done_0;
wire            rd_done_0;

wire [15:0]     rd_data_1;
wire            wr_done_1;
wire            rd_done_1;

// MDIO VIO Instance
vio_mdio u_vio_mdio (
    .clk        (w_clk_100),
    // Inputs to VIO (visible in HW Manager)
    .probe_in0  (rd_data_0),
    .probe_in1  (rd_data_1),
    // Outputs from VIO
    .probe_out0 (w_rst_100),
    .probe_out1 (phy_addr),
    .probe_out2 (reg_addr),
    .probe_out3 (wr_init),
    .probe_out4 (rd_init),
    .probe_out5 (wr_data),
    .probe_out6 (phy_rst)
    );
assign phy_rst_0 = phy_rst;
assign phy_rst_1 = phy_rst;

// MDIO Interface Instance
mdio u_mdio_inst_0 (
    .clk      (w_clk_100),
    .rst      (w_rst_100),
    .phy_addr (phy_addr),
    .reg_addr (reg_addr),
    .wr_init  (wr_init),
    .rd_init  (rd_init),
    .wr_data  (wr_data),
    .rd_data  (rd_data_0),
    .wr_done  (wr_done_0),
    .rd_done  (rd_done_0),
    .mdc      (mdc_0),
    .mdio     (mdio_0)
);

mdio u_mdio_inst_1 (
    .clk      (w_clk_100),
    .rst      (w_rst_100),
    .phy_addr (phy_addr),
    .reg_addr (reg_addr),
    .wr_init  (wr_init),
    .rd_init  (rd_init),
    .wr_data  (wr_data),
    .rd_data  (rd_data_1),
    .wr_done  (wr_done_1),
    .rd_done  (rd_done_1),
    .mdc      (mdc_1),
    .mdio     (mdio_1)
);
/*------------------------------------------------------------------------------------*/

/*-----GMII Interface------------------*/
wire w_rst_125;
wire [47:0] w_src_addr;
wire [47:0] w_dest_addr;
wire [15:0] w_eth_type;
wire [31:0] w_burst_len;   // repurposed from the old manually-entered "crc" VIO
                            // probe -- CRC is now computed in hardware, so this
                            // 32-bit probe now sets how many back-to-back frames
                            // to send per trigger.
wire        w_tx_en;
wire        w_tx_done;
wire        w_burst_done;

// GMII Tx VIO
vio_gmii_tx u_vio_tx_gmii (
  .clk          (w_clk_125),                // input wire clk
  .probe_in0    (w_burst_done), // input wire [0 : 0] probe_in0 -- pulses once the WHOLE burst is sent
  .probe_out0   (w_rst_125),  // output wire [0 : 0] probe_out0
  .probe_out1   (w_dest_addr),  // output wire [47 : 0] probe_out1
  .probe_out2   (w_src_addr),  // output wire [47 : 0] probe_out2
  .probe_out3   (w_eth_type),  // output wire [15 : 0] probe_out3
  .probe_out4   (w_burst_len),  // output wire [31 : 0] probe_out4 (was w_crc)
  .probe_out5   (w_tx_en)  // output wire [0 : 0] probe_out5
);

gmii_tx u_gmii_inst(
.clk        (w_clk_125),
.rst        (w_rst_125),
.src_addr   (w_src_addr),
.dest_addr  (w_dest_addr),
.eth_type   (w_eth_type),
.burst_len  (w_burst_len),
.tx_en      (w_tx_en),
.gmii_txd   (gmii_txd),
.gmii_tx_en (gmii_tx_en),
.gmii_tx_er (gmii_tx_er),
.tx_done    (w_tx_done),
.burst_done (w_burst_done)
);

/*----------------------------------------*/

wire eth_rx_er_ibuf;

IBUF u_ibuf (
    .I(eth_rx_er),      // External FPGA pin
    .O(eth_rx_er_ibuf)     // Internal FPGA signal
);

/*------RCVR  Instantiation-------------*/
wire        eth_rst_n;
vio_gmii_rx u_vio_rx (
  .clk(eth_rx_clk),                // input wire clk
  .probe_out0(eth_rst_n)  // output wire [0 : 0] probe_out0
);
gmii_rx u_eth_rx
(
    .rx_clk (eth_rx_clk),
    .rst_n  (eth_rst_n),

    .rxd    (eth_rxd),
    .rx_dv  (eth_rx_dv),
    .rx_er  (eth_rx_er_ibuf)
);
/*-------------------------------------*/



endmodule
