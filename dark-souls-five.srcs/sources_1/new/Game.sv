module Game (
    input enter,pause,up,down,left,right,clk,
    input [3:0] state,
    input [9:0] textId,
    input [5:0] level,
    input [20:0] playerHp,
    input [20:0] enemyHp,
    input [6:0] playerPosition[0:1],
    input [6:0] enemyPosition[0:1],
    input [28:0] playerBullet[0:79][0:59],
    input [28:0] enemyBullet[0:79][0:59],
    
    output [3:0] next_state,
    output [9:0] next_textId,
    output [5:0] next_level,
    output [20:0] next_playerHp,
    output [20:0] next_enemyHp,
    output [6:0] next_playerPosition[0:1],
    output [6:0] next_enemyPosition[0:1],
    output [3:0] next_playerBullet[0:79][0:59],
    output [3:0] next_enemyBullet[0:79][0:59]
);
GetState getstate(
    .enter(enter),
    .pause(pause),
    .state(state),
    .textId(textId),
    .level(level),
    .playerHp(playerHp),
    .enemyHp(enemyHp),
    
    .next_state(next_state),
    .next_level(next_level)
);

GetPlayerPosition getPlayerPosition(
    .clk(clk),
    .state(state),
    .up(up),
    .down(down),
    .left(left),
    .right(right),
    .playerPosition(playerPosition),
    
    .next_platerPosition(next_playerPosition)
);

GetEnemyPosition getEnemyPosition(
    .state(state),
    .playerPosition(playerPosition),
    .playerBullet(playerBullet),//躲避玩家子弹？
    .enemyPosition(enemyPosition),
    
    .next_enemyPosition(next_enemyPosition)
);

GetBulletPosition getBulletPosition(//这个模块计算下一时刻的弹幕碰撞信息（从而生命值的变化情况）以及弹幕位置信息
    .state(state),
    .playerHp(playerHp),
    .enemyHp(enemyHp),
    .playerPosition(playerPosition),
    .enemyPosition(enemyPosition),
    .playerBullet(playerBullet),
    .enemyBullet(enemyBullet),
    
    .next_playerHp(next_playerHp),
    .next_enemyHp(next_enemyHp),
    .next_playerBullet(next_playerBullet),
    .next_enemyBullet(next_enemyBullet)
);

endmodule
