####################################################
# Generate Reports
####################################################

puts ""
puts "========================================="
puts "Generating Reports..."
puts "========================================="

####################################################
# Timing Reports
####################################################

report_timing_summary \
    -file "$REPORTS_DIR/post_route_timing_summary.rpt"

report_timing \
    -max_paths 100 \
    -file "$REPORTS_DIR/post_route_timing.rpt"

####################################################
# Utilization Reports
####################################################

report_utilization \
    -file "$REPORTS_DIR/post_route_utilization.rpt"

report_utilization \
    -hierarchical \
    -file "$REPORTS_DIR/post_route_utilization_hierarchical.rpt"

####################################################
# Clock Reports
####################################################

report_clock_utilization \
    -file "$REPORTS_DIR/clock_utilization.rpt"

####################################################
# Power Report
####################################################

report_power \
    -file "$REPORTS_DIR/power.rpt"

####################################################
# DRC Report
####################################################

report_drc \
    -file "$REPORTS_DIR/drc.rpt"

puts ""
puts "Reports Generated Successfully."
puts ""