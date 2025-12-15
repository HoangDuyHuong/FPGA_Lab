/*
 *-----------------------------------------------------------------------------
 * Title       : Controller for Fixed-Point Adder
 * Description : 3-state FSM (IDLE, EXE, SEND) to control the Fixed_Adder datapath
 * Author      : Pham Hoai Luan
 * Date        : 2025-11-04
 *-----------------------------------------------------------------------------
 */

module Controller (
    input  wire 				CLK,
    input  wire 				RST,        // active-low synchronous reset
	/* From RX UART Interface*/	
    input  wire    				Rx_DV_in,
	/* From TX UART Interface*/	
	input  wire					Tx_Done_in,
	/* From Datapath*/
	input  wire					c_valid_in,
	/* For Datapath*/
    output wire  				En_out,
	
	/* For Instruction Memory*/
	output wire  				Load_INS_en_out,
	
	/* For Input Memory*/
	output wire  				Load_MSB_a_en_out,
	output wire  				Load_LSB_a_en_out,
	output wire  				Load_MSB_b_en_out,
	output wire  				Load_LSB_b_en_out,
	/* To TX UART Interface*/
	output wire 				Tx_DV_out,
	/* To Core*/
	output wire					MLSB_SEL_Tx_Byte_out
);

    // State encoding
    localparam IDLE 			= 2'b00;
	localparam LOAD 			= 2'b01;
	localparam EXE  			= 2'b10;
    localparam SEND 			= 2'b11;

    //==================================================//
    //                   	Wire                      	//
    //==================================================//
	
	wire						LOAD_flag_w, EXE_flag_w;
	wire						SEND_flag_w, IDLE_flag_w;
	// wire						first_send_1_w;
	// wire						send_request_w;
	
    //==================================================//
    //                   Registers                      //
    //==================================================//
	reg [1:0]					current_state_r, next_state_r;
	reg [2:0]					load_counter_r;
	reg [1:0]					send_counter_r;
	
	reg							send_request_r;
	// reg							first_send_2_r;
	
	//==================================================//
    //              Combinational Circuits              //
    //==================================================//
	
	assign LOAD_flag_w			= Rx_DV_in;
	assign EXE_flag_w			= (load_counter_r == 5)? 1'b1: 1'b0;
	assign SEND_flag_w			= c_valid_in;
	assign IDLE_flag_w			= ((send_counter_r == 2) && Tx_Done_in) ? 1'b1: 1'b0;
	
	assign first_send_1_w		= (current_state_r == SEND) ? 1'b1: 1'b0;
	// assign send_request_w		= first_send_1_w & ~first_send_2_r;
	
	// Next state logic
	always @(current_state_r or LOAD_flag_w or EXE_flag_w or SEND_flag_w or IDLE_flag_w) begin
		case(current_state_r)
			IDLE: begin
				if (LOAD_flag_w)
					next_state_r = LOAD;
				else
					next_state_r = IDLE;
			end
			LOAD: begin
				if (EXE_flag_w)
					next_state_r = EXE;
				else
					next_state_r = LOAD;
			end

			EXE: begin
				if (SEND_flag_w)
					next_state_r = SEND;
				else
					next_state_r = EXE;
			end
			
			SEND: begin
				if (IDLE_flag_w)
					next_state_r = IDLE;
				else
					next_state_r = SEND;
			end

			default: next_state_r = IDLE;
		endcase
	end
	
	//==================================================//
    //              	Sequential Circuits             //
    //==================================================//
	
	// Next state reg
	always @(posedge CLK or negedge RST) begin
		if(RST == 0) begin
			current_state_r	<= IDLE;
		end
		else begin
			current_state_r	<= next_state_r;
		end
	end
	
	// Counter reg
	always @(posedge CLK or negedge RST) begin
		if(RST == 0) begin
			load_counter_r	<= 0;
			send_counter_r	<= 0;
			send_request_r	<= 0;
			
			// first_send_2_r	<= 0;
		end
		else begin
			//load_counter_r
			if(current_state_r == EXE) 
				load_counter_r <= 0;
			else if((current_state_r == IDLE || current_state_r == LOAD) && Rx_DV_in) 
				load_counter_r	<= load_counter_r + 1;
			else
				load_counter_r	<= load_counter_r;
			
			//send_counter_r
			if(current_state_r == IDLE) 
				send_counter_r <= 0;
			else if(current_state_r == SEND && send_request_r) 
				send_counter_r	<= send_counter_r + 1;
			else
				send_counter_r	<= send_counter_r;
				
			// send_request_r
			// if(current_state_r == SEND)
				// first_send_2_r	<= 1;
			// else
				// first_send_2_r	<= 0;
			
			if(current_state_r == SEND && (c_valid_in || Tx_Done_in) && (send_counter_r <2))
				send_request_r	<= 1;
			else 
				send_request_r	<= 0;
		end
	end

	//==================================================//
    //              		Output            		    //
    //==================================================//

	assign En_out 				= (current_state_r == EXE) ? 1'b1: 1'b0; 
	assign Load_INS_en_out		= (Rx_DV_in && current_state_r == IDLE) ? 1'b1 : 1'b0;
	assign Load_MSB_a_en_out	= (Rx_DV_in && load_counter_r == 1) ? 1'b1 : 1'b0;
	assign Load_LSB_a_en_out	= (Rx_DV_in && load_counter_r == 2) ? 1'b1 : 1'b0;
	assign Load_MSB_b_en_out	= (Rx_DV_in && load_counter_r == 3) ? 1'b1 : 1'b0;
	assign Load_LSB_b_en_out	= (Rx_DV_in && load_counter_r == 4) ? 1'b1 : 1'b0;
	assign Tx_DV_out			= send_request_r;
	assign MLSB_SEL_Tx_Byte_out	= send_counter_r[0:0];
endmodule