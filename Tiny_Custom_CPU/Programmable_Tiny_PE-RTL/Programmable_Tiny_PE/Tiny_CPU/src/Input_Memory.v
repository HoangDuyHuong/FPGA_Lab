module Input_Memory (
    input  wire                 CLK,
	input  wire					RST,
	/* From Controller */
	input  wire  				Load_MSB_a_en_in,
	input  wire  				Load_LSB_a_en_in,
	input  wire  				Load_MSB_b_en_in,
	input  wire  				Load_LSB_b_en_in,
	/* From TX UART Interface */
	input  wire	signed [7:0] 	Rx_Byte_in,   
	/* To Datapath */
	output reg 	signed [15:0] 	a_out,
	output reg 	signed [15:0] 	b_out
);

    always @(posedge CLK or negedge RST) begin
		if(RST == 0) begin
			a_out				<= 0;
			b_out				<= 0;
		end
        else begin
			if(Load_MSB_a_en_in) 				
				a_out[15:8]		<= Rx_Byte_in;
			else if(Load_LSB_a_en_in) 				
				a_out[7:0]		<= Rx_Byte_in;
			else
				a_out			<= a_out;
				
			if(Load_MSB_b_en_in) 				
				b_out[15:8]		<= Rx_Byte_in;
			else if(Load_LSB_b_en_in) 				
				b_out[7:0]		<= Rx_Byte_in;
			else
				b_out			<= b_out;		
		end
    end

endmodule
