module food (
  input  wire       clk_12500Hz,   // 12.5 kHz RNG clock
  input  wire       rst,           // async reset
  input  wire       set_seed,      // async LFSR seed
  input  wire       food_update,   // fast-domain 1-cycle pulse
  output reg  [5:0] food_loc       // {y[2:0], x[2:0]}
);

  wire [2:0] idx, idy;
  random_generator random_generator (
    .clk      (clk_12500Hz),
    .set_seed (set_seed),
    .idx      (idx),
    .idy      (idy)
  );

  always @(posedge clk_12500Hz or posedge rst) begin
    if (rst) begin
      food_loc <= 6'b100100;  // reset to (4,4)
    end else if (food_update) begin
      food_loc <= {idx, idy};  // update immediately when food_update pulses
    end
  end

endmodule