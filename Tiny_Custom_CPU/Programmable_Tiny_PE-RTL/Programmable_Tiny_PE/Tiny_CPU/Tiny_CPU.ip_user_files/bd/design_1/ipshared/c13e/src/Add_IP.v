/*
 *-----------------------------------------------------------------------------
 * Title       : Controller for Fixed-Point Adder
 * Description : 3-state FSM (IDLE, EXE, SEND) to control the Fixed_Adder datapath
 * Author      : Pham Hoai Luan
 * Date        : 2025-11-04
 *-----------------------------------------------------------------------------
 */

module Add_IP (
    input  wire 				CLK,
    input  wire 				RST,        // active-low synchronous reset
	/* From RX UART Pin*/	
	input  wire        			Rx_in,
	/* To TX UART Pin*/	
	output wire        			Tx_out,
	/* Debug*/
	output wire [7:0] 			LED_out
);

    //==================================================//
    //                   	Wire                      	//
    //==================================================//
	wire						Rx_DV_out_w, Tx_Done_in_w;
	wire						Tx_DV_out_w;

	wire signed [7:0] 			Rx_Byte_out_w, Tx_Byte_out_w, c_out_w;
	
	//==================================================//
    //              		Instances              		//
    //==================================================//
	
	
	receiver #(
    .CLKS_PER_BIT(217)
	) RX(
		.CLK(CLK),
		.Rx_in(Rx_in),
		.Rx_DV_out(Rx_DV_out_w),
		.Rx_Byte_out(Rx_Byte_out_w)
	);

	// Core
	Core core(
		.CLK(CLK),
		.RST(RST),        // active-low synchronous reset
		/* From RX UART Interface*/	
		.Rx_Byte_in(Rx_Byte_out_w),
		.Rx_DV_in(Rx_DV_out_w),
		/* From TX UART Interface*/	
		.Tx_Done_in(Tx_Done_in_w),
		/* To TX UART Interface*/
		.Tx_DV_out(Tx_DV_out_w),
		.Tx_Byte_out(Tx_Byte_out_w),
		/* Debug*/
		.c_out(c_out_w)
	);
	
	// Input Memory*/
	transmitter #(
    .CLKS_PER_BIT(217)
	) TX(
		.CLK(CLK),
		.Tx_DV_in(Tx_DV_out_w),
		.Tx_Byte_in(Tx_Byte_out_w),
		.Tx_Active_out(),
		.Tx_out(Tx_out),
		.Tx_Done_out(Tx_Done_in_w)
	);

	//==================================================//
    //              		Output			            //
    //==================================================//
	assign LED_out				= c_out_w;
endmodule