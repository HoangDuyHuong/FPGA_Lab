module Instruction_Memory (
    input  wire                 CLK,
	input  wire					RST,
	/* From Controller */
	input  wire  				Load_INS_en_in,
	/* From TX UART Interface */
	input  wire	signed [7:0] 	Rx_Byte_in,   
	/* To Datapath */
	output reg  [7:0] 			INS_out
);

    always @(posedge CLK or negedge RST) begin
		if(RST == 0) begin
			INS_out				<= 0;
		end
        else begin
			if(Load_INS_en_in) 				
				INS_out			<= Rx_Byte_in;
			else
				INS_out			<= INS_out;
		end
    end

endmodule
