set proj_name vga_bram

open_hw
connect_hw_server
current_hw_target [get_hw_targets *]
open_hw_target
set_property PROGRAM.FILE bin/$proj_name.bit [lindex [get_hw_devices] 0]
program_hw_devices [lindex [get_hw_devices] 0]
