puts "Creating IPs"

## Clock Generation
puts "Generating clk_gen IP"
source "$IP_DIR/clk_gen/create_clk_gen.tcl"

## VIO MDIO
puts "Generating vio_mdio IP"
source "$IP_DIR/vio_mdio/vio_mdio.tcl"

## VIO GMII_Tx
puts "Generating vio_gmii_tx IP"
source "$IP_DIR/vio_gmii_tx/vio_gmii_tx.tcl"

## VIO GMII_Rx
puts "Generating vio_gmii_rx IP"
source "$IP_DIR/vio_gmii_rx/vio_gmii_rx.tcl"

puts "Done creating IPs"
