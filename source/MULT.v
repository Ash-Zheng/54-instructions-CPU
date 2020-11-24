`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/18 10:45:56
// Design Name: 
// Module Name: MULT
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


module MULT(
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
    reg [31:0] na;
    reg [31:0] nb;
    reg tag;
    wire [63:0] z;
    integer i;
    always@(posedge clk or negedge reset)begin
        if(reset)begin
            temp=0;
            tpa=0;
            shift=0;
            na=0;
            nb=0;
            tag=0;
        end       
        else begin
            if(ctr==1) begin
            temp=0;
            tag=0;
            if(a[31]==1)begin
            tag=tag+1;
            na=~a+1;
            end
            else na=a;
            if(b[31]==1)begin
            tag=tag+1;
            nb=~b+1;
            end
            else nb=b;
        
        for(i=0;i<32;i=i+1) begin
            tpa=0;
            shift=0;
            if(nb[i]==1)begin
                 shift={32'b0,na};
                 tpa=shift<<i;
                 temp=temp+tpa;
                end
            end
         end  
     
     if(tag==1)begin
     temp=~temp+1;          
   end   
end
end
assign z=temp;
assign HI=z[63:32];
assign LO=z[31:0];
endmodule
