`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2023 12:08:20 PM
// Design Name: 
// Module Name: NBit_RegFile
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


module NBit_RegFile #(N=32)(
input clk,rst,RegWrite,
input [N-1:0] writeData,
input [4:0] RegRead1,RegRead2,WriteAddress,
output reg [N-1:0] RegReadOut1,RegReadOut2
    );
    reg[5:0] i;
    reg [N-1:0] reg_file[31:0];
    
    always@(posedge (clk))begin
        if (rst==1'b1) begin
            for (i=0; i<32; i=i+1) begin
                reg_file[i]<=32'd0;
            end
        end
        else begin
            if (RegWrite==1'b1 && WriteAddress!=0)
                reg_file[WriteAddress] <= writeData;
        end
        
    end
    
    always@(*) begin
        RegReadOut1 = reg_file[RegRead1];
        RegReadOut2 = reg_file[RegRead2];
    end
    
endmodule
