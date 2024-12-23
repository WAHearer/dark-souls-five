module Controller (
    input clk,clk_50,enter,pause,up,down,left,right,space,
    output [3:0] vga_r,vga_g,vga_b,
    output vga_hs,vga_vs
);
reg [3:0] state;//0开始游戏前，1暂停，2游戏中，3完成一关但未开启下一关，4通关，5失败，6显示文本
reg [9:0] textId;
reg [5:0] level;
reg [20:0] playerHp;
reg [20:0] enemyHp;
reg [7:0] playerPosition[0:1];//0为x坐标，1为y坐标
reg [7:0] enemyPosition[0:1];//同上
reg [27:0] playerBullet[0:39];//7:0为x坐标，15:8为y坐标，22:16为伤害，25:23为方向，27:26为速度
reg [27:0] enemyBullet[0:159];//同上
reg [16:0] wall[0:4];//7:0为y坐标，14:8为伤害，16:15为速度

reg [3:0] next_state;
reg [9:0] next_textId;
reg [5:0] next_level;
reg [20:0] next_playerHp;
reg [20:0] next_enemyHp;
reg [7:0] next_playerPosition[0:1];
reg [7:0] next_enemyPosition[0:1];
reg [27:0] next_playerBullet[0:39];
reg [27:0] next_enemyBullet[0:159];
reg [16:0] next_wall[0:4];

integer i,j,k;

Screen screen(//screen模块生成画布信息，然后调用显示模块输出到vga
    .clk(clk),
    .clk_50(clk_50),
    .state(state),
    .textId(textId),
    .level(level),
    .playerHp(playerHp),
    .enemyHp(enemyHp),
    .playerPosition(playerPosition),
    .enemyPosition(enemyPosition),
    .playerBullet(playerBullet),
    .enemyBullet(enemyBullet),
    .wall(wall),
    .vga_r(vga_r),
    .vga_g(vga_g),
    .vga_b(vga_b),
    .vga_hs(vga_hs),
    .vga_vs(vga_vs)
);
/*
Music music(//播放音乐？可以依据：当前游戏状态、关卡数、boss血量
    .state(state),
    .level(level),
    .enemyHp(enemyHp)
);*/

Game game(//计算下一时刻状态，内部需要：根据按键输入更新状态，计算子弹碰撞，计算血量
    .clk(clk_50),
    .enter(enter),
    .pause(pause),
    .up(up),
    .down(down),
    .left(left),
    .right(right),
    .space(space),
    .state(state),
    .textId(textId),
    .level(level),
    .playerHp(playerHp),
    .enemyHp(enemyHp),
    .playerPosition(playerPosition),
    .enemyPosition(enemyPosition),
    .playerBullet(playerBullet),
    .enemyBullet(enemyBullet),
    .wall(wall),
    
    .next_state(next_state),
    .next_textId(next_textId),
    .next_level(next_level),
    .next_playerHp(next_playerHp),
    .next_enemyHp(next_enemyHp),
    .next_playerPosition(next_playerPosition),
    .next_enemyPosition(next_enemyPosition),
    .next_playerBullet(next_playerBullet),
    .next_enemyBullet(next_enemyBullet),
    .next_wall(next_wall)
);

initial begin
    state<=0;
    textId<=0;
    level<=0;
    playerHp<=32'd100;
    enemyHp<=32'd600;
    playerPosition[0]<=8'd100;
    playerPosition[1]<=8'd30;
    enemyPosition[0]<=8'd150;
    enemyPosition[1]<=8'd120;
    for(i=0;i<40;i++)
        playerBullet[i]<=0;
    for(j=0;j<160;j++) 
        enemyBullet[j]<=0;
    for(k=0;k<5;k++)
        wall[k]<=0;
end

always @(posedge clk_50) begin//更新状态
    state<=next_state;
    textId<=next_textId;
    level<=next_level;
    playerHp<=next_playerHp;
    enemyHp<=next_enemyHp;
    playerPosition[0]<=next_playerPosition[0];
    playerPosition[1]<=next_playerPosition[1];
    enemyPosition[0]<=next_enemyPosition[0];
    enemyPosition[1]<=next_enemyPosition[1];
    for(i=0;i<40;i++)
        playerBullet[i]<=next_playerBullet[i];
    for(j=0;j<160;j++)
        enemyBullet[j]<=next_enemyBullet[j];
    for(k=0;k<5;k++)
        wall[k]<=next_wall[k];
end

endmodule
