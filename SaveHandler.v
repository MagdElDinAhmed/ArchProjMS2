`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2023 02:27:33 PM
// Design Name: 
// Module Name: SaveHandler
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


module SaveHandler(
    input fun3,
    output reg [1:0] SaveMethod
    );
    always@(*) begin
        case(fun3)
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
endmodule
