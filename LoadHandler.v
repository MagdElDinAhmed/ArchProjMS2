`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2023 02:06:26 PM
// Design Name: 
// Module Name: LoadHandler
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


module LoadHandler(
    input [2:0] fun3,
    input [31:0] MemDataOut,
    output reg [31:0] LoadOut
    );
    always@(*) begin
        case(fun3)
            `LB: begin
                LoadOut = { { 24{MemDataOut[7]} },MemDataOut[7:0] };
            end
            `LH: begin
                LoadOut = { { 16{MemDataOut[15]} },MemDataOut[15:0] };
            end
            `LW: begin
                LoadOut = MemDataOut;
            end
            `LBU: begin
                LoadOut = { {(21) {1'b0} },MemDataOut[7:0] };
            end
            `LHU: begin
                LoadOut = { { 16{1'b0} },MemDataOut[15:0] };
            end
        endcase
    end
endmodule
