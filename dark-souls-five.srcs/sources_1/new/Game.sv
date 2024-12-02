module Game (
    input enter,pause,up,down,left,right,space,clk,
    input [3:0] state,
    input [9:0] textId,
    input [5:0] level,
    input [20:0] playerHp,
    input [20:0] enemyHp,
    input [6:0] playerPosition[0:1],
    input [6:0] enemyPosition[0:1],
    input [16:0] playerBullet[0:79][0:59],
    input [16:0] enemyBullet[0:79][0:59],
    
    output [3:0] next_state,
    output [9:0] next_textId,
    output [5:0] next_level,
    output [20:0] next_playerHp,
    output [20:0] next_enemyHp,
    output [6:0] next_playerPosition[0:1],
    output [6:0] next_enemyPosition[0:1],
    output reg [16:0] next_playerBullet[0:79][0:59],
    output reg [16:0] next_enemyBullet[0:79][0:59]
);
reg [16:0] next_playerBullet_moved[0:79][0:59];
reg [16:0] next_playerBullet_generated[0:79][0:59];
reg [16:0] next_enemyBullet_moved[0:79][0:59];
reg [16:0] next_enemyBullet_generated[0:79][0:59];

integer i,j;

GetState getState(
    .enter(enter),
    .pause(pause),
    .state(state),
    .textId(textId),
    .level(level),
    .playerHp(playerHp),
    .enemyHp(enemyHp),
    
    .next_state(next_state),
    .next_textId(next_textId),
    .next_level(next_level)
);

GetPlayerPosition getPlayerPosition(
    .clk(clk),
    .state(state),
    .up(up),
    .down(down),
    .left(left),
    .right(right),
    .space(space),
    .playerPosition(playerPosition),
    
    .next_playerPosition(next_playerPosition)
);

GeneratePlayerBullet generatePlayerBullet(
    .clk(clk),
    .state(state),
    .level(level),
    .playerPosition(playerPosition),

    .next_playerBullet(next_playerBullet_generated)
);

GetEnemyPosition getEnemyPosition(
    .state(state),
    .playerPosition(playerPosition),
    .playerBullet(playerBullet),//躲避玩家子弹？
    .enemyPosition(enemyPosition),
    
    .next_enemyPosition(next_enemyPosition)
);

GeneratePlayerBullet generateEnemyBullet(
    .clk(clk),
    .state(state),
    .level(level),
    .playerPosition(playerPosition),
    .EnemyPosition(EnemyPosition),
    .enemyHp(enemyHp),

    .next_enemyBullet(next_enemyBullet_generated)
);

GetBulletPosition getBulletPosition(//这个模块计算下一时刻的弹幕碰撞信息（从而生命值的变化情况）以及弹幕位置信息
    .clk(clk),
    .state(state),
    .playerHp(playerHp),
    .enemyHp(enemyHp),
    .playerPosition(playerPosition),
    .enemyPosition(enemyPosition),
    .playerBullet(playerBullet),
    .enemyBullet(enemyBullet),
    
    .next_playerHp(next_playerHp),
    .next_enemyHp(next_enemyHp),
    .next_playerBullet(next_playerBullet_moved),
    .next_enemyBullet(next_enemyBullet_moved)
);

always @(posedge clk) begin
    for(i=0;i<80;i++) begin
        for(j=0;j<60;j++) begin
            if(next_playerBullet_generated[i][j]!=0)
                next_playerBullet[i][j]<=next_playerBullet_generated[i][j];
            else
                next_playerBullet[i][j]<=next_playerBullet_moved[i][j];
            if(next_enemyBullet_generated[i][j]!=0)
                next_enemyBullet[i][j]<=next_enemyBullet_generated[i][j];
            else
                next_enemyBullet[i][j]<=next_enemyBullet_moved[i][j];
        end
    end
end

endmodule
