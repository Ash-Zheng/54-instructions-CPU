`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/21 15:23:22
// Design Name: 
// Module Name: DIVU
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



module DIVU(     
    input [31:0]dividend,     
    input [31:0]divisor,       
    input start,          
    input clock,     
    input reset,     
    output [31:0]q,           
    output [31:0]r                 
 );     
    reg busy;
    reg [63:0]temp_a;     
    reg [63:0]temp_b;     
    integer i;     
    always@(posedge clock or posedge reset)begin
    if(reset==1)begin          
        temp_a=0;         
        temp_b=0;         
        busy=0;     
    end     
    else if(start==1)begin         
        busy=1;         
        temp_a={32'b0,dividend};         
        temp_b={divisor,32'b0};         
    for(i=0;i<32;i=i+1)begin         
    temp_a=temp_a<<1;         
    if(temp_a>=temp_b)begin
    temp_a=temp_a-temp_b+1;                     
        end         
    end 
            
    busy=0;     
    end 
        
    end 
    assign q=temp_a[31:0]; 
    assign r=temp_a[63:32];    
endmodule 
