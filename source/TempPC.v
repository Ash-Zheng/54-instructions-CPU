`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/06 22:44:16
// Design Name: 
// Module Name: TempPC
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


module TempPC(
    input clk,
    input reset,
    input ctr,
    input [31:0] pc,
    
    output reg [31:0] z
    );
    always@(posedge clk or posedge reset)begin
        if(reset==1)z<=32'h00400000;
        else begin
            if(ctr==1)z<=pc;
        end
    end
endmodule
