module GetBulletPosition (
    input clk,
    input [3:0] state,
    input [20:0] playerHp,
    input [20:0] enemyHp,
    input [7:0] playerPosition[0:1],
    input [7:0] enemyPosition[0:1],
    input [27:0] playerBullet[0:39],
    input [27:0] enemyBullet[0:159],
    input [16:0] wall[0:4],

    output reg [20:0] next_playerHp,
    output reg [20:0] next_enemyHp,
    output reg [27:0] next_playerBullet[0:39],
    output reg [27:0] next_enemyBullet[0:159],
    output reg [16:0] next_wall[0:4]
);
reg [27:0]next_playerBullet_moved[0:39];
reg [21:0] base[0:3];
integer i,counter[0:3];
initial begin
    next_playerHp<=21'd100;
    next_enemyHp<=21'd600;
    base[0]<=22'd2000000;
    base[1]<=22'd1000000;
    base[2]<=22'd500000;
    base[3]<=22'd250000;
    counter[0]<=0;
    counter[1]<=0;
    counter[2]<=0;
    counter[3]<=0;
    for(i=0;i<40;i++)
        next_playerBullet[i]<=0;
    for(i=0;i<160;i++)
        next_enemyBullet[i]<=0;
    for(i=0;i<5;i++)
        next_wall[i]<=0;
end
always @(posedge clk) begin
    if(state==2) begin
        if(counter[0]!=base[0])
            counter[0]++;
        else
            counter[0]<=0;
        if(counter[1]!=base[1])
            counter[1]++;
        else
            counter[1]<=0;
        if(counter[2]!=base[2])
            counter[2]++;
        else
            counter[2]<=0;
        if(counter[3]!=base[3])
            counter[3]++;
        else
            counter[3]<=0;
        for(i=0;i<40;i++) begin
             if((playerBullet[i][7:0]<=enemyPosition[0]+10&&playerBullet[i][7:0]+10>=enemyPosition[0])&&(playerBullet[i][15:8]<=enemyPosition[1]+10&&playerBullet[i][15:8]+10>=enemyPosition[1])) begin
                if(enemyHp<=playerBullet[i][22:16])
                    next_enemyHp<=0;
                else
                    next_enemyHp<=enemyHp-playerBullet[i][22:16];
            end
        end
        for(i=0;i<160;i++) begin
            if(enemyBullet[i][7:0]==playerPosition[0]&&enemyBullet[i][15:8]==playerPosition[1]) begin
                if(playerHp<=enemyBullet[i][22:16])
                    next_playerHp<=0;
                else
                    next_playerHp<=playerHp-enemyBullet[i][22:16];
            end
        end
        for(i=0;i<5;i++) begin
            if(wall[i][7:0]==playerPosition[1]) begin
                if(playerHp<=wall[i][14:8])
                    next_playerHp<=0;
                else
                    next_playerHp<=playerHp-wall[i][14:8];
            end
        end
    end
    else begin
        counter[0]<=0;
        counter[1]<=0;
        counter[2]<=0;
        counter[3]<=0;
        next_playerHp<=playerHp;
        next_enemyHp<=enemyHp;
    end
end
always @(*) begin
    if(state==1||state==2) begin
        for(i=0;i<40;i++) begin
            if((playerBullet[i][7:0]<=enemyPosition[0]+10&&playerBullet[i][7:0]+10>=enemyPosition[0])&&(playerBullet[i][15:8]<=enemyPosition[1]+10&&playerBullet[i][15:8]+10>=enemyPosition[1]))
                next_playerBullet[i]=0;
            else begin
                if(counter[playerBullet[i][27:26]]==base[playerBullet[i][27:26]]) begin
                    case(playerBullet[i][25:23])
                        4'd0:next_playerBullet[i]=playerBullet[i]-(1<<8);
                        4'd1:next_playerBullet[i]=playerBullet[i]-1;
                        4'd2:next_playerBullet[i]=playerBullet[i]+1;
                        4'd3:next_playerBullet[i]=playerBullet[i]+(1<<8);
                        4'd4:next_playerBullet[i]=playerBullet[i]-(1<<8)-1;
                        4'd5:next_playerBullet[i]=playerBullet[i]-(1<<8)+1;
                        4'd6:next_playerBullet[i]=playerBullet[i]+(1<<8)-1;
                        4'd7:next_playerBullet[i]=playerBullet[i]+(1<<8)+1;
                    endcase
                end
                else
                    next_playerBullet[i]=playerBullet[i];
            end
        end
        for(i=0;i<160;i++) begin
            if(enemyBullet[i][7:0]==playerPosition[0]&&enemyBullet[i][15:8]==playerPosition[1])
                next_enemyBullet[i]=0;
            else begin
                if(counter[enemyBullet[i][27:26]]==base[enemyBullet[i][27:26]]) begin
                    case(enemyBullet[i][25:23])
                        4'd0:next_enemyBullet[i]=enemyBullet[i]-(1<<8);
                        4'd1:next_enemyBullet[i]=enemyBullet[i]-1;
                        4'd2:next_enemyBullet[i]=enemyBullet[i]+1;
                        4'd3:next_enemyBullet[i]=enemyBullet[i]+(1<<8);
                        4'd4:next_enemyBullet[i]=enemyBullet[i]-(1<<8)-1;
                        4'd5:next_enemyBullet[i]=enemyBullet[i]-(1<<8)+1;
                        4'd6:next_enemyBullet[i]=enemyBullet[i]+(1<<8)-1;
                        4'd7:next_enemyBullet[i]=enemyBullet[i]+(1<<8)+1;
                    endcase
                end
                else
                    next_enemyBullet[i]=enemyBullet[i];
            end
        end
        for(i=0;i<5;i++) begin
            if(wall[i][7:0]==playerPosition[1])
                next_wall[i]=0;
            else begin
                if(counter[wall[i][16:15]]==base[wall[i][16:15]]) begin
                    next_wall[i]=wall[i]-1;
                end
                else
                    next_wall[i]=wall[i];
            end
        end
    end
    else begin
        for(i=0;i<40;i++)
            next_playerBullet[i]=0;
        for(i=0;i<160;i++)
            next_enemyBullet[i]=0;
        for(i=0;i<5;i++)
            next_wall[i]=0;
    end
end
endmodule