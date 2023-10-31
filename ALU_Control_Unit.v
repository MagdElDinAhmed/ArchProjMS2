`timescale 1ns / 1ps
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
output reg [3:0] ALUSel
    );
        always@(*) begin
            case (ALUOp)
                2'b00: begin
                    ALUSel = 4'b0010;
                end
                
                2'b01: begin
                    ALUSel = 4'b0110;
                end
                
                2'b10: begin
                    case (Instruction[14:12])
                        3'b000: begin
                            if (Instruction[30] == 1'b0)
                                ALUSel = 4'b0010;
                            else
                                ALUSel = 4'b0110;
                        end
                        
                        3'b111: begin
                            if (Instruction[30] == 1'b0)
                                ALUSel = 4'b0000;
                        end
                        
                        3'b110: begin
                            if (Instruction[30] == 1'b0)
                                ALUSel = 4'b0001;
                        end
                        default: ALUSel = 4'b0000;
                    endcase
                end
                default: ALUSel = 4'b0000;
            endcase
        end
endmodule
