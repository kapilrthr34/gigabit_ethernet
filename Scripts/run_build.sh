#!/usr/bin/env bash
# Run the non-project build from the repo root, keeping Vivado's log/journal
# out of the root directory. variables.tcl derives ROOT_DIR from [pwd], so
# this must be run from (and stay in) the repo root -- do not cd elsewhere.
set -e

cd "$(dirname "$0")/.."

LOG_DIR="Output/vivado_logs"
mkdir -p "$LOG_DIR"
TS="$(date +%Y%m%d_%H%M%S)"

source /tools/Xilinx/2020/Vivado/2020.2/settings64.sh

vivado -mode batch \
    -nojournal \
    -log "$LOG_DIR/build_${TS}.log" \
    -source Scripts/build.tcl
