module Screen #(
    parameter PCLK = 50_000_000,
    parameter HSW = 120,
    parameter BP = 64, 
    parameter HEN = 800,
    parameter HFP = 56,
    parameter VSW = 6,
    parameter VBP = 23,
    parameter VEN = 600,
    parameter VFP = 37
) (
    input clk,                    // 系统时钟
    input [3:0] state,           // 游戏状态
    input [9:0] textId,          // 文本ID
    input [5:0] level,           // 关卡
    input [20:0] playerHp,       // 玩家血量
    input [20:0] enemyHp,        // 敌人血量
    input [7:0] playerPosition[0:1], // 玩家位置
    input [7:0] enemyPosition[0:1],  // 敌人位置
    input [27:0] playerBullet[0:599], // 玩家子弹
    input [27:0] enemyBullet[0:599],  // 敌人子弹
    
    output reg [3:0] vga_r,      // VGA红色分量
    output reg [3:0] vga_g,      // VGA绿色分量
    output reg [3:0] vga_b,      // VGA蓝色分量
    output reg vga_hs,           // 行同步
    output reg vga_vs            // 场同步
);

// 时钟分频产生50MHz像素时钟
reg pclk;
always @(posedge clk) begin
    pclk <= ~pclk;
end

// 计数器
reg [11:0] hcount;
reg [11:0] vcount;
initial begin
    hcount <= 0;
    vcount <= 0;
end

// 有效显示区域标志
wire disp_enable = (hcount >= HSW + BP) && (hcount < HSW + BP + HEN) &&
                  (vcount >= VSW + VBP) && (vcount < VSW + VBP + VEN);

// 实际显示坐标(0-799, 0-599)
wire [9:0] x = (hcount - (HSW + BP));
wire [9:0] y = (vcount - (VSW + VBP));

// 游戏显示区域坐标(0-199, 0-149)
wire [7:0] game_x = x[9:2];
wire [7:0] game_y = y[9:2];

// 水平计数
always @(posedge pclk) begin
    if(hcount == HSW + BP + HEN + HFP - 1)
        hcount <= 0;
    else 
        hcount <= hcount + 1;
end

// 垂直计数
always @(posedge pclk) begin
    if(hcount == HSW + BP + HEN + HFP - 1) begin
        if(vcount == VSW + VBP + VEN + VFP - 1)
            vcount <= 0;
        else
            vcount <= vcount + 1;
    end
end

// 同步信号
always @(posedge pclk) begin
    vga_hs <= (hcount >= HSW);
    vga_vs <= (vcount >= VSW);
end

// 显示逻辑
always @(posedge pclk) begin
    if(disp_enable) begin
        // 默认黑色背景
        {vga_r,vga_g,vga_b} <= 12'h000;
        
        // 显示玩家 (蓝色)
        if(game_x >= playerPosition[0] && game_x < playerPosition[0] + 10 &&
           game_y >= playerPosition[1] && game_y < playerPosition[1] + 10) begin
            {vga_r,vga_g,vga_b} <= 12'h00F;
        end
        
        // 显示敌人 (红色)
        if(game_x >= enemyPosition[0] && game_x < enemyPosition[0] + 10 &&
           game_y >= enemyPosition[1] && game_y < enemyPosition[1] + 10) begin
            {vga_r,vga_g,vga_b} <= 12'hF00;
        end
        
        // 显示子弹
        for(int i = 0; i < 600; i++) begin
            // 玩家子弹 (青色)
            if(playerBullet[i] != 0 &&
               game_x == playerBullet[i][7:0] && 
               game_y == playerBullet[i][15:8]) begin
                {vga_r,vga_g,vga_b} <= 12'h0FF;
            end
            // 敌人子弹 (黄色)
            if(enemyBullet[i] != 0 &&
               game_x == enemyBullet[i][7:0] && 
               game_y == enemyBullet[i][15:8]) begin
                {vga_r,vga_g,vga_b} <= 12'hFF0;
            end
        end
    end else begin
        {vga_r,vga_g,vga_b} <= 12'h000;
    end
end

endmodule