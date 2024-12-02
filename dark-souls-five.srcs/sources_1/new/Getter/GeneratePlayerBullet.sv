module GeneratePlayerBullet (
    input clk,
    input [3:0] state,
    input [5:0] level,
    input [6:0] playerPosition[0:1],

    output reg [16:0] next_playerBullet[0:79][0:59]
);
reg [25:0] counter;
integer i,j;
always @(posedge clk) begin
    if(counter<26'd50000000) begin
        counter<=counter+1;
        if(counter==0) begin
            for(i=0;i<79;i++) begin
                for(j=0;j<59;j++) begin
                    next_playerBullet[i][j]<=0;
                end
            end
        end
    end
    else begin
        counter<=0;
        if(level==1||level==2) begin
            if(playerPosition[1]<7'd59) begin
                next_playerBullet[playerPosition[0]][playerPosition[1]+1]<=17'b10001100010100000;
                if(playerPosition[0]>0)
                    next_playerBullet[playerPosition[0]-1][playerPosition[1]+1]<=17'b10001100001010000;
                if(playerPosition[0]<7'd79)
                    next_playerBullet[playerPosition[0]+1][playerPosition[1]+1]<=17'b10001100001010000;
            end
        end
        else if(level==3||level==4) begin
            if(playerPosition[1]<7'd59) begin
                next_playerBullet[playerPosition[0]][playerPosition[1]+1]<=17'b10001100010100000;
                if(playerPosition[0]>0)
                    next_playerBullet[playerPosition[0]-1][playerPosition[1]+1]<=17'b10001100001010000;
                if(playerPosition[0]<7'd79)
                    next_playerBullet[playerPosition[0]+1][playerPosition[1]+1]<=17'b10001100001010000;
                if(playerPosition[0]>0&&playerPosition[1]<7'd58) begin
                    next_playerBullet[playerPosition[0]-1][playerPosition[1]+2]<=17'b10111000001010000;
                end
                if(playerPosition[0]<7'd79&&playerPosition[1]<7'd58) begin
                    next_playerBullet[playerPosition[0]+1][playerPosition[1]+2]<=17'b10110100001010000;
                end
            end
        end
        else if(level>=5) begin
            if(playerPosition[1]<7'd59) begin
                next_playerBullet[playerPosition[0]][playerPosition[1]+1]<=17'b10001100010100000;
                if(playerPosition[0]>0)
                    next_playerBullet[playerPosition[0]-1][playerPosition[1]+1]<=17'b10001100001010000;
                if(playerPosition[0]<7'd79)
                    next_playerBullet[playerPosition[0]+1][playerPosition[1]+1]<=17'b10001100001010000;
                if(playerPosition[0]>1)
                    next_playerBullet[playerPosition[0]-2][playerPosition[1]+1]<=17'b10001100001010000;
                if(playerPosition[0]<7'd78)
                    next_playerBullet[playerPosition[0]+2][playerPosition[1]+1]<=17'b10001100001010000;
                if(playerPosition[0]>2)
                    next_playerBullet[playerPosition[0]-3][playerPosition[1]+1]<=17'b10001100001010000;
                if(playerPosition[0]<7'd77)
                    next_playerBullet[playerPosition[0]+3][playerPosition[1]+1]<=17'b10001100001010000;
            end
        end
    end
end
endmodule