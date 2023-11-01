`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2023 08:47:08 AM
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb(

    );
    localparam clk_period = 10;
    
    reg [3:0] alufn;
    reg [31:0] A,B;
    wire[31:0] C;
    wire ZeroFlag, CarryFlag, OverflowFlag, SignFlag;
    
    initial begin
        alufn = 4'b10_01;
        A = -16;
        B = 1'b1;
        #(clk_period);
        #(clk_period);
        $finish;
    end
    
    NBit_ALU #(32) ALU_test(
    .alufn(alufn),
    .A(A),
    .B(B),
    .C(C),
    .ZeroFlag(ZeroFlag),
    .CarryFlag(CarryFlag),
    .OverflowFlag(OverflowFlag),
    .SignFlag(SignFlag)
    );
endmodule
