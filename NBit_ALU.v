`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2023 10:53:11 AM
// Design Name: 
// Module Name: NBit_ALU
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


module NBit_ALU #(N=32)(
input [3:0] alufn,
input [N-1:0] A,B,
output reg [N-1:0] C,
output ZeroFlag, CarryFlag, OverflowFlag, SignFlag
    );
       wire [31:0] add, sub, op_b; //op_b is the inversion of b, idk what sub is though
       wire cfa, cfs; //what even are these????
       wire [4:0]  shamt; //defines how many bits to shift
       assign shamt = B[4:0];
       
       assign op_b = (~B);
       
       assign {CarryFlag, add} = alufn[0] ? (A + op_b + 1'b1) : (A + B); //a-b or a+b depending on the lsb of the alufn
       
       assign ZeroFlag = (add == 0);
       assign SignFlag = add[31];
       assign OverflowFlag = (A[31] ^ (op_b[31]) ^ add[31] ^ CarryFlag); //^ means xor
       
       wire[31:0] sh;
       shifter shifter0(.a(A), .shamt(shamt), .type(alufn[1:0]),  .r(sh)); //this does shifty business
       
       always @ * begin
           C = 0;
           (* parallel_case *)
           case (alufn)
               // arithmetic
               4'b00_00 : C = add;
               4'b00_01 : C = add;
               4'b00_11 : C = B;
               // logic
               4'b01_00:  C = A | B;
               4'b01_01:  C = A & B;
               4'b01_11:  C = A ^ B;
               // shift
               4'b10_00:  C=sh; //SLL
               4'b10_01:  C=sh; //SRL
               4'b10_10:  C=sh; //SRA
               // slt & sltu
               4'b11_01:  C = {31'b0,(SignFlag != OverflowFlag)}; //remember these 2 for bge and blt
               4'b11_11:  C = {31'b0,(~CarryFlag)};                
           endcase
       end
endmodule
