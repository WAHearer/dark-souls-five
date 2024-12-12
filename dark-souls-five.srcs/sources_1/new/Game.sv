module Game (
    input clk,enter,pause,up,down,left,right,space,
    input [3:0] state,
    input [9:0] textId,
    input [5:0] level,
    input [20:0] playerHp,
    input [20:0] enemyHp,
    input [7:0] playerPosition[0:1],
    input [7:0] enemyPosition[0:1],
    input [27:0] playerBullet[0:39],
    input [27:0] enemyBullet[0:159],
    input [16:0] wall[0:4],
    
    output [3:0] next_state,
    output [9:0] next_textId,
    output [5:0] next_level,
    output reg [20:0] next_playerHp,
    output reg [20:0] next_enemyHp,
    output reg [7:0] next_playerPosition[0:1],
    output reg [7:0] next_enemyPosition[0:1],
    output reg [27:0] next_playerBullet[0:39],
    output reg [27:0] next_enemyBullet[0:159],
    output reg [16:0] next_wall[0:4]
);

wire [20:0] next_playerHp_inGame;
wire [20:0] next_enemyHp_inGame;
wire [7:0] next_playerPosition_inGame[0:1];
wire [7:0] next_enemyPosition_inGame[0:1];
wire [27:0] next_playerBullet_moved[0:39];
wire [27:0] next_playerBullet_generated[0:39];
wire [27:0] next_enemyBullet_moved[0:159];
wire [27:0] next_enemyBullet_generated[0:159];
wire [16:0] next_wall_moved[0:4];
wire [16:0] next_wall_generated[0:4];
integer i,j,k;

GetState getState(
    .clk(clk),
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
    .enemyHp(enemyHp),
    
    .next_enemyPosition(next_enemyPosition_inGame)
);

GenerateEnemyBullet generateEnemyBullet(
    .clk(clk),
    .state(state),
    .level(level),
    .playerPosition(playerPosition),
    .enemyPosition(enemyPosition),
    .enemyHp(enemyHp),

    .next_enemyBullet(next_enemyBullet_generated),
    .next_wall(next_wall_generated)
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
    .wall(wall),
    
    .next_playerHp(next_playerHp_inGame),
    .next_enemyHp(next_enemyHp_inGame),
    .next_playerBullet(next_playerBullet_moved),
    .next_enemyBullet(next_enemyBullet_moved),
    .next_wall(next_wall_moved)
);

always @(*) begin
    if(state==1||state==2) begin
        next_playerHp=next_playerHp_inGame;
        next_enemyHp=next_enemyHp_inGame;
        next_playerPosition[0]=next_playerPosition_inGame[0];
        next_playerPosition[1]=next_playerPosition_inGame[1];
        next_enemyPosition[0]=next_enemyPosition_inGame[0];
        next_enemyPosition[1]=next_enemyPosition_inGame[1];
        for(i=0;i<40;i++) begin
            if(next_playerBullet_generated[i]!=0)
                next_playerBullet[i]=next_playerBullet_generated[i];
            else if(next_playerBullet_moved[i][7:0]<8'd200&&next_playerBullet_moved[i][15:8]<8'd150)
                next_playerBullet[i]=next_playerBullet_moved[i];
            else
                next_playerBullet[i]=0;
        end
        for(j=0;j<160;j++) begin
            if(next_enemyBullet_generated[j]!=0)
                next_enemyBullet[j]=next_enemyBullet_generated[j];
            else if(next_enemyBullet_moved[j][7:0]<8'd200&&next_enemyBullet_moved[j][15:8]<8'd150)
                next_enemyBullet[j]=next_enemyBullet_moved[j];
            else
                next_enemyBullet[j]=0;
        end
        for(k=0;k<5;k++) begin
            if(next_wall_generated[k]!=0)
                next_wall[k]=next_wall_generated[k];
            else if(next_wall_moved[k][7:0]<8'd150)
                next_wall[k]=next_wall_moved[k];
            else
                next_wall[k]=0;
        end
    end
    else begin
        next_playerHp=21'd100;
        case(level)
            1:next_enemyHp=21'd500;
            2:next_enemyHp=21'd1000;
            3:next_enemyHp=21'd1000;
            4:next_enemyHp=21'd2000;
            5:next_enemyHp=21'd4000;
            default:next_enemyHp=21'd4000;
        endcase
        next_playerPosition[0]=8'd100;
        next_playerPosition[1]=8'd30;
        next_enemyPosition[0]=8'd150;
        next_enemyPosition[1]=8'd120;
        for(i=0;i<40;i++)
            next_playerBullet[i]=0;
        for(j=0;j<160;j++)
            next_enemyBullet[j]=0;
        for(k=0;k<5;k++)
            next_wall[k]=0;
    end
end
endmodule