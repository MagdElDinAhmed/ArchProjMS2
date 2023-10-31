`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2023 11:06:35 AM
// Design Name: 
// Module Name: NBit_MUX2x1
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


module NBit_MUX2x1 #(N=32)(
input [N-1:0] A,
input [N-1:0] B,
input sel,
output [N-1:0] Y
    );
    
    genvar i;
    generate
        for (i=0; i<N; i=i+1)begin
            MUX_2x1 MUX_INST(
            .A(A[i]),
            .B(B[i]),
            .sel(sel),
            .Y(Y[i])
            );
        end
    endgenerate
endmodule
