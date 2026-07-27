####################################################
# VIO : GMII Rx Debug Interface
####################################################

set IP_NAME vio_gmii_rx

puts "Creating VIO IP: $IP_NAME"

#---------------------------------------------------
# Create IP
#---------------------------------------------------

create_ip \
    -name vio \
    -vendor xilinx.com \
    -library ip \
    -version 3.0 \
    -module_name $IP_NAME \
    -dir "$IP_DIR/vio_gmii_rx/output"

#---------------------------------------------------
# Configure IP
#---------------------------------------------------

set_property -dict [list \
    CONFIG.C_NUM_PROBE_IN      {0} \
    CONFIG.C_NUM_PROBE_OUT     {1} \
    CONFIG.C_PROBE_OUT0_WIDTH  {1} \
    CONFIG.C_PROBE_OUT0_INIT_VAL {0x0} \
] [get_ips $IP_NAME]

#---------------------------------------------------
# Generate Output Products
#---------------------------------------------------

generate_target all [get_ips $IP_NAME]
synth_ip [get_ips $IP_NAME]

puts "VIO GMII_Rx created successfully."