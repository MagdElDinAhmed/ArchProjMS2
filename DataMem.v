`timescale 1ns / 1ps
`include "defines.v"
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
 (input clk, input MemRead, input MemWrite, input[1:0] SaveMethod,
 input [5:0] addr, input [31:0] data_in, output reg [31:0] data_out);
 reg [7:0] mem [0:255];
 
 initial begin
    mem[0]=8'd1;
    mem[1]=8'd5;
    mem[2]=8'd25;
 end
 
 always @(*) begin
    if (MemRead==1'b1)
        data_out = mem[addr];
 end
 
 always @(posedge clk) begin
    if (MemWrite == 1'b1)begin
        case(SaveMethod)
            `SB: begin 
                mem[addr] <= data_in[7:0];
            end
            `SH: begin 
                {mem[addr+1],mem[addr]} <= data_in[15:0];
            end
            `SW: begin 
                {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]} <= data_in;
            end
        endcase
        
    end
 end
 
endmodule

