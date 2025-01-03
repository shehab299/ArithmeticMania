module alu (
    input wire clk, rst,
    input wire signed [31:0] x, y,
    input wire op,
    output wire overflow,
    output wire signed [31:0] result
  );
  reg signed [31:0] reg_x;
  reg signed [31:0] reg_y;
  reg signed [31:0] reg_result;
  reg reg_overflow;
  wire signed [31:0] multiplier_result; // Use wire for output of multiplier
  wire multiplier_overflow; // Use wire for overflow signal from multiplier
  wire signed [31:0] adder_result; // Use wire for output of adder
  wire adder_overflow; // Use wire for overflow signal from adder

  // Instantiate floating-point multiplier and adder modules
  floatingPointMultiplier multiplier(
                            .clk(clk),
                            .rst(rst),
                            .x(reg_x),
                            .y(reg_y),
                            .product(multiplier_result), // Corrected to wire
                            .overflow(multiplier_overflow) // Corrected to wire
                          );

  floatingPointAdder adder(
                       .x(reg_x),
                       .y(reg_y),
                       .result(adder_result), // Corrected to wire
                       .overflow(adder_overflow) // Corrected to wire
                     );

  // Always block with correct sensitivity list
  always @(posedge clk or posedge rst)
  begin
    if (rst)
    begin
      reg_x <= 32'b0;
      reg_y <= 32'b0;
      reg_result <= 32'b0;
      reg_overflow <= 1'b0;
    end
    else
    begin
      reg_x <= x;
      reg_y <= y;
      if (op == 1'b0)
      begin // add
        reg_result <= adder_result;
        reg_overflow <= adder_overflow;
      end
      else
      begin // multiply
        reg_result <= multiplier_result;
        reg_overflow <= multiplier_overflow;
      end
    end
  end

  // Continuous assignments for result and overflow
  assign result = reg_result;
  assign overflow = reg_overflow;

endmodule
