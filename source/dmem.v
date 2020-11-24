`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/05 17:39:02
// Design Name: 
// Module Name: dmem
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


module dmem(
    input [7:0] addr,
    input [31:0] wdata,
    input clk,
    input [1:0] DM_W,
    output [31:0] rdata
    );
    reg [7:0] ram [255:0];
    reg [31:0] temp;
    always @(negedge clk)
    begin
        if(DM_W==2'b01)//32bit
        begin
            ram[addr]<=wdata[7:0];
            ram[addr+1]<=wdata[15:8];
            ram[addr+2]<=wdata[23:16];
            ram[addr+3]<=wdata[31:24];
            temp<=wdata;
        end
        else if(DM_W==2'b10)//16bit
        begin
            ram[addr]<=wdata[7:0];
            ram[addr+1]<=wdata[15:8];
            temp<=wdata;    
        end
        else if(DM_W==2'b11)//8bit
        begin
            ram[addr]<=wdata[7:0];
            temp<=wdata;
        end
        else begin
            temp<={ram[addr+3],ram[addr+2],ram[addr+1],ram[addr]};
        end
    end
    assign rdata=temp;
endmodule
