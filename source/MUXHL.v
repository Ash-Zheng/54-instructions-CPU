`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/04 09:55:12
// Design Name: 
// Module Name: MUXHL
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


module MUXHL(
    input [31:0]a,
    input [31:0]b,
    input [31:0]c,
    input [31:0]d,
    input [31:0]e,
    input [2:0]ctr,
   
    output [31:0] z
    );
    reg [31:0] temp;
    always@(*)begin
        case(ctr)
            3'b000:temp<=a;
            3'b001:temp<=b;
            3'b010:temp<=c;
            3'b011:temp<=d;
            3'b100:temp<=e;
            //default:temp<=32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
        endcase
    end
    assign z=temp;
endmodule
