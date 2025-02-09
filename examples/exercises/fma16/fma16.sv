`include “wally-config.vh”

module fma16(input  logic [15:0] x, y, z,
             input  logic mul, add, negp, negz,
             input  logic [1:0] roundmode,
             output logic [15:0] result,
             output logic [3:0] flags);


    multUnit mu()

module multUnit(input logic [15:0] x,y,
                input logic negp,
                output result); 
    
    always_comb begin : blockName
        out[9:0] = x[9:0] * y[9:0];
        out[14:10] = x[14:10] + y[14:10] - 127;
        out[15] = negp ? (x[15] ^ y[14]) : ~(x[15] ^ y[14])
    end