source Scripts/variables.tcl

create_project \
    -in_memory \
    -part $PART
# Clear all exisiting IP directories
foreach ip_dir {clk_gen vio_mdio vio_gmii_tx vio_gmii_rx} {
    set ip_path "$IP_DIR/$ip_dir/output"
    if {[file exists $ip_path/$ip_dir]} {
        file delete -force $ip_path/$ip_dir
        puts "Deleted existing IP directory: $ip_path"
    }
}
puts "Existing Directories cleared"
# puts "Creating IPs"

# ## Clock Generation
# puts "Generating clk_gen IP"
# source "$IP_DIR/clk_gen/create_clk_gen.tcl"