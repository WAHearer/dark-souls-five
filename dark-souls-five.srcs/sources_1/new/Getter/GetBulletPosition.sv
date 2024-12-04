module GetBulletPosition (
    input clk,
    input [3:0] state,
    input [20:0] playerHp,
    input [20:0] enemyHp,
    input [7:0] playerPosition[0:1],
    input [7:0] enemyPosition[0:1],
    input [27:0] playerBullet[0:69],
    input [27:0] enemyBullet[0:69],

    output reg [20:0] next_playerHp,
    output reg [20:0] next_enemyHp,
    output reg [27:0] next_playerBullet[0:69],
    output reg [27:0] next_enemyBullet[0:69]
);
localparam base1=32'd4000000;
localparam base2=32'd5656854;//4*10^6sqrt(2)
integer i,counter1,counter2;
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
    else begin
        counter1<=0;
        counter2<=0;
    end
end
always @(*) begin
    if(state==2) begin
        for(i=0;i<70;i++) begin
            if((playerBullet[i][7:0]<=enemyPosition[0]+1&&playerBullet[i][7:0]+1>=enemyPosition[0])&&(playerBullet[i][15:8]<=enemyPosition[1]+1&&playerBullet[i][15:8]+1>=enemyPosition[1])) begin
                if(enemyHp<=playerBullet[i][22:16])
                    next_enemyHp=0;
                else
                    next_enemyHp=enemyHp-playerBullet[i][22:16];
                next_playerBullet[i]=0;
            end
            else begin
                case(playerBullet[i][25:23])
                    4'd0: begin
                        if(counter1==(base1>>playerBullet[i][27:26])) begin
                            if(playerBullet[i][15:8]>0)
                                next_playerBullet[i]=playerBullet[i]-(1<<8);
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                    4'd1: begin
                        if(counter1==(base1>>playerBullet[i][27:26])) begin
                            if(playerBullet[i][7:0]>0)
                                next_playerBullet[i]=playerBullet[i]-1;
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                    4'd2: begin
                        if(counter1==(base1>>playerBullet[i][27:26])) begin
                            if(playerBullet[i][7:0]<8'd199)
                                next_playerBullet[i]=playerBullet[i]+1;
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                    4'd3: begin
                        if(counter1==(base1>>playerBullet[i][27:26])) begin
                            if(playerBullet[i][15:8]<8'd149)
                                next_playerBullet[i]=playerBullet[i]+(1<<8);
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                    4'd4: begin
                        if(counter2==(base2>>playerBullet[i][27:26])) begin
                            if(playerBullet[i][7:0]>0&&playerBullet[i][15:8]>0)
                                next_playerBullet[i]=playerBullet[i]-(1<<8)-1;
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                    4'd5: begin
                        if(counter2==(base2>>playerBullet[i][27:26])) begin
                            if(playerBullet[i][7:0]<8'd199&&playerBullet[i][15:8]>0)
                                next_playerBullet[i]=playerBullet[i]-(1<<8)+1;
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                    4'd6: begin
                        if(counter2==(base2>>playerBullet[i][27:26])) begin
                            if(playerBullet[i][7:0]>0&&playerBullet[i][15:8]<8'd149)
                                next_playerBullet[i]=playerBullet[i]+(1<<8)-1;
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                    4'd7: begin
                        if(counter2==(base2>>playerBullet[i][27:26])) begin
                            if(playerBullet[i][7:0]<8'd199&&playerBullet[i][15:8]<8'd149)
                                next_playerBullet[i]=playerBullet[i]+(1<<8)+1;
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_playerBullet[i]=playerBullet[i];
                    end
                endcase
            end
            if((enemyBullet[i][7:0]<=playerPosition[0]+1&&enemyBullet[i][7:0]+1>=playerPosition[0])&&(enemyBullet[i][15:8]<=playerPosition[1]+1&&enemyBullet[i][15:8]+1>=playerPosition[1])) begin
                if(playerHp<=enemyBullet[i][22:16])
                    next_playerHp=0;
                else
                    next_playerHp=playerHp-enemyBullet[i][22:16];
                next_enemyBullet[i]=0;
            end
            else begin
                case(enemyBullet[i][25:23])
                    4'd0: begin
                        if(counter1==(base1>>enemyBullet[i][27:26])) begin
                            if(enemyBullet[i][15:8]>0)
                                next_enemyBullet[i]=enemyBullet[i]-(1<<8);
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_enemyBullet[i]=enemyBullet[i];
                    end
                    4'd1: begin
                        if(counter1==(base1>>enemyBullet[i][27:26])) begin
                            if(enemyBullet[i][7:0]>0)
                                next_enemyBullet[i]=enemyBullet[i]-1;
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_enemyBullet[i]=enemyBullet[i];
                    end
                    4'd2: begin
                        if(counter1==(base1>>enemyBullet[i][27:26])) begin
                            if(enemyBullet[i][7:0]<8'd199)
                                next_enemyBullet[i]=enemyBullet[i]+1;
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_enemyBullet[i]=enemyBullet[i];
                    end
                    4'd3: begin
                        if(counter1==(base1>>enemyBullet[i][27:26])) begin
                            if(enemyBullet[i][15:8]<8'd149)
                                next_enemyBullet[i]=enemyBullet[i]+(1<<8);
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_enemyBullet[i]=enemyBullet[i];
                    end
                    4'd4: begin
                        if(counter2==(base2>>enemyBullet[i][27:26])) begin
                            if(enemyBullet[i][7:0]>0&&enemyBullet[i][15:8]>0)
                                next_enemyBullet[i]=enemyBullet[i]-(1<<8)-1;
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_enemyBullet[i]=enemyBullet[i];
                    end
                    4'd5: begin
                        if(counter2==(base2>>enemyBullet[i][27:26])) begin
                            if(enemyBullet[i][7:0]<8'd199&&enemyBullet[i][15:8]>0)
                                next_enemyBullet[i]=enemyBullet[i]-(1<<8)+1;
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_enemyBullet[i]=enemyBullet[i];
                    end
                    4'd6: begin
                        if(counter2==(base2>>enemyBullet[i][27:26])) begin
                            if(enemyBullet[i][7:0]>0&&enemyBullet[i][15:8]<8'd149)
                                next_enemyBullet[i]=enemyBullet[i]+(1<<8)-1;
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_enemyBullet[i]=enemyBullet[i];
                    end
                    4'd7: begin
                        if(counter2==(base2>>enemyBullet[i][27:26])) begin
                            if(enemyBullet[i][7:0]<8'd199&&enemyBullet[i][15:8]<8'd149)
                                next_enemyBullet[i]=enemyBullet[i]+(1<<8)+1;
                            else
                                next_enemyBullet[i]=0;
                        end
                        else
                            next_enemyBullet[i]=enemyBullet[i];
                    end
                endcase
            end
        end
    end
    else if(state!=1) begin
        next_playerHp=playerHp;
        next_enemyHp=enemyHp;
        for(i=0;i<70;i++) begin
            next_playerBullet[i]=playerBullet[i];
            next_enemyBullet[i]=enemyBullet[i];
        end
    end
end
endmodule