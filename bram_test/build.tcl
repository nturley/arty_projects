
set proj_name bram_test

set arty_part xc7a35ticsg324-1L

read_vhdl [ glob -directory src *.vhd ]
read_xdc [ glob -directory src *.xdc ]
synth_design -top top -part $arty_part
place_design
route_design
file mkdir bin
write_bitstream -force bin/$proj_name.bit
