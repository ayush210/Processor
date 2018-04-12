module mux4(in0,in1,in2,in3,select,out);
input[31:0] in0,in1,in2,in3;  //inputs 
input[1:0] select;  //select line
output[31:0] out; //output
reg[31:0] out;
always@(*)
		begin
			case(select)
				0:out<=in0;
				1:out<=in1;
				2:out<=in2;
				3:out<=in3;
			endcase
		end
endmodule
