module mux2(in0,in1,select,out);
input[31:0] in0,in1;
input select;
output[31:0] out;
reg[31:0] out;
always @(*)
		begin
case(select)
		0:out<=in0;
1:out<=in1;
endcase
end
endmodule
