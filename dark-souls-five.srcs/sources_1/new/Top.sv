module Top(
    input logic clkk,
    input logic rstn,
    input logic PS2_CLK,
    input logic PS2_DATA
);
wire key_valid;
wire [127:0] key_status;
KeyBoard keyBoard(
    .clk(clkk),
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
    .space(key_status[7'h29])
);
endmodule