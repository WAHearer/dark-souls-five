module GetBulletPosition (
    input clk,
    input [3:0] state,
    input [20:0] playerHp,
    input [20:0] enemyHp,
    input [7:0] playerPosition[0:1],
    input [7:0] enemyPosition[0:1],
    input [27:0] playerBullet[0:39],
    input [27:0] enemyBullet[0:99],

    output reg [20:0] next_playerHp,
    output reg [20:0] next_enemyHp,
    output reg [27:0] next_playerBullet[0:39],
    output reg [27:0] next_enemyBullet[0:99]
);
reg [21:0] base1[0:3],base2[0:3];
integer i,j,counter1[0:3],counter2[0:3];
initial begin
    base1[0]<=22'd2000000;
    base1[1]<=22'd1000000;
    base1[2]<=22'd500000;
    base1[3]<=22'd250000;
    base2[0]<=22'd2828427;//2*10^6sqrt(2)
    base2[1]<=22'd1414213;
    base2[2]<=22'd707106;
    base2[3]<=22'd353553;
    counter1[0]<=0;
    counter1[1]<=0;
    counter1[2]<=0;
    counter1[3]<=0;
    counter2[0]<=0;
    counter2[1]<=0;
    counter2[2]<=0;
    counter2[3]<=0;
    for(i=0;i<40;i++)
        next_playerBullet[i]<=0;
    for(j=0;j<100;j++)
        next_enemyBullet[j]<=0;
end
always @(posedge clk) begin
    if(state==2) begin
        if(counter1[0]!=base1[0])
            counter1[0]++;
        else
            counter1[0]<=0;
        if(counter1[1]!=base1[1])
            counter1[1]++;
        else
            counter1[1]<=0;
        if(counter1[2]!=base1[2])
            counter1[2]++;
        else
            counter1[2]<=0;
        if(counter1[3]!=base1[3])
            counter1[3]++;
        else
            counter1[3]<=0;
        if(counter2[0]!=base2[0])
            counter2[0]++;
        else
            counter2[0]<=0;
        if(counter2[1]!=base2[1])
            counter2[1]++;
        else
            counter2[1]<=0;
        if(counter2[2]!=base2[2])
            counter2[2]++;
        else
            counter2[2]<=0;
        if(counter2[3]!=base2[3])
            counter2[3]++;
        else
            counter2[3]<=0;
    end
    else begin
        counter1[0]<=0;
        counter1[1]<=0;
        counter1[2]<=0;
        counter1[3]<=0;
        counter2[0]<=0;
        counter2[1]<=0;
        counter2[2]<=0;
        counter2[3]<=0;
    end
