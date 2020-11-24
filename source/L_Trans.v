`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 15:25:06
// Design Name: 
// Module Name: L_Trans
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


module L_Trans(
    input [31:0] a,
    input [2:0]ctr,
    
    output [31:0] z
    );
    reg [31:0] temp;
    always@(*)begin
        case(ctr)
            //lb
            3'b001:temp<={{24{a[7]}},a[7:0]};
            //lbu
            3'b010:temp<={{24{1'b0}},a[7:0]};
            //lh
            3'b011:temp<={{16{a[15]}},a[15:0]};
            //lhu
            3'b100:temp<={{16{1'b0}},a[15:0]};
            default:temp<=a;
        endcase
    end
    assign z=temp;
endmodule
