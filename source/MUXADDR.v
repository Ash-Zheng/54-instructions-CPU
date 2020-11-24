`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/30 16:00:47
// Design Name: 
// Module Name: MUXADDR
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


module MUXADDR(
    input [31:0] a,
    input [1:0] ctr,
    
    output [4:0] z
    );
    reg [4:0] temp;
    always@(*)begin
        if(ctr==2'b00)temp<=a[15:11];
        else if(ctr==2'b01)temp<=a[20:16];
        else if(ctr==2'b10)temp<=5'b11111;
        else if(ctr==2'b11)temp<=a[25:21];
        else temp<=5'bzzzzz;
    end
    assign z=temp;
endmodule
