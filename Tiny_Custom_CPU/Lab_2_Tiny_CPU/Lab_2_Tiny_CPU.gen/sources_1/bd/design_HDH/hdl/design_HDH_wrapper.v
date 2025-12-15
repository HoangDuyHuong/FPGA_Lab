//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
//Date        : Sun Nov 30 10:22:54 2025
//Host        : HUONG running 64-bit major release  (build 9200)
//Command     : generate_target design_HDH_wrapper.bd
//Design      : design_HDH_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_HDH_wrapper
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

  design_HDH design_HDH_i
       (.LED_out_0(LED_out_0),
        .Rx_in_0(Rx_in_0),
        .Tx_out_0(Tx_out_0),
        .reset(reset),
        .user_si570_sysclk_clk_n(user_si570_sysclk_clk_n),
        .user_si570_sysclk_clk_p(user_si570_sysclk_clk_p));
endmodule
