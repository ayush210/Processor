//adder for computing branch address if branch condition holds true than this is passed to pc
module adder(pc2,sext,branchaddress);

input[31:0] pc2,sext;  //sign extended value and program counter address from which instruction has been fetched
output[31:0] branchaddress; //branchaddress
reg[31:0] branchaddress;

always @(*)
		begin
		branchaddress <= pc2 + sext; 
		end
endmodule
