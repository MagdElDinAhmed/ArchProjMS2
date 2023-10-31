`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2023 11:14:56 AM
// Design Name: 
// Module Name: RCA
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


module RCA #(N=8)(
    input [N-1:0] A,
    input [N-1:0] B,
    input AddSub,
    output [N:0] S
    );
    wire [N:0] Carry;
    reg [N-1:0] B_temp;
    always@(*) begin
        if (AddSub==1'b1)
            B_temp= ~B+1;
        else
            B_temp = B;
    end
    genvar i;
    generate
    assign Carry[0]=1'b0;
    for (i=0; i<N; i=i+1) begin
        FA FA_INST (
        .A(A[i]),
        .B(B_temp[i]),
        .Cin(Carry[i]),
        .S(S[i]),
        .Cout(Carry[i+1])
        );
    end
    endgenerate
    assign S[N]=Carry[N];
    endmodule 

