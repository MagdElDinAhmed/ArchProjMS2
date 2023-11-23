`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2023 12:50:04 PM
// Design Name: 
// Module Name: Control_Unit
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


module ALU_Control_Unit #(N=32)(
input [N-1:0] Instruction,
input [1:0] ALUOp,
input ALUSrc,
output reg [3:0] ALUSel
    );
        always@(*) begin
            case (ALUOp)
                2'b00: begin
                    ALUSel = `ALU_ADD;
                end
                
                2'b01: begin
                    ALUSel = `ALU_SUB;
                end
                
                2'b10: begin
                    case (Instruction[`IR_funct3])
                        `F3_ADD: begin
                            if (Instruction[30] == 1'b0 || ALUSrc == 1'b1)//ALUSrc is meant to account for the possibility of ADDI with a negative number
                                ALUSel = `ALU_ADD;
                            else
                                ALUSel = `ALU_SUB;
                        end
                        
                        `F3_AND: begin
                            if (Instruction[30] == 1'b0)
                                ALUSel = `ALU_AND;
                        end
                        
                        `F3_OR: begin
                            if (Instruction[30] == 1'b0)
                                ALUSel = `ALU_OR;
                        end
                        `F3_XOR: begin
                            ALUSel = `ALU_XOR;
                        end
                        `F3_SLL: begin
                            ALUSel = `ALU_SLL;
                        end
                        `F3_SRL: begin
                            if (Instruction[30] == 1'b0)
                                ALUSel = `ALU_SRL;
                            else
                                ALUSel = `ALU_SRA;
                        end
                        `F3_SLT: begin
                            ALUSel = `ALU_SLT;
                        end
                        `F3_SLTU: begin
                            ALUSel = `ALU_SLTU;
                        end
                        default: ALUSel = 4'b0000;
                    endcase
                end
                2'b11: begin
                    ALUSel = 4'b00_11; //LUI
                end
            endcase
        end
endmodule
