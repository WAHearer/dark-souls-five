module Controller (
    input enter,pause,up,down,left,right,clk
);
reg [3:0] state;//0开始游戏前，1暂停，2游戏中，3完成一关但未开启下一关，4通关，5失败
reg [5:0] level;
reg [20:0] playerHp;
reg [20:0] enemyHp;
reg [200:0] playerPosition[1:0];//0为x坐标，1为y坐标。考虑到每个时钟周期都更新位置，因此需要很大的位置储存来使得一个时钟周期的移动相对整体而言微不足道。screen模块中再将其压缩为800*600
reg [200:0] enemyPosition[1:0];//同上
reg [10:0] playerBullet[799:0][599:0];//以某种编码方式储存每个像素位置弹幕的颜色，速度方向与已等待时间（显然子弹每若干个时钟周期移动一次）
reg [10:0] enemyBullet[799:0][599:0];//同上

reg [3:0] next_state;
reg [5:0] next_level;
reg [20:0] next_playerHp;
reg [20:0] next_enemyHp;
reg [9:0] next_playerPosition[1:0];
reg [9:0] next_enemyPosition[1:0];
reg [3:0] next_playerBullet[799:0][599:0];
reg [3:0] next_enemyBullet[799:0][599:0];

Screen screen(//screen模块生成画布信息，然后调用显示模块输出到vga
    .state(state),
    .level(level),
    .playerHp(playerHp),
    .enemyHp(enemyHp),
    .playerPosition(playerPosition),
    .enemyPosition(enemyPosition),
    .playerBullet(playerBullet),
    .enemyBullet(enemyBullet)
);

.Music music(//播放音乐？可以依据：当前游戏状态、关卡数、boss血量
    .state(state),
    .level(level),
    .enemyHp(enemyHp)
);

Game game(//计算下一时刻状态，内部需要：根据按键输入更新状态，计算子弹碰撞，计算血量
    .enter(enter),
    .pause(pause),
    .up(up),
    .down(down),
    .left(left),
    .right(right),
    .state(state),
    .level(level),
    .playerHp(playerHp),
    .enemyHp(enemyHp),
    .playerPosition(playerPosition),
    .enemyPosition(enemyPosition),
    .playerBullet(playerBullet),
    .enemyBullet(enemyBullet),
    //以下是输出
    .next_state(next_state),
    .next_level(next_level),
    .next_playerHp(next_playerHp),
    .next_enemyHp(next_enemyHp),
    .next_playerPosition(next_playerPosition),
    .next_enemyPosition(next_enemyPosition),
    .next_playerBullet(next_playerBullet),
    .next_enemyBullet(next_enemyBullet)
);

always @(posedge clk) begin//更新状态
    state<=next_state;
    level<=next_level;
    playerHp<=next_playerHp;
    enemyHp<=next_enemyHp;
    playerPosition<=next_playerPosition;
    enemyPosition<=next_enemyPosition;
    playerBullet<=next_playerBullet;
    enemyBullet<=next_enemyBullet;
end

endmodule

