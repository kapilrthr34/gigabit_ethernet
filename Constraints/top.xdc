###############################################################################
# hello_eth_top constraints  (AX7101 / Artix-7 XC7A100T, RTL8211EG PHYs)
#
#   E1 PHY  -> TRANSMITTER  (driven from FPGA GMII TX, controlled via VIO)
#   E2 PHY  -> RECEIVER     (GMII RX captured in FPGA, observed via ILA)
#
# Cable loopback: E1 RJ-45  <---->  E2 RJ-45
#
# All Ethernet I/O is 3.3V (RTL8211EG SELRGV strap = 3.3V) -> LVCMOS33.
# Pin numbers taken from AX7101 User Manual, Part 3.2 (channels E1 & E2).
###############################################################################

#=============================================================================#
# Clock constraints
#=============================================================================#
# E2 GMII receive clock from the PHY (125 MHz for 1000BASE-T) -> eth_rx_clk
create_clock -period 8.000 -name eth_rx_clk [get_ports eth_rx_clk]

# NOTE: E2_RXC (J20) may not be on a clock-capable (MRCC/SRCC) pin. If
# implementation errors with a CLOCK_DEDICATED_ROUTE DRC, uncomment the line
# below to allow the RX clock onto a regional/backbone route:
# set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets eth_rx_clk_IBUF]

#=============================================================================#
# System / configuration clock input (feeds clk_wiz_0 -> 100 MHz + 125 MHz)
#=============================================================================#
set_property PACKAGE_PIN R4 [get_ports clk_in1_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_in1_p]

#=============================================================================#
# E1 PHY  --  TRANSMITTER  (GMII TX)
#=============================================================================#
set_property PACKAGE_PIN G21 [get_ports gmii_tx_clk]
set_property IOSTANDARD LVCMOS33 [get_ports gmii_tx_clk]

