`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/16 16:17:53
// Design Name: 
// Module Name: uextend16
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

//�޷���16λ��չ
module uextend16(
    input [15:0] a,
    output [31:0] b
    );
    assign b = {{16{1'b0}},a};
endmodule
