// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Tue Jul 28 00:54:22 2026
// Host        : aujusDSP1 running 64-bit Ubuntu 20.04.6 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/aujus_dsp_1/Documents/Learning/gigabit_ethernet/IP/vio_mdio/output/vio_mdio/vio_mdio_stub.v
// Design      : vio_mdio
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2020.2" *)
module vio_mdio(clk, probe_in0, probe_in1, probe_out0, 
  probe_out1, probe_out2, probe_out3, probe_out4, probe_out5, probe_out6)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[15:0],probe_in1[15:0],probe_out0[0:0],probe_out1[4:0],probe_out2[4:0],probe_out3[0:0],probe_out4[0:0],probe_out5[15:0],probe_out6[0:0]" */;
  input clk;
  input [15:0]probe_in0;
  input [15:0]probe_in1;
  output [0:0]probe_out0;
  output [4:0]probe_out1;
  output [4:0]probe_out2;
  output [0:0]probe_out3;
  output [0:0]probe_out4;
  output [15:0]probe_out5;
  output [0:0]probe_out6;
endmodule
