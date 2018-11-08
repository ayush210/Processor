// control for pc4z4 has to be done - not req
// control part for pc4 has to be done - done
// mux has to be added at ir4_input for nop - not req  
//branch signal has to be added  - done 
//branch address after stage 3 has to be added and connected to pc mux 
//reset has to be added 
// lui and auipc has to be considered seperately for hazards 
module control(reset,ir2_output,ir3_output,ir4_output,ir5_output,branch_control_output,select_pc,select_pc2,select_ir2,select_ir3,select_ir4,select_pc3,select_x3,select_y3,select_md3,select_operand1,select_operand2,select_md4,select_datawrite,select_z5,reg_write_enable,data_write_signal,select_ir5);
input branch_control_output;
input[31:0] ir2_output,ir3_output,ir4_output,ir5_output; // instruction reg of each stage;
output[1:0] select_pc,select_ir2,select_ir3,select_x3,select_y3,select_md3,select_operand1,select_operand2,select_md4,select_z5;
output select_pc2,select_pc3,select_datawrite,select_ir4,reg_write_enable,data_write_signal;
output select_ir5;
reg[1:0] select_pc,select_ir2,select_ir3,select_x3,select_y3,select_md3,select_operand1,select_operand2,select_md4,select_z5;
reg select_pc2,select_pc3,select_datawrite,select_ir4,output_reg_enable,reg_write_enable,data_write_signal;
reg select_ir5;
input reset;
always @(*)
		begin
if(reset==1)
		begin
		select_pc = 2;
		select_ir2 = 0;
		select_pc2 = 0;
		end
else
		begin
if((ir4_output[6:0]==7'b1100111)||(ir4_output[6:0]==7'b1101111)) //jump
	begin
		select_pc = 0;  //pc = jump add
		select_ir2 = 1; //nop
		//	select_pc2 = 1;
		select_ir3 = 1; //nop
		//	select_pc3 = 1;
		//	select_x3 = 0;
		//	select_y3 = 0;
		//	select_md3 = 0;
		select_ir4 = 1; //nop
	end
