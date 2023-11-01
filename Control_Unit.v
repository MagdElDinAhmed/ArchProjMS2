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


module Control_Unit #(N=32)(
input [N-1:0] Instruction,
output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
output reg [1:0] ALUOp, SaveMethod
    );
        always@(*) begin
            case (Instruction[`IR_opcode])
                `OPCODE_Arith_R: begin
                    Branch = 1'b0;
                    MemRead = 1'b0;
                    MemtoReg = 1'b0;
                    ALUOp = 2'b10;
                    MemWrite = 1'b0;
                    ALUSrc = 1'b0;
                    RegWrite = 1'b1;
                    SaveMethod = 2'b00;
                end
                
                `OPCODE_Load: begin
                    Branch = 1'b0;
                    MemRead = 1'b1;
                    MemtoReg = 1'b1;
                    ALUOp = 2'b00;
                    MemWrite = 1'b0;
                    ALUSrc = 1'b1;
                    RegWrite = 1'b1;
                    SaveMethod = 2'b00;
                end
                
                `OPCODE_Store: begin
                    Branch = 1'b0;
                    MemRead = 1'b0;
                    ALUOp = 2'b00;
                    MemWrite = 1'b1;
                    ALUSrc = 1'b1;
                    RegWrite = 1'b0;
                    case(Instruction[`IR_funct3])
                        `SB: begin
                            SaveMethod = 2'b00;
                        end
                        `SH: begin
                            SaveMethod = 2'b01;
                        end
                        `SB: begin
                            SaveMethod = 2'b10;
                        end
                    endcase
                end
                
                `OPCODE_Branch: begin
                    Branch = 1'b1;
                    MemRead = 1'b0;
                    ALUOp = 2'b01;
                    MemWrite = 1'b0;
                    ALUSrc = 1'b0;
                    RegWrite = 1'b0;
                    SaveMethod = 2'b00;
                end
                `OPCODE_Arith_I: begin //I-type instructions
                 	Branch = 1'b0;
                    MemRead = 1'b0;
                    ALUOp = 2'b10; //what should i make this 
                    MemWrite = 1'b0; 
                    ALUSrc = 1'b1; //check if this is the right signal
                    RegWrite = 1'b1;
                    SaveMethod = 2'b00;
                  
                end
            endcase
        end
        
endmodule
