####################################################
# Generate Bitstream
####################################################

puts ""
puts "========================================="
puts "Generating Bitstream..."
puts "========================================="

####################################################
# Write Bitstream
####################################################

write_bitstream \
    -force \
    "$BIT_DIR/$TOP.bit"

####################################################
# Write Hardware Platform (Optional)
####################################################

# write_hw_platform \
#     -fixed \
#     -include_bit \
#     -force \
#     "$BIT_DIR/$TOP.xsa"

puts ""
puts "Bitstream Generated Successfully."
puts ""