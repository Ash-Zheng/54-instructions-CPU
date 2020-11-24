`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/13 19:41:01
// Design Name: 
// Module Name: CP0
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



module CP0(clk,rst,mfc0,mtc0,pc,Rd,wdata,exception,eret,cause,rdata,status,exc_addr);
       input clk;
       input rst;
       input mfc0;//CPU指令mfc0
       input mtc0;//CPU指令mtc0
       input [31:0]pc;
       input [4:0] Rd;//指定CP0寄存器
       input [31:0] wdata;//数据从GP寄存器到CP0寄存器
       input exception;
       input eret;//指令ERET(Exception Return)
       input [3:0]cause;
       output [31:0] rdata;//数据从CP0寄存器到GP寄存器
       output [31:0] status;
       output [31:0]exc_addr;//异常起始地址
       
       reg [31:0] cp0[31:0];
       integer i;
       always @(negedge clk or posedge rst)
       begin
       if(rst)begin
              for(i=0;i<=31;i=i+1)
                   cp0[i] <= 0;
              end
       else begin
            if(mtc0) cp0[Rd] <= wdata;
            else if(exception)
                 begin
                 cp0[12] <= {status[26:0],5'b0};
                 cp0[13] <= {26'b0,cause,2'b00};
                 cp0[14] <= pc;
                 end
            else if(eret)
                 begin
                 cp0[12] <= {5'b0,status[31:5]};
                 end
            else cp0[12] <= cp0[12];
            end
       end
       
       assign status=cp0[12];
       assign exc_addr = eret ? cp0[14] : 32'h00400004;
       assign rdata = mfc0 ? cp0[Rd] : rdata;
endmodule
