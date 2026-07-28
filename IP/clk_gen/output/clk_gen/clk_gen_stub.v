// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Tue Jul 28 00:54:10 2026
// Host        : aujusDSP1 running 64-bit Ubuntu 20.04.6 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/aujus_dsp_1/Documents/Learning/gigabit_ethernet/IP/clk_gen/output/clk_gen/clk_gen_stub.v
// Design      : clk_gen
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_gen(clk_100, clk_125, clk_in1_p, clk_in1_n)
/* synthesis syn_black_box black_box_pad_pin="clk_100,clk_125,clk_in1_p,clk_in1_n" */;
  output clk_100;
  output clk_125;
  input clk_in1_p;
  input clk_in1_n;
endmodule
