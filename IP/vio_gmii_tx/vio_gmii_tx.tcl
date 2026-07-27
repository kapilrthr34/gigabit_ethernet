####################################################
# VIO : GMII Tx Debug Interface
####################################################

set IP_NAME vio_gmii_tx

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
    -dir "$IP_DIR/vio_gmii_tx/output"

#---------------------------------------------------
# Configure IP
#---------------------------------------------------

# Configure the IP
set_property -dict [list \
    CONFIG.C_NUM_PROBE_IN      {1} \
    CONFIG.C_NUM_PROBE_OUT     {6} \
    CONFIG.C_PROBE_IN0_WIDTH   {1} \
    CONFIG.C_PROBE_OUT0_WIDTH  {1} \
    CONFIG.C_PROBE_OUT1_WIDTH  {48} \
    CONFIG.C_PROBE_OUT2_WIDTH  {48} \
    CONFIG.C_PROBE_OUT3_WIDTH  {16} \
    CONFIG.C_PROBE_OUT4_WIDTH  {32} \
    CONFIG.C_PROBE_OUT5_WIDTH  {1} \
    CONFIG.C_PROBE_OUT0_INIT_VAL {0x0} \
    CONFIG.C_PROBE_OUT1_INIT_VAL {0x000000FFFFFF} \
    CONFIG.C_PROBE_OUT2_INIT_VAL {0x02123456789A} \
    CONFIG.C_PROBE_OUT3_INIT_VAL {0x88B5} \
    CONFIG.C_PROBE_OUT4_INIT_VAL {0x83E8CCEE} \
    CONFIG.C_PROBE_OUT5_INIT_VAL {0x0} \
] [get_ips $IP_NAME]

#---------------------------------------------------
# Generate Output Products
#---------------------------------------------------

generate_target all [get_ips $IP_NAME]

puts "VIO GMII_Tx created successfully."