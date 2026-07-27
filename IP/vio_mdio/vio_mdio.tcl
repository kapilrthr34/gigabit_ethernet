####################################################
# VIO : MDIO Debug Interface
####################################################

set IP_NAME vio_mdio

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
    -dir "$IP_DIR/vio_mdio/output"

#---------------------------------------------------
# Configure IP
#---------------------------------------------------

set_property -dict [list \
    CONFIG.C_NUM_PROBE_IN        {2} \
    CONFIG.C_NUM_PROBE_OUT       {7} \
    CONFIG.C_PROBE_IN0_WIDTH     {16} \
    CONFIG.C_PROBE_IN1_WIDTH     {16} \
    CONFIG.C_PROBE_OUT1_WIDTH    {5} \
    CONFIG.C_PROBE_OUT1_INIT_VAL {0x1} \
    CONFIG.C_PROBE_OUT2_WIDTH    {5} \
    CONFIG.C_PROBE_OUT5_WIDTH    {16} \
    CONFIG.C_PROBE_OUT5_INIT_VAL {0x1340} \
] [get_ips $IP_NAME]

#---------------------------------------------------
# Generate Output Products
#---------------------------------------------------

generate_target all [get_ips $IP_NAME]
synth_ip [get_ips $IP_NAME]

puts "VIO MDIO created successfully."