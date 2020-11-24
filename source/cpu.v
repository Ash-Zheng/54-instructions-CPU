`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/15 14:17:23
// Design Name: 
// Module Name: cpu
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


module cpu(
    input clk,
    input reset,
    input [31:0] inst,
    input [31:0] rdata,
    output [31:0] pc,
    output [31:0] addr,
    output [31:0] wdata,
    output [1:0] DM_W,
    output [31:0] realpc
    );
    //控制信号
    wire ALUzero;
    wire ALUcarry;
    wire ALUoverflow;
    wire ALUnegative;
    wire PC_ctr;
    wire PC_ena;
    wire IM_ctr;
    wire Z_ctr;
    wire Write_ena;
    wire [3:0] ALU_op;
    wire ALU_ctr;
    wire [1:0] C_MUXA;
    wire [1:0] C_MUXB;
    wire [1:0] C_MUXC;
    wire [2:0] C_MUXD;
    wire [2:0] C_MUXH;
    wire [2:0] C_MUXL;
    wire [1:0] C_MUXP;
    wire [1:0] C_MUXADDR;
    //wire [1:0] DM_W;
    wire [2:0] LT_ctr;
    wire HI_ctr;
    wire LO_ctr;
    wire CLZ_ctr;
    wire MUL_ctr;
    wire MULTU_ctr;
    wire DIV_ctr;
    wire DIVU_ctr;
    wire II_ctr;
    wire finish;
    
    //输出信号  
    wire state_out;
    wire [31:0] PC4;
    wire [31:0] PC0;
    wire [31:0] ALU_out;
    wire [31:0] RegRs;
    wire [31:0] RegRt;
    wire [31:0] PC_out;
    wire [31:0] Z_out;
    wire [31:0] IM_out;
    wire [31:0] D_MUXA;
    wire [31:0] D_MUXB;
    wire [31:0] D_MUXC;
    wire [31:0] D_MUXD;
    wire [31:0] D_MUXH;
    wire [31:0] D_MUXL;
    wire [31:0] D_MUXP;
    wire [4:0] D_MUXADDR;
    wire [31:0] D_EXT16;
    wire [31:0] D_UEXT16;
    wire [31:0] D_EXT18;
    wire [31:0] D_EXT5;
    wire [31:0] II_out;
    wire [31:0] LT_out;
    wire [31:0] CLZ_out;
    wire [31:0] MUL_H;
    wire [31:0] MUL_L;
    wire [31:0] MULTU_H;
    wire [31:0] MULTU_L;
    wire [31:0] DIV_Q;
    wire [31:0] DIV_R;
    wire [31:0] DIVU_Q;
    wire [31:0] DIVU_R;
    
    wire [31:0] HI_out;
    wire [31:0] LO_out;
    
    //CPO
    wire mfc0;
    wire mtc0;
    wire [31:0] prePC;
    wire [4:0] cp0_addr;
    wire [31:0] cp0_wdata;
    wire exception;
    wire eret;
    wire [3:0] cause;
    
    wire [31:0] CP0_rdata;
    wire [31:0] status;
    wire [31:0]exc_addr;
    
    assign PC4=4;
    assign PC0=0;
    assign realpc=PC_out;
    assign wdata=RegRt;
    assign addr=Z_out;
    assign prePC=PC_out-4;
    
    //TempPC TPC(clk,reset,finish,PC_out,pc);
    assign pc=PC_out;
    ControlUnit control(clk,reset,IM_out,ALUzero,ALUnegative,PC_ctr,PC_ena,IM_ctr,Z_ctr,Write_ena,ALU_op,ALU_ctr,II_ctr,C_MUXA,C_MUXB,C_MUXC,C_MUXD,C_MUXH,C_MUXL,C_MUXP,C_MUXADDR,DM_W,LT_ctr,HI_ctr,LO_ctr,CLZ_ctr,MUL_ctr,MULTU_ctr,DIV_ctr,DIVU_ctr,mfc0,mtc0,expection,cause,eret,finish,state_out);
    alu ALU(ALU_ctr,D_MUXA,D_MUXB,ALU_op,ALU_out,ALUzero,ALUcarry,ALUnegative,ALUoverflow);
    regfile cpu_ref(clk,Write_ena,reset,IM_out[25:21],IM_out[20:16],D_MUXADDR,D_MUXD,RegRs,RegRt);
   
    MUXA MUX_A(PC_out,RegRs,D_MUXC,C_MUXA,D_MUXA);
    MUXBC MUX_B(PC4,RegRt,D_MUXC,PC0,C_MUXB,D_MUXB);
    MUXBC MUX_C(D_EXT16,D_UEXT16,D_EXT5,D_EXT18,C_MUXC,D_MUXC);
    MUXD MUX_D(PC_out,Z_out,LT_out,HI_out,LO_out,CP0_rdata,CLZ_out,C_MUXD,D_MUXD);
    MUXBC MUX_P(Z_out,II_out,RegRs,exc_addr,C_MUXP,D_MUXP);
    MUXADDR MUX_addr(IM_out,C_MUXADDR,D_MUXADDR);
    Z RegZ(Z_ctr,ALU_out,Z_out);
    pcreg PC(clk,PC_ctr,PC_ena,reset,D_MUXP,PC_out);
    Z IMEMreg(IM_ctr,inst,IM_out);
    extend5 EXT5(IM_out[10:6],D_EXT5);
    extend16 EXT16(IM_out[15:0],D_EXT16);
    uextend16 UEXT16(IM_out[15:0],D_UEXT16);
    extend18 EXT18(IM_out[15:0],D_EXT18);
    II cpu_ii(4'b0000,IM_out[25:0],II_ctr,II_out);
    L_Trans LT(rdata,LT_ctr,LT_out);
    CLZ clz(D_MUXA,CLZ_ctr,CLZ_out);
    
    MULT mul(clk,reset,RegRs,RegRt,MUL_ctr,MUL_H,MUL_L);
    MULTU multu(clk,reset,RegRs,RegRt,MULTU_ctr,MULTU_H,MULTU_L);
    DIV div(RegRs,RegRt,DIV_ctr,clk,reset,DIV_Q,DIV_R);
    DIVU divu(RegRs,RegRt,DIVU_ctr,clk,reset,DIVU_Q,DIVU_R);
    MUXHL MUX_HI(MUL_H,MULTU_H,DIV_R,DIVU_R,RegRs,C_MUXH,D_MUXH);
    MUXHL MUX_LO(MUL_L,MULTU_L,DIV_Q,DIVU_Q,RegRs,C_MUXL,D_MUXL);
    Z HI(HI_ctr,D_MUXH,HI_out);
    Z LO(LO_ctr,D_MUXL,LO_out);
    
    CP0 cp0(clk,reset,mfc0,mtc0,prePC,IM_out[15:11],RegRt,expection,eret,cause,CP0_rdata,status,exc_addr);
    
endmodule