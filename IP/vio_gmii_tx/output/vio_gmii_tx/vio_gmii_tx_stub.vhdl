-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
-- Date        : Tue Jul 28 00:54:34 2026
-- Host        : aujusDSP1 running 64-bit Ubuntu 20.04.6 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/aujus_dsp_1/Documents/Learning/gigabit_ethernet/IP/vio_gmii_tx/output/vio_gmii_tx/vio_gmii_tx_stub.vhdl
-- Design      : vio_gmii_tx
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tfgg484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vio_gmii_tx is
  Port ( 
    clk : in STD_LOGIC;
    probe_in0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out1 : out STD_LOGIC_VECTOR ( 47 downto 0 );
    probe_out2 : out STD_LOGIC_VECTOR ( 47 downto 0 );
    probe_out3 : out STD_LOGIC_VECTOR ( 15 downto 0 );
    probe_out4 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    probe_out5 : out STD_LOGIC_VECTOR ( 0 to 0 )
  );

end vio_gmii_tx;

architecture stub of vio_gmii_tx is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_in0[0:0],probe_out0[0:0],probe_out1[47:0],probe_out2[47:0],probe_out3[15:0],probe_out4[31:0],probe_out5[0:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2020.2";
begin
end;
