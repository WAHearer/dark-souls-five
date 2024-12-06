module Game (
    input clk,enter,pause,up,down,left,right,space,
    input [3:0] state,
    input [9:0] textId,
    input [5:0] level,
    input [20:0] playerHp,
    input [20:0] enemyHp,
    input [7:0] playerPosition[0:1],
    input [7:0] enemyPosition[0:1],
    input [27:0] playerBullet[0:69],
    input [27:0] enemyBullet[0:69],
    
    output [3:0] next_state,
    output [9:0] next_textId,
    output [5:0] next_level,
    output reg [20:0] next_playerHp,
    output reg [20:0] next_enemyHp,
    output reg [7:0] next_playerPosition[0:1],
    output reg [7:0] next_enemyPosition[0:1],
    output reg [27:0] next_playerBullet[0:69],
    output reg [27:0] next_enemyBullet[0:69]
);

wire [20:0] next_playerHp_inGame;
wire [20:0] next_enemyHp_inGame;
wire [7:0] next_playerPosition_inGame[0:1];
wire [7:0] next_enemyPosition_inGame[0:1];
wire [27:0] next_playerBullet_moved[0:69];
wire [27:0] next_playerBullet_generated[0:69];
wire [27:0] next_enemyBullet_moved[0:69];
wire [27:0] next_enemyBullet_generated[0:69];

integer i;

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

GetEnemyPosition getEnemyPosition(
    .clk(clk),
    .state(state),
    .level(level),
    .enemyPosition(enemyPosition),
    
    .next_enemyPosition(next_enemyPosition_inGame)
);

GenerateEnemyBullet generateEnemyBullet(
    .clk(clk),
    .state(state),
    .level(level),
    .playerPosition(playerPosition),
    .enemyPosition(enemyPosition),
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
    
    .next_playerHp(next_playerHp_inGame),
    .next_enemyHp(next_enemyHp_inGame),
    .next_playerBullet(next_playerBullet_moved),
    .next_enemyBullet(next_enemyBullet_moved)
);

always @(*) begin
    if(state==1||state==2) begin
        next_playerHp=next_playerHp_inGame;
        next_enemyHp=next_enemyHp_inGame;
        next_playerPosition[0]=next_playerPosition_inGame[0];
        next_playerPosition[1]=next_playerPosition_inGame[1];
        next_enemyPosition[0]=next_enemyPosition_inGame[0];
        next_enemyPosition[1]=next_enemyPosition_inGame[1];
        for(i=0;i<70;i++) begin
            if(next_playerBullet_generated[i]!=0)
                next_playerBullet[i]=next_playerBullet_generated[i];
            else
                next_playerBullet[i]=next_playerBullet_moved[i];
            if(next_enemyBullet_generated[i]!=0)
                next_enemyBullet[i]=next_enemyBullet_generated[i];
            else
                next_enemyBullet[i]=next_enemyBullet_moved[i];
        end
    end
    else begin
        next_playerHp=21'd100;
        case(level)
            1:next_enemyHp=21'd500;
            2:next_enemyHp=21'd750;
            3:next_enemyHp=21'd1000;
            4:next_enemyHp=21'd1500;
            5:next_enemyHp=21'd5000;
            default:next_enemyHp=21'd10000;
        endcase
        next_playerPosition[0]=8'd100;
        next_playerPosition[1]=8'd30;
        next_enemyPosition[0]=8'd150;
        next_enemyPosition[1]=8'd120;
        for(i=0;i<70;i++) begin
            next_playerBullet[i]=0;
            next_enemyBullet[i]=0;
        end
    end
end
endmodule