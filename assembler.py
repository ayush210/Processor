from numpy import binary_repr
k = open('machinecode.txt','w')
with open('assemblycode.txt') as f:
	a = f.readlines()
#	print a
	
for j in range(0,len(a)):
		if(a[j][3:]=='\n'):
				output = '00000000000000000000000000000000'
		else:
			num = []
			f = a[j][4:].split();
			opcode_dict = {'add':'0110011','sub':'0110011','and':'0110011','or':'0110011','xor':'0110011','slt':'0110011','sltu':'0110011','sra':'0110011','srl':'0110011','sll':'0110011','mul':'0110011','addi':'0010011','subi':'0010011','andi':'0010011','ori':'0010011','xori':'0010011','slti':'0010011','sltiu':'0010011','srai':'0010011','srli':'0010011','slli':'0010011','lui':'0110111','auipc':'0010111','lw':'0000011','sw':'0100011','jal':'1101111','jr':'1100111','jalr':'1100111','beq':'1100011','bne':'1100011','blt':'1100011','bge':'1100011','bltu':'1100011','bgeu':'1100011'}
			funct3_dict = {'add':'000','sub':'000','and':'111','or':'110','xor':'100','slt':'010','sltu':'011','sra':'101','srl':'101','sll':'001','mul':'000','addi':'000','subi':'001','andi':'111','ori':'110','xori':'100','slti':'010','sltiu':'011','srai':'101','srli':'101','slli':'101','lw':'010','sw':'010','beq':'000','bne':'001','blt':'100','bge':'101','bltu':'110','bgeu':'111'}
			funct7_dict = {'add':'0100000','sub':'0000000','and':'0000000','or':'0000000','xor':'0000000','slt':'0000000','sltu':'0000000','sra':'0100000','srl':'0000000','sll':'0000000','mul':'0000001','srai':'0100000','srli':'0000000','slli':'0000001'}
			reg_dict = {0:'00000',1:'00001',2:'00010',3:'00011',4:'00100',5:'00101',6:'00110',7:'00111',8:'01000',9:'01001',10:'01010',11:'01011',12:'01100',13:'01101',14:'01110',15:'01111',16:'10000',17:'10001',18:'10010',19:'10011',20:'10100',21:'10101',22:'10110',23:'10111',24:'11000',25:'11001',26:'11010',27:'11011',28:'11100',29:'11101',30:'11110',31:'11111'}
#			print f
			output = opcode_dict[f[0]]
			for i in range(1,len(f)):
					num.append(f[i][1: ])
#			print num
#print output
			if(output=="0110011"):  # R-type register instruction
				output = funct7_dict[f[0]] +  reg_dict[int(num[2])]  +  reg_dict[int(num[1])]  + funct3_dict[f[0]]  + reg_dict[int(num[0])]  +  output
			if(output=="0010011"):  #immediate instruction
					if (f[0]=="srai" or f[0]=="srli" or f[0]=="slli"):
						output = funct7_dict[f[0]]  + binary_repr(int(num[2]),5)  + reg_dict[int(num[1])]  + funct3_dict[f[0]] + reg_dict[int(num[0])] + output
					else:
						output = binary_repr(int(num[2]),12)  + reg_dict[int(num[1])] + funct3_dict[f[0]]  +  reg_dict[int(num[0])] + output
			if(output=="0110111" or output=="0010111"):         #lui or auipc
					output  = binary_repr(int(num[1]),20) + reg_dict[int(num[0])] + output
			if(output=="0000011"): #lw
					output = binary_repr(int(num[2]),12) + reg_dict[int(num[1])] + funct3_dict[f[0]]  +  reg_dict[int(num[0])]  + output
			if(output=="0100011"): #sw
					output =  binary_repr(int(num[2]),12)[0:7] +  reg_dict[int(num[0])]  +  reg_dict[int(num[1])]  +  funct3_dict[f[0]]  +  binary_repr(int(num[2]),12)[7:12]  +  output
			if(output=="1101111"): #jal
					output = binary_repr(int(num[1]),20)  +  reg_dict[int(num[0])]  + output
			if(output=="1100111"): #jr or jalr
					if(f[0]=="jr"):
						output = '000000000000' +  reg_dict[int(num[0])] +  '000' +  '00000' +  output
					if(f[0]=="jalr"):
						output = binary_repr(int(num[2]),12) +  reg_dict[int(num[1])] +  '000' +  reg_dict[int(num[0])] +  output
#		print output,"herr",output=="1100011";
#if(output=="1100011"):
#				print("ayush\n")
			if(output=="1100011"): #branch_instruction	    
			    	output = binary_repr(int(num[2]),13)[0] + binary_repr(int(num[2]),13)[2:8] +  reg_dict[int(num[1])] +  reg_dict[int(num[0])] +funct3_dict[f[0]] +  binary_repr(int(num[2]),13)[8:12] + binary_repr(int(num[2]),13)[1] +  output	
		k.write(output + '\n') #writing to output file
#print(output)
