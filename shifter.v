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
            2'b00: begin
                r = a>>shamt;
            end
            //SRL
            2'b01: begin
                r = a<<shamt;
            end
            //SRA
            2'b10: begin
                r = a>>>shamt;
            end
            default: r = a;
        endcase
    end
endmodule
