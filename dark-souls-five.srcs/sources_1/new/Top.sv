module Top(
    input logic clkk,
    input logic rstn,
    input logic UART_TXD_IN,
    input logic UART_RXD_OUT,
    input logic UART_CTS,
    input logic UART_RTS,

    output logic [11:0] rgb,
    output logic hs,vs
);
wire key_valid;
wire [127:0] key_status;

reg clk_50, clk_200, clk_120;
clk_wiz_0 clk_wiz_0(
    .clk_in1(clkk),
    .clk_out1(clk_50),
    .clk_out2(clk_200),
    .clk_out3(clk_120)
);

KeyBoard keyBoard(
    .clk(clk_120),
    .rst_n(rstn),
    .ps2_clk(PS2_CLK),
    .ps2_data(PS2_DATA),
    .key_valid(key_valid),
    .key_status(key_status)
);
Controller controller(
    .clk(clkk),
    .enter(key_status[7'h5A]),
    .pause(key_status[7'h76]),
    .up(key_status[7'h1D]),
    .down(key_status[7'h1B]),
    .left(key_status[7'h1C]),
    .right(key_status[7'h23]),
    .space(key_status[7'h29]),

    .vga_r(rgb[11:8]),
    .vga_g(rgb[7:4]),
    .vga_b(rgb[3:0]),
    .vga_hs(hs),
    .vga_vs(vs)
);
endmodule