`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2023 12:15:30 PM
// Design Name: 
// Module Name: Immediate_Gen
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


module Immediate_Gen #(N=32)(
input [N-1:0] Instruction,
output reg [N-1:0] Immediate
    );
    
    always@(*)begin
        //SB Condition
        if (Instruction[6]==1'b1) begin
            Immediate = { {(N-12){Instruction[31]}} ,Instruction[31],Instruction[7],Instruction[30:25],Instruction[11:8]};
        end else //S Condition
        if (Instruction[5]==1'b1) begin
            Immediate = { {(N-12){Instruction[31]}} ,Instruction[31:25],Instruction[11:7] };
        end else begin //I Condition
            Immediate = { {(N-12){Instruction[31]}} ,Instruction[31:20] };
        end
    end
    
endmodule
