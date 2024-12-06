module Controller_tb();
reg clk, enter;
initial begin
    clk = 0; enter=0;
    #20;
    enter=1;
    #10
    enter=0;
    #20;
    enter=1;
    #10
    enter=0;
    #20;
    enter=1;
    #10
    enter=0;
    #20;
    enter=1;
    #10
    enter=0;
end
always #1 clk = ~clk;
Controller controller (
    .clk_50(clk),
    .enter(),
    .pause(),
    .up(),
    .down(),
    .left(),
    .right(),
    .space(),
    .vga_r(),
    .vga_g(),
    .vga_b(),
    .vga_hs(),
    .vga_vs()
);
endmodule