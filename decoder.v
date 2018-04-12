//decoder for sign extension for which type of sign extension has to be done
module decoder(in,sext_select);
		input[6:0] in;
		output[2:0] sext_select;
		reg[2:0] sext_select;
always @(*)
		begin
case(in)
		19:sext_select<=0;//itype  
		3:sext_select<=0;//i-type
		99:sext_select<=1;//b-type
		55:sext_select<=2;//u-type (aui)
		23:sext_select<=2;//u-type (auipc)
		3:sext_select<=3; // s-imm
		111:sext_select<=4;//j-type
endcase
end
endmodule

