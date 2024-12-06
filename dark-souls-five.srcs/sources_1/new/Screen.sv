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
    input clk,clk_50,         // 系统时钟
    input [3:0] state,           // 游戏状态
    input [9:0] textId,          // 文本ID
    input [5:0] level,           // 关卡
    input [20:0] playerHp,       // 玩家血量
    input [20:0] enemyHp,        // 敌人血量
    input [7:0] playerPosition[0:1], // 玩家位置
    input [7:0] enemyPosition[0:1],  // 敌人位置
    input [27:0] playerBullet[0:69], // 玩家子弹
    input [27:0] enemyBullet[0:69],  // 敌人子弹
    
    output wire [3:0] vga_r,      // VGA红色分量
    output wire [3:0] vga_g,      // VGA绿色分量
    output wire [3:0] vga_b,      // VGA蓝色分量
    output reg vga_hs,           // 行同步
    output reg vga_vs            // 场同步
);
 
// VRAM接口
reg  vram_we;
reg  [11:0] vram_din;
wire [11:0] vram_dout;
blk_mem_gen_0 vram (
    .clka(clk_50),
    .wea(vram_we),
    .addra({render_y, render_x}),
    .dina(vram_din),
    .clkb(clk),
    .addrb({y, x}),
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
reg [7:0] render_x, render_y;
reg [7:0] bulletCounter;
always @(posedge clk_50) begin
    case (render_state)
        IDLE: begin
            render_state <= RENDER_ENEMY;
            vram_we <= 1;
            render_x <= enemyPosition[0] - 7'hF;
            render_y <= enemyPosition[1] - 7'hF;
            vram_din <= COLOR_ENEMY;
        end

        RENDER_ENEMY: begin
            if (render_x == enemyPosition[0] + 7'hF) begin
                render_x <= enemyPosition[0] - 7'hF;
                if (render_y == enemyPosition[1] + 7'hF) begin
                    render_state <= RENDER_PLAYER;
                    render_x <= playerPosition[0] - 7'hF;
                    render_y <= playerPosition[1] - 7'hF;
                    vram_din <= COLOR_PLAYER;
                end else begin
                    render_y <= render_y + 1;
                end
            end else begin
                render_x <= render_x + 1;
            end
        end

        RENDER_PLAYER: begin
            if (render_x == playerPosition[0] + 7'hF) begin
                render_x <= playerPosition[0] - 7'hF;
                if (render_y == playerPosition[1] + 7'hF) begin
                    render_state <= RENDER_PLAYER_BULLET;
                    render_x <= playerBullet[0] - 7'h1;
                    render_y <= playerBullet[1] - 7'h1;
                    vram_din <= COLOR_PLAYER_BULLET;
                    bulletCounter <= 0;
                end else begin
                    render_y <= render_y + 1;
                end
            end else begin
                render_x <= render_x + 1;
            end
        end

        RENDER_PLAYER_BULLET: begin
            if (bulletCounter == 69) begin
                render_state <= RENDER_ENEMY_BULLET;
                render_x <= enemyBullet[0] - 7'h1;
                render_y <= enemyBullet[1] - 7'h1;
                vram_din <= COLOR_ENEMY_BULLET;
                bulletCounter <= 0;
            end else begin
                if (render_x == playerBullet[bulletCounter] + 7'h1) begin
                    render_x <= playerBullet[bulletCounter] - 7'h1;
                    if (render_y == playerBullet[bulletCounter + 1] + 7'h1) begin
                        bulletCounter <= bulletCounter + 1;
                        render_x <= playerBullet[bulletCounter + 1] - 7'h1;
                        render_y <= playerBullet[bulletCounter + 1] - 7'h1;
                    end else begin
                        render_y <= render_y + 1;
                    end
                end else begin
                    render_x <= render_x + 1;
                end
            end
        end

        RENDER_ENEMY_BULLET: begin
            if (bulletCounter == 69) begin
                render_state <= DONE;
            end else begin
                if (render_x == enemyBullet[bulletCounter] + 7'h1) begin
                    render_x <= enemyBullet[bulletCounter] - 7'h1;
                    if (render_y == enemyBullet[bulletCounter + 1] + 7'h1) begin
                        bulletCounter <= bulletCounter + 1;
                        render_x <= enemyBullet[bulletCounter + 1] - 7'h1;
                        render_y <= enemyBullet[bulletCounter + 1] - 7'h1;
                    end else begin
                        render_y <= render_y + 1;
                    end
                end else begin
                    render_x <= render_x + 1;
                end
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
initial begin
    hcount = 0;
    vcount = 0;
end
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
    vga_hs <= (hcount < HSW);
    vga_vs <= (vcount < VSW);
 end
 
// 显示使能信号
wire disp_enable = (hcount >= HSW + BP) && (hcount < HSW + BP + HEN) &&
                  (vcount >= VSW + VBP) && (vcount < VSW + VBP + VEN);

// 显示坐标计算
wire [7:0] x, y;
assign x = (hcount - (HSW + BP)) >> 2;
assign y = (vcount - (VSW + VBP)) >> 2;

assign vga_r = disp_enable ? vram_dout[11:8] : 4'h0;
assign vga_g = disp_enable ? vram_dout[7:4] : 4'h0;
assign vga_b = disp_enable ? vram_dout[3:0] : 4'h0;


endmodule