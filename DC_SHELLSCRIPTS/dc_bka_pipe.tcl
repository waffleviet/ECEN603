# Define the search paths for source files and libraries
set SEARCH_PATH "./src ./lib"
# 1. Set the real target library path
set target_library /usr/synopsys/SAED/SAED32nm_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_ss0p95vn40c.db

# 2. Set the link library (don't forget the "*")
set link_library "* /usr/synopsys/SAED/SAED32nm_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_ss0p95vn40c.db"

# 3. Ensure the work library is defined
define_design_lib work -path ./work
# Analyze the Verilog files
analyze -format verilog ./src/bkapipe.v

# Elaborate the top-level design
elaborate  bka_pipe

create_clock -name "my_clk" -period 10 [get_ports clk]
set_clock_latency 0.3 clk
set_output_delay 1.7 -clock clk [all_outputs]
set_load 0.1 [all_outputs]
set_max_fanout 1 [all_inputs]
set_fanout_load 8 [all_output]
compile -map_effort medium -area_effort medium


report_area > ./reports/bkapipearea.txt
report_timing > ./reports/bkapipetiming.txt
report_power > ./reports/bkapipepower.txt
start_gui


