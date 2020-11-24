`timescale 1ns / 1ps
module regfile(
	input clk,
	input wenable,//Ğ´ÓĞĞ§ĞÅºÅ
	input reset,	
	
	input [4:0]a_addr, 
	input [4:0]b_addr, 
	input [4:0]c_addr, 
	input [31:0]c_newdata,
    output [31:0]a_data, 
	output [31:0]b_data  
	);
	reg [31:0]array_reg[31:0];       
	integer i = 0;
	always@(negedge clk or posedge wenable or posedge reset)begin
	   if(reset==1)begin
	       for(i = 0;i<32;i=i+1)begin
	           array_reg[i]=0;
	       end
	   end
	   else begin
	       if(wenable==1)begin
	           if(c_addr!=0)array_reg[c_addr]=c_newdata;
	       end
	   end
	end
    assign a_data=array_reg[a_addr];
    assign b_data=array_reg[b_addr];       
endmodule
