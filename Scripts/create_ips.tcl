# Clear all exisiting IP directories
foreach ip_dir {clk_gen vio_mdio vio_gmii_tx vio_gmii_rx} {

    # Drop the IP from the in-memory design first, otherwise create_ip below
    # sees the name taken and silently renames it to <ip>_1, <ip>_2, ...
    if {[llength [get_ips -quiet $ip_dir]] > 0} {

        puts "Removing in-memory IP: $ip_dir"

        remove_files [get_files -quiet -of_objects [get_ips $ip_dir]]
    }

    set output_dir "$IP_DIR/$ip_dir/output"
        if {[file exists $output_dir]} {
            foreach item [glob -nocomplain "$output_dir/*"] {
                file delete -force $item
            }
        }
}
puts "Existing Directories cleared"
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
