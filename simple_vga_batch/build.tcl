read_vhdl [ glob -directory src *.vhd ]
read_xdc [ glob -directory src *.xdc ]
synth_design -top top -part xc7a35ticsg324-1L
place_design
route_design
file mkdir bin
write_bitstream bin/simple_vga.bit