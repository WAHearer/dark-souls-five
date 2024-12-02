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

// 时钟分频
clk_wiz_0 clk_wiz_0 (
    .clk_in1(clk),
    .clk_out1(pclk)
);

// 计数器用于生成同步信号
reg [11:0] hcount = 0; 
reg [11:0] vcount = 0;

// 有效显示区域标志
wire disp_enable;
// 实际显示坐标
reg [7:0] x;
reg [7:0] y;

// 水平计数器
always @(posedge pclk) begin
    if(hcount == HSW + BP + HEN + HFP - 1)
        hcount <= 0;
    else
        hcount <= hcount + 1;
end

// 垂直计数器
always @(posedge pclk) begin
    if(hcount == HSW + BP + HEN + HFP - 1) begin
        if(vcount == VSW + VBP + VEN + VFP - 1)
            vcount <= 0;
        else
            vcount <= vcount + 1;
    end
end

// 同步信号生成
always @(posedge pclk) begin
    vga_hs <= (hcount >= HSW);
    vga_vs <= (vcount >= VSW);
end

// 判断是否在有效显示区域
assign disp_enable = (hcount >= HSW + BP) && 
                    (hcount < HSW + BP + HEN) && 
                    (vcount >= VSW + VBP) && 
                    (vcount < VSW + VBP + VEN);

// 计算实际显示坐标(缩放)
always @(posedge pclk) begin
    if(disp_enable) begin
        x <= (hcount - HSW - BP) * 200 / HEN;
        y <= (vcount - VSW - VBP) * 150 / VEN;
    end
end

// 输出像素数据
always @(posedge pclk) begin
    if(disp_enable) begin
        {vga_r, vga_g, vga_b} <= {vram[x][y][11], vram[x][y][10], vram[x][y][9], vram[x][y][8], vram[x][y][7], vram[x][y][6], vram[x][y][5], vram[x][y][4], vram[x][y][3], vram[x][y][2], vram[x][y][1], vram[x][y][0]};
    end else begin
        {vga_r, vga_g, vga_b} <= 12'h000;
    end
end
    
endmodule