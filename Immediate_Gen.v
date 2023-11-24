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
    
        if (Instruction[4:0]==5'b10111) begin //Handles LUI and AUIPC
            Immediate = { {Instruction[31:12]} ,{(N-20){1'b0}}};
        end else    
        //SB Condition
        if (Instruction[6]==1'b1) begin
            if (Instruction[3]==1'b1) begin
                Immediate = { {(N-12){Instruction[31]}} ,Instruction[31],Instruction[19:12],Instruction[20],Instruction[30:21]};
            end else if (Instruction[2]==1'b1)
                Immediate = { {(N-12){Instruction[31]}} ,Instruction[31:20]};
            else
                Immediate = { {(N-12){Instruction[31]}} ,Instruction[31],Instruction[7],Instruction[30:25],Instruction[11:8] };
        end else //S Condition
        if (Instruction[5]==1'b1) begin
            Immediate = { {(N-12){Instruction[31]}} ,Instruction[31:25],Instruction[11:7] };
        end else begin//I Condition
            Immediate = { {(N-12){Instruction[31]}} ,Instruction[31:20] };
        end
    end
    
endmodule