else if(ir4_output[6:0] == 7'b1100011 && branch_control_output == 1 )//branch
	begin
	$display("workd");
		select_pc = 3;  // pc = branch add
		select_ir2 = 1; //nop
		//	select_pc2 = 1;
		select_ir3 = 1; //nop
		//	select_pc3 = 1;
		//	select_x3 = 0;
		//	select_y3 = 0;
		//	select_md3 = 0;
		select_ir4 = 1; //nop 
	end
else if(ir2_output[19:15] == ir3_output[11:7]&&(ir3_output[14:12] == 3'b010) && (ir3_output[6:0] == 7'b0000011) && (ir2_output[6:0] == 7'b1100111) && (ir2_output[14:12] == 3'b000))
	begin                                           // Lw rd,imm(rs1)  JALR rs1,rd,imm/jr imm(rd)  
		select_pc = 2; //pc = old pc
		select_pc2 = 1; //pc2 = old pc2 stall
		select_ir2 = 2; //stall 
		select_ir3 = 1; //nop in stage 3
	end
else if((ir2_output[19:15] == ir3_output[11:7])&&(ir3_output[6:0] == 7'b0000011) && (ir2_output[6:0] == 7'b1100111) && (ir3_output[14:12] == 3'b010) && (ir3_output[14:12] == 3'b000))   // Lw r’, imm(rs1)  Beq rs1,r’,imm
	begin
		select_pc = 2; // pc = old pc
		select_pc2 = 1; // pc2 = old pc2 stall 
		select_ir2 = 2; //stall
		select_ir3 = 1; //nop in stage 3	
	end
else if(((ir3_output[11:7]== ir2_output[24:20])||(ir3_output[11:7]==ir2_output[19:15]))&&(ir2_output[6:0]==7'b0110011)&&(ir3_output[6:0]==7'b0000011)&&(ir3_output[14:12] == 3'b010)) // Lw r’, imm(rs1) addi r3, r’ ,rs2
	begin
		select_pc = 2; // pc = old pc (stall)
		select_pc2 = 1; // pc2 = old pc2 (stall)	
		select_ir2 = 2; // stall 
		select_ir3 = 1; // nop in stage 3
	end
else if((ir3_output[11:7]==ir2_output[19:15])&&(ir2_output[6:0]==7'b0010011)&&(ir3_output[6:0]==7'b0000011)&&(ir3_output[14:12] == 3'b010)) // Lw r’, imm(rs1) add r3, r’ ,rs2
	begin
		select_pc = 2;
		select_pc2 = 1;
		select_ir2 = 2;
		select_ir3 = 1;
	end
else if((ir3_output[14:12]==3'b010)&&(ir3_output[6:0]==7'b0000011)&&(ir2_output[6:0]==7'b1100011)&&((ir3_output[11:7]==ir2_output[24:20])||(ir3_output[11:7]==ir2_output[19:15]))) //Lw r’,imm(rs1) Beq rs1,r’,imm
	begin
		select_pc = 2;  //pc = old pc (stall)
		select_pc2 = 1;	//pc2 = old pc2(stall)
		select_ir2 = 2; //stall
		select_ir3 = 1; //nop in stage 3
	end
else if((ir3_output[6:0]==7'b0000011)&&(ir2_output[6:0]==7'b0100011)&&(ir3_output[14:12]==3'b010)&&(ir2_output[14:12]==3'b010)&&(ir3_output[11:7]==ir2_output[19:15])) // Lw rd, imm(rs1) Sw rs2, imm(rd)
	begin
		select_pc = 2; 
		select_pc2 = 1;
		select_ir2 = 2;
		select_ir3 = 1;
	end 
else       // for all other instructions
	begin
		select_pc = 1;
		select_pc2 = 0;
		select_ir2 = 0;
		select_ir3 = 0;
	end	

	/*	//control for x3
		if((ir2[6:0]==7'b0010111)||(ir2[6:0]==7'b1101111)) // pc relative addressing //auipc or jal
		begin
		select_x3 = 1;
		end
		else if((ir5[6:0] ==7'b0000011)&&(ir2[6:0]==7'b1100111&&ir2[11:7]!=5'b00000)&&(ir2[19:15]==ir5[11:7])) // Lw rd, imm(rs1) JALR rs1,rd,imm
	begin
	select_x3 = 3;
	end

	else if((ir5[6:0]==7'b0000011)&&(ir2[6:0]==7'b1100111&&ir2[11:7]==5'b00000)&&(ir5[11:7]==ir2[19:15])) //Lw rd,imm(rs1) JR rd
		begin
		select_x3 = 3;
		end*/
	
		//control for x3
if((ir2_output[6:0]==7'b0010111)||(ir2_output[6:0]==7'b1101111)) // pc relative addressing //auipc or jal
	begin
		select_x3 = 1;
	end
else if((ir5_output[6:0] == 7'b0000011||ir5_output[6:0]==7'b0110011||ir5_output[6:0]==7'b0010011) && (ir2_output[6:0]==7'b1100011||ir2_output[6:0]==7'b0010011||ir2_output[6:0]==7'b0110011) && (ir5_output[11:7] == ir2_output[19:15]))//Lw rd, imm(rs1) JALR rs1,rd,imm
	begin                    //forwaded                                                   // Lw rd,imm(rs1) JR rd
		select_x3 = 3;																 //Lw rd, imm(rs1) Beq rs1,rd,imm
	end							// addi/add   beq
else if(ir5_output[6:0]==7'b0000011&&ir5_output[14:12]==3'b010&&ir2_output[6:0]==7'b0100011&&ir2_output[14:12]==3'b010&&ir5_output[11:7]==ir2_output[19:15])
	begin // Lw rd,imm(rs1)  sw rs2,imm(rd)
		select_x3 = 3;
	end
else
	begin
		select_x3 = 0;
	end

	//control for y3
if((ir2_output[6:0]==7'b0010011)||ir2_output[6:0]==7'b1100111||ir2_output[6:0]==7'b0110111||ir2_output[6:0]==7'b0010111||ir2_output[6:0]==7'b0000011)	//sign extended value jr/jalr/arithmetic imm //lui // auipc //lw
	begin
		select_y3 = 1;
	end
else if((ir5_output[6:0]==7'b0000011||ir5_output[6:0]==7'b0110011||ir5_output[6:0]==7'b0010011)&&(ir2_output[6:0]==7'b0110011||ir2_output[6:0]==7'b0100011||ir2_output==7'b1100011)&&(ir2_output[24:20]==ir5_output[11:7]))//Lw rd,imm(rs1) Add r3,rd,rs2
	begin					// lw beq //addi beq //add beq
		select_y3 = 3;      //Lw rd, imm(rs1) Beq rs1,rd,imm   //forwaded from z5	
	end

else
	begin
		select_y3 = 0;
	end

//control for pc3
	select_pc3 = 0;


	//control for md3
if(ir2_output[24:20]==ir5_output[11:7]&&ir2_output[6:0]==7'b0100011&&ir5_output[6:0]==7'b0000011)
	begin	
		select_md3 = 1;
	end
else
	begin
		select_md3 = 0;
	end
	
	//control for operand1
if((ir5_output[6:0]==7'b0000011)&&(ir5_output[14:12]==3'b010)&&((ir3_output==7'b1100011)||(ir3_output[6:0]==7'b1100111)||(ir3_output[6:0]==7'b0110011)||(ir3_output[6:0]==7'b0010011))&&(ir5_output[11:7]==ir3_output[19:15])) // 	Lw rd, imm(rs1) Beq rs1,rd,imm
	begin
		select_operand1 = 1; //forward from z5//Lw rd, imm(rs1) JALR rs1,imm(rd)//Lw rd,imm(rs1) Jr rd// Lw rd,imm(rs1),add r3,rd,rs2/addi
	end
else if((ir5_output[6:0]==7'b0000011)&&(ir5_output[14:12]==3'b010)&&(ir3_output[6:0]==7'b0100011)&&(ir3_output[14:12]==3'b010)&&(ir5_output[11:7]==ir3_output[19:15]))
	begin
		select_operand1 = 1; // Lw rd,imm(rs1) sw rs2,imm(rd)
	end
else if((ir5_output[6:0]==7'b0110011||ir5_output==7'b0010011)&&(ir3_output[6:0]==7'b0110011||ir3_output==7'b0010011)&&(ir5_output[11:7]==ir3_output[19:15]));
else if((ir4_output[6:0]==7'b0110011||ir4_output[6:0]==7'b0010011||ir4_output[6:0]==7'b0110111||ir4_output[6:0]==7'b0010111)&&((ir3_output[6:0]==7'b0100011)||(ir3_output[6:0]==7'b1100111)||(ir3_output[6:0]==7'b0000011)&&(ir3_output[6:0]==7'b1100011)||(ir3_output[6:0]==7'b0010011)||(ir3_output[6:0]==7'b0010011)||(ir3_output[6:0]==7'b0110011))&&ir4_output[11:7]==ir3_output[19:15]) // lui followed by add or addi
	begin        //lui followed by branch instructions //forward from z4  //lui follwed by jr or jalr //auipc follwed by add/addi/jr/jalr/sw
		select_operand1 = 2;
	end
else
	begin
		select_operand1 = 0;
	end

		//control for operand2 
if((ir5_output[6:0]==7'b0000011||ir5_output[6:0]==7'b0110011||ir5_output[6:0]==7'b0010011)&&((ir3_output[6:0]==7'b1100011||ir3_output[6:0]==7'b0110011))&&(ir5_output[11:7]==ir3_output[24:20])) //forward from z5
	begin //lw beq/add   //add add //sub add                                                                        
		select_operand2 = 1;
	end
else if((ir4_output[6:0]==7'b0110011)&&((ir3_output[6:0]==7'b1100011))&&(ir4_output[11:7]==ir3_output[24:20]))
	begin //add beq 
		select_operand2 = 2;
	end
else if((ir4_output[6:0]==7'b0110011||ir4_output[6:0]==7'b0110111)&&(ir3_output[6:0]==7'b0110011)&&(ir4_output[11:7]==ir3_output[24:20])) //add add forwarding from z4 
	begin // add add forward from z4 //lui add
		select_operand2 = 2;
	end
else
	begin
		select_operand2 = 0;
	end

//control for md4
if((ir5_output[6:0]==7'b0000011)||(ir5_output[6:0]==7'b0110011)||(ir5_output[6:0]==7'b0010011)&&(ir3_output[6:0]==7'b0100011)&&(ir5_output[11:7]==ir3_output[24:20])) // Lw rd,imm1 Sw rd,imm2  //Add rd,r1,r2 / Addi  Sw rd,imm //forward from z5
	begin
		select_md4 = 1;
	end
else if(((ir4_output[6:0]==7'b0110011)||(ir4_output[6:0]==7'b0010011))&&(ir3_output[6:0]==7'b0100011)&&(ir4_output[11:7]==ir3_output[24:20]))//Add rd,r1,r2 /Addi 	Sw rd,imm
	begin
		select_md4 = 2;
	end
else 
	begin
		select_md4 = 0;
	end
	

	// **stage 4th controls 
	//control for ir4	
	if(ir4_output[6:0] == 7'b1100011 && branch_control_output == 1)
	begin
	select_ir4 = 1;
	end
	else
	begin
	select_ir4 = 0;
	end
	//control for z5
if(ir4_output[6:0]==7'b0000011)  //Connected to read data (For load instructions)
	begin
		select_z5 = 0;
	end
else if(ir4_output[6:0]==7'b0110011||ir4_output[6:0]==7'b0010011||ir4_output[6:0]==7'b0110111||ir4_output[6:0]==7'b0010111) //Connected to Z4 (For arithmetic instructions)
	begin
		select_z5 = 1;
	end
else if(((ir4_output[6:0]==7'b1101111)||(ir4_output[6:0]==7'b1100111))&&(ir4_output[11:7]!=5'b00000)) //Connected to PC4 For jump and link instructions
	begin
		select_z5 = 2;
	end

	//control for datawrite
if((ir5_output[6:0]==7'b0000011)&&(ir4_output[6:0]==7'b0100011)&&(ir5_output[11:7]==ir4_output[24:20]))//lw rd, imm(rs1) sw rd,imm(rs2)
	begin			
		select_datawrite = 0;    //forward from z5
	end
else
	begin
		select_datawrite = 1;
	end

	// data_Write_signal
if(ir4_output[6:0]==7'b0100011) // only 1 for sw instruction
	begin
		data_write_signal = 1;
	end
else
	begin
		data_write_signal = 0;
	end	
	
	//reg_write_enable
if(ir5_output[6:0]==7'b0110011||ir5_output[6:0]==7'b0010011||ir5_output[6:0]==7'b1101111||ir5_output[6:0]==7'b0000011||ir5_output[6:0]==7'b0110111||ir5_output[6:0]==7'b0010111) //r-type i-type and j and link-type ins //lw //lui //auipc
	begin	
		reg_write_enable = 1;
	end
else 
	begin
		reg_write_enable = 0;
	end

	


end
end
endmodule
