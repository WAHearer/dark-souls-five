module Top(
    input logic clkk,
    input logic rstn,
    input logic PS2_CLK,
    input logic PS2_DATA,

    output logic [11:0] rgb,
    output logic hs,vs
);
wire key_valid;
wire [127:0] key_status;

reg clk_50;
clk_wiz_0 clk_wiz_0(
    .clk_in1(clkk),
    .clk_out1(clk_50)
);

KeyBoard keyBoard(
    .clk(clkk),
    .ps2_clk(PS2_CLK),
    .ps2_data(PS2_DATA),
    .key_valid(key_valid),
    .key_status(key_status)
);
Controller controller(
    .clk(clkk),
    .clk_50(clk_50),
    .enter(key_status[8'h28]),
    .pause(key_status[8'h29]),
    .up(key_status[8'h1A]),
    .down(key_status[8'h16]),
    .left(key_status[8'h04]),
    .right(key_status[8'h07]),
    .space(key_status[8'h2C]),

    .vga_r(rgb[11:8]),
    .vga_g(rgb[7:4]),
    .vga_b(rgb[3:0]),
    .vga_hs(hs),
    .vga_vs(vs)
);
endmodule