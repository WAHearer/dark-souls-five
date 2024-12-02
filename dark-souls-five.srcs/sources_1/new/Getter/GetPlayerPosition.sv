module GetPlayerPosition (
    input up,down,left,right,space,clk,
    input [3:0] state,
    input [6:0] playerPosition[0:1],

    output reg [6:0] next_playerPosition[0:1]
);
reg [20:0] upCounter;
reg [20:0] downCounter;
reg [20:0] leftCounter;
reg [20:0] rightCounter;
reg [28:0] rollCounter;
reg rollAvailable;
initial begin
    next_playerPosition[0]<=7'd40;
    next_playerPosition[1]<=7'd15;
    upCounter<=0;
    downCounter<=0;
    leftCounter<=0;
    rightCounter<=0;
    rollCounter<=0;
    rollAvailable<=1;
end
always @(posedge clk) begin
    if(state==2) begin
        if(!rollAvailable) begin
            if(rollCounter<29'd300000000)
                rollCounter<=rollCounter+1;
            else begin
                rollCounter<=0;
                rollAvailable<=1;
            end
        end
        else if(space) begin
            rollAvailable<=0;
            if(up) begin
                if(playerPosition[1]<7'd50)
                    next_playerPosition[1]<=playerPosition[1]+10;
                else
                    next_playerPosition[1]<=7'd59;
            end
            if(down) begin
                if(playerPosition[1]>9)
                    next_playerPosition[1]<=playerPosition[1]-10;
                else
                    next_playerPosition[1]<=0;
            end
            if(right) begin
                if(playerPosition[0]<7'd70)
                    next_playerPosition[0]<=playerPosition[0]+10;
                else
                    next_playerPosition[0]<=7'd79;
            end
            if(left) begin
                if(playerPosition[0]>9)
                    next_playerPosition[0]<=playerPosition[0]-10;
                else
                    next_playerPosition[0]<=0;
            end
        end
        if(!space) begin
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
end
endmodule
