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
output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,AUIPCSel, MuxRFSel, Jump, JALR,loadPC, //do we need MUXRFSel
output reg [1:0] ALUOp, SaveMethod
    );
        always@(*) begin
            if (Instruction[6:0] == `OPCODE_FENCE) begin
                Branch = 1'b0;
                MemRead = 1'b0;
                MemtoReg = 1'b0;
                ALUOp = 2'b00;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
                SaveMethod = 2'b00;
                MuxRFSel=1'b0; 
                AUIPCSel=1'b0;
                Jump = 1'b0;
                JALR = 1'b0;
                loadPC=1'b1;                
            end else
            if (Instruction[6:0] == `OPCODE_ECALL) begin
                if(Instruction[20]==1'b0)begin
                    Branch = 1'b0;
                    MemRead = 1'b0;
                    MemtoReg = 1'b0;
                    ALUOp = 2'b00;
                    MemWrite = 1'b0;
                    ALUSrc = 1'b0;
                    RegWrite = 1'b0;
                    SaveMethod = 2'b00;
                    MuxRFSel=1'b0; 
                    AUIPCSel=1'b0;
                    Jump = 1'b0;
                    JALR = 1'b0;
                    loadPC=1'b1;
                end
                else
                    Branch = 1'b0;
                    MemRead = 1'b0;
                    MemtoReg = 1'b0;
                    ALUOp = 2'b00;
                    MemWrite = 1'b0;
                    ALUSrc = 1'b0;
                    RegWrite = 1'b0;
                    SaveMethod = 2'b00;
                    MuxRFSel=1'b0; 
                    AUIPCSel=1'b0;
                    Jump = 1'b0;
                    JALR = 1'b0;
                    loadPC=1'b0;
            end else begin
                case (Instruction[`IR_opcode]) //checking opcode (change to the macro defined name)
                    `OPCODE_Arith_R: begin //arithmetic regitser operations
                        Branch = 1'b0;
                        MemRead = 1'b0;
                        MemtoReg = 1'b0;
                        ALUOp = 2'b10;
                        MemWrite = 1'b0;
                        ALUSrc = 1'b0;
                        RegWrite = 1'b1;
                        SaveMethod = 2'b00;
                        MuxRFSel=1'b1; 
                        AUIPCSel=1'b0;
                        Jump = 1'b0;
                        JALR = 1'b0;
                        loadPC=1'b1;
    
                    end
                    
                    `OPCODE_Arith_I: begin //I-type instructions
                        Branch = 1'b0;
                        MemRead = 1'b0;
                        MemtoReg = 1'b0;
                        ALUOp = 2'b10; //what should i make this 
                        MemWrite = 1'b0; 
                        ALUSrc = 1'b1; //check if this is the right signal
                        RegWrite = 1'b1;
                        SaveMethod = 2'b00;
                        MuxRFSel=1'b1; 
                        AUIPCSel=1'b0;
                        Jump = 1'b0;
                        JALR = 1'b0;
                        loadPC=1'b1;
                      
                    end
                    
                    `OPCODE_Load: begin //load
                        Branch = 1'b0;
                        MemRead = 1'b1;
                        MemtoReg = 1'b1;
                        ALUOp = 2'b00;
                        MemWrite = 1'b0;
                        ALUSrc = 1'b1;
                        RegWrite = 1'b1;
                        SaveMethod = 2'b00;
                        MuxRFSel=1'b1; 
                        AUIPCSel=1'b0;
                        Jump = 1'b0;
                        JALR = 1'b0;
                        loadPC=1'b1;
                    end
                    
                    `OPCODE_Store: begin //store
                        Branch = 1'b0;
                        MemRead = 1'b0;
                        ALUOp = 2'b00;
                        MemWrite = 1'b1;
                        ALUSrc = 1'b1;
                        RegWrite = 1'b0;
                        MuxRFSel=1'b1;  //X
                        AUIPCSel=1'b0; //X
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
                        Jump = 1'b0;
                        JALR = 1'b0;
                        loadPC=1'b1;
                    end
                    
                    `OPCODE_Branch: begin //branching
                        Branch = 1'b1;
                        MemRead = 1'b0;
                        ALUOp = 2'b01;
                        MemWrite = 1'b0;
                        ALUSrc = 1'b0;
                        RegWrite = 1'b0;
                        SaveMethod = 2'b00;
                        MuxRFSel=1'b1; 
                        AUIPCSel=1'b0; //XXX
                        Jump = 1'b0;
                        JALR = 1'b0;
                        loadPC=1'b1;
    
                    end
                    `OPCODE_AUIPC: begin
                        //
                       Branch=1'b0;
                       MemRead= 1'b0;
                       ALUOp= 2'b00; //(i think because add)
                       MemWrite=1'b0;
                       ALUSrc=1'b1; //check this 
                       RegWrite=1'b1; //because we will write back to RF
                        //add here signals to control the new Muxes. 
                       MuxRFSel=1'b0; //chooses sel line of branched  
                       AUIPCSel=1'b1;
                       SaveMethod = 2'b00;
                       Jump = 1'b0;
                       JALR = 1'b0;
                       loadPC=1'b1;
                       
                    end 
                    
                    `OPCODE_JAL: begin 
                            Branch = 1'b1;  
                            MemRead = 1'b0;
                            ALUOp = 2'b00; //check
                            MemWrite = 1'b0;
                            ALUSrc = 1'b1;
                            RegWrite = 1'b1; //
                            SaveMethod = 2'b00;
                            MuxRFSel=1'b0; //chooses i think the line that reads from PC_IN  to calculate jump address  
                            AUIPCSel=1'b1; //XXX
                            Jump = 1'b1;
                            JALR = 1'b0;
                            loadPC=1'b1;
                    end
                    `OPCODE_JALR: begin 
                         Branch = 1'b1;  
                        MemRead = 1'b0;
                        ALUOp = 2'b10; //check
                        MemWrite = 1'b0;
                        ALUSrc = 1'b1;
                        RegWrite = 1'b1; //
                        SaveMethod = 2'b00;
                        MuxRFSel=1'b1; //chooses i think the line that reads from PC_IN  to calculate jump address  
                        AUIPCSel=1'b1; //XXX
                        Jump = 1'b1;
                        JALR = 1'b1;
                        loadPC=1'b1;
                    end
    
                endcase
		    end
        end
endmodule
