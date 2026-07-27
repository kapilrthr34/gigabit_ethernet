####################################################
# Gigabit Ethernet Build Script
####################################################

puts ""
puts "========================================="
puts "Gigabit Ethernet Build Started"
puts "========================================="
puts ""

####################################################
# Project Variables
####################################################

source Scripts/variables.tcl

####################################################
# Create In-Memory Project
####################################################

create_project \
    -in_memory \
    -part $PART

####################################################
# Build Flow
####################################################
source Scripts/create_ips.tcl
source Scripts/read_rtl.tcl
source Scripts/read_constraints.tcl

source Scripts/synthesize.tcl
source Scripts/add_debug.tcl
source Scripts/implement.tcl

source Scripts/reports.tcl
source Scripts/write_bitstream.tcl

puts ""
puts "========================================="
puts "Build Completed Successfully!"
puts "========================================="
puts ""