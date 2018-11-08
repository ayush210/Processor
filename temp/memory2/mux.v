module mux(in0,in1,out,select);

input[31:0] in0;
input[31:0] in1;
output[31:0] out;
input select;

assign out = (select==0)?in0:in1;

endmodule
