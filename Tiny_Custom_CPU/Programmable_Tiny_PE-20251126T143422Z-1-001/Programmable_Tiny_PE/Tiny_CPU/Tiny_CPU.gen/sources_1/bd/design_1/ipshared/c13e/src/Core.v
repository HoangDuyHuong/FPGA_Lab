/*
 *-----------------------------------------------------------------------------
 * Title       : Controller for Fixed-Point Adder
 * Description : 3-state FSM (IDLE, EXE, SEND) to control the Fixed_Adder datapath
 * Author      : Pham Hoai Luan
 * Date        : 2025-11-04
 *-----------------------------------------------------------------------------
 */

module Core (
    input  wire 				CLK,
    input  wire 				RST,        // active-low synchronous reset
	/* From RX UART Interface*/	
	input  wire	signed [7:0] 	Rx_Byte_in,
    input  wire    				Rx_DV_in,
	/* From TX UART Interface*/	
	input  wire					Tx_Done_in,
	/* To TX UART Interface*/
	output wire  				Tx_DV_out,
	output wire signed [7:0]	Tx_Byte_out,
	/* Debug*/
	output wire [7:0]			c_out
);

    //==================================================//
    //                   	Wire                      	//
    //==================================================//
	wire						Load_INS_en_out_w;
	wire						c_valid_in_w, En_out_w, Tx_DV_out_w;
	wire						Load_MSB_a_en_out_w, Load_LSB_a_en_out_w;
	wire						Load_MSB_b_en_out_w, Load_LSB_b_en_out_w;

	wire signed [15:0] 			a_out_w, b_out_w, c_out_w;
	wire [7:0]					INS_out_w;
	
	//==================================================//
    //              		Instances              		//
    //==================================================//
	
	// Controller
	Controller controller(
		.CLK(CLK),
		.RST(RST),        // active-low synchronous reset
		/* From RX UART Interface*/
		.Rx_DV_in(Rx_DV_in),
		/* From TX UART Interface*/	
		.Tx_Done_in(Tx_Done_in),
		/* From Datapath*/
		.c_valid_in(c_valid_in_w),
		/* To Datapath*/
		.En_out(En_out_w),
		/* To Instruction Memory*/
		.Load_INS_en_out(Load_INS_en_out_w),	
		/* To Input Memory*/
		.Load_MSB_a_en_out(Load_MSB_a_en_out_w),
		.Load_LSB_a_en_out(Load_LSB_a_en_out_w),
		.Load_MSB_b_en_out(Load_MSB_b_en_out_w),
		.Load_LSB_b_en_out(Load_LSB_b_en_out_w),
		/* To TX UART Interface*/
		.Tx_DV_out(Tx_DV_out_w),
		/* To Core*/
		.MLSB_SEL_Tx_Byte_out(MLSB_SEL_Tx_Byte_out_w)
	);

	// Instruction Memory*/
	Instruction_Memory instruction_memory(
		.CLK(CLK),
		.RST(RST),
		/* From Controller */
		.Load_INS_en_in(Load_INS_en_out_w),
		/* From TX UART Interface */
		.Rx_Byte_in(Rx_Byte_in),   
		/* To ALU */
		.INS_out(INS_out_w)
	);
	
	// Input Memory*/
	Input_Memory input_memory(
		.CLK(CLK),
		.RST(RST),
		/* From Controller */
		.Load_MSB_a_en_in(Load_MSB_a_en_out_w),
		.Load_LSB_a_en_in(Load_LSB_a_en_out_w),
		.Load_MSB_b_en_in(Load_MSB_b_en_out_w),
		.Load_LSB_b_en_in(Load_LSB_b_en_out_w),
		/* From TX UART Interface */
		.Rx_Byte_in(Rx_Byte_in),   
		/* To ALU */
		.a_out(a_out_w),
		.b_out(b_out_w)
	);

	// Datapath
	
	ALU alu(
		.CLK(CLK),
		.RST(RST),
		.En_in(En_out_w),
		.INS_in(INS_out_w),
		.a_in(a_out_w),        // input A (Q4.3)
		.b_in(b_out_w),        // input B (Q4.3)
		.c_out(c_out_w),       // output C (Q4.3)
		.c_valid_out(c_valid_in_w)
	);

	//==================================================//
    //              		Output			            //
    //==================================================//
	assign Tx_DV_out			= Tx_DV_out_w;
	assign Tx_Byte_out			= (MLSB_SEL_Tx_Byte_out_w)? c_out_w[7:0] : c_out_w[15:8];
	assign c_out				= c_out_w[15:8];
endmodule