`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 10:46:24 AM
// Design Name: 
// Module Name: InstMem
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


module InstMem (input [7:0] addr, output [31:0] data_out);
 reg [31:0] mem [0:63];
 assign data_out = mem[addr];
 
 initial begin
     //lw x1,0(x0) loads 1 into x1
     //0
     mem[0]=32'h0x00002083 ;
     //lw x2,4(x0) loads 5 into x2
     //4
     mem[1]= 32'h0x00402103 ;
     //add x3,x0,x0 makes x3 = 0
     //8
     mem[2] = 32'h0x000001b3;
     //add x4,x0,x0 makes x4 = 0
     //12
     mem[3] = 32'h0x00000233;
     //add x3,x3,x1 increments x3
     //16
     mem[4] = 32'h0x001181b3;
     //add x4,x4,x3 
     //20
     mem[5] = 32'h0x00320233;
     //bge x3,x2,8
     //24
     mem[6] = 32'h0x0021d463;
     //blt x3, x2, -12
     //28
     mem[7] = 32'h0xfe21cae3;
     //sh x4,12(x0)
     //32
     mem[8] = 32'h0x00401623;
     //auipc x7,15
     //36
     mem[9] = 32'h0x0000f397;
 end
endmodule