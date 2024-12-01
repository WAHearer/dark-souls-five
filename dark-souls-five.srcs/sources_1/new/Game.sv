module Game (
    input clk,enter,pause,up,down,left,right,space,
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
    output reg [20:0] next_playerHp,
    output reg [20:0] next_enemyHp,
    output reg [6:0] next_playerPosition[0:1],
    output reg [6:0] next_enemyPosition[0:1],
    output reg [16:0] next_playerBullet[0:79][0:59],
    output reg [16:0] next_enemyBullet[0:79][0:59]
);

reg [20:0] next_playerHp_inGame;
reg [20:0] next_enemyHp_inGame;
reg [6:0] next_playerPosition_inGame[0:1];
reg [6:0] next_enemyPosition_inGame[0:1];
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
    
    .next_playerPosition(next_playerPosition_inGame)
);

GeneratePlayerBullet generatePlayerBullet(
    .clk(clk),
    .state(state),
    .level(level),
    .playerPosition(playerPosition),

    .next_playerBullet(next_playerBullet_generated)
);

/*GetEnemyPosition getEnemyPosition(
    .state(state),
    .playerPosition(playerPosition),
    .playerBullet(playerBullet),//躲避玩家子弹？
    .enemyPosition(enemyPosition),
    
    .next_enemyPosition(next_enemyPosition_inGame)
);

GenerateEnemyBullet generateEnemyBullet(
    .clk(clk),
    .state(state),
    .level(level),
    .playerPosition(playerPosition),
    .EnemyPosition(EnemyPosition),
    .enemyHp(enemyHp),

    .next_enemyBullet(next_enemyBullet_generated)
);*/

GetBulletPosition getBulletPosition(//这个模块计算下一时刻的弹幕碰撞信息（从而生命值的变化情况）以及弹幕位置信息
    .clk(clk),
    .state(state),
    .playerHp(playerHp),
    .enemyHp(enemyHp),
    .playerPosition(playerPosition),
    .enemyPosition(enemyPosition),
    .playerBullet(playerBullet),
    .enemyBullet(enemyBullet),
    
    .next_playerHp(next_playerHp_inGame),
    .next_enemyHp(next_enemyHp_inGame),
    .next_playerBullet(next_playerBullet_moved),
    .next_enemyBullet(next_enemyBullet_moved)
);

always @(posedge clk) begin
    if(state==2||state==1) begin
        next_playerHp<=next_playerHp_inGame;
        next_enemyHp<=next_enemyHp_inGame;
        next_playerPosition<=next_playerPosition_inGame;
        next_enemyPosition<=next_enemyPosition_inGame;
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
    else begin
        next_playerHp<=21'd100;
        next_playerPosition[0]<=7'd40;
        next_playerPosition[1]<=7'd15;
        next_enemyPosition[0]<=7'd40;
        next_enemyPosition[1]<=7'd50;
        case(level)
            1:begin
                next_enemyHp<=21'd500;
            end
        endcase
    end
end

endmodule