set_property PACKAGE_PIN D22 [get_ports {gmii_txd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gmii_txd[0]}]
set_property PACKAGE_PIN H20 [get_ports {gmii_txd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gmii_txd[1]}]
set_property PACKAGE_PIN H22 [get_ports {gmii_txd[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gmii_txd[2]}]
set_property PACKAGE_PIN J22 [get_ports {gmii_txd[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gmii_txd[3]}]
set_property PACKAGE_PIN K22 [get_ports {gmii_txd[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gmii_txd[4]}]
set_property PACKAGE_PIN L19 [get_ports {gmii_txd[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gmii_txd[5]}]
set_property PACKAGE_PIN K19 [get_ports {gmii_txd[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gmii_txd[6]}]
set_property PACKAGE_PIN L20 [get_ports {gmii_txd[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gmii_txd[7]}]

set_property PACKAGE_PIN G22 [get_ports gmii_tx_en]
set_property IOSTANDARD LVCMOS33 [get_ports gmii_tx_en]
set_property PACKAGE_PIN K17 [get_ports gmii_tx_er]
set_property IOSTANDARD LVCMOS33 [get_ports gmii_tx_er]

#=============================================================================#
# E1 PHY  --  MDIO management + reset  (mdio_interface u_mdio_inst_0)
#=============================================================================#
set_property PACKAGE_PIN J17 [get_ports mdc_0]
set_property IOSTANDARD LVCMOS33 [get_ports mdc_0]
set_property PACKAGE_PIN L16 [get_ports mdio_0]
set_property IOSTANDARD LVCMOS33 [get_ports mdio_0]
set_property PACKAGE_PIN G20 [get_ports phy_rst_0]
set_property IOSTANDARD LVCMOS33 [get_ports phy_rst_0]

#=============================================================================#
# E2 PHY  --  RECEIVER  (GMII RX)   *** NEW ***
#=============================================================================#
set_property PACKAGE_PIN J20 [get_ports eth_rx_clk]
set_property IOSTANDARD LVCMOS33 [get_ports eth_rx_clk]

set_property PACKAGE_PIN M13 [get_ports {eth_rxd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[0]}]
set_property PACKAGE_PIN K14 [get_ports {eth_rxd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[1]}]
set_property PACKAGE_PIN K13 [get_ports {eth_rxd[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[2]}]
set_property PACKAGE_PIN J14 [get_ports {eth_rxd[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[3]}]
set_property PACKAGE_PIN H14 [get_ports {eth_rxd[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[4]}]
set_property PACKAGE_PIN H15 [get_ports {eth_rxd[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[5]}]
set_property PACKAGE_PIN J15 [get_ports {eth_rxd[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[6]}]
set_property PACKAGE_PIN H13 [get_ports {eth_rxd[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[7]}]

set_property PACKAGE_PIN L13 [get_ports eth_rx_dv]
set_property IOSTANDARD LVCMOS33 [get_ports eth_rx_dv]
set_property PACKAGE_PIN G13 [get_ports eth_rx_er]
set_property IOSTANDARD LVCMOS33 [get_ports eth_rx_er]

#=============================================================================#
# E2 PHY  --  MDIO management + reset  (mdio_interface u_mdio_inst_1)   *** NEW ***
#=============================================================================#
set_property PACKAGE_PIN AB21 [get_ports mdc_1]
set_property IOSTANDARD LVCMOS33 [get_ports mdc_1]
set_property PACKAGE_PIN AB22 [get_ports mdio_1]
set_property IOSTANDARD LVCMOS33 [get_ports mdio_1]
set_property PACKAGE_PIN L14 [get_ports phy_rst_1]
set_property IOSTANDARD LVCMOS33 [get_ports phy_rst_1]

#=============================================================================#
# Debug cores
#=============================================================================#
# The old top_constraints.xdc contained an auto-generated debug block
# (create_debug_core / connect_debug_port for u_ila_0, u_ila_1, dbg_hub).
# It is intentionally NOT copied here: it referenced instance/net names that
# no longer exist in hello_eth_top (u_mdio_interface, u_mdio_inst,
# u_clk_wiz/inst/clk_out1, clk_100m, ...) and would fail implementation.
#
# eth_rx.v already flags rxd / rx_dv / rx_er with (* mark_debug = "true" *).
# To view the RX pattern: open the synthesized design -> Set Up Debug, assign
# eth_rx_clk as the debug clock for these nets. Vivado will (re)generate the
# correct connect_debug_port constraints automatically.
###############################################################################

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list instance_name/inst/clk_100]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {u_mdio_inst_0/w_dbg_rd_data[0]} {u_mdio_inst_0/w_dbg_rd_data[1]} {u_mdio_inst_0/w_dbg_rd_data[2]} {u_mdio_inst_0/w_dbg_rd_data[3]} {u_mdio_inst_0/w_dbg_rd_data[4]} {u_mdio_inst_0/w_dbg_rd_data[5]} {u_mdio_inst_0/w_dbg_rd_data[6]} {u_mdio_inst_0/w_dbg_rd_data[7]} {u_mdio_inst_0/w_dbg_rd_data[8]} {u_mdio_inst_0/w_dbg_rd_data[9]} {u_mdio_inst_0/w_dbg_rd_data[10]} {u_mdio_inst_0/w_dbg_rd_data[11]} {u_mdio_inst_0/w_dbg_rd_data[12]} {u_mdio_inst_0/w_dbg_rd_data[13]} {u_mdio_inst_0/w_dbg_rd_data[14]} {u_mdio_inst_0/w_dbg_rd_data[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 18 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {u_mdio_inst_1/w_dbg_r_rd_data[0]} {u_mdio_inst_1/w_dbg_r_rd_data[1]} {u_mdio_inst_1/w_dbg_r_rd_data[2]} {u_mdio_inst_1/w_dbg_r_rd_data[3]} {u_mdio_inst_1/w_dbg_r_rd_data[4]} {u_mdio_inst_1/w_dbg_r_rd_data[5]} {u_mdio_inst_1/w_dbg_r_rd_data[6]} {u_mdio_inst_1/w_dbg_r_rd_data[7]} {u_mdio_inst_1/w_dbg_r_rd_data[8]} {u_mdio_inst_1/w_dbg_r_rd_data[9]} {u_mdio_inst_1/w_dbg_r_rd_data[10]} {u_mdio_inst_1/w_dbg_r_rd_data[11]} {u_mdio_inst_1/w_dbg_r_rd_data[12]} {u_mdio_inst_1/w_dbg_r_rd_data[13]} {u_mdio_inst_1/w_dbg_r_rd_data[14]} {u_mdio_inst_1/w_dbg_r_rd_data[15]} {u_mdio_inst_1/w_dbg_r_rd_data[16]} {u_mdio_inst_1/w_dbg_r_rd_data[17]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {u_mdio_inst_1/w_dbg_rd_data[0]} {u_mdio_inst_1/w_dbg_rd_data[1]} {u_mdio_inst_1/w_dbg_rd_data[2]} {u_mdio_inst_1/w_dbg_rd_data[3]} {u_mdio_inst_1/w_dbg_rd_data[4]} {u_mdio_inst_1/w_dbg_rd_data[5]} {u_mdio_inst_1/w_dbg_rd_data[6]} {u_mdio_inst_1/w_dbg_rd_data[7]} {u_mdio_inst_1/w_dbg_rd_data[8]} {u_mdio_inst_1/w_dbg_rd_data[9]} {u_mdio_inst_1/w_dbg_rd_data[10]} {u_mdio_inst_1/w_dbg_rd_data[11]} {u_mdio_inst_1/w_dbg_rd_data[12]} {u_mdio_inst_1/w_dbg_rd_data[13]} {u_mdio_inst_1/w_dbg_rd_data[14]} {u_mdio_inst_1/w_dbg_rd_data[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 64 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {u_mdio_inst_0/w_dbgr_tx_reg[0]} {u_mdio_inst_0/w_dbgr_tx_reg[1]} {u_mdio_inst_0/w_dbgr_tx_reg[2]} {u_mdio_inst_0/w_dbgr_tx_reg[3]} {u_mdio_inst_0/w_dbgr_tx_reg[4]} {u_mdio_inst_0/w_dbgr_tx_reg[5]} {u_mdio_inst_0/w_dbgr_tx_reg[6]} {u_mdio_inst_0/w_dbgr_tx_reg[7]} {u_mdio_inst_0/w_dbgr_tx_reg[8]} {u_mdio_inst_0/w_dbgr_tx_reg[9]} {u_mdio_inst_0/w_dbgr_tx_reg[10]} {u_mdio_inst_0/w_dbgr_tx_reg[11]} {u_mdio_inst_0/w_dbgr_tx_reg[12]} {u_mdio_inst_0/w_dbgr_tx_reg[13]} {u_mdio_inst_0/w_dbgr_tx_reg[14]} {u_mdio_inst_0/w_dbgr_tx_reg[15]} {u_mdio_inst_0/w_dbgr_tx_reg[16]} {u_mdio_inst_0/w_dbgr_tx_reg[17]} {u_mdio_inst_0/w_dbgr_tx_reg[18]} {u_mdio_inst_0/w_dbgr_tx_reg[19]} {u_mdio_inst_0/w_dbgr_tx_reg[20]} {u_mdio_inst_0/w_dbgr_tx_reg[21]} {u_mdio_inst_0/w_dbgr_tx_reg[22]} {u_mdio_inst_0/w_dbgr_tx_reg[23]} {u_mdio_inst_0/w_dbgr_tx_reg[24]} {u_mdio_inst_0/w_dbgr_tx_reg[25]} {u_mdio_inst_0/w_dbgr_tx_reg[26]} {u_mdio_inst_0/w_dbgr_tx_reg[27]} {u_mdio_inst_0/w_dbgr_tx_reg[28]} {u_mdio_inst_0/w_dbgr_tx_reg[29]} {u_mdio_inst_0/w_dbgr_tx_reg[30]} {u_mdio_inst_0/w_dbgr_tx_reg[31]} {u_mdio_inst_0/w_dbgr_tx_reg[32]} {u_mdio_inst_0/w_dbgr_tx_reg[33]} {u_mdio_inst_0/w_dbgr_tx_reg[34]} {u_mdio_inst_0/w_dbgr_tx_reg[35]} {u_mdio_inst_0/w_dbgr_tx_reg[36]} {u_mdio_inst_0/w_dbgr_tx_reg[37]} {u_mdio_inst_0/w_dbgr_tx_reg[38]} {u_mdio_inst_0/w_dbgr_tx_reg[39]} {u_mdio_inst_0/w_dbgr_tx_reg[40]} {u_mdio_inst_0/w_dbgr_tx_reg[41]} {u_mdio_inst_0/w_dbgr_tx_reg[42]} {u_mdio_inst_0/w_dbgr_tx_reg[43]} {u_mdio_inst_0/w_dbgr_tx_reg[44]} {u_mdio_inst_0/w_dbgr_tx_reg[45]} {u_mdio_inst_0/w_dbgr_tx_reg[46]} {u_mdio_inst_0/w_dbgr_tx_reg[47]} {u_mdio_inst_0/w_dbgr_tx_reg[48]} {u_mdio_inst_0/w_dbgr_tx_reg[49]} {u_mdio_inst_0/w_dbgr_tx_reg[50]} {u_mdio_inst_0/w_dbgr_tx_reg[51]} {u_mdio_inst_0/w_dbgr_tx_reg[52]} {u_mdio_inst_0/w_dbgr_tx_reg[53]} {u_mdio_inst_0/w_dbgr_tx_reg[54]} {u_mdio_inst_0/w_dbgr_tx_reg[55]} {u_mdio_inst_0/w_dbgr_tx_reg[56]} {u_mdio_inst_0/w_dbgr_tx_reg[57]} {u_mdio_inst_0/w_dbgr_tx_reg[58]} {u_mdio_inst_0/w_dbgr_tx_reg[59]} {u_mdio_inst_0/w_dbgr_tx_reg[60]} {u_mdio_inst_0/w_dbgr_tx_reg[61]} {u_mdio_inst_0/w_dbgr_tx_reg[62]} {u_mdio_inst_0/w_dbgr_tx_reg[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 64 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {u_mdio_inst_1/w_dbgr_tx_reg[0]} {u_mdio_inst_1/w_dbgr_tx_reg[1]} {u_mdio_inst_1/w_dbgr_tx_reg[2]} {u_mdio_inst_1/w_dbgr_tx_reg[3]} {u_mdio_inst_1/w_dbgr_tx_reg[4]} {u_mdio_inst_1/w_dbgr_tx_reg[5]} {u_mdio_inst_1/w_dbgr_tx_reg[6]} {u_mdio_inst_1/w_dbgr_tx_reg[7]} {u_mdio_inst_1/w_dbgr_tx_reg[8]} {u_mdio_inst_1/w_dbgr_tx_reg[9]} {u_mdio_inst_1/w_dbgr_tx_reg[10]} {u_mdio_inst_1/w_dbgr_tx_reg[11]} {u_mdio_inst_1/w_dbgr_tx_reg[12]} {u_mdio_inst_1/w_dbgr_tx_reg[13]} {u_mdio_inst_1/w_dbgr_tx_reg[14]} {u_mdio_inst_1/w_dbgr_tx_reg[15]} {u_mdio_inst_1/w_dbgr_tx_reg[16]} {u_mdio_inst_1/w_dbgr_tx_reg[17]} {u_mdio_inst_1/w_dbgr_tx_reg[18]} {u_mdio_inst_1/w_dbgr_tx_reg[19]} {u_mdio_inst_1/w_dbgr_tx_reg[20]} {u_mdio_inst_1/w_dbgr_tx_reg[21]} {u_mdio_inst_1/w_dbgr_tx_reg[22]} {u_mdio_inst_1/w_dbgr_tx_reg[23]} {u_mdio_inst_1/w_dbgr_tx_reg[24]} {u_mdio_inst_1/w_dbgr_tx_reg[25]} {u_mdio_inst_1/w_dbgr_tx_reg[26]} {u_mdio_inst_1/w_dbgr_tx_reg[27]} {u_mdio_inst_1/w_dbgr_tx_reg[28]} {u_mdio_inst_1/w_dbgr_tx_reg[29]} {u_mdio_inst_1/w_dbgr_tx_reg[30]} {u_mdio_inst_1/w_dbgr_tx_reg[31]} {u_mdio_inst_1/w_dbgr_tx_reg[32]} {u_mdio_inst_1/w_dbgr_tx_reg[33]} {u_mdio_inst_1/w_dbgr_tx_reg[34]} {u_mdio_inst_1/w_dbgr_tx_reg[35]} {u_mdio_inst_1/w_dbgr_tx_reg[36]} {u_mdio_inst_1/w_dbgr_tx_reg[37]} {u_mdio_inst_1/w_dbgr_tx_reg[38]} {u_mdio_inst_1/w_dbgr_tx_reg[39]} {u_mdio_inst_1/w_dbgr_tx_reg[40]} {u_mdio_inst_1/w_dbgr_tx_reg[41]} {u_mdio_inst_1/w_dbgr_tx_reg[42]} {u_mdio_inst_1/w_dbgr_tx_reg[43]} {u_mdio_inst_1/w_dbgr_tx_reg[44]} {u_mdio_inst_1/w_dbgr_tx_reg[45]} {u_mdio_inst_1/w_dbgr_tx_reg[46]} {u_mdio_inst_1/w_dbgr_tx_reg[47]} {u_mdio_inst_1/w_dbgr_tx_reg[48]} {u_mdio_inst_1/w_dbgr_tx_reg[49]} {u_mdio_inst_1/w_dbgr_tx_reg[50]} {u_mdio_inst_1/w_dbgr_tx_reg[51]} {u_mdio_inst_1/w_dbgr_tx_reg[52]} {u_mdio_inst_1/w_dbgr_tx_reg[53]} {u_mdio_inst_1/w_dbgr_tx_reg[54]} {u_mdio_inst_1/w_dbgr_tx_reg[55]} {u_mdio_inst_1/w_dbgr_tx_reg[56]} {u_mdio_inst_1/w_dbgr_tx_reg[57]} {u_mdio_inst_1/w_dbgr_tx_reg[58]} {u_mdio_inst_1/w_dbgr_tx_reg[59]} {u_mdio_inst_1/w_dbgr_tx_reg[60]} {u_mdio_inst_1/w_dbgr_tx_reg[61]} {u_mdio_inst_1/w_dbgr_tx_reg[62]} {u_mdio_inst_1/w_dbgr_tx_reg[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 2 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {u_mdio_inst_1/w_dbg_sm_main[0]} {u_mdio_inst_1/w_dbg_sm_main[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 7 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {u_mdio_inst_1/w_dbg_bit_count[0]} {u_mdio_inst_1/w_dbg_bit_count[1]} {u_mdio_inst_1/w_dbg_bit_count[2]} {u_mdio_inst_1/w_dbg_bit_count[3]} {u_mdio_inst_1/w_dbg_bit_count[4]} {u_mdio_inst_1/w_dbg_bit_count[5]} {u_mdio_inst_1/w_dbg_bit_count[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 18 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {u_mdio_inst_0/w_dbg_r_rd_data[0]} {u_mdio_inst_0/w_dbg_r_rd_data[1]} {u_mdio_inst_0/w_dbg_r_rd_data[2]} {u_mdio_inst_0/w_dbg_r_rd_data[3]} {u_mdio_inst_0/w_dbg_r_rd_data[4]} {u_mdio_inst_0/w_dbg_r_rd_data[5]} {u_mdio_inst_0/w_dbg_r_rd_data[6]} {u_mdio_inst_0/w_dbg_r_rd_data[7]} {u_mdio_inst_0/w_dbg_r_rd_data[8]} {u_mdio_inst_0/w_dbg_r_rd_data[9]} {u_mdio_inst_0/w_dbg_r_rd_data[10]} {u_mdio_inst_0/w_dbg_r_rd_data[11]} {u_mdio_inst_0/w_dbg_r_rd_data[12]} {u_mdio_inst_0/w_dbg_r_rd_data[13]} {u_mdio_inst_0/w_dbg_r_rd_data[14]} {u_mdio_inst_0/w_dbg_r_rd_data[15]} {u_mdio_inst_0/w_dbg_r_rd_data[16]} {u_mdio_inst_0/w_dbg_r_rd_data[17]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 2 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {u_mdio_inst_0/w_dbg_sm_main[0]} {u_mdio_inst_0/w_dbg_sm_main[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 7 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {u_mdio_inst_0/w_dbg_bit_count[0]} {u_mdio_inst_0/w_dbg_bit_count[1]} {u_mdio_inst_0/w_dbg_bit_count[2]} {u_mdio_inst_0/w_dbg_bit_count[3]} {u_mdio_inst_0/w_dbg_bit_count[4]} {u_mdio_inst_0/w_dbg_bit_count[5]} {u_mdio_inst_0/w_dbg_bit_count[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list u_mdio_inst_0/w_dbg_mdc]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list u_mdio_inst_1/w_dbg_mdc]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list u_mdio_inst_1/w_dbg_mdc_fe]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list u_mdio_inst_0/w_dbg_mdc_fe]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list u_mdio_inst_1/w_dbg_mdc_re]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list u_mdio_inst_0/w_dbg_mdc_re]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list u_mdio_inst_1/w_dbg_mdio_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list u_mdio_inst_0/w_dbg_mdio_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list u_mdio_inst_1/w_dbg_mdio_rx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list u_mdio_inst_0/w_dbg_mdio_rx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list u_mdio_inst_0/w_dbg_mdio_tx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list u_mdio_inst_1/w_dbg_mdio_tx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list u_mdio_inst_0/w_dbg_rd_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list u_mdio_inst_1/w_dbg_rd_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list u_mdio_inst_1/w_dbg_wr_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list u_mdio_inst_0/w_dbg_wr_done]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list instance_name/inst/clk_125]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 8 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {u_gmii_inst/w_dbg_gmii_txd[0]} {u_gmii_inst/w_dbg_gmii_txd[1]} {u_gmii_inst/w_dbg_gmii_txd[2]} {u_gmii_inst/w_dbg_gmii_txd[3]} {u_gmii_inst/w_dbg_gmii_txd[4]} {u_gmii_inst/w_dbg_gmii_txd[5]} {u_gmii_inst/w_dbg_gmii_txd[6]} {u_gmii_inst/w_dbg_gmii_txd[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 1 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list u_gmii_inst/w_dbg_gmii_tx_en]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 1 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list u_gmii_inst/w_dbg_gmii_tx_er]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 1 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list u_gmii_inst/w_dbg_tx_done]]
create_debug_core u_ila_2 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_2]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_2]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_2]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_2]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_2]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_2]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_2]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_2]
set_property port_width 1 [get_debug_ports u_ila_2/clk]
connect_debug_port u_ila_2/clk [get_nets [list eth_rx_clk_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe0]
set_property port_width 3 [get_debug_ports u_ila_2/probe0]
connect_debug_port u_ila_2/probe0 [get_nets [list {u_eth_rx/w_dbg_rx_state[0]} {u_eth_rx/w_dbg_rx_state[1]} {u_eth_rx/w_dbg_rx_state[2]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe1]
set_property port_width 8 [get_debug_ports u_ila_2/probe1]
connect_debug_port u_ila_2/probe1 [get_nets [list {u_eth_rx/w_dbg_rxd[0]} {u_eth_rx/w_dbg_rxd[1]} {u_eth_rx/w_dbg_rxd[2]} {u_eth_rx/w_dbg_rxd[3]} {u_eth_rx/w_dbg_rxd[4]} {u_eth_rx/w_dbg_rxd[5]} {u_eth_rx/w_dbg_rxd[6]} {u_eth_rx/w_dbg_rxd[7]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe2]
set_property port_width 1 [get_debug_ports u_ila_2/probe2]
connect_debug_port u_ila_2/probe2 [get_nets [list u_eth_rx/w_dbg_rx_dv]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe3]
set_property port_width 1 [get_debug_ports u_ila_2/probe3]
connect_debug_port u_ila_2/probe3 [get_nets [list u_eth_rx/w_dbg_rx_er]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets gmii_tx_clk_OBUF]
