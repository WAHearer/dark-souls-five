module Controller (
    input enter,pause,up,down,left,right,clk
);
reg [3:0] state;//0开始游戏前，1暂停，2游戏中，3完成一关但未开启下一关，4通关，5失败，6显示文本
reg [9:0] textId;//当前文本编号
reg [5:0] level;
reg [20:0] playerHp;
reg [20:0] enemyHp;
reg [6:0] playerPosition[0:1];//0为x坐标，1为y坐标
reg [6:0] enemyPosition[0:1];//同上
reg [28:0] playerBullet[0:79][0:59];//11:0为色彩，21:12为伤害，25:22为方向，28:26为速度
reg [28:0] enemyBullet[0:79][0:59];//同上

reg [3:0] next_state;
reg [9:0] next_textId;
reg [5:0] next_level;
reg [20:0] next_playerHp;
reg [20:0] next_enemyHp;
reg [6:0] next_playerPosition[0:1];
reg [6:0] next_enemyPosition[0:1];
reg [3:0] next_playerBullet[0:79][0:59];
reg [3:0] next_enemyBullet[0:79][0:59];

Screen screen(//screen模块生成画布信息，然后调用显示模块输出到vga
    .state(state),
    .textId(textId),
    .level(level),
    .playerHp(playerHp),
    .enemyHp(enemyHp),
    .playerPosition(playerPosition),
    .enemyPosition(enemyPosition),
    .playerBullet(playerBullet),
    .enemyBullet(enemyBullet)
);

Music music(//播放音乐？可以依据：当前游戏状态、关卡数、boss血量
    .state(state),
    .level(level),
    .enemyHp(enemyHp)
);

Game game(//计算下一时刻状态，内部需要：根据按键输入更新状态，计算子弹碰撞，计算血量
    .clk(clk),
    .enter(enter),
    .pause(pause),
    .up(up),
    .down(down),
    .left(left),
    .right(right),
    .state(state),
    .textId(textId),
    .level(level),
    .playerHp(playerHp),
    .enemyHp(enemyHp),
    .playerPosition(playerPosition),
    .enemyPosition(enemyPosition),
    .playerBullet(playerBullet),
    .enemyBullet(enemyBullet),

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
    textId<=next_textId;
    level<=next_level;
    playerHp<=next_playerHp;
    enemyHp<=next_enemyHp;
    playerPosition<=next_playerPosition;
    enemyPosition<=next_enemyPosition;
    playerBullet<=next_playerBullet;
    enemyBullet<=next_enemyBullet;
end

endmodule
