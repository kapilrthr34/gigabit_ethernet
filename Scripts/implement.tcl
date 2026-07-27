####################################################
# Implementation
####################################################

puts ""
puts "========================================="
puts "Running Implementation..."
puts "========================================="

####################################################
# Optimize Design
####################################################

puts "Running opt_design..."
opt_design

####################################################
# Place Design
####################################################

puts "Running place_design..."
place_design

####################################################
# Physical Optimization
####################################################

puts "Running phys_opt_design..."
phys_opt_design

####################################################
# Route Design
####################################################

puts "Running route_design..."
route_design

####################################################
# Post Route Optimization
####################################################

puts "Running post-route phys_opt_design..."
phys_opt_design -post_route

####################################################
# Write Checkpoint
####################################################

write_checkpoint \
    -force \
    "$CHECKPOINT_DIR/post_route.dcp"

puts ""
puts "Implementation Completed."
puts ""