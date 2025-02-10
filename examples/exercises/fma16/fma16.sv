module fma16(input  logic [15:0] x, y, z,
             input  logic mul, add, negp, negz,
             input  logic [1:0] roundmode,
             output logic [15:0] result,
             output logic [3:0] flags);


    multUnit mu(x, y, negp, result);
    assign flags = 0;
endmodule

module multUnit(input logic [15:0] x, y,
                input logic negp,
                output logic [15:0] result); 

    logic sign_x, sign_y, sign_result;
    logic [4:0] exp_x, exp_y;
    logic [10:0] frac_x, frac_y, frac_result;
    logic [21:0] full_frac_result;
    logic [5:0] exp_temp, exp_result;

    always_comb begin
        // Extract sign, exponent, and fraction
        sign_x = x[15];
        sign_y = y[15];
        exp_x = x[14:10];
        exp_y = y[14:10];
        frac_x = {1'b1, x[9:0]}; // Implicit leading 1
        frac_y = {1'b1, y[9:0]}; // Implicit leading 1

        // Perform multiplication
        full_frac_result = frac_x * frac_y;
        exp_temp = exp_x + exp_y - 5'b01111; // Adjust exponent

        // Normalize result
        if (full_frac_result[21]) begin
            frac_result = full_frac_result[21:11];
            exp_result = exp_temp + 1;
        end else begin
            frac_result = full_frac_result[20:10];
            exp_result = exp_temp;
        end
 
        // Handle sign
        sign_result = negp ? ~(sign_x ^ sign_y) : (sign_x ^ sign_y);

        // Pack result
        result = {sign_result, exp_result[4:0], frac_result[9:0]};
    end
endmodule
