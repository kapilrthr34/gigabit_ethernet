####################################################
# Synthesis
####################################################

puts ""
puts "========================================="
puts "Running Synthesis..."
puts "========================================="

####################################################
# Synthesize Design
####################################################

synth_design \
    -top $TOP \
    -part $PART

####################################################
# Write Checkpoint
####################################################

write_checkpoint \
    -force \
    "$CHECKPOINT_DIR/post_synth.dcp"

####################################################
# Reports
####################################################

report_utilization \
    -file "$REPORTS_DIR/post_synth_utilization.rpt"

report_timing_summary \
    -file "$REPORTS_DIR/post_synth_timing_summary.rpt"

puts ""
puts "Synthesis Completed."
puts ""