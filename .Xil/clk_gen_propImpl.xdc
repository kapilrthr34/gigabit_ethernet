set_property SRC_FILE_INFO {cfile:/home/aujus_dsp_1/Documents/Learning/gigabit_ethernet/IP/clk_gen/output/clk_gen/clk_gen.xdc rfile:../IP/clk_gen/output/clk_gen/clk_gen.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:54 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1_p]] 0.050
