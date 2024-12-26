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
    input [27:0] playerBullet[0:39], // 玩家子弹
    input [27:0] enemyBullet[0:159],  // 敌人子弹
    input [16:0] wall[0:4],          // 敌人子弹墙壁
    
    output wire [3:0] vga_r,      // VGA红色分量
    output wire [3:0] vga_g,      // VGA绿色分量
    output wire [3:0] vga_b,      // VGA蓝色分量
    output reg vga_hs,           // 行同步
    output reg vga_vs            // 场同步
);

reg [7:0] disp_hp;
reg buffer_select;
reg render_ready, vga_ready;
reg  [11:0] vram_din_a, vram_din_b;
wire [11:0] vram_dout_a, vram_dout_b;
wire rom_text_out;
reg [7:0] rom_figure_in_y, rom_figure_in_x;
wire [11:0] rom_figure_out;
reg [3:0] imgID;
reg [7:0] img_y, img_x;
wire [11:0] display_data = buffer_select ? vram_dout_b : vram_dout_a;
reg vram_we_a, vram_we_b;
reg [11:0] hcount, vcount;
reg figID;
initial begin
    hcount = 0;
    vcount = 0;
    disp_hp <= 150;
    buffer_select = 0;
    render_ready = 0;
    vga_ready = 0;
    img_y = 0;
    img_x = 0;
end
reg [7:0] render_x, render_y;
reg [7:0] bulletCounter;
reg [3:0] wallCounter;
always @(posedge clk) begin
    case (level)
        1:disp_hp <= enemyHp >> 2;
        2:disp_hp <= enemyHp >> 3;
        3:disp_hp <= enemyHp >> 4;
        4:disp_hp <= enemyHp >> 4;
        5:disp_hp <= enemyHp >> 5;
    endcase

    case (level)
        1:figID <= 0;
        2:figID <= 1;
        3:figID <= 2;
        4:figID <= 3;
        5:figID <= 4; 
    endcase
end
blk_mem_gen_0 vram_A (
    .clka(clk),
    .wea(vram_we_a),
    .addra({150 - render_y, render_x}),
    .dina(vram_din_a),
    .clkb(clk),
    .addrb({y, x}),
    .doutb(vram_dout_a)
);

blk_mem_gen_0 vram_B (
    .clka(clk),
    .wea(vram_we_b),
    .addra({150 - render_y, render_x}),
    .dina(vram_din_b),
    .clkb(clk),
    .addrb({y, x}),
    .doutb(vram_dout_b)
);

blk_mem_gen_1 rom_text (
    .clka(clk),
    .addra(imgID * 200 * 150 + render_y * 200 + render_x),
    .douta(rom_text_out)
);

blk_mem_gen_2 rom_figure (
    .clka(clk),
    .addra(figID * 41 * 41 + rom_figure_in_y * 41 + rom_figure_in_x),
    .douta(rom_figure_out)
);

// 渲染逻辑
typedef enum {
    IDLE,

    RENDER_BG,
    RENDER_ENEMY,
    RENDER_PLAYER,
    RENDER_PLAYER_BULLET,
    RENDER_ENEMY_BULLET,
    RENDER_ENEMY_BULLETWALL,
    RENDER_ENEMY_HEALTH,
    RENDER_PLAYER_HEALTH,

    RENDER_COVER,
    RENDER_TEXT,

    DONE
} render_state_t;

localparam COLOR_BG = 12'h000;
localparam COLOR_PLAYER = 12'h0F0;
localparam COLOR_ENEMY = 12'hF00;
localparam COLOR_PLAYER_BULLET = 12'h0FF;
localparam COLOR_ENEMY_BULLET = 12'hF0F;
localparam COLOR_NORMAL_TEXT = 12'hFF7;
localparam COLOR_FATAL_TEXT = 12'hF00;

render_state_t render_state;

