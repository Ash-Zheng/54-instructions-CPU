`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/16 10:36:28
// Design Name: 
// Module Name: II
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


module II(
    input [3:0] a,
    input [25:0] b,
    input ctr,
    output [31:0] r
    );
    reg [31:0] temp;
    always@(*)begin
        if(ctr==1)begin
        temp<={a,b<<2};
        end
    end
    assign r = temp;
endmodule
