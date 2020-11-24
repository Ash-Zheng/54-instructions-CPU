`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/30 14:38:50
// Design Name: 
// Module Name: MUXA
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


module MUXA(
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [1:0] ctr,
    
    output [31:0] z
    );
    reg [31:0] temp;
    always@(*)begin
        case(ctr)
            2'b00:temp<=a;
            2'b01:temp<=b;
            2'b10:begin
                temp <= {{27{1'b0}},b[4:0]};
            end
            2'b11:temp<=c;
        endcase
    end
    assign z=temp;
endmodule