always @(posedge clk) begin
    case (render_state)
        IDLE: begin
            render_ready <= 0;
            render_x <= 0;
            render_y <= 0;
            if (state == 6) begin
                render_state <= RENDER_TEXT;
                imgID <= textId + 6;
            end else if (state != 1 && state != 2) begin
                render_state <= RENDER_COVER;
                imgID <= state;
            end else begin
                render_state <= RENDER_BG;
            end
            if (buffer_select) begin
                vram_we_a <= 1;
                vram_din_a <= COLOR_BG;
            end else begin
                vram_we_b <= 1;
                vram_din_b <= COLOR_BG;
            end
        end

        RENDER_COVER: begin
            if (rom_text_out) begin
                if (buffer_select) begin
                    vram_din_a <= (state == 5) ? COLOR_FATAL_TEXT : COLOR_NORMAL_TEXT;
                end else begin
                    vram_din_b <= (state == 5) ? COLOR_FATAL_TEXT : COLOR_NORMAL_TEXT;
                end
            end else begin
                if (buffer_select) begin
                    vram_din_a <= COLOR_BG;
                end else begin
                    vram_din_b <= COLOR_BG;
                end
            end
            if (render_x == 199) begin
                render_x <= 0;
                if (render_y == 149) begin
                    render_state <= DONE;
                end else begin
                    render_y <= render_y + 1;
                end
            end else begin
                render_x <= render_x + 1;
            end
        end

        RENDER_TEXT: begin
            if (rom_text_out) begin
                if (buffer_select) begin
                    vram_din_a <= COLOR_NORMAL_TEXT;
                end else begin
                    vram_din_b <= COLOR_NORMAL_TEXT;
                end
            end else begin
                if (buffer_select) begin
                    vram_din_a <= COLOR_BG;
                end else begin
                    vram_din_b <= COLOR_BG;
                end
            end
            if (render_x == 199) begin
                render_x <= 0;
                if (render_y == 149) begin
                    render_state <= DONE;
                end else begin
                    render_y <= render_y + 1;
                end
            end else begin
                render_x <= render_x + 1;
            end
        end

        RENDER_BG: begin
            if (render_x == 199) begin
                render_x <= 0;
                if (render_y == 149) begin
                    render_state <= RENDER_ENEMY;
                    render_x <= enemyPosition[0] - 20;
                    render_y <= enemyPosition[1] - 20;
                    rom_figure_in_x <= 0;
                    rom_figure_in_y <= 0;
                    if (buffer_select) begin
                        vram_we_a <= 1;
                        vram_din_a <= rom_figure_out;
                    end else begin
                        vram_we_b <= 1;
                        vram_din_b <= rom_figure_out;
                    end
                end else begin
                    render_y <= render_y + 1;
                end
            end else begin
                render_x <= render_x + 1;
            end
        end

        RENDER_ENEMY: begin
            if (render_x == (enemyPosition[0] + 20) || render_x == 199) begin
                render_x <= enemyPosition[0] - 20;
                rom_figure_in_x <= 0;
                if (render_y == (enemyPosition[1] + 20) || render_y == 149) begin
                    render_state <= RENDER_PLAYER;
                    render_x <= playerPosition[0];
                    render_y <= playerPosition[1];
                    if (buffer_select) begin
                        vram_we_a <= 1;
                        vram_din_a <= COLOR_PLAYER;
                    end else begin
                        vram_we_b <= 1;
                        vram_din_b <= COLOR_PLAYER;
                    end
                end else begin
                    render_y <= render_y + 1;
                    rom_figure_in_y <= rom_figure_in_y + 1;
                end
            end else begin
                render_x <= render_x + 1;
                rom_figure_in_x <= rom_figure_in_x + 1;
            end
        end

        RENDER_PLAYER: begin
            render_state <= RENDER_PLAYER_BULLET;
            render_x <= playerBullet[0][7:0];
            render_y <= playerBullet[0][15:8];
            if (buffer_select) begin
                vram_we_a <= 1;
                vram_din_a <= COLOR_PLAYER_BULLET;
            end else begin
                vram_we_b <= 1;
                vram_din_b <= COLOR_PLAYER_BULLET;
            end
        end

        RENDER_PLAYER_BULLET: begin
            if (bulletCounter == 39) begin
                render_state <= RENDER_ENEMY_BULLET;
                render_x <= enemyBullet[0][7:0];
                render_y <= enemyBullet[0][15:8];
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
                render_x <= playerBullet[bulletCounter + 1][7:0];
                render_y <= playerBullet[bulletCounter + 1][15:8];
            end
        end

        RENDER_ENEMY_BULLET: begin
            if (bulletCounter == 159) begin
                render_state <= RENDER_ENEMY_BULLETWALL;
                render_x <= 0;
                render_y <= wall[0][7:0];
                wallCounter <= 0;
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
                render_x <= enemyBullet[bulletCounter + 1][7:0];
                render_y <= enemyBullet[bulletCounter + 1][15:8];
            end
        end

        RENDER_ENEMY_BULLETWALL: begin
            if (render_x == 199) begin
                render_x <= 0;
                if (wallCounter == 4) begin
                    render_state <= RENDER_ENEMY_HEALTH;
                    if (buffer_select) begin
                        vram_we_a <= 1;
                        vram_din_a <= COLOR_ENEMY;
                    end else begin
                        vram_we_b <= 1;
                        vram_din_b <= COLOR_ENEMY;
                    end
                    render_x <= 25;
                    render_y <= 10;
                end else begin
                    wallCounter <= wallCounter + 1;
                    render_y <= wall[wallCounter][7:0];
                end
            end else begin
                render_x <= render_x + 1;
            end
        end

        RENDER_ENEMY_HEALTH: begin
            if (render_x == (25 + disp_hp) || render_x == 199) begin
                render_x <= 25;
                if (render_y == 12) begin
                    render_state <= RENDER_PLAYER_HEALTH;
                    render_x <= 0;
                    render_y <= 137;
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

        RENDER_PLAYER_HEALTH: begin
            if (render_x == playerHp) begin
                render_x <= 0;
                if (render_y == 140) begin
                    render_state <= DONE;
                end else begin
                    render_y <= render_y + 1;
                end
            end else begin
                render_x <= render_x + 1;
            end
        end

        DONE: begin
            if (buffer_select) begin
                vram_we_a <= 0;
            end else begin
                vram_we_b <= 0;
            end
            render_ready <= 1;
            render_state <= (vga_ready) ? IDLE : DONE;
        end
    endcase
end

always @(posedge clk_50) begin
    if(hcount == HSW + BP + HEN + HFP - 1) begin
        hcount <= 0;
        if(vcount == VSW + VBP + VEN + VFP - 1) begin
            vcount <= 0;
            if (render_ready) begin
                buffer_select <= ~buffer_select;
                vga_ready <= 1;
            end else begin
                vga_ready <= 0;
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
