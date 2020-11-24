`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 14:34:29
// Design Name: 
// Module Name: CLZ
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


module CLZ(
    input [31:0] a,
    input ctr,
    output [31:0] z
    );
    reg [31:0] cnt;
    always@(*)begin
    if(ctr==1)begin
        if(a[31]==1)cnt<=0;
        else if(a[30]==1)cnt<=1;
        else if(a[29]==1)cnt<=2;
        else if(a[28]==1)cnt<=3;
        else if(a[27]==1)cnt<=4;
        else if(a[26]==1)cnt<=5;
        else if(a[25]==1)cnt<=6;
        else if(a[24]==1)cnt<=7;
        else if(a[23]==1)cnt<=8;
        else if(a[22]==1)cnt<=9;
        else if(a[21]==1)cnt<=10;
        else if(a[20]==1)cnt<=11;
        else if(a[19]==1)cnt<=12;
        else if(a[18]==1)cnt<=13;
        else if(a[17]==1)cnt<=14;
        else if(a[16]==1)cnt<=15;
        else if(a[15]==1)cnt<=16;
        else if(a[14]==1)cnt<=17;
        else if(a[13]==1)cnt<=18;
        else if(a[12]==1)cnt<=19;
        else if(a[11]==1)cnt<=20;
        else if(a[10]==1)cnt<=21;
        else if(a[9]==1)cnt<=22;
        else if(a[8]==1)cnt<=23;
        else if(a[7]==1)cnt<=24;
        else if(a[6]==1)cnt<=25;
        else if(a[5]==1)cnt<=26;
        else if(a[4]==1)cnt<=27;
        else if(a[3]==1)cnt<=28;
        else if(a[2]==1)cnt<=29;
        else if(a[1]==1)cnt<=30;
        else if(a[0]==1)cnt<=31;
        else cnt<=32;
    end
    else cnt<=32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
    end
    assign z=cnt;
endmodule
