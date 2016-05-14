read_vhdl { src/top.vhd src/vga_controller.vhd}
read_xdc src/arty.xdc
synth_design -top top -part xc7a35ticsg324-1L
place_design
route_design
file mkdir bin
write_bitstream bin/simple_vga.bit