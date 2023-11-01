`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2023 10:39:59 AM
// Design Name: 
// Module Name: RISCV_tb
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


module RISCV_tb(

    );
    localparam clk_period = 30;
    
    reg clk, rst;
    reg [1:0] ledSel;
    reg [3:0] ssdSel;
    wire [15:0] LED;
    wire [3:0] Anode;
    wire [6:0] Seven_Seg_Out;
    
    initial begin
        clk = 1'b0;
        forever #(clk_period/2) clk = ~clk;
    end
    
    initial begin
        rst=1;
        clk=0;
        ssdSel=4'b0000;
        ledSel=2'b00;
        #(clk_period);
        rst=0;
        #(clk_period);
        
        //$finish;
    end
    
    RISCV CPU_TEST(
    .clk(clk),
    .rst(rst),
    .SSDclk(clk),
    .ledSel(ledSel),
    .ssdSel(ssdSel),
    .LED(LED),
    .Anode(Anode),
    .Seven_Seg_Out(Seven_Seg_Out)
    );
    
endmodule
