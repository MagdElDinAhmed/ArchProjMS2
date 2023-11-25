`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2023 11:02:54 AM
// Design Name: 
// Module Name: DataMem
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


module DataMem (
    input clk, 
    input [7:0] word_addr,// instruction address 
    input MemRead,
    input MemWrite,
    input [1:0] SaveMethod,
    input [31:0] data_in,
    output reg [31:0] data_out
);
 reg [31:0] mem[0:127]; // Assuming each memory location is 32 bits (4 bytes) wide and 64 words in total
 integer i;
 initial begin
 
    mem[0] = 32'h0x00000013;
     mem[1]=32'h0x00100093 ;
     //addi x2,x0,5
     //4
     mem[2]= 32'h0x00500113 ;
     //addi x3,x0,20
     //8
     mem[3] = 32'h0x01400193;
     //addi x4,x0,1787
     //12
     mem[4] = 32'h0x6fb00213;
     //addi x5,x0,-1234
     //16
     mem[5] = 32'h0xb2e00293;
     //addi x30,x0,-5
     //20
     mem[6] = 32'h0xffb00f13;
     //and x6,x4,x2
     //24
     mem[7] = 32'h0x00227333;
     //andi x6,x4,5
     //28
     mem[8] = 32'h0x00527313;
     //or x7,x3,x1
     //32
     mem[9] = 32'h0x0011e3b3;
     //ori x7, x3, 65
     //36
     mem[10] = 32'h0x0411e393;
     
     //sra x8,x5,x2
     //40
     mem[11]=32'h0x4022d433 ;
     //srai x8,x8,2
     //44
     mem[12]= 32'h0x40245413 ;
     //srl x8,x8,x1
     //48
     mem[13] = 32'h0x00145433;
     //srli x8,x8,3
     //52
     mem[14] = 32'h0x00345413;
     //sll x9,x3,x2
     //56
     mem[15] = 32'h0x002194b3;
     //slli x9,x9,4
     //60
     mem[16] = 32'h0x00449493;
     //xor x10,x4,x5
     //64
     mem[17] = 32'h0x00524533;
     //xori x10,x10,436
     //68
     mem[18] = 32'h0x1b454513;
     //sltu x11,x3,x5
     //72
     mem[19] = 32'h0x0051b5b3;
     //sltiu x11,x4,-463
     //76
     mem[20] = 32'h0xe3123593;
     
     
      //slt x12,x5,x3
      //80
      mem[21]=32'h0x0032a633 ;
      //slti x12,x5,-2
      //84
      mem[22]= 32'h0xffe2a613 ;
      //sub x13,x5,x4
      //88
      mem[23] = 32'h0x404286b3;
      //add x14, x9,x8
      //92
      mem[24] = 32'h0x00848733;
      //sw x5,316(x0)
      //96
      mem[25] = 32'h0x12502e23;
      //sh x6,2(x3)
      //100
      mem[26] = 32'h0x00619123;
      //sb x3,1(x3)
      //104
      mem[27] = 32'h0x003180a3;
      //lw x15,316(x0)
      //108
      mem[28] = 32'h0x13c02783;
      //lh x16,2(x3)
      //112
      mem[29] = 32'h0x00219803;
      //lb x17,1(x3)
      //116
      mem[30] = 32'h0x00118883;
      
      
      //lhu x18,31(x0)
      //120
      mem[31]=32'h0x13c05903 ;
      //lbu x19,3(x0)
      //124
      mem[32]= 32'h0x00304983 ;
      //beq x0,x0,20
      //128
      mem[33] = 32'h0x00000a63;
      //addi x0,x0,0
      //132
      mem[34] = 32'h0x00000013;
      //addi x0,x0,0
      //136
      mem[35] = 32'h0x00000013;
      mem[36] = 32'h0x00000013;
      mem[37] = 32'h0x00000013;
      //bne x0,x1,20
      //140
      mem[38] = 32'h0x00101a63;
      //addi x0,x0,0
      //144
      mem[39] = 32'h0x00000013;
      //addi x0,x0,0
      //148
      mem[40] = 32'h0x00000013;
      mem[41] = 32'h0x00000013;
      mem[42] = 32'h0x00000013;
      //blt x5,x2,20
      //152
      mem[43] = 32'h0x0022ca63;
      //addi x0,x0,0
      //156
      mem[44] = 32'h0x00000013;
      

      //addi x0,x0,0
      //160
      mem[45]=32'h0x00000013 ;
      mem[46] = 32'h0x00000013;
      mem[47] = 32'h0x00000013;
      //bge x4,x1,20
      //164
      mem[48]= 32'h0x00125a63 ;
      //addi x0,x0,0
      //168
      mem[49] = 32'h0x00000013;
      //addi x0,x0,0
      //172
      mem[50] = 32'h0x00000013;
      mem[51] = 32'h0x00000013;
      mem[52] = 32'h0x00000013;
      //bltu x2,x5,20
      //176
      mem[53] = 32'h0x00516a63;
      //addi x0,x0,0
      //180
      mem[54] = 32'h0x00000013;
      //addi x0,x0,0
      //184
      mem[55] = 32'h0x00000013;
      mem[56] = 32'h0x00000013;
      mem[57] = 32'h0x00000013;
      //bgeu x2,x30,20
      //188
      mem[58] = 32'h0x01e17a63;
      //addi x0,x0,0
      //192
      mem[59] = 32'h0x00000013;
      //addi x0,x0,0
      //196
      mem[60] = 32'h0x00000013;
      mem[61] = 32'h0x00000013;
      mem[62] = 32'h0x00000013;

     //jal x20, 20
     //200
     mem[63]=32'h0x01400a6f ;
     //addi x0,x0,0
     //204
     mem[64]= 32'h0x00000013 ;
     //addi x0,x0,0
     //208
     mem[65] = 32'h0x00000013;
     mem[66] = 32'h0x00000013;
     //beq x0,x0,16
     //212
     mem[67] = 32'h0x00000863;
     //jalr x21,x20,4
     //216
     mem[68] = 32'h0x004a0ae7;
     //addi x0,x0,0
     //220
     mem[69] = 32'h0x00000013;
     //addi x0,x0,0
     //224
     mem[70] = 32'h0x00000013;
     //auipc x22, 2134
     //228
     mem[71] = 32'h0x00856b17;
     //lui x23, -12
     //232
     mem[72] = 32'h0xffff4bb7;
     //addi a7,x0,1
     //236
     mem[73] = 32'h0x00100893;
     
     //ecall
     //240
     mem[74]=32'h0x00100093 ;
     //fence 1,1
     //244
     mem[75]= 32'h0x0110000f ;
     //ebreak
     //248
     mem[76] = 32'h0x00100073;
     //addi x0,x0,0
     //252
     mem[77] = 32'h0x00000013;
     //addi x0,x0,0
     //256
     mem[78] = 32'h0x00000013;
    mem[79]=8'd1;
    mem[80]=8'b0;
    mem[81]=8'b0;
    mem[82]=8'b0;
    mem[83]=8'd5;
    mem[84]=8'b0;
    mem[85]=8'b0;
    mem[86]=8'b0;
    mem[87]=8'd25;
    mem[88]=8'b0;
    mem[89]=8'b0;
    mem[90]=8'b0;
   
    
    for(i=91;i<128;i=i+1)
    begin
    
        mem[i]=32'b0;
        
    end 
 end
 
 always @(*) begin
    if (MemRead == 1'b1) begin
        data_out = mem[word_addr]; // Read the entire word from the specified word address
    end
 end
 
 always @(posedge clk) begin
    if (MemWrite == 1'b1)begin
        case(SaveMethod)
            `SB: begin 

                mem[word_addr][7:0] <= data_in[7:0];
            end
            `SH: begin 

                mem[word_addr][15:0] <= data_in[15:0];
            end
            `SW: begin 

                mem[word_addr] <= data_in;
            end
        endcase
        
    end
 end
 
endmodule

