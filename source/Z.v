`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/26 23:15:24
// Design Name: 
// Module Name: Z
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


module Z(
    input ctr,
    //input ena,
    input [31:0] data_in,
    output [31:0] data_out
    );
    wire[31:0]temp;
    assign temp=(ctr)?data_in:temp;
    assign data_out=(ctr)?temp:data_out;
endmodule
