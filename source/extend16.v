`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/16 08:31:45
// Design Name: 
// Module Name: extend16
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

//从16位扩展到32位

module extend16(
    input [15:0] a,
    output [31:0] b
    );
    assign b = {{16{a[15]}},a};
endmodule
/*
module extend16(
    input [15:0] a,
    input sext,             //1表示有符号
    output [31:0] b
    );
    assign b = sext ? {{(16){a[15]}},a} : {{(16){1'b0}},a};
endmodule
*/