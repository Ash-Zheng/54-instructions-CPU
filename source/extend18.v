`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/16 08:35:45
// Design Name: 
// Module Name: extend18
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

//从16位开始，先乘4，然后扩展到32位
module extend18(
    input [15:0] a,
    
    output [31:0] b
    );
    assign b = {{14{a[15]}},a,2'b00};
endmodule
