//Copyright 1986-2023 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2.2 (lin64) Build 3788238 Tue Feb 21 19:59:23 MST 2023
//Date        : Tue Nov 18 23:55:41 2025
//Host        : cad115 running 64-bit Ubuntu 22.04.5 LTS
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=3,numReposBlks=3,numNonXlnxBlks=1,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_board_cnt=2,da_clkrst_cnt=1,synth_mode=Global}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (LED_out_0,
    Rx_in_0,
    Tx_out_0,
    reset,
    user_si570_sysclk_clk_n,
    user_si570_sysclk_clk_p);
  output [7:0]LED_out_0;
  input Rx_in_0;
  output Tx_out_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input reset;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 user_si570_sysclk CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME user_si570_sysclk, CAN_DEBUG false, FREQ_HZ 300000000" *) input user_si570_sysclk_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 user_si570_sysclk CLK_P" *) input user_si570_sysclk_clk_p;

  wire Rx_in_0_1;
  wire [7:0]Tiny_CPU_IP_0_LED_out;
  wire Tiny_CPU_IP_0_Tx_out;
  wire clk_wiz_0_clk_out1;
  wire reset_1;
  wire [0:0]rst_clk_wiz_0_25M_peripheral_aresetn;
  wire user_si570_sysclk_1_CLK_N;
  wire user_si570_sysclk_1_CLK_P;

  assign LED_out_0[7:0] = Tiny_CPU_IP_0_LED_out;
  assign Rx_in_0_1 = Rx_in_0;
  assign Tx_out_0 = Tiny_CPU_IP_0_Tx_out;
  assign reset_1 = reset;
  assign user_si570_sysclk_1_CLK_N = user_si570_sysclk_clk_n;
  assign user_si570_sysclk_1_CLK_P = user_si570_sysclk_clk_p;
  design_1_Tiny_CPU_IP_0_0 Tiny_CPU_IP_0
       (.CLK(clk_wiz_0_clk_out1),
        .LED_out(Tiny_CPU_IP_0_LED_out),
        .RST(rst_clk_wiz_0_25M_peripheral_aresetn),
        .Rx_in(Rx_in_0_1),
        .Tx_out(Tiny_CPU_IP_0_Tx_out));
  design_1_clk_wiz_0_0 clk_wiz_0
       (.clk_in1_n(user_si570_sysclk_1_CLK_N),
        .clk_in1_p(user_si570_sysclk_1_CLK_P),
        .clk_out1(clk_wiz_0_clk_out1));
  design_1_rst_clk_wiz_0_25M_0 rst_clk_wiz_0_25M
       (.aux_reset_in(1'b1),
        .dcm_locked(1'b1),
        .ext_reset_in(reset_1),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(rst_clk_wiz_0_25M_peripheral_aresetn),
        .slowest_sync_clk(clk_wiz_0_clk_out1));
endmodule
