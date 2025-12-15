onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+design_HDH  -L xil_defaultlib -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_13 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.design_HDH xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure

do {design_HDH.udo}

run 1000ns

endsim

quit -force
