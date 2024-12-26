module Top(
    input logic clkk,
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
    .ps2_c(PS2_CLK),
    .ps2_d(PS2_DATA),
    .key_state(key_status)
);
Controller controller(
    .clk(clkk),
    .clk_50(clk_50),
    .enter(key_status[8'h5A]),
    .pause(key_status[8'h76]),
    .up(key_status[8'h1D]),
    .down(key_status[8'h1B]),
    .left(key_status[8'h1C]),
    .right(key_status[8'h23]),
    .space(key_status[8'h29]),
    .p(key_status[8'h4D]),

    .vga_r(rgb[11:8]),
    .vga_g(rgb[7:4]),
    .vga_b(rgb[3:0]),
    .vga_hs(hs),
    .vga_vs(vs)
);
endmodule