end
always @(*) begin
    if(state==2) begin
        for(i=0;i<40;i++) begin
            if((playerBullet[i][7:0]<=enemyPosition[0]+10&&playerBullet[i][7:0]+10>=enemyPosition[0])&&(playerBullet[i][15:8]<=enemyPosition[1]+10&&playerBullet[i][15:8]+10>=enemyPosition[1])) begin
                if(enemyHp<=playerBullet[i][22:16])
                    next_enemyHp=0;
                else
                    next_enemyHp=enemyHp-playerBullet[i][22:16];
                next_playerBullet[i]=0;
            end
            else begin
                case(playerBullet[i][25:23])
                    4'd0: begin
                        if(counter1[playerBullet[i][27:26]]==base1[playerBullet[i][27:26]]) begin
                            next_playerBullet[i]=playerBullet[i]-(1<<8);
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                    4'd1: begin
                        if(counter1[playerBullet[i][27:26]]==base1[playerBullet[i][27:26]]) begin
                            next_playerBullet[i]=playerBullet[i]-1;
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                    4'd2: begin
                        if(counter1[playerBullet[i][27:26]]==base1[playerBullet[i][27:26]]) begin
                            next_playerBullet[i]=playerBullet[i]+1;
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                    4'd3: begin
                        if(counter1[playerBullet[i][27:26]]==base1[playerBullet[i][27:26]]) begin
                            next_playerBullet[i]=playerBullet[i]+(1<<8);
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                    4'd4: begin
                        if(counter2[playerBullet[i][27:26]]==base2[playerBullet[i][27:26]]) begin
                            next_playerBullet[i]=playerBullet[i]-(1<<8)-1;
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                    4'd5: begin
                        if(counter2[playerBullet[i][27:26]]==base2[playerBullet[i][27:26]]) begin
                            next_playerBullet[i]=playerBullet[i]-(1<<8)+1;
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                    4'd6: begin
                        if(counter2[playerBullet[i][27:26]]==base2[playerBullet[i][27:26]]) begin
                            next_playerBullet[i]=playerBullet[i]+(1<<8)-1;
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                    4'd7: begin
                        if(counter2[playerBullet[i][27:26]]==base2[playerBullet[i][27:26]]) begin
                            next_playerBullet[i]=playerBullet[i]+(1<<8)+1;
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                endcase
            end
        end
        for(j=0;j<100;j++) begin
            if(enemyBullet[j][7:0]==playerPosition[0]&&enemyBullet[j][15:8]==playerPosition[1]) begin
                if(playerHp<=enemyBullet[j][22:16])
                    next_playerHp=0;
                else
                    next_playerHp=playerHp-enemyBullet[j][22:16];
                next_enemyBullet[j]=0;
            end
            else begin
                case(enemyBullet[j][25:23])
                    4'd0: begin
                        if(counter1[enemyBullet[j][27:26]]==base1[enemyBullet[j][27:26]]) begin
                            next_enemyBullet[j]=enemyBullet[j]-(1<<8);
                        end
                        else
                            next_enemyBullet[j]=enemyBullet[j];
                    end
                    4'd1: begin
                        if(counter1[enemyBullet[j][27:26]]==base1[enemyBullet[j][27:26]]) begin
                            next_enemyBullet[j]=enemyBullet[j]-1;
                        end
                        else
                            next_enemyBullet[j]=enemyBullet[j];
                    end
                    4'd2: begin
                        if(counter1[enemyBullet[j][27:26]]==base1[enemyBullet[j][27:26]]) begin
                            next_enemyBullet[j]=enemyBullet[j]+1;
                        end
                        else
                            next_enemyBullet[j]=enemyBullet[j];
                    end
                    4'd3: begin
                        if(counter1[enemyBullet[j][27:26]]==base1[enemyBullet[j][27:26]]) begin
                            next_enemyBullet[j]=enemyBullet[j]+(1<<8);
                        end
                        else
                            next_enemyBullet[j]=enemyBullet[j];
                    end
                    4'd4: begin
                        if(counter2[enemyBullet[j][27:26]]==base2[enemyBullet[j][27:26]]) begin
                            next_enemyBullet[j]=enemyBullet[j]-(1<<8)-1;
                        end
                        else
                            next_enemyBullet[j]=enemyBullet[j];
                    end
                    4'd5: begin
                        if(counter2[enemyBullet[j][27:26]]==base2[enemyBullet[j][27:26]]) begin
                            next_enemyBullet[j]=enemyBullet[j]-(1<<8)+1;
                        end
                        else
                            next_enemyBullet[j]=enemyBullet[j];
                    end
                    4'd6: begin
                        if(counter2[enemyBullet[j][27:26]]==base2[enemyBullet[j][27:26]]) begin
                            next_enemyBullet[j]=enemyBullet[j]+(1<<8)-1;
                        end
                        else
                            next_enemyBullet[j]=enemyBullet[j];
                    end
                    4'd7: begin
                        if(counter2[enemyBullet[j][27:26]]==base2[enemyBullet[j][27:26]]) begin
                            next_enemyBullet[j]=enemyBullet[j]+(1<<8)+1;
                        end
                        else
                            next_enemyBullet[j]=enemyBullet[j];
                    end
                endcase
            end
        end
    end
    else if(state!=1) begin
        next_playerHp=playerHp;
        next_enemyHp=enemyHp;
        for(i=0;i<40;i++)
            next_playerBullet[i]=0;
        for(j=0;j<100;j++)
            next_enemyBullet[j]=0;
    end
end
endmodule
