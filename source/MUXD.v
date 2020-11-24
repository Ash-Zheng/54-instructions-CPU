`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/30 14:51:20
// Design Name: 
// Module Name: MUXD
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


module MUXD(
    input [31:0]a,
    input [31:0]b,
    input [31:0]c,
    input [31:0]d,
    input [31:0]e,
    input [31:0]f,
    input [31:0]g,
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
                3'b101:temp<=f;
                3'b110:temp<=g;
            endcase
        end
        assign z=temp;
endmodule
