`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/14 19:10:09
// Design Name: 
// Module Name: alu
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


module alu(ctr,a,b,aluc,r,zero,carry,negative,overflow);
    input ctr;
    input [31:0] a;
    input [31:0] b;
    input [3:0] aluc;
    output reg [31:0] r;
    output reg zero;
    output reg carry;
    output reg negative;
    output reg overflow;
    
    wire signed [31:0] sa=a,sb=b;
    always@(*)begin
    if(ctr==1)begin
    case(aluc)
    4'b0000:begin
            r=$unsigned(a)+$unsigned(b);
            if(r==0)zero=1; else zero=0; 
            if(r<a&&r<b)carry=1; else carry=0;
            if(r[31]==1)negative=1; else negative=0;    
            overflow=0;
            end
    4'b0010:begin
            r=$signed(a)+$signed(b);
            if(r==0)zero=1; else zero=0; 
            carry=0;
            if(r[31]==1)negative=1; else negative=0;
            if(a[31]!=b[31])overflow=0;
            else begin if(r[31]==a[31]) overflow=0; else overflow =1;end
            end
    4'b0001:begin
            r=$unsigned(a)-$unsigned(b);
             if(r==0)zero=1; else zero=0; 
             if(a>b)carry=1; else carry=0;
             if(r[31]==1)negative=1; else negative=0;    
             overflow=0;
            end
    4'b0011:begin
            r=$signed(a)-$signed(b);
            if(r==0)zero=1; else zero=0; 
            carry=0;
            if(r[31]==1)negative=1; else negative=0;
            if(a[31]==b[31])overflow=0;
            else if(a[31]==0&&b[31]==1) begin if(r[31]==0)overflow=0; else overflow=1;end
            else if(a[31]==1&&b[31]==0) begin if(r[31]==1)overflow=0; else overflow=1;end
            end
    4'b0100:begin
            r=a&b;
            if(r==0)zero=1;else zero=0;
            carry=0;
            if(r[31]==1)negative=1;else negative=0;
            overflow=0;
            end
    4'b0101:begin
            r=a|b;
            if(r==0)zero=1;else zero=0;
            carry=0;
            if(r[31]==1)negative=1;else negative=0;
            overflow=0;
            end
    4'b0110:begin
            r=a^b;
            if(r==0)zero=1;else zero=0;
            carry=0;
            if(r[31]==1)negative=1;else negative=0;
            overflow=0;
            end
    4'b0111:begin
            r=~(a|b);
            if(r==0)zero=1;else zero=0;
            carry=0;
            if(r[31]==1)negative=1;else negative=0;
            overflow=0;
            end
    4'b1000:begin
            r={b[15:0],16'b0};
            if(r==0)zero=1;else zero=0;
            carry=0; 
            if(r[31]==1)negative=1;else negative=0;
            overflow=0;
            end
    4'b1001:begin
            r={b[15:0],16'b0};
            if(r==0)zero=1;else zero=0;
            carry=0; 
            if(r[31]==1)negative=1;else negative=0;
            overflow=0;
            end 
    4'b1011:begin
            if(a[31]==0&&b[31]==0) if(a<b)r=1;else r=0;
            else if(a[31]==1&&b[31]==1) if(b<a)r=1;else r=0;
            else if(a[31]==1&&b[31]==0)r=1;
            else if(a[31]==0&&b[31]==1)r=0;
            if(a==b)zero=1;else zero=0;
            carry=0; 
            if(r==1)negative=1;else negative=0;
            overflow=0;
            end
    4'b1010:begin
            if(a<b)r=1;else r=0;
            if(a==b)zero=1;else zero=0;
            if(a<b)carry=1;else carry=0;
            if(r[31]==1)negative=1;else negative=0;
            overflow=0;
            end
    4'b1100:begin
            if(a==0) {r[31:0],r[32]}={b,1'b0};
            else {r[31:0],r[32]}=sb>>>(a-1);
            if(r==0)zero=1;else zero=0;
            if(a==0)carry=0;
            else carry=b[a-1];
            if(r[31]==1)negative=1;else negative=0;
            overflow=0; 
            end  
    4'b1110:begin
            r=b<<a;
            if(r==0)zero=1;else zero=0;
            if(a==0)carry=0;
            else carry=b[32-a];
            if(r[31]==1)negative=1;else negative=0;
            overflow=0;
            end
    4'b1111:begin
             r=b<<a;
             if(r==0)zero=1;else zero=0;
             if(a==0)carry=0;
             else carry=b[32-a];
             if(r[31]==1)negative=1;else negative=0;
             overflow=0;
             end  
    4'b1101:begin
            r=b>>a;
            if(r==0)zero=1;else zero=0;
            if(a==0)carry=0;
            else carry=b[32-a];
            if(r[31]==1)negative=1;else negative=0;
            overflow=0;
            end
    endcase 
    end
    end
endmodule


