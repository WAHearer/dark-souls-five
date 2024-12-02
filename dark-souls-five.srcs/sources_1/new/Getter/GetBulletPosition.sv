module GetPlayerPosition (
    input clk,
    input [3:0] state,
    input [20:0] playerHp,
    input [20:0] enemyHp,
    input [6:0] playerPosition[0:1],
    input [6:0] enemyPosition[0:1],
    input [27:0] playerBullet[0:79][0:59],
    input [27:0] enemyBullet[0:79][0:59],

    output reg [20:0] next_playerHp,
    output reg [20:0] next_enemyHp,
    output reg [27:0] next_playerBullet[0:79][0:59],
    output reg [27:0] next_enemyBullet[0:79][0:59]
);
localparam base1=24'd10000000;
localparam base2=24'd7071068;
localparam base3=24'd4472136;
reg [23:0] counter;
integer i,j;
initial begin
    next_playerHp<=21'd100;
    next_enemyHp<=21'd1000;
    for(i=0;i<80;i++) begin
        for(j=0;j<60;j++) begin
            next_playerBullet[i][j]<=0;
            next_enemyBullet[i][j]<=0;
        end
    end
end
always @(posedge clk) begin
    if(state==2) begin
        if(counter<24'd10000000)
            counter<=counter+1;
        else
            counter<=0;
        for(i=0;i<80;i++) begin
            for(j=0;j<60;j++) begin
                if(playerBullet[i][j]!=0) begin
                    if(enemyPosition[0]==i&&enemyPosition[1]==j) begin
                        next_playerBullet[i][j]<=0;
                        next_enemyHp<=enemyHp-playerBullet[i][j][21:12];
                    end
                    else begin
                        case(playerBullet[i][j][25:22])
                            4'd0: begin
                                if(counter==(base1>>playerBullet[i][j][27:26])) begin
                                    if(j>0)
                                        next_playerBullet[i][j-1]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd1: begin
                                if(counter==(base1>>playerBullet[i][j][27:26])) begin
                                    if(i>0)
                                        next_playerBullet[i-1][j]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd2: begin
                                if(counter==(base1>>playerBullet[i][j][27:26])) begin
                                    if(i<79)
                                        next_playerBullet[i+1][j]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd3: begin
                                if(counter==(base1>>playerBullet[i][j][27:26])) begin
                                    if(j<59)
                                        next_playerBullet[i][j+1]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd4: begin
                                if(counter==(base2>>playerBullet[i][j][27:26])) begin
                                    if(i>0&&j>0)
                                        next_playerBullet[i-1][j-1]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd5: begin
                                if(counter==(base2>>playerBullet[i][j][27:26])) begin
                                    if(i<79&&j>0)
                                        next_playerBullet[i+1][j-1]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd6: begin
                                if(counter==(base2>>playerBullet[i][j][27:26])) begin
                                    if(i>0&&j<59)
                                        next_playerBullet[i-1][j+1]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd7: begin
                                if(counter==(base2>>playerBullet[i][j][27:26])) begin
                                    if(i<79&&j<59)
                                        next_playerBullet[i+1][j+1]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd8: begin
                                if(counter==(base3>>playerBullet[i][j][27:26])) begin
                                    if(i>1&&j>0)
                                        next_playerBullet[i-2][j-1]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd9: begin
                                if(counter==(base3>>playerBullet[i][j][27:26])) begin
                                    if(i>0&&j>1)
                                        next_playerBullet[i-1][j-2]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd10: begin
                                if(counter==(base3>>playerBullet[i][j][27:26])) begin
                                    if(i<79&&j>1)
                                        next_playerBullet[i+1][j-2]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd11: begin
                                if(counter==(base3>>playerBullet[i][j][27:26])) begin
                                    if(i<78&&j>0)
                                        next_playerBullet[i+2][j-1]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd12: begin
                                if(counter==(base3>>playerBullet[i][j][27:26])) begin
                                    if(i<78&&j<59)
                                        next_playerBullet[i+2][j+1]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd13: begin
                                if(counter==(base3>>playerBullet[i][j][27:26])) begin
                                    if(i<79&&j<58)
                                        next_playerBullet[i+1][j+2]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd14: begin
                                if(counter==(base3>>playerBullet[i][j][27:26])) begin
                                    if(i>0&&j<58)
                                        next_playerBullet[i-1][j+2]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                            4'd15: begin
                                if(counter==(base3>>playerBullet[i][j][27:26])) begin
                                    if(i>1&&j<59)
                                        next_playerBullet[i-2][j+1]<=playerBullet[i][j];
                                    next_playerBullet[i][j]<=0;
                                end
                                else
                                    next_playerBullet[i][j]<=playerBullet[i][j];
                            end
                        endcase
                    end
                end
                if(enemyBullet[i][j]!=0) begin
                    if(playerPosition[0]==i&&playerPosition[1]==j) begin
                        next_enemyBullet[i][j]<=0;
                        next_playerHp<=playerHp-enemyBullet[i][j][21:12];
                    end
                    else begin
                        case(enemyBullet[i][j][25:22])
                            4'd0: begin
                                if(counter==(base1>>enemyBullet[i][j][27:26])) begin
                                    if(j>0)
                                        next_enemyBullet[i][j-1]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd1: begin
                                if(counter==(base1>>enemyBullet[i][j][27:26])) begin
                                    if(i>0)
                                        next_enemyBullet[i-1][j]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd2: begin
                                if(counter==(base1>>enemyBullet[i][j][27:26])) begin
                                    if(i<79)
                                        next_enemyBullet[i+1][j]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd3: begin
                                if(counter==(base1>>enemyBullet[i][j][27:26])) begin
                                    if(j<59)
                                        next_enemyBullet[i][j+1]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd4: begin
                                if(counter==(base2>>enemyBullet[i][j][27:26])) begin
                                    if(i>0&&j>0)
                                        next_enemyBullet[i-1][j-1]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd5: begin
                                if(counter==(base2>>enemyBullet[i][j][27:26])) begin
                                    if(i<79&&j>0)
                                        next_enemyBullet[i+1][j-1]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd6: begin
                                if(counter==(base2>>enemyBullet[i][j][27:26])) begin
                                    if(i>0&&j<59)
                                        next_enemyBullet[i-1][j+1]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd7: begin
                                if(counter==(base2>>enemyBullet[i][j][27:26])) begin
                                    if(i<79&&j<59)
                                        next_enemyBullet[i+1][j+1]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd8: begin
                                if(counter==(base3>>enemyBullet[i][j][27:26])) begin
                                    if(i>1&&j>0)
                                        next_enemyBullet[i-2][j-1]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd9: begin
                                if(counter==(base3>>enemyBullet[i][j][27:26])) begin
                                    if(i>0&&j>1)
                                        next_enemyBullet[i-1][j-2]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd10: begin
                                if(counter==(base3>>enemyBullet[i][j][27:26])) begin
                                    if(i<79&&j>1)
                                        next_enemyBullet[i+1][j-2]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd11: begin
                                if(counter==(base3>>enemyBullet[i][j][27:26])) begin
                                    if(i<78&&j>0)
                                        next_enemyBullet[i+2][j-1]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd12: begin
                                if(counter==(base3>>enemyBullet[i][j][27:26])) begin
                                    if(i<78&&j<59)
                                        next_enemyBullet[i+2][j+1]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd13: begin
                                if(counter==(base3>>enemyBullet[i][j][27:26])) begin
                                    if(i<79&&j<58)
                                        next_enemyBullet[i+1][j+2]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd14: begin
                                if(counter==(base3>>enemyBullet[i][j][27:26])) begin
                                    if(i>0&&j<58)
                                        next_enemyBullet[i-1][j+2]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                            4'd15: begin
                                if(counter==(base3>>enemyBullet[i][j][27:26])) begin
                                    if(i>1&&j<59)
                                        next_enemyBullet[i-2][j+1]<=enemyBullet[i][j];
                                    next_enemyBullet[i][j]<=0;
                                end
                                else
                                    next_enemyBullet[i][j]<=enemyBullet[i][j];
                            end
                        endcase
                    end
                end
            end
        end
    end
end
endmodule