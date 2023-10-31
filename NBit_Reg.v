`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2023 10:33:32 AM
// Design Name: 
// Module Name: NBit_Reg
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


module NBit_Reg #(N=8)(
input clk,
input rst,
input load,
input[N-1:0] D,
output [N-1:0] Q
    );
    wire [N-1:0] Temp;
    
    genvar i;
    generate
    for (i=0; i<N; i=i+1) begin
        MUX_2x1 MUX_INST(.A(Q[i]),
        .B(D[i]),
        .sel(load),
        .Y(Temp[i])
        );
        DFlipFlop FF_INST (
        .clk(clk),
        .rst(rst),
        .D(Temp[i]),
        .Q(Q[i])
        );
    end
    endgenerate
endmodule
