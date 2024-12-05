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
    input clk_50,clk_200,         // 系统时钟
    input [3:0] state,           // 游戏状态
    input [9:0] textId,          // 文本ID
    input [5:0] level,           // 关卡
    input [20:0] playerHp,       // 玩家血量
    input [20:0] enemyHp,        // 敌人血量
    input [7:0] playerPosition[0:1], // 玩家位置
    input [7:0] enemyPosition[0:1],  // 敌人位置
    input [27:0] playerBullet[0:69], // 玩家子弹
    input [27:0] enemyBullet[0:69],  // 敌人子弹
    
    output reg [3:0] vga_r,      // VGA红色分量
    output reg [3:0] vga_g,      // VGA绿色分量
    output reg [3:0] vga_b,      // VGA蓝色分量
    output reg vga_hs,           // 行同步
    output reg vga_vs            // 场同步
);
 
// VRAM接口
reg  vram_we;
reg  [11:0] vram_din;
wire [11:0] vram_dout;
blk_mem_gen_0 vram (
    .ena(1'b1),
    .clka(clk_50),
    .wea(vram_we),
    .addra({render_y[7:0], render_x[7:0]}),
    .dina(vram_din),
    .enb(1'b1),
    .clkb(clk_200),
    .addrb({y[9:0]>>2, x[9:0]>>2}),
    .doutb(vram_dout)
);

// 渲染逻辑
typedef enum {
    IDLE,
    RENDER_ENEMY,
    RENDER_PLAYER,
    RENDER_PLAYER_BULLET,
    RENDER_ENEMY_BULLET,
    DONE
} render_state_t;

localparam COLOR_BG = 12'h000;
localparam COLOR_PLAYER = 12'h0F0;
localparam COLOR_ENEMY = 12'hF00;
localparam COLOR_PLAYER_BULLET = 12'h0FF;
localparam COLOR_ENEMY_BULLET = 12'hF0F;

render_state_t render_state;
reg [9:0] render_x, render_y;

always @(posedge clk_50) begin
    case (render_state)
        IDLE: begin
            render_x <= 0;
            render_y <= 0;
            render_state <= RENDER_ENEMY;
            vram_we <= 1;
        end

        RENDER_ENEMY: begin
            // 检查当前像素是否在敌人范围内
            if (render_x >= enemyPosition[0] && render_x < enemyPosition[0] + 8'd32 &&
                render_y >= enemyPosition[1] && render_y < enemyPosition[1] + 8'd32) begin
                vram_din <= COLOR_ENEMY;
            end else begin
                vram_din <= COLOR_BG;
            end
                
            // 更新渲染位置
            if (render_x == HEN - 1) begin
                render_x <= 0;
                if (render_y == VEN - 1) begin
                    render_state <= RENDER_PLAYER;
                    render_y <= 0;
                end else begin
                    render_y <= render_y + 1;
                end
            end else begin
                render_x <= render_x + 1;
            end
        end

        RENDER_PLAYER: begin
            // 检查当前像素是否在玩家范围内
            if (render_x >= playerPosition[0] && render_x < playerPosition[0] + 8'd32 &&
                render_y >= playerPosition[1] && render_y < playerPosition[1] + 8'd32) begin
                vram_din <= COLOR_PLAYER;
            end
                
            // 更新渲染位置(类似RENDER_ENEMY)
            if (render_x == HEN - 1) begin
                render_x <= 0;
                if (render_y == VEN - 1) begin
                    render_state <= RENDER_PLAYER_BULLET;
                    render_y <= 0;
                end else begin
                    render_y <= render_y + 1;
                end
            end else begin
                render_x <= render_x + 1;
            end
        end

        RENDER_PLAYER_BULLET: begin
            // 遍历所有玩家子弹
            if (playerBullet[render_y][27]) begin  // 检查子弹是否有效
                if (render_x >= playerBullet[render_y][15:8] && 
                    render_x < playerBullet[render_y][15:8] + 8'd4) begin
                    vram_din <= COLOR_PLAYER_BULLET;
                end
            end

            // 更新渲染位置
            if (render_x == HEN - 1) begin
                render_x <= 0;
                if (render_y == VEN - 1) begin
                    render_state <= RENDER_ENEMY_BULLET;
                    render_y <= 0;
                end else begin
                    render_y <= render_y + 1;
                end
            end else begin
                render_x <= render_x + 1;
            end
        end

        RENDER_ENEMY_BULLET: begin
            // 遍历所有敌人子弹
            if (enemyBullet[render_y][27]) begin  // 检查子弹是否有效
                if (render_x >= enemyBullet[render_y][15:8] && 
                    render_x < enemyBullet[render_y][15:8] + 8'd4) begin
                    vram_din <= COLOR_ENEMY_BULLET;
                end
            end

            // 更新渲染位置
            if (render_x == HEN - 1) begin
                render_x <= 0;
                if (render_y == VEN - 1) begin
                    render_state <= DONE;
                end else begin
                    render_y <= render_y + 1;
                end
            end else begin
                render_x <= render_x + 1;
            end
        end

        DONE: begin
            vram_we <= 0;
            render_state <= IDLE;
        end
    endcase
 end

// 水平和垂直计数器
reg [11:0] hcount, vcount;
 always @(posedge clk_50) begin
     if(hcount == HSW + BP + HEN + HFP - 1) begin
        hcount <= 0;
         if(vcount == VSW + VBP + VEN + VFP - 1)
             vcount <= 0;
         else
             vcount <= vcount + 1;
     end
    else
        hcount <= hcount + 1;
 end
 
// 同步信号生成
 always @(posedge clk_50) begin
    vga_hs <= (hcount >= HSW);
    vga_vs <= (vcount >= VSW);
 end
 
// 显示使能信号
wire disp_enable = (hcount >= HSW + BP) && (hcount < HSW + BP + HEN) &&
                  (vcount >= VSW + VBP) && (vcount < VSW + VBP + VEN);

// 显示坐标计算
wire [9:0] x = (hcount - (HSW + BP));
wire [9:0] y = (vcount - (VSW + VBP));

// VGA输出逻辑
always @(posedge clk_50) begin
    if(!disp_enable) begin
        vga_r <= 4'h0;
        vga_g <= 4'h0;
        vga_b <= 4'h0;
    end
    else begin
        vga_r <= vram_dout[11:8];
        vga_g <= vram_dout[7:4];
        vga_b <= vram_dout[3:0];
     end
end

endmodule