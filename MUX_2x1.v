`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2023 11:04:33 AM
// Design Name: 
// Module Name: MUX_2x1
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


module MUX_2x1(
input A,
input B,
input sel,
output Y
    );
    
    assign Y = (sel==1'b0)?A:B;
    
endmodule
