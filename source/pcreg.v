`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/16 10:26:56
// Design Name: 
// Module Name: pcreg
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


module pcreg(
    input clk,
    input ctr,
    input ena,
    input rst,
    input [31:0] data_in,
    
    output reg [31:0] data_out 
    );
    wire[31:0]temp;
    assign temp=(ctr)?data_in:temp;
    always @(negedge clk or posedge ena or posedge rst)
    begin
        if(rst) data_out = 32'h0040_0000;
        else if(ena) data_out = temp;
        else data_out = data_out;
    end
endmodule
