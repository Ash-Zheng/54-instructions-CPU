`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/15 11:12:48
// Design Name: 
// Module Name: sccomp_dataflow
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

module sccomp_dataflow(
    input clk_in,
    input reset,
    
    output [31:0]inst,
    output [31:0]pc
    );
    wire IM_R;
    wire [31:0]rdata;
    wire [31:0]addr;      
    wire [31:0]wdata;
    wire [1:0]DM_W;
    wire [31:0] realpc;
    cpu sccpu(clk_in,reset,inst,rdata,pc,addr,wdata,DM_W,realpc);
    dist_mem_gen_0 IMEM1(realpc[15:2],inst[31:0]);
    dmem DMEM(addr[7:0],wdata,clk_in,DM_W,rdata); 
endmodule
