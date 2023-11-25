`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2023 12:07:48 PM
// Design Name: 
// Module Name: HazardDetectionUnit
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


module HazardDetectionUnit(
input [4:0]  rs1, //this is IF/ID.RegisterRs1
input [4:0] rs2, //this is IF/ID.registerRs2
input [4:0] rd,  //this is ID/EX.registerRD 
input MemRead,
output reg stall //default as wire.  (here we can use thi a 
    );
    
    always @(*) begin
        if(((rs1==rd) || (rs2==rd)) && MemRead && rd!=0)begin
        //above checks the conditions
        stall=1'b1;
        
        end
        
        else begin
        
        stall=1'b0;
        
        end
    end 
endmodule
