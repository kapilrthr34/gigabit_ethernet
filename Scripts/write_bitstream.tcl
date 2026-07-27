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
# Write Debug Probes
####################################################
# Required for Hardware Manager to know about any ILA/VIO cores in the
# design (probe names, widths, BSCAN/dbg_hub address). write_bitstream does
# NOT generate this in non-project mode -- must be called explicitly.

write_debug_probes \
    -force \
    "$BIT_DIR/$TOP.ltx"

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