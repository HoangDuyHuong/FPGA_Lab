/*
 *-----------------------------------------------------------------------------
 * Title       : ALU
 * Description : 8-bit signed fixed-point adder with clock and reset
 * Author      : Pham Hoai Luan
 * Date        : 2025-11-04
 *-----------------------------------------------------------------------------
 * Format      : Q4.3 (1 sign, 4 integer, 3 fractional)
 * Function    : c_out_ = a_in + b_in  (saturation)
 *-----------------------------------------------------------------------------
 */
`define NOP		       			0
`define ADD		       			1
`define SUB		       			2
`define MUL		       			3
`define AND		       			4
`define OR		       			5
`define NOT		       			6
`define XOR		       			7

module ALU (
    input  wire                 CLK,
	input  wire					RST,
	input  wire					En_in,
	input  wire [7:0]   		INS_in,      // Instruction
    input  wire signed [15:0]   a_in,        // input A (Q8.7)
    input  wire signed [15:0]   b_in,        // input B (Q8.7)
    output reg  signed [15:0]   c_out,       // output C (Q8.7)
	output reg 					c_valid_out
);

    //==================================================//
    //                   	Wire                      	//
    //==================================================//
	wire 						ADD_SUB_Select_w;
	wire signed [31:0]			MUL_raw_w;
	
    wire signed [15:0] 			NOP_w, ADD_SUB_w, MUL_w;  
	wire signed [15:0] 			AND_w, OR_w,  NOT_w, XOR_w;	
	
	//==================================================//
    //              		Instances              		//
    //==================================================//
	
	ADD_SUB_Sharing add_sub_sharing(
	.ADD_SUB_Select_in(ADD_SUB_Select_w),
    .a_in(a_in),        // input A (Q8.7)
    .b_in(b_in),        // input B (Q8.7)
    .c_out(ADD_SUB_w)
	);

	//==================================================//
    //              Combinational Circuits              //
    //==================================================//
	assign ADD_SUB_Select_w		= INS_in[1:1];
	
	// Arithematic Operations
    assign NOP_w 				= a_in;
	assign MUL_raw_w			= $signed(a_in) * $signed(b_in);
	assign MUL_w				= MUL_raw_w[23:7];
	
	// Logic Operations
    assign AND_w 				= a_in & b_in;
	assign OR_w					= a_in | b_in;
	assign NOT_w				= ~a_in;
	assign XOR_w				= a_in ^ b_in;
	
	//==================================================//
    //              	Sequential Circuits             //
    //==================================================//
	
    always @(posedge CLK or negedge RST) begin
		if(RST == 0) begin
			c_out				<= 0;
			c_valid_out			<= 0;
		end
        else begin
			if(En_in) begin
				case (INS_in)
					`NOP: begin   ///*** No Operation ***///
						c_out				<= NOP_w;
						c_valid_out			<= 1;
					end
					`ADD: begin   ///*** ADD Operation ***///
						c_out				<= ADD_SUB_w;
						c_valid_out			<= 1;
					end
					`SUB: begin   ///*** SUB Operation ***///
						c_out				<= ADD_SUB_w;
						c_valid_out			<= 1;
					end
					`MUL: begin   ///*** MULT Operation ***///
						c_out				<= MUL_w;
						c_valid_out			<= 1;
					end
					`AND: begin   ///*** AND Operation ***///
						c_out				<= AND_w;
						c_valid_out			<= 1;
					end
					`OR: begin   ///*** OR Operation ***///
						c_out				<= OR_w;
						c_valid_out			<= 1;
					end
					`NOT: begin   ///*** NOT Operation ***///
						c_out				<= NOT_w;
						c_valid_out			<= 1;
					end
					`XOR: begin   ///*** XOR Operation ***///
						c_out				<= XOR_w;
						c_valid_out			<= 1;
					end
					default: begin
						c_out 				<= c_out; 
						c_valid_out 		<= 0; 
					end
				endcase
			end
			else begin
				c_out			<= c_out;
				c_valid_out		<= 0;
			end
		end
    end

endmodule
