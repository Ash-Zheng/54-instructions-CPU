`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/18 10:15:03
// Design Name: 
// Module Name: MULTU
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


module MULTU(
    input clk,
    input reset,
    input [31:0]a,
    input [31:0]b,
    input ctr,
    output [31:0] HI,
    output [31:0] LO
    );
    reg [63:0] temp;
    reg [63:0] tpa;
    reg [63:0] shift;
    wire [63:0] z;
    integer i;
    always @(posedge clk or negedge reset)begin
        if(reset)begin
            temp=0;
            tpa=0;
            shift=0;
          end
        else if(ctr==1)
        begin
          temp=0;
            for(i=0;i<32;i=i+1) begin
                tpa=0;
                shift=0;
                if(b[i]==1)begin
                    shift={32'b0,a};
                    tpa=shift<<i;
                    temp=temp+tpa;
                end
            end
        end          
    end 
    assign z=temp;
    assign HI=z[63:32];
    assign LO=z[31:0];
endmodule
