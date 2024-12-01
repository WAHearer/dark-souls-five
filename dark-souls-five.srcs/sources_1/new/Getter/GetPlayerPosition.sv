module GetPlayerPosition (
    input up,down,left,right,clk,
    input [3:0] state,
    input [6:0] playerPosition[0:1],

    output reg [6:0] next_playerPosition[0:1]
);
reg [20:0] upCounter;
reg [20:0] downCounter;
reg [20:0] leftCounter;
reg [20:0] rightCounter;
initial begin
    next_playerPosition[0]<=7'd40;
    next_playerPosition[1]<=7'd15;
    upCounter<=0;
    downCounter<=0;
    leftCounter<=0;
    rightCounter<=0;
end
always @(posedge clk) begin
    if(state==2) begin
        if(up) begin
            if(upCounter<21'd1666667)
                upCounter<=upCounter+1;
            else begin
                upCounter<=0;
                if(playerPosition[1]<7'd59)
                    next_playerPosition[1]<=playerPosition[1]+1;
            end
        end
        else
            upCounter<=0;
        if(down) begin
            if(downCounter<21'd1666667)
                downCounter<=downCounter+1;
            else begin
                downCounter<=0;
                if(playerPosition[1]>0)
                    next_playerPosition[1]<=playerPosition[1]-1;
            end
        end
        else
            downCounter<=0;
        if(right) begin
            if(rightCounter<21'd1666667)
                rightCounter<=rightCounter+1;
            else begin
                rightCounter<=0;
                if(playerPosition[0]<7'd79)
                    next_playerPosition[0]<=playerPosition[0]+1;
            end
        end
        else
            rightCounter<=0;
        if(left) begin
            if(leftCounter<21'd1666667)
                leftCounter<=leftCounter+1;
            else begin
                leftCounter<=0;
                if(playerPosition[0]>0)
                    next_playerPosition[0]<=playerPosition[0]-1;
            end
        end
        else
            leftCounter<=0;
    end
end
endmodule
