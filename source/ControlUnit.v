`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 14:56:12
// Design Name: 
// Module Name: ControlUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ControlUnit(
    input clk,
    input reset,
    input [31:0] inst,
    input ALUzero,//ï¿½ï¿½ï¿½ï¿½ï¿½Ð¶ï¿½BEQ,BNEï¿½ï¿½ï¿½ï¿½×ª
    input ALUnega,//ï¿½ï¿½ï¿½ï¿½BGEZ
    
    output reg PC_ctr,
    output reg PC_ena,
    output reg IM_ctr,
    output reg Z_ctr,
    output reg Write_ena,
    output reg [3:0] ALU_op,
    output reg ALU_ctr,
    output reg II_ctr,
    output reg [1:0] C_MUXA,
    output reg [1:0] C_MUXB,
    output reg [1:0] C_MUXC,
    output reg [2:0] C_MUXD,
    output reg [2:0] C_MUXH,
    output reg [2:0] C_MUXL,
    output reg [1:0] C_MUXP,
    output reg [1:0] C_MUXADDR,
    output reg [1:0] DM_W,
    output reg [2:0] LT_ctr,
    output reg HI_ctr,
    output reg LO_ctr,
    output reg CLZ_ctr,
    output reg MUL_ctr,
    output reg MULTU_ctr,
    output reg DIV_ctr,
    output reg DIVU_ctr,
    output reg mfc0,
    output reg mtc0,
    output reg expection,
    output reg [3:0] cause,
    output reg eret,
    output reg finish,
    
    output reg state_out
    );
    parameter [3:0] SIF = 4'b0000,   // IF state
	                  SID = 4'b0001,   // ID state
                      SEXE_J = 4'b0010,  // jump
					  SEXE_ALU = 4'b0011,  // alu
					  SEXE_B = 4'b0100,  // b
					  SEXE_B1 = 4'b0101,  // b_next
					  SEXE_LS = 4'b0110,   // l&s
					  SEXE_LS1 = 4'b0111,   // l&s_next
					  SWB = 4'b1000, //save to reg
					  SCLZ= 4'b1001,
				      SMD= 4'b1010,
				      SHL=4'b1011, //special reg load and save 
					  SBRK=4'b1100;
					  	  
	 parameter [5:0]ADDI = 6'b001000,//1
                     ADDIU = 6'b001001,//2
                     ANDI = 6'b001100,//3
                     ORI = 6'b001101,//4
                     SLTIU = 6'b001011,//5
                     LUI = 6'b001111,//6
                     XORI = 6'b001110,//7
                     SLTI = 6'b001010,//8                    
                     BEQ = 6'b000100,//11
                     BNE = 6'b000101,//12
                     J = 6'b000010,//13
                     JAL = 6'b000011,//14
                     LW = 6'b100011,//16                    
                     SW = 6'b101011,//26                    
                     LB = 6'b100000,//36
                     LBU = 6'b100100,//37
                     LHU = 6'b100101,//38
                     SB = 6'b101000,//39
                     SH = 6'b101001,//40
                     LH = 6'b100001,//41                    
                     BGEZ = 6'b000001;//52
                                     
    parameter [12:0] ADDU = 6'b000000_100001,//9
                       AND = 6'b000000_100100,//10		
                       JR = 12'b000000_001000,//15
                       XOR = 12'b000000_100110,//17
                       NOR = 12'b000000_100111,//18
                       OR = 12'b000000_100101,//19
                       SLL = 12'b000000_000000,//20
                       SLLV = 12'b000000_000100,//21
                       SLTU = 12'b000000_101011,//22
                       SRA = 12'b000000_000011,//23
                       SRL = 12'b000000_000010,//24
                       SUBU = 12'b000000_100011,//25	
                       ADD = 12'b000000_100000,//27
                       SUB = 12'b000000_100010,//28
                       SLT = 12'b000000_101010,//29
                       SRLV = 12'b000000_000110,//30
                       SRAV = 12'b000000_000111,//31
                       CLZ = 12'b011100_100000,//32
                       DIVU = 12'b000000_011011,//33
                       ERET = 12'b010000_011000,//34
                       JALR = 12'b000000_001001,//35 	
                       MFC0 = 12'b010000_000000,//42 same
                       MFHI = 12'b000000_010000,//43
                       MFLO = 12'b000000_010010,//44
                       MTC0 = 12'b010000_000000,//45 same
                       MTHI = 12'b000000_010001,//46
                       MTLO = 12'b000000_010011,//47
                       //MUL = 12'b000000_011000,//48
                       MUL = 12'b011100_000010,
                       MULT = 12'b000000_011000,//48
                       MULTU = 12'b000000_011001,//49
                       SYSCALL = 12'b000000_001100,//50
                       TEQ = 12'b000000_110100,//51 
                       BREAK = 12'b000000_001101,//53
                       DIV = 12'b000000_011010;//54
                       
	 reg [3:0] state;
	 reg [3:0] next_state;
     reg [11:0] inst_tag;
     reg [5:0] inst_tag1;
     reg [4:0] jump_tag;
     reg [4:0] CP0_tag;
     
    always@(posedge clk or posedge reset)begin
        if(reset==1)begin
            state<=SIF;
            state_out<=1;
        end
        else 
            state<=next_state;
    end

    always@(*)begin//×´Ì¬±ä»¯
        case(state)
            SIF:next_state<=SID;

            SID:begin
                if(inst_tag1==JAL||inst_tag==JALR)
                    next_state<=SEXE_J;
                else if(inst_tag1==J||inst_tag==JR||inst==0)
                    next_state<=SIF;
                else if(inst_tag1==BEQ||inst_tag1==BNE||inst_tag1==BGEZ||inst_tag==TEQ)
                    next_state<=SEXE_B;
                else if(inst_tag1==LB||inst_tag1==LBU||inst_tag1==LH||inst_tag1==LHU||inst_tag1==LW||inst_tag1==SB||inst_tag1==SH||inst_tag1==SW)
                    next_state<=SEXE_LS;
                else if(inst_tag==CLZ)
                    next_state<=SCLZ;
                else if(inst_tag==MUL||inst_tag==MULTU||inst_tag==DIV||inst_tag==DIVU||inst_tag==MULT)
                    next_state<=SMD;
                else if(inst_tag==MFC0||inst_tag==MFHI||inst_tag==MFLO||inst_tag==MTC0||inst_tag==MTHI||inst_tag==MTLO)
                    next_state<=SHL;
                else if(inst_tag==SYSCALL||inst_tag==BREAK||inst_tag==ERET)
                    next_state<=SBRK;
                else next_state<=SEXE_ALU;
            end
            
            SBRK:next_state<=SIF;
            
            SHL:next_state<=SIF;
            
            SMD:begin
                if(inst_tag==MUL)
                    next_state<=SHL;
                else 
                    next_state<=SIF;
            end
            
            SEXE_J:next_state<=SIF;
            
            SEXE_B:begin
                if(inst_tag1==BEQ&&ALUzero==1)next_state<=SEXE_B1;
                else if(inst_tag1==BNE&&ALUzero==0)next_state<=SEXE_B1;
                else if(inst_tag1==BGEZ&&ALUnega==0)
                    next_state<=SEXE_B1;
                else if(inst_tag==TEQ&&ALUzero==1)next_state<=SBRK;
                else next_state<=SIF;
            end
            
            SEXE_B1:next_state<=SIF;
            
            SEXE_LS:next_state<=SEXE_LS1;
            
            SEXE_LS1:next_state<=SIF;
            
            SEXE_ALU:next_state<=SWB;
            
            SCLZ:next_state<=SWB;
            
            SWB:next_state<=SIF;
        endcase
        if(next_state==SIF)finish<=1;
        else finish<=0;
    end

    always@(*)begin//¿ØÖÆÐÅºÅ
        if(reset)begin
            PC_ctr<=0;
            PC_ena<=0;
            IM_ctr<=0;
            Z_ctr<=0;
            Write_ena<=0;
            ALU_op<=4'b0000;
            ALU_ctr<=0;
            C_MUXA<=2'b00;
            C_MUXB<=2'b00;
            C_MUXC<=2'bzz;
            C_MUXD<=3'bzzz;
            C_MUXH<=3'bzzz;
            C_MUXL<=3'bzzz;
            C_MUXP<=2'b00;
            C_MUXADDR<=2'bzz;
            DM_W<=2'bzz;
            LT_ctr<=2'bzz;
            CLZ_ctr<=0;
            HI_ctr<=0;
            LO_ctr<=0;
            MUL_ctr<=0;
            MULTU_ctr<=0;
            DIV_ctr<=0;
            DIVU_ctr<=0;
            mtc0<=0;
            mfc0<=0;
            expection<=0;
            eret<=0;
            cause<=4'b0000;
            II_ctr<=0;
        end
        case(state)
            SIF:begin
                PC_ctr<=1;
                PC_ena<=0;
                IM_ctr<=1;
                Z_ctr<=1;
                Write_ena<=0;
                ALU_op<=4'b0000;
                ALU_ctr<=1;
                C_MUXA<=2'b00;
                C_MUXB<=2'b00;
                C_MUXC<=2'bzz;
                C_MUXP<=2'b00;
                C_MUXD<=3'bzzz;
                C_MUXH<=3'bzzz;
                C_MUXL<=3'bzzz;
                C_MUXADDR<=2'bzz;
                DM_W<=2'bzz;
                LT_ctr<=2'bzz;
                CLZ_ctr<=0;
                HI_ctr<=0;
                LO_ctr<=0;
                MUL_ctr<=0;
                MULTU_ctr<=0;
                DIV_ctr<=0;
                DIVU_ctr<=0;
                mtc0<=0;
                mfc0<=0;
                expection<=0;
                eret<=0;
                cause<=4'b0000;
                II_ctr<=0;
                
                inst_tag <= {inst[31:26],inst[5:0]};
                inst_tag1<=inst[31:26];
                jump_tag<=inst[20:16];
                CP0_tag<=inst[25:21];
            end

            SID:begin
                PC_ctr<=1;
                PC_ena<=1;
                              
                IM_ctr<=0;
                Z_ctr<=0;
                ALU_ctr<=0;
                if(inst_tag1==JAL)begin
                    II_ctr<=1;
                    Write_ena<=1;
                    C_MUXD<=3'b000;
                    C_MUXADDR<=2'b10;
                end
                else if(inst_tag==JALR)begin
                     Write_ena<=1;
                     C_MUXD<=3'b000;
                     if(jump_tag==5'b00000)C_MUXADDR<=2'b10;
                     else C_MUXADDR<=2'b00;
                     end
                else Write_ena<=0;
                
                if(inst_tag1==J)begin
                    C_MUXP<=2'b01;
                    II_ctr<=1;
                end
                else if(inst_tag==JR)C_MUXP<=2'b10;
                else C_MUXP<=2'b00;
            end

            SEXE_J:begin
                PC_ctr<=1;
                PC_ena<=1;
                IM_ctr<=0;
                Z_ctr<=0;
                Write_ena<=0;
                ALU_ctr<=0;
                if(inst_tag1==JAL)C_MUXP<=2'b01;
                else if(inst_tag==JALR)C_MUXP<=2'b10;
            end

            SEXE_B:begin
                PC_ctr<=0;
                PC_ena<=0;
                IM_ctr<=0;
                Z_ctr<=1;
                Write_ena<=0;
                ALU_op<=4'b0011;
                ALU_ctr<=1;
                C_MUXA<=2'b01;
                if(inst_tag1==BGEZ)C_MUXB<=2'b11;
                else C_MUXB<=2'b01;
            end

            SEXE_B1:begin
                PC_ctr<=1;
                PC_ena<=1;
                IM_ctr<=0;
                Z_ctr<=1;
                Write_ena<=0;
                ALU_op<=4'b0010;
                ALU_ctr<=1;
                C_MUXA<=2'b00;
                C_MUXB<=2'b10;
                C_MUXC<=2'b11;
                C_MUXP<=2'b00;
            end

            SEXE_LS:begin
                PC_ctr<=0;
                PC_ena<=0;
                IM_ctr<=0;
                Z_ctr<=1;
                Write_ena<=0;
                ALU_op<=4'b0010;
                ALU_ctr<=1;
                C_MUXA<=2'b01;
                C_MUXB<=2'b10;
                C_MUXC<=2'b00;
            end

            SEXE_LS1:begin
                PC_ctr<=0;
                PC_ena<=0;
                IM_ctr<=0;
                Z_ctr<=0;
                ALU_ctr<=0;
                if(inst_tag1==LB||inst_tag1==LBU||inst_tag1==LH||inst_tag1==LHU||inst_tag1==LW)begin
                    Write_ena<=1;
                    C_MUXD<=3'b010;
                    C_MUXADDR<=2'b01;
                end
                else Write_ena<=0;

                if(inst_tag1==LB)LT_ctr<=3'b001;
                else if(inst_tag1==LBU)LT_ctr<=3'b010;
                else if(inst_tag1==LH)LT_ctr<=3'b011;
                else if(inst_tag1==LHU)LT_ctr<=3'b100;
                else if(inst_tag1==LW)LT_ctr<=3'b000;
                
                if(inst_tag1==SB)DM_W<=2'b11;
                else if(inst_tag1==SH)DM_W<=2'b10;
                else if(inst_tag1==SW)DM_W<=2'b01;
            end

            SWB:begin
                PC_ctr<=0;
                PC_ena<=0;
                IM_ctr<=0;
                Z_ctr<=0;
                Write_ena<=1;
                ALU_ctr<=0;
                if(inst_tag==CLZ)C_MUXD<=3'b110;
                else C_MUXD<=3'b001;
                               
                if(inst_tag1==ADDI||inst_tag1==ADDIU||inst_tag1==ANDI||inst_tag1==ORI||inst_tag1==XORI||inst_tag1==LUI||inst_tag1==SLTI||inst_tag1==SLTIU)
                    C_MUXADDR<=2'b01;
                else C_MUXADDR<=2'b00; 
            end
            
            SCLZ:begin
                PC_ctr<=0;
                PC_ena<=0;
                IM_ctr<=0;
                Z_ctr<=0;
                Write_ena<=0;
                ALU_ctr<=0;
                C_MUXA<=1;
                CLZ_ctr<=1;
            end
            
            SMD:begin
                PC_ctr<=0;
                PC_ena<=0;
                IM_ctr<=0;
                Z_ctr<=0;
                Write_ena<=0;
                ALU_ctr<=0;
                HI_ctr<=1;
                LO_ctr<=1;
                if(inst_tag==MULT)begin
                    MUL_ctr<=1;
                    C_MUXH<=2'b000;
                    C_MUXL<=2'b000;
                end
                else if(inst_tag==MUL)begin
                    MUL_ctr<=1;
                    C_MUXH<=2'b000;
                    C_MUXL<=2'b000;
                end
                else if(inst_tag==MULTU)begin
                     MULTU_ctr<=1;
                     C_MUXH<=2'b001;
                     C_MUXL<=2'b001;
                end
                else if(inst_tag==DIV)begin
                     DIV_ctr<=1;
                     C_MUXH<=2'b010;
                     C_MUXL<=2'b010;
                end
                else if(inst_tag==DIVU)begin
                     DIVU_ctr<=1;
                     C_MUXH<=2'b011;
                     C_MUXL<=2'b011;
                end                
            end
            
            SHL:begin
                PC_ctr<=0;
                PC_ena<=0;
                IM_ctr<=0;
                Z_ctr<=0;
                Write_ena<=0;
                ALU_ctr<=0;
                if(inst_tag==MTLO)begin
                    C_MUXH<=3'b100;
                    C_MUXL<=3'b100;
                    HI_ctr<=0;
                    LO_ctr<=1;
                end
                if(inst_tag==MTHI)begin
                    C_MUXH<=3'b100;
                    C_MUXL<=3'b100;
                    HI_ctr<=1;
                    LO_ctr<=0;
                    end
                else if(inst_tag==MFLO)begin
                    HI_ctr<=0;
                    LO_ctr<=0;
                    C_MUXADDR<=2'b00;
                    C_MUXD<=3'b100;
                    Write_ena<=1;
                end
                else if(inst_tag==MUL)begin
                    HI_ctr<=0;
                    LO_ctr<=0;
                    C_MUXADDR<=2'b00;
                    C_MUXD<=3'b100;
                    Write_ena<=1;
                end
                else if(inst_tag==MFHI)begin
                     HI_ctr<=0;
                     LO_ctr<=0;
                     C_MUXADDR<=2'b00;
                     C_MUXD<=3'b011;
                     Write_ena<=1;
                end
                else if(inst_tag==MTC0)begin
                     if(CP0_tag==5'b00000)begin//MFC0
                        mfc0<=1;
                        C_MUXADDR<=2'b01;
                        Write_ena<=1;
                        C_MUXD<=3'b101;
                     end
                     else begin//MTC0 
                        mtc0<=1;
                     end
                end
            end
            
            SBRK:begin
                PC_ctr<=1;
                PC_ena<=1;
                IM_ctr<=0;
                Z_ctr<=0;
                Write_ena<=0;
                ALU_ctr<=0;
                C_MUXP<=2'b11;
                if(inst_tag==SYSCALL)begin
                    cause<=4'b1000;
                    expection<=1;
                end
                else if(inst_tag==TEQ)begin
                    cause<=4'b1101;
                    expection<=1;
                end
                else if(inst_tag==BREAK)begin
                    cause<=4'b1001;
                    expection<=1;
                end
                else if(inst_tag==ERET)begin
                    eret<=1;
                end
            end      
            
            SEXE_ALU:begin
                PC_ctr<=0;
                PC_ena<=0;
                IM_ctr<=0;
                Z_ctr<=1;
                Write_ena<=0;
                ALU_ctr<=1;
                if(inst_tag==SLLV||inst_tag==SRLV||inst_tag==SRAV)C_MUXA<=2'b10;
                else if(inst_tag==SLL||inst_tag==SRL||inst_tag==SRA)     
                    C_MUXA<=2'b11;          
                else C_MUXA<=2'b01;
                
                if(inst_tag1==ADDI||inst_tag1==ADDIU||inst_tag1==ANDI||inst_tag1==ORI||inst_tag1==XORI||inst_tag1==LUI||inst_tag1==SLTI||inst_tag1==SLTIU)
                    C_MUXB<=2'b10;
                else C_MUXB<=2'b01;
                
                if(inst_tag==SLL||inst_tag==SRL||inst_tag==SRA)C_MUXC<=2'b10;
                else if(inst_tag1==ANDI||inst_tag1==ORI||inst_tag1==XORI||inst_tag1==SLTIU||inst_tag1==LUI)
                    C_MUXC<=2'b01;
                else if(inst_tag1==ADDI||inst_tag1==SLTI||inst_tag1==ADDIU)
                    C_MUXC<=2'b00;

                    
                if(inst_tag==ADD||inst_tag1==ADDI)ALU_op<=4'b0010;
                else if(inst_tag==ADDU||inst_tag1==ADDIU)ALU_op<=4'b0000;
                else if(inst_tag==AND||inst_tag1==ANDI)ALU_op<=4'b0100;
                else if(inst_tag==OR||inst_tag1==ORI)ALU_op<=4'b0101;
                else if(inst_tag==XOR||inst_tag1==XORI)ALU_op<=4'b0110;
                else if(inst_tag==SLT||inst_tag1==SLTI)ALU_op<=4'b1011;
                else if(inst_tag==SLTU||inst_tag1==SLTIU)ALU_op<=4'b1010;
                else if(inst_tag==NOR)ALU_op<=4'b0111;
                else if(inst_tag==SUB)ALU_op<=4'b0011;
                else if(inst_tag==SUBU)ALU_op<=4'b0001;
                else if(inst_tag1==LUI)ALU_op<=4'b1000;
                else if(inst_tag==SLL||inst_tag==SLLV)ALU_op<=4'b1110;
                else if(inst_tag==SRL||inst_tag==SRLV)ALU_op<=4'b1101;
                else if(inst_tag==SRA||inst_tag==SRAV)ALU_op<=4'b1100;
            end
        endcase
    end
endmodule
