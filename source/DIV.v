`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/21 19:34:08
// Design Name: 
// Module Name: DIV
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


module DIV(
    input [31:0]dividend, 
    input [31:0]divisor,  
    input start,     
    input clock,
    input reset,
    output [31:0]q,  //ษฬ    
    output [31:0]r  // ำเสý  
);
   reg [63:0]temp_a;
   reg [63:0]temp_b;
   reg [31:0]temp_q;
   reg [31:0]temp_r;
   reg [31:0]ta;
   reg [31:0]tb;
   reg tag=0;
   reg busy;
   integer i;
   always@(posedge clock or posedge reset)begin
   if(reset==1)begin 
       temp_a=0;
       temp_b=0;
       busy=0;
       tag=0;
   end
   else if(start==1)begin          
       busy=1;
       ta=dividend;
       tb=divisor;
       if(ta[31]==1)begin
           tag=tag+1;
           ta=~ta+1;
       end
       if(tb[31]==1)begin
           tag=tag+1;
           tb=~tb+1;
       end
       temp_a={32'b0,ta};
       temp_b={tb,32'b0};
       for(i=0;i<32;i=i+1)begin
       temp_a=temp_a<<1;
       if(temp_a>=temp_b)begin
               temp_a=temp_a-temp_b+1;        
           end
           temp_q=temp_a[31:0];
           temp_r=temp_a[63:32];
           
       end
       if(tag==1)begin
            tag=0;
            temp_q=~temp_q+1;
       end
       if(temp_r[31]!=dividend[31])temp_r=~temp_r+1;
       busy=0;
   end
end
assign q=temp_q;
assign r=temp_r;   
endmodule
