`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2023 06:53:41 PM
// Design Name: 
// Module Name: shifter
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


module shifter(
    input wire signed [31:0] a,
    input [4:0] shamt,
    input [1:0] type,
    output reg [31:0] r
    );
    
    
    always@(*) begin
        case(type)
            //SLL
            00: begin
                r = a<<shamt;
            end
            //SRL
            01: begin
                r = a>>shamt;
            end
            //SRA
            10: begin
                r = $signed(a)>>>shamt;
            end
        endcase
    end
endmodule
