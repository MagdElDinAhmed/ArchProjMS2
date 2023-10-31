`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:02:54 AM
// Design Name: 
// Module Name: DataMem
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


module DataMem
 (input clk, input MemRead, input MemWrite,
 input [5:0] addr, input [31:0] data_in, output reg [31:0] data_out);
 reg [31:0] mem [0:63];
 
 initial begin
    mem[0]=32'd1;
    mem[1]=32'd5;
    mem[2]=32'd25;
 end
 
 always @(*) begin
    if (MemRead==1'b1)
        data_out = mem[addr];
 end
 
 always @(posedge clk) begin
    if (MemWrite == 1'b1)
        mem[addr] <= data_in;
 end
 
endmodule

