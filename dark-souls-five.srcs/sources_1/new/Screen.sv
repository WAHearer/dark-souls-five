module Screen #(
    PCLK = 50_000_000,
    HSW = 120,
    BP = 64,
    HEN = 800,
    HFP = 56,
    VSW = 6,
    VBP = 23,
    VEN = 600,
    VFP = 37
) (
    input clk,                    // 系统时钟
    input [3:0] state,           // 游戏状态
    input [9:0] textId,          // 文本ID
    input [5:0] level,           // 关卡
    input [20:0] playerHp,       // 玩家血量
    input [20:0] enemyHp,        // 敌人血量
    input [6:0] playerPosition[0:1], // 玩家位置
    input [6:0] enemyPosition[0:1],  // 敌人位置
    input [28:0] playerBullet[0:79][0:59], // 玩家子弹
    input [28:0] enemyBullet[0:79][0:59],  // 敌人子弹
    
    output reg [3:0] vga_r,      // VGA红色分量
    output reg [3:0] vga_g,      // VGA绿色分量
    output reg [3:0] vga_b,      // VGA蓝色分量
    output reg vga_hs,           // 行同步
    output reg vga_vs            // 场同步
);

reg pclk;
reg vram[199:0][149:0][11:0];

clk_wiz_0 clk_wiz_0 (
    .clk_in1(clk),
    .clk_out1(pclk)
);

always @(posedge pclk) begin
    
end
    
endmodule