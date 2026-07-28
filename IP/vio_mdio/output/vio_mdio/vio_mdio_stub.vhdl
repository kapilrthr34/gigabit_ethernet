-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
-- Date        : Tue Jul 28 00:54:22 2026
-- Host        : aujusDSP1 running 64-bit Ubuntu 20.04.6 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/aujus_dsp_1/Documents/Learning/gigabit_ethernet/IP/vio_mdio/output/vio_mdio/vio_mdio_stub.vhdl
-- Design      : vio_mdio
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tfgg484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vio_mdio is
  Port ( 
    clk : in STD_LOGIC;
    probe_in0 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe_in1 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe_out0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out1 : out STD_LOGIC_VECTOR ( 4 downto 0 );
    probe_out2 : out STD_LOGIC_VECTOR ( 4 downto 0 );
    probe_out3 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out4 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out5 : out STD_LOGIC_VECTOR ( 15 downto 0 );
    probe_out6 : out STD_LOGIC_VECTOR ( 0 to 0 )
  );

end vio_mdio;

architecture stub of vio_mdio is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_in0[15:0],probe_in1[15:0],probe_out0[0:0],probe_out1[4:0],probe_out2[4:0],probe_out3[0:0],probe_out4[0:0],probe_out5[15:0],probe_out6[0:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2020.2";
begin
end;
