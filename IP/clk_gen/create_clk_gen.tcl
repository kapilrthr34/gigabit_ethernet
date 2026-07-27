## Clock wizard IP generation script
set IP_NAME clk_gen

puts "Generating $IP_NAME IP in $IP_DIR"

# Create the IP
create_ip \
    -name clk_wiz \
    -vendor xilinx.com \
    -library ip \
    -version 6.0 \
    -module_name $IP_NAME \
    -dir $IP_DIR/clk_gen/Output

# Configure the IP
set_property -dict [list \
    CONFIG.PRIM_SOURCE                  {Differential_clock_capable_pin} \
    CONFIG.PRIM_IN_FREQ                 {200.000} \
    CONFIG.NUM_OUT_CLKS                 {2} \
    CONFIG.CLKOUT1_USED                 {true} \
    CONFIG.CLKOUT2_USED                 {true} \
    CONFIG.CLK_OUT1_PORT                {clk_100} \
    CONFIG.CLK_OUT2_PORT                {clk_125} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ   {125.000} \
    CONFIG.USE_RESET                    {false} \
    CONFIG.USE_LOCKED                   {false} \
] [get_ips $IP_NAME]

# Generate the output products
generate_target all [get_ips $IP_NAME]

puts "Clock wizard IP generation complete"
