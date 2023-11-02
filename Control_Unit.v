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


module Control_Unit #(N=32)(
input [N-1:0] Instruction,
output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,AUIPCSel, MuxRFSel //do we need MUXRFSel
output reg [1:0] ALUOp
    );
        always@(*) begin
            case (Instruction[6:2]) //checking opcode (change to the macro defined name)
                5'b01100: begin //shift
                    Branch = 1'b0;
                    MemRead = 1'b0;
                    MemtoReg = 1'b0;
                    ALUOp = 2'b10;
                    MemWrite = 1'b0;
                    ALUSrc = 1'b0;
                    RegWrite = 1'b1;
		    MuxRFSel=1'1; 
		    AUIPCSel=1'b0;

                end
                
                5'b00000: begin //load
                    Branch = 1'b0;
                    MemRead = 1'b1;
                    MemtoReg = 1'b1;
                    ALUOp = 2'b00;
                    MemWrite = 1'b0;
                    ALUSrc = 1'b1;
                    RegWrite = 1'b1;
		    MuxRFSel=1'1; 
		    AUIPCSel=1'b0;
                end
                
                5'b01000: begin //store
                    Branch = 1'b0;
                    MemRead = 1'b0;
                    ALUOp = 2'b00;
                    MemWrite = 1'b1;
                    ALUSrc = 1'b1;
                    RegWrite = 1'b0;
		    MuxRFSel=1'1;  //X
		    AUIPCSel=1'b0; //X
                end
                
                5'b11000: begin //branching
                    Branch = 1'b1;
                    MemRead = 1'b0;
                    ALUOp = 2'b01;
                    MemWrite = 1'b0;
                    ALUSrc = 1'b0;
                    RegWrite = 1'b0;
		    MuxRFSel=1'1; 
		    AUIPCSel=1'b0; //XXX

                end
		5'b00101: begin
			//
		   Branch=1'b0;
		   MemRead= 1'b
	   	   ALUOp= 2'b00; //(i think because add)
	   	   MemWrite=1'b0;
		   ALUSrc=1'b1; //check this 
		   RegWrite=1'b1; //because we will write back to RF
			//add here signals to control the new Muxes. 
		   MuxRFSel=1'b0; //chooses sel line of branched  
		   AUIPCSel=1'b1;
		end

            endcase
		
        end
endmodule
