`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2023 12:11:52 PM
// Design Name: 
// Module Name: Forward_Unit
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


module Forward_Unit(
input [4:0] ID_EX_Rs1, ID_EX_Rs2,
input [4:0] EX_MEM_Rd, MEM_WB_Rd,
input EX_MEM_RegWrite, MEM_WB_RegWrite,
output reg [1:0] forwardA, forwardB
    );
    always@(ID_EX_Rs1,ID_EX_Rs2,EX_MEM_Rd,MEM_WB_Rd,EX_MEM_RegWrite,MEM_WB_RegWrite) begin
        forwardA = 2'b00;
        if (EX_MEM_RegWrite && EX_MEM_Rd!= 0 && (EX_MEM_Rd == ID_EX_Rs1)) begin
            forwardA = 2'b10;
        end
        else if (MEM_WB_RegWrite && MEM_WB_Rd != 0 && (MEM_WB_Rd==ID_EX_Rs1) ) begin
            forwardA = 2'b01;
        end
        
        forwardB=2'b00;
        if (EX_MEM_RegWrite && EX_MEM_Rd!= 0 && (EX_MEM_Rd == ID_EX_Rs2)) begin
            forwardB = 2'b10;
        end
        else if (MEM_WB_RegWrite && MEM_WB_Rd != 0 && (MEM_WB_Rd==ID_EX_Rs2) ) begin
            forwardB = 2'b01;
        end
    end

endmodule
