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


