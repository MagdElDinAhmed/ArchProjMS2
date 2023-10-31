`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2023 11:58:36 AM
// Design Name: 
// Module Name: NBit_Shift_Left_1
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


module NBit_Shift_Left_1 #(N=32)(
    input [N-1:0] X,
    output [N-1:0] Y
    );
    
    assign Y = {X[N-2:0],1'b0};
    
endmodule
