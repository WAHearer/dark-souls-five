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
reg buffer_select;
reg buffer_swap_ready;
// VRAM接口
reg  [11:0] vram_din_a, vram_din_b;
wire [11:0] vram_dout_a, vram_dout_b;
wire [11:0] display_data = buffer_select ? vram_dout_b : vram_dout_a;
reg vram_we_a, vram_we_b;
blk_mem_gen_0 vram_A (
    .clka(clk),
    .wea(vram_we_a),
    .addra({8'hff - render_y, 8'hff - render_x}),
    .dina(vram_din_a),
    .clkb(clk),
    .addrb({y, x}),
    .doutb(vram_dout_a)
);

blk_mem_gen_0 vram_B (
    .clka(clk),
    .wea(vram_we_b),
    .addra({8'hff - render_y, 8'hff - render_x}),
    .dina(vram_din_b),
    .clkb(clk),
    .addrb({y, x}),
    .doutb(vram_dout_b)
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
always @(posedge clk) begin
    case (render_state)
        IDLE: begin
            render_state <= RENDER_ENEMY;
            render_x <= enemyPosition[0] - 7'h7;
            render_y <= enemyPosition[1] - 7'h7;
            if (buffer_select) begin
                vram_we_a <= 1;
                vram_din_a <= COLOR_ENEMY;
            end else begin
                vram_we_b <= 1;
                vram_din_b <= COLOR_ENEMY;
            end
        end

        RENDER_ENEMY: begin
            if (render_x == enemyPosition[0] + 7'h7) begin
                render_x <= enemyPosition[0] - 7'h7;
                if (render_y == enemyPosition[1] + 7'h7) begin
                    render_state <= RENDER_PLAYER;
                    render_x <= playerPosition[0] - 7'h7;
                    render_y <= playerPosition[1] - 7'h7;
                    if (buffer_select) begin
                        vram_we_a <= 1;
                        vram_din_a <= COLOR_PLAYER;
                    end else begin
                        vram_we_b <= 1;
                        vram_din_b <= COLOR_PLAYER;
                    end
                end else begin
                    render_y <= render_y + 1;
                end
            end else begin
                render_x <= render_x + 1;
            end
        end

        RENDER_PLAYER: begin
            if (render_x == playerPosition[0] + 7'h7) begin
                render_x <= playerPosition[0] - 7'h7;
                if (render_y == playerPosition[1] + 7'h7) begin
                    render_state <= RENDER_PLAYER_BULLET;
                    render_x <= playerBullet[0];
                    render_y <= playerBullet[1];
                    if (buffer_select) begin
                        vram_we_a <= 1;
                        vram_din_a <= COLOR_PLAYER_BULLET;
                    end else begin
                        vram_we_b <= 1;
                        vram_din_b <= COLOR_PLAYER_BULLET;
                    end
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
                render_x <= enemyBullet[0];
                render_y <= enemyBullet[1];
                if (buffer_select) begin
                    vram_we_a <= 1;
                    vram_din_a <= COLOR_ENEMY_BULLET;
                end else begin
                    vram_we_b <= 1;
                    vram_din_b <= COLOR_ENEMY_BULLET;
                end
                bulletCounter <= 0;
            end else begin
                bulletCounter <= bulletCounter + 1;
                render_x <= playerBullet[bulletCounter + 1] - 7'h1;
                render_y <= playerBullet[bulletCounter + 1] - 7'h1;
            end
        end

        RENDER_ENEMY_BULLET: begin
            if (bulletCounter == 69) begin
                render_state <= DONE;
            end else begin
                bulletCounter <= bulletCounter + 1;
                render_x <= enemyBullet[bulletCounter + 1] - 7'h1;
                render_y <= enemyBullet[bulletCounter + 1] - 7'h1;
            end
        end

        DONE: begin
            if (buffer_select) begin
                vram_we_a <= 0;
            end else begin
                vram_we_b <= 0;
            end
            buffer_swap_ready <= 1; 
            render_state <= buffer_swap_ready ? DONE : IDLE;
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
        if(vcount == VSW + VBP + VEN + VFP - 1) begin
            vcount <= 0;
            if (buffer_swap_ready) begin
                buffer_select <= ~buffer_select;
                buffer_swap_ready <= 0;
            end
        end else
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

assign vga_r = disp_enable ? display_data[11:8] : 4'h0;
assign vga_g = disp_enable ? display_data[7:4] : 4'h0;
assign vga_b = disp_enable ? display_data[3:0] : 4'h0;


endmodule