vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/lib_cdc_v1_0_2
vlib modelsim_lib/msim/proc_sys_reset_v5_0_13

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap lib_cdc_v1_0_2 modelsim_lib/msim/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 modelsim_lib/msim/proc_sys_reset_v5_0_13

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../Lab_2_Tiny_CPU.gen/sources_1/bd/design_HDH/ipshared/7698" \
"../../../bd/design_HDH/ipshared/9a2f/BASIC_IC_COURSE---Tiny_Custom_CPU/RTL_Tiny_CPU/ADD_SUB_Sharing.v" \
"../../../bd/design_HDH/ipshared/9a2f/BASIC_IC_COURSE---Tiny_Custom_CPU/RTL_Tiny_CPU/ALU.v" \
"../../../bd/design_HDH/ipshared/9a2f/BASIC_IC_COURSE---Tiny_Custom_CPU/RTL_Tiny_CPU/Controller.v" \
"../../../bd/design_HDH/ipshared/9a2f/BASIC_IC_COURSE---Tiny_Custom_CPU/RTL_Tiny_CPU/Core.v" \
"../../../bd/design_HDH/ipshared/9a2f/BASIC_IC_COURSE---Tiny_Custom_CPU/RTL_Tiny_CPU/Input_Memory.v" \
"../../../bd/design_HDH/ipshared/9a2f/BASIC_IC_COURSE---Tiny_Custom_CPU/RTL_Tiny_CPU/Instruction_Memory.v" \
"../../../bd/design_HDH/ipshared/9a2f/BASIC_IC_COURSE---Tiny_Custom_CPU/RTL_Tiny_CPU/receiver.v" \
"../../../bd/design_HDH/ipshared/9a2f/BASIC_IC_COURSE---Tiny_Custom_CPU/RTL_Tiny_CPU/transmitter.v" \
"../../../bd/design_HDH/ipshared/9a2f/BASIC_IC_COURSE---Tiny_Custom_CPU/RTL_Tiny_CPU/Add_IP.v" \
"../../../bd/design_HDH/ip/design_HDH_Add_IP_HDH_0_0/sim/design_HDH_Add_IP_HDH_0_0.v" \
"../../../bd/design_HDH/ip/design_HDH_clk_wiz_0_0/design_HDH_clk_wiz_0_0_clk_wiz.v" \
"../../../bd/design_HDH/ip/design_HDH_clk_wiz_0_0/design_HDH_clk_wiz_0_0.v" \

vcom -work lib_cdc_v1_0_2  -93  \
"../../../../Lab_2_Tiny_CPU.gen/sources_1/bd/design_HDH/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13  -93  \
"../../../../Lab_2_Tiny_CPU.gen/sources_1/bd/design_HDH/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../bd/design_HDH/ip/design_HDH_rst_clk_wiz_0_25M_0/sim/design_HDH_rst_clk_wiz_0_25M_0.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../Lab_2_Tiny_CPU.gen/sources_1/bd/design_HDH/ipshared/7698" \
"../../../bd/design_HDH/sim/design_HDH.v" \

vlog -work xil_defaultlib \
"glbl.v"

