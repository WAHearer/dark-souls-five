module GetBulletPosition (
    input clk,
    input [3:0] state,
    input [20:0] playerHp,
    input [20:0] enemyHp,
    input [7:0] playerPosition[0:1],
    input [7:0] enemyPosition[0:1],
    input [27:0] playerBullet[0:599],
    input [27:0] enemyBullet[0:599],

    output reg [20:0] next_playerHp,
    output reg [20:0] next_enemyHp,
    output reg [27:0] next_playerBullet[0:599],
    output reg [27:0] next_enemyBullet[0:599]
);
localparam base1=32'd40000;
localparam base2=32'd56569;//4*10^4sqrt(2)
integer i,counter1,counter2,clkCounter;
always @(posedge clk) begin
    if(clkCounter<32'd99)
        clkCounter<=clkCounter+1;
    else
        clkCounter<=0;
    if(state==2) begin
        if(clkCounter==32'd99) begin
            if(counter1<base1)
                counter1<=counter1+1;
            else
                counter1<=0;
            if(counter2<base2)
                counter2<=counter2+1;
            else
                counter2<=0;
        end
        for(i=0;i<6;i++) begin
            if(playerBullet[clkCounter*6+i][7:0]==enemyPosition[0]&&playerBullet[clkCounter*6+i][15:8]==enemyPosition[1]) begin
                if(enemyHp<=playerBullet[clkCounter*6+i][22:16])
                    next_enemyHp<=0;
                else
                    next_enemyHp<=enemyHp-playerBullet[clkCounter*6+i][22:16];
                next_playerBullet[clkCounter*6+i]<=0;
            end
            else begin
                case(playerBullet[clkCounter*6+i][25:23])
                    4'd0: begin
                        if(counter1==(base1>>playerBullet[clkCounter*6+i][27:26])) begin
                            if(playerBullet[clkCounter*6+i][15:8]>0)
                                next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i]-(1<<8);
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i];
                    end
                    4'd1: begin
                        if(counter1==(base1>>playerBullet[clkCounter*6+i][27:26])) begin
                            if(playerBullet[clkCounter*6+i][7:0]>0)
                                next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i]-1;
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i];
                    end
                    4'd2: begin
                        if(counter1==(base1>>playerBullet[clkCounter*6+i][27:26])) begin
                            if(playerBullet[clkCounter*6+i][7:0]<8'd199)
                                next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i]+1;
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i];
                    end
                    4'd3: begin
                        if(counter1==(base1>>playerBullet[clkCounter*6+i][27:26])) begin
                            if(playerBullet[clkCounter*6+i][15:8]<8'd149)
                                next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i]+(1<<8);
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i];
                    end
                    4'd4: begin
                        if(counter2==(base2>>playerBullet[clkCounter*6+i][27:26])) begin
                            if(playerBullet[clkCounter*6+i][7:0]>0&&playerBullet[clkCounter*6+i][15:8]>0)
                                next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i]-(1<<8)-1;
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i];
                    end
                    4'd5: begin
                        if(counter2==(base2>>playerBullet[clkCounter*6+i][27:26])) begin
                            if(playerBullet[clkCounter*6+i][7:0]<8'd199&&playerBullet[clkCounter*6+i][15:8]>0)
                                next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i]-(1<<8)+1;
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i];
                    end
                    4'd6: begin
                        if(counter2==(base2>>playerBullet[clkCounter*6+i][27:26])) begin
                            if(playerBullet[clkCounter*6+i][7:0]>0&&playerBullet[clkCounter*6+i][15:8]<8'd149)
                                next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i]+(1<<8)-1;
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i];
                    end
                    4'd7: begin
                        if(counter2==(base2>>playerBullet[clkCounter*6+i][27:26])) begin
                            if(playerBullet[clkCounter*6+i][7:0]<8'd199&&playerBullet[clkCounter*6+i][15:8]<8'd149)
                                next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i]+(1<<8)+1;
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_playerBullet[clkCounter*6+i]<=playerBullet[clkCounter*6+i];
                    end
                endcase
            end
            if(enemyBullet[clkCounter*6+i][7:0]==playerPosition[0]&&enemyBullet[clkCounter*6+i][15:8]==playerPosition[1]) begin
                if(playerHp<=enemyBullet[clkCounter*6+i][22:16])
                    next_playerHp<=0;
                else
                    next_playerHp<=playerHp-enemyBullet[clkCounter*6+i][22:16];
                next_enemyBullet[clkCounter*6+i]<=0;
            end
            else begin
                case(enemyBullet[clkCounter*6+i][25:23])
                    4'd0: begin
                        if(counter1==(base1>>enemyBullet[clkCounter*6+i][27:26])) begin
                            if(enemyBullet[clkCounter*6+i][15:8]>0)
                                next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i]-(1<<8);
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i];
                    end
                    4'd1: begin
                        if(counter1==(base1>>enemyBullet[clkCounter*6+i][27:26])) begin
                            if(enemyBullet[clkCounter*6+i][7:0]>0)
                                next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i]-1;
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i];
                    end
                    4'd2: begin
                        if(counter1==(base1>>enemyBullet[clkCounter*6+i][27:26])) begin
                            if(enemyBullet[clkCounter*6+i][7:0]<8'd199)
                                next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i]+1;
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i];
                    end
                    4'd3: begin
                        if(counter1==(base1>>enemyBullet[clkCounter*6+i][27:26])) begin
                            if(enemyBullet[clkCounter*6+i][15:8]<8'd149)
                                next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i]+(1<<8);
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i];
                    end
                    4'd4: begin
                        if(counter2==(base2>>enemyBullet[clkCounter*6+i][27:26])) begin
                            if(enemyBullet[clkCounter*6+i][7:0]>0&&enemyBullet[clkCounter*6+i][15:8]>0)
                                next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i]-(1<<8)-1;
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i];
                    end
                    4'd5: begin
                        if(counter2==(base2>>enemyBullet[clkCounter*6+i][27:26])) begin
                            if(enemyBullet[clkCounter*6+i][7:0]<8'd199&&enemyBullet[clkCounter*6+i][15:8]>0)
                                next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i]-(1<<8)+1;
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i];
                    end
                    4'd6: begin
                        if(counter2==(base2>>enemyBullet[clkCounter*6+i][27:26])) begin
                            if(enemyBullet[clkCounter*6+i][7:0]>0&&enemyBullet[clkCounter*6+i][15:8]<8'd149)
                                next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i]+(1<<8)-1;
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i];
                    end
                    4'd7: begin
                        if(counter2==(base2>>enemyBullet[clkCounter*6+i][27:26])) begin
                            if(enemyBullet[clkCounter*6+i][7:0]<8'd199&&enemyBullet[clkCounter*6+i][15:8]<8'd149)
                                next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i]+(1<<8)+1;
                            else
                                next_enemyBullet[clkCounter*6+i]<=0;
                        end
                        else
                            next_enemyBullet[clkCounter*6+i]<=enemyBullet[clkCounter*6+i];
                    end
                endcase
            end
        end
    end
    else if(state!=1) begin
        counter1<=0;
        counter2<=0;
        next_playerHp<=playerHp;
        next_enemyHp<=enemyHp;
        next_playerBullet[clkCounter*6]<=0;
        next_playerBullet[clkCounter*6+1]<=0;
        next_playerBullet[clkCounter*6+2]<=0;
        next_playerBullet[clkCounter*6+3]<=0;
        next_playerBullet[clkCounter*6+4]<=0;
        next_playerBullet[clkCounter*6+5]<=0;
        next_enemyBullet[clkCounter*6]<=0;
        next_enemyBullet[clkCounter*6+1]<=0;
        next_enemyBullet[clkCounter*6+2]<=0;
        next_enemyBullet[clkCounter*6+3]<=0;
        next_enemyBullet[clkCounter*6+4]<=0;
        next_enemyBullet[clkCounter*6+5]<=0;
    end
end
endmodule