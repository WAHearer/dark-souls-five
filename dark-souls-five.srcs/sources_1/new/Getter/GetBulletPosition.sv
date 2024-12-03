module GetBulletPosition (
    input clk,
    input [3:0] state,
    input [20:0] playerHp,
    input [20:0] enemyHp,
    input [6:0] playerPosition[0:1],
    input [6:0] enemyPosition[0:1],
    input [25:0] playerBullet[0:299],
    input [25:0] enemyBullet[0:299],

    output reg [20:0] next_playerHp,
    output reg [20:0] next_enemyHp,
    output reg [25:0] next_playerBullet[0:299],
    output reg [25:0] next_enemyBullet[0:299]
);
localparam base1=25'd10000000;
localparam base2=25'd14142136;//10^7sqrt(2)
reg [24:0] counter1;
reg [24:0] counter2;
integer i;
initial begin
    counter1<=0;
    counter2<=0;
    next_playerHp<=21'd100;
    next_enemyHp<=21'd1000;
    for(i=0;i<300;i++) begin
        next_playerBullet[i]<=0;
        next_enemyBullet[i]<=0;
    end
end
always @(posedge clk) begin
    if(state==2) begin
        if(counter1<base1)
            counter1<=counter1+1;
        else
            counter1<=0;
        if(counter2<base2)
            counter2<=counter2+1;
        else
            counter2<=0;
    end
    else if(state!=1) begin
        next_playerHp<=playerHp;
        next_enemyHp<=enemyHp;
    end
end
always @(posedge clk) begin
    for(i=0;i<300;i++) begin
        if(playerBullet[i][6:0]==enemyPosition[0]&&playerBullet[i][13:7]==enemyPosition[1]) begin
            if(enemyHp<=playerBullet[i][20:14])
                next_enemyHp<=0;
            else
                next_enemyHp<=enemyHp-playerBullet[i][20:14];
            next_playerBullet[i]<=0;
        end
        else begin
            case(playerBullet[i][23:21])
                4'd0: begin
                    if(counter1==(base1>>playerBullet[i][25:24])) begin
                        if(playerBullet[i][13:7]>0)
                            next_playerBullet[i]<=playerBullet[i]-(1<<7);
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_playerBullet[i]<=playerBullet[i];
                end
                4'd1: begin
                    if(counter1==(base1>>playerBullet[i][25:24])) begin
                        if(playerBullet[i][6:0]>0)
                            next_playerBullet[i]<=playerBullet[i]-1;
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_playerBullet[i]<=playerBullet[i];
                end
                4'd2: begin
                    if(counter1==(base1>>playerBullet[i][25:24])) begin
                        if(playerBullet[i][6:0]<7'd79)
                            next_playerBullet[i]<=playerBullet[i]+1;
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_playerBullet[i]<=playerBullet[i];
                end
                4'd3: begin
                    if(counter1==(base1>>playerBullet[i][25:24])) begin
                        if(playerBullet[i][13:7]<7'd59)
                            next_playerBullet[i]<=playerBullet[i]+(1<<7);
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_playerBullet[i]<=playerBullet[i];
                end
                4'd4: begin
                    if(counter2==(base2>>playerBullet[i][25:24])) begin
                        if(playerBullet[i][6:0]>0&&playerBullet[i][13:7]>0)
                            next_playerBullet[i]<=playerBullet[i]-(1<<7)-1;
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_playerBullet[i]<=playerBullet[i];
                end
                4'd5: begin
                    if(counter2==(base2>>playerBullet[i][25:24])) begin
                        if(playerBullet[i][6:0]<7'd79&&playerBullet[i][13:7]>0)
                            next_playerBullet[i]<=playerBullet[i]-(1<<7)+1;
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_playerBullet[i]<=playerBullet[i];
                end
                4'd6: begin
                    if(counter2==(base2>>playerBullet[i][25:24])) begin
                        if(playerBullet[i][6:0]>0&&playerBullet[i][13:7]<7'd59)
                            next_playerBullet[i]<=playerBullet[i]+(1<<7)-1;
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_playerBullet[i]<=playerBullet[i];
                end
                4'd7: begin
                    if(counter2==(base2>>playerBullet[i][25:24])) begin
                        if(playerBullet[i][6:0]<7'd79&&playerBullet[i][13:7]<7'd59)
                            next_playerBullet[i]<=playerBullet[i]+(1<<7)+1;
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_playerBullet[i]<=playerBullet[i];
                end
            endcase
        end
        if(enemyBullet[i][6:0]==playerPosition[0]&&enemyBullet[i][13:7]==playerPosition[1]) begin
            if(playerHp<=enemyBullet[i][20:14])
                next_playerHp<=0;
            else
                next_playerHp<=playerHp-enemyBullet[i][20:14];
            next_enemyBullet[i]<=0;
        end
        else begin
            case(enemyBullet[i][23:21])
                4'd0: begin
                    if(counter1==(base1>>enemyBullet[i][25:24])) begin
                        if(enemyBullet[i][13:7]>0)
                            next_enemyBullet[i]<=enemyBullet[i]-(1<<7);
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_enemyBullet[i]<=enemyBullet[i];
                end
                4'd1: begin
                    if(counter1==(base1>>enemyBullet[i][25:24])) begin
                        if(enemyBullet[i][6:0]>0)
                            next_enemyBullet[i]<=enemyBullet[i]-1;
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_enemyBullet[i]<=enemyBullet[i];
                end
                4'd2: begin
                    if(counter1==(base1>>enemyBullet[i][25:24])) begin
                        if(enemyBullet[i][6:0]<7'd79)
                            next_enemyBullet[i]<=enemyBullet[i]+1;
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_enemyBullet[i]<=enemyBullet[i];
                end
                4'd3: begin
                    if(counter1==(base1>>enemyBullet[i][25:24])) begin
                        if(enemyBullet[i][13:7]<7'd59)
                            next_enemyBullet[i]<=enemyBullet[i]+(1<<7);
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_enemyBullet[i]<=enemyBullet[i];
                end
                4'd4: begin
                    if(counter2==(base2>>enemyBullet[i][25:24])) begin
                        if(enemyBullet[i][6:0]>0&&enemyBullet[i][13:7]>0)
                            next_enemyBullet[i]<=enemyBullet[i]-(1<<7)-1;
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_enemyBullet[i]<=enemyBullet[i];
                end
                4'd5: begin
                    if(counter2==(base2>>enemyBullet[i][25:24])) begin
                        if(enemyBullet[i][6:0]<7'd79&&enemyBullet[i][13:7]>0)
                            next_enemyBullet[i]<=enemyBullet[i]-(1<<7)+1;
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_enemyBullet[i]<=enemyBullet[i];
                end
                4'd6: begin
                    if(counter2==(base2>>enemyBullet[i][25:24])) begin
                        if(enemyBullet[i][6:0]>0&&enemyBullet[i][13:7]<7'd59)
                            next_enemyBullet[i]<=enemyBullet[i]+(1<<7)-1;
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_enemyBullet[i]<=enemyBullet[i];
                end
                4'd7: begin
                    if(counter2==(base2>>enemyBullet[i][25:24])) begin
                        if(enemyBullet[i][6:0]<7'd79&&enemyBullet[i][13:7]<7'd59)
                            next_enemyBullet[i]<=enemyBullet[i]+(1<<7)+1;
                        else
                            next_enemyBullet[i]<=0;
                    end
                    else
                        next_enemyBullet[i]<=enemyBullet[i];
                end
            endcase
        end
    end
end
endmodule