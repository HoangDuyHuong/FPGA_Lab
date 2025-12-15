module ADD_SUB_Sharing (
    input  wire                 ADD_SUB_Select_in,   // 0=ADD, 1=SUB
    input  wire signed [15:0]   a_in,
    input  wire signed [15:0]   b_in,
    output wire signed [15:0]   c_out
);

    wire signed [15:0]  b_xor_w;
    wire signed [16:0]  sum_w;

    // XOR b for subtraction
    assign b_xor_w = b_in ^ {16{ADD_SUB_Select_in}};

    // shared adder with proper sign extension
    assign sum_w = {a_in[15], a_in} 
                 + {b_xor_w[15], b_xor_w} 
                 + ADD_SUB_Select_in;

    // saturation
    assign c_out = (sum_w > 17'sd32767)  ? 16'sd32767 :
                   (sum_w < -17'sd32768) ? -16'sd32768 :
                                           sum_w[15:0];

endmodule
