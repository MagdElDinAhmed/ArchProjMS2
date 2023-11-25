`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2023 12:35:35 PM
// Design Name: 
// Module Name: NBit_MUX4x1
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


module NBit_MUX4x1 #(N=32)(
    input [N-1:0] A,
    input [N-1:0] B,
    input [N-1:0] C,
    input [N-1:0] D,
    input [1:0] sel,
    output reg [N-1:0] Y
    );
    
    always@(*) begin
        case (sel)
            2'b00: Y = A;
            2'b01: Y = B;
            2'b10: Y = C;
            2'b11: Y = D;
        endcase
    end
endmodule
