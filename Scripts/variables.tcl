####################################################
# Project Information
####################################################

set PROJECT_NAME "gigabit_ethernet"
set PART         "xc7a100tfgg484-2"
set TOP          "gmii_top"

####################################################
# Project Directories
####################################################

set ROOT_DIR        [pwd]

set RTL_DIR         "$ROOT_DIR/RTL"
set CONSTRAINTS_DIR "$ROOT_DIR/Constraints"
set IP_DIR          "$ROOT_DIR/IP"
set SCRIPTS_DIR     "$ROOT_DIR/Scripts"

####################################################
# Output Directories
####################################################

set OUTPUT_DIR      "$ROOT_DIR/Output"

set BIT_DIR         "$OUTPUT_DIR/bitstream"
set CHECKPOINT_DIR  "$OUTPUT_DIR/checkpoint"
set REPORTS_DIR     "$OUTPUT_DIR/reports"

####################################################
# Create Output Directories
####################################################

foreach dir [list \
    $OUTPUT_DIR \
    $BIT_DIR \
    $CHECKPOINT_DIR \
    $REPORTS_DIR] {

    file mkdir $dir
}

set BIT_FILE        "$BIT_DIR/$TOP.bit"
set DCP_FILE        "$CHECKPOINT_DIR/$TOP.dcp"
set UTIL_REPORT     "$REPORTS_DIR/utilization.rpt"
set TIMING_REPORT   "$REPORTS_DIR/timing_summary.rpt"
set POWER_REPORT    "$REPORTS_DIR/power.rpt"