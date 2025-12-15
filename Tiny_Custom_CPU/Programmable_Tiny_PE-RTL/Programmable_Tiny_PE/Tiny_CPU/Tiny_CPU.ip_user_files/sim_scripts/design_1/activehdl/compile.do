vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/xil_defaultlib
vlib activehdl/lib_cdc_v1_0_2
vlib activehdl/proc_sys_reset_v5_0_13

vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib
vmap lib_cdc_v1_0_2 activehdl/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 activehdl/proc_sys_reset_v5_0_13

vlog -work xpm  -sv2k12 "+incdir+../../../../Tiny_CPU.gen/sources_1/bd/design_1/ipshared/7698" \
"/opt/xilinx/Vivado/2022.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93  \
"/opt/xilinx/Vivado/2022.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../Tiny_CPU.gen/sources_1/bd/design_1/ipshared/7698" \
"../../../bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0_clk_wiz.v" \
"../../../bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0.v" \

vcom -work lib_cdc_v1_0_2 -93  \
"../../../../Tiny_CPU.gen/sources_1/bd/design_1/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13 -93  \
"../../../../Tiny_CPU.gen/sources_1/bd/design_1/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  \
"../../../bd/design_1/ip/design_1_rst_clk_wiz_0_25M_0/sim/design_1_rst_clk_wiz_0_25M_0.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../Tiny_CPU.gen/sources_1/bd/design_1/ipshared/7698" \
"../../../bd/design_1/ipshared/c13e/src/ADD_SUB_Sharing.v" \
"../../../bd/design_1/ipshared/c13e/src/ALU.v" \
"../../../bd/design_1/ipshared/c13e/src/Controller.v" \
"../../../bd/design_1/ipshared/c13e/src/Core.v" \
"../../../bd/design_1/ipshared/c13e/src/Input_Memory.v" \
"../../../bd/design_1/ipshared/c13e/src/Instruction_Memory.v" \
"../../../bd/design_1/ipshared/c13e/src/receiver.v" \
"../../../bd/design_1/ipshared/c13e/src/transmitter.v" \
"../../../bd/design_1/ipshared/c13e/src/Add_IP.v" \
"../../../bd/design_1/ip/design_1_Tiny_CPU_IP_0_0/sim/design_1_Tiny_CPU_IP_0_0.v" \
"../../../bd/design_1/sim/design_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

