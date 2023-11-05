`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.11.2023 02:33:47
// Design Name: 
// Module Name: branchControlUnit
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


module branchControlUnit #(N=32)(
    input [N-1:0] Instruction, 
    input ZFlag, SFlag,VFlag,CFlag,
    output reg Branch  //branching control signal generated here 
    );
    
   always@(*)begin
   
   case (Instruction[`IR_opcode]) 
  //checking opcode (change to the macro defined name)
                   `BR_BEQ:
                    begin 
                        if(ZFlag) begin
                            Branch=1'b1;
                         end
                         else begin
                            Branch=1'b0;
                         end
                          
                   end
                    `BR_BNE:
                    begin 
                    if(~ZFlag)begin
                         Branch=1'b1;
                     end
                     else begin
                        Branch=1'b0;
                     end
                     end
                     `BR_BLT: begin
                        if(SFlag != VFlag)begin 
                        Branch=1'b1;
                        end
                     end
                     `BR_BGE: begin
                        if(SFlag==VFlag) begin
                            Branch=1'b1; 
                        
                        end
                        else begin Branch=1'b0; 
                        end
                      end
                     `BR_BLTU: begin 
                        if(~CFlag) begin 
                        Branch=1'b1;
                        end
                        else begin  Branch=1'b0;
                        end
                        
                     end
                     `BR_BGEU:begin 
                     if(CFlag)begin 
                     Branch=1'b1;
                     end
                     else begin
                     Branch=1'b0;
                     end
                     
                     end
 
   
   endcase
   end

endmodule

/* 

`define     BR_BEQ          3'b000
`define     BR_BNE          3'b001
`define     BR_BLT          3'b100
`define     BR_BGE          3'b101
`define     BR_BLTU         3'b110
`define     BR_BGEU         3'b111
*/ 
