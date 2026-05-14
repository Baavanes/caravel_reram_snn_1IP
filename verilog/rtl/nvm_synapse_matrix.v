// nvm_synapse_matrix.v — 1 IP version


module nvm_synapse_matrix (
`ifdef USE_POWER_PINS
      inout VDDC,
      inout VDDA,
      inout VSS,
`endif
  input         wb_clk_i,
  input         wb_rst_i,
  input         wbs_stb_i,
  input         wbs_cyc_i,
  input         wbs_we_i,
  input  [3:0]  wbs_sel_i,
  input  [31:0] wbs_dat_i,
  input  [31:0] wbs_adr_i,
  output [31:0] wbs_dat_o,
  output reg    wbs_ack_o,
  input         ScanInCC,
  input         ScanInDL,
  input         ScanInDR,
  input         TM,
  output        ScanOutCC,
  input         Iref,
  input         Vcc_read,
  input         Vcomp,
  input         Bias_comp2,
  input         Vcc_wl_read,
  input         Vcc_wl_set,
  input         Vbias,
  input         Vcc_wl_reset,
  input         Vcc_set,
  input         Vcc_reset,
  input         Vcc_L,
  input         Vcc_Body
);
  parameter NUM_OF_MACRO = 1;
  parameter [31:0] ADDR_MATCH = 32'h3000_000C;
  parameter  [7:0] MEM_HIGH   = 8'hFF;
  parameter  [7:0] MEM_LOW    = 8'h00;

  wire [31:0] slave_dat_o;
  wire        slave_ack_o;
  wire [7:0]  mem;
  reg  wbs_we_i_reversed;

  assign mem = wbs_dat_i[0] ? MEM_HIGH : MEM_LOW;

  Neuromorphic_X1_wb X1_inst (
    `ifdef USE_POWER_PINS
    .VDDC(VDDC), .VDDA(VDDA), .VSS(VSS),
    `endif
    .user_clk (wb_clk_i),  .user_rst (wb_rst_i),
    .wb_clk_i (wb_clk_i),  .wb_rst_i (wb_rst_i),
    .wbs_stb_i(wbs_stb_i), .wbs_cyc_i(wbs_cyc_i),
    .wbs_we_i (wbs_we_i),  .wbs_sel_i(wbs_sel_i),
    .wbs_dat_i({wbs_dat_i[31:8], mem}),
    .wbs_adr_i(ADDR_MATCH),
    .wbs_dat_o(slave_dat_o), .wbs_ack_o(slave_ack_o),
    .ScanInCC(ScanInCC), .ScanInDL(ScanInDL),
    .ScanInDR(ScanInDR), .TM(TM), .ScanOutCC(ScanOutCC),
    .Iref(Iref), .Vcc_read(Vcc_read), .Vcomp(Vcomp),
    .Bias_comp2(Bias_comp2), .Vcc_wl_read(Vcc_wl_read),
    .Vcc_wl_set(Vcc_wl_set), .Vbias(Vbias),
    .Vcc_wl_reset(Vcc_wl_reset), .Vcc_set(Vcc_set),
    .Vcc_reset(Vcc_reset), .Vcc_L(Vcc_L), .Vcc_Body(Vcc_Body)
  );

 
  assign wbs_dat_o = {31'b0, slave_dat_o[0]};


  always @(posedge wb_clk_i) begin
    wbs_we_i_reversed <= ~wbs_we_i;
  end
  assign wbs_ack_o = slave_ack_o;

endmodule
