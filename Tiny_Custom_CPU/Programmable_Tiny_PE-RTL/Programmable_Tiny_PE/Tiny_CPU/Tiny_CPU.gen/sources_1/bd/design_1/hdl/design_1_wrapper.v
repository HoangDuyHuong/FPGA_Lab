//Copyright 1986-2023 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2.2 (lin64) Build 3788238 Tue Feb 21 19:59:23 MST 2023
//Date        : Tue Nov 18 23:55:41 2025
//Host        : cad115 running 64-bit Ubuntu 22.04.5 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (LED_out_0,
    Rx_in_0,
    Tx_out_0,
    reset,
    user_si570_sysclk_clk_n,
    user_si570_sysclk_clk_p);
  output [7:0]LED_out_0;
  input Rx_in_0;
  output Tx_out_0;
  input reset;
  input user_si570_sysclk_clk_n;
  input user_si570_sysclk_clk_p;

  wire [7:0]LED_out_0;
  wire Rx_in_0;
  wire Tx_out_0;
  wire reset;
  wire user_si570_sysclk_clk_n;
  wire user_si570_sysclk_clk_p;

  design_1 design_1_i
       (.LED_out_0(LED_out_0),
        .Rx_in_0(Rx_in_0),
        .Tx_out_0(Tx_out_0),
        .reset(reset),
        .user_si570_sysclk_clk_n(user_si570_sysclk_clk_n),
        .user_si570_sysclk_clk_p(user_si570_sysclk_clk_p));
endmodule
