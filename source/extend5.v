`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/16 08:29:06
// Design Name: 
// Module Name: extend5
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

//��5λ��չ��32λ
module extend5(
    input [4:0] a,
    
    output [31:0] b
    );
    assign b = {{27{1'b0}},a};
endmodule
