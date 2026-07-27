####################################################
# Debug Probe Insertion
# Must run AFTER synth_design, BEFORE opt_design.
####################################################

puts ""
puts "========================================="
puts "Adding Debug Probes..."
puts "========================================="

proc dbg_bus {pattern} {
    set nets [get_nets -hierarchical -filter "MARK_DEBUG && NAME =~ \"$pattern\""]
    set indexed {}
    foreach n $nets {
        set nm [get_property NAME $n]
        if {[regexp {\[(\d+)\]$} $nm -> idx]} {
            lappend indexed [list $idx $nm]
        } else {
            lappend indexed [list 0 $nm]
        }
    }
    set result {}
    foreach pair [lsort -integer -index 0 $indexed] {
        lappend result [lindex $pair 1]
    }
    if {[llength $result] == 0} {
        error "dbg_bus: no MARK_DEBUG nets matched pattern '$pattern'"
    }
    return $result
}

proc dbg_clk {pin} {
    set p [get_pins -quiet $pin]
    if {$p eq ""} {
        error "dbg_clk: pin '$pin' does not exist in the synthesized design"
    }
    set n [get_nets -of_objects $p]
    if {$n eq ""} {
        error "dbg_clk: pin '$pin' has no driving net"
    }
    return $n
}

proc add_probe {core idx pattern} {
    if {$idx > 0} { create_debug_port $core probe }
    set nets [dbg_bus $pattern]
    set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports $core/probe$idx]
    set_property port_width [llength $nets] [get_debug_ports $core/probe$idx]
    connect_debug_port $core/probe$idx $nets
    puts "  probe$idx <- $pattern ([llength $nets] bit(s))"
}

####################################################
# RX domain -- eth_rx_clk
####################################################
puts "Creating u_ila_rx"
create_debug_core u_ila_rx ila
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_rx]
set_property port_width 1 [get_debug_ports u_ila_rx/clk]
connect_debug_port u_ila_rx/clk [dbg_clk u_eth_rx/rx_clk]

add_probe u_ila_rx 0 {*w_dbg_rxd*}
add_probe u_ila_rx 1 {*w_dbg_rx_dv*}
add_probe u_ila_rx 2 {*w_dbg_rx_er*}
add_probe u_ila_rx 3 {*w_dbg_rx_state*}

####################################################
# TX domain -- clk_125_clk_gen
####################################################
puts "Creating u_ila_tx"
create_debug_core u_ila_tx ila
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_tx]
set_property port_width 1 [get_debug_ports u_ila_tx/clk]
connect_debug_port u_ila_tx/clk [dbg_clk u_gmii_inst/clk]

add_probe u_ila_tx 0 {*w_dbg_gmii_txd*}
add_probe u_ila_tx 1 {*w_dbg_gmii_tx_en*}
add_probe u_ila_tx 2 {*w_dbg_gmii_tx_er*}
add_probe u_ila_tx 3 {*w_dbg_tx_done*}

####################################################
# MDIO domain -- clk_100_clk_gen  (both instances share one core)
####################################################
puts "Creating u_ila_mdio"
create_debug_core u_ila_mdio ila
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_mdio]
set_property port_width 1 [get_debug_ports u_ila_mdio/clk]
connect_debug_port u_ila_mdio/clk [dbg_clk u_mdio_inst_0/clk]

add_probe u_ila_mdio 0 {u_mdio_inst_0/w_dbg_mdc}
add_probe u_ila_mdio 1 {u_mdio_inst_0/w_dbg_mdio_tx*}
add_probe u_ila_mdio 2 {u_mdio_inst_0/w_dbg_mdio_rx*}
add_probe u_ila_mdio 3 {u_mdio_inst_0/w_dbg_sm_main*}
add_probe u_ila_mdio 4 {u_mdio_inst_0/w_dbg_rd_data*}
add_probe u_ila_mdio 5 {u_mdio_inst_0/w_dbg_wr_done*}
add_probe u_ila_mdio 6 {u_mdio_inst_0/w_dbg_rd_done*}

puts ""
puts "Debug Probes Added Successfully."
puts ""
