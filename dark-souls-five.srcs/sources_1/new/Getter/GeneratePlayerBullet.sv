module GeneratePlayerBullet (
    input clk,
    input [3:0] state,
    input [5:0] level,
    input [6:0] playerPosition[0:1],

    output reg [25:0] next_playerBullet[0:299]
);
reg [25:0] counter;
reg [8:0] startPos;
integer i;
always @(posedge clk) begin
    if(state==2) begin
        if(counter<26'd50000000)
            counter<=counter+1;
        else
            counter<=0;
        if(counter==1) begin
            next_playerBullet[startPos]<=0;
            next_playerBullet[(startPos+1)%300]<=0;
            next_playerBullet[(startPos+2)%300]<=0;
            next_playerBullet[(startPos+3)%300]<=0;
            next_playerBullet[(startPos+4)%300]<=0;
            next_playerBullet[(startPos+5)%300]<=0;
            next_playerBullet[(startPos+6)%300]<=0;
        end
    end
    else begin
        counter<=0;
        if(state!=1)
            startPos<=0;
    end
end
wire fire=(counter==0);
always @(posedge fire) begin
    if(level==1||level==2) begin
        startPos<=startPos+3;
        next_playerBullet[startPos+3]<={12'b100000010100,playerPosition[1],playerPosition[0]};
        if(playerPosition[0]>0)
            next_playerBullet[startPos+4]<={12'b100000001010,playerPosition[1],playerPosition[0]}-1;
        if(playerPosition[0]<7'd79)
            next_playerBullet[startPos+5]<={12'b100000010100,playerPosition[1],playerPosition[0]}+1;
    end
    else if(level==3||level==4) begin
        startPos<=startPos+5;
        next_playerBullet[startPos+3]<={12'b100000010100,playerPosition[1],playerPosition[0]};
        if(playerPosition[0]>0)
            next_playerBullet[startPos+4]<={12'b100000001010,playerPosition[1],playerPosition[0]}-1;
        if(playerPosition[0]<7'd79)
            next_playerBullet[startPos+5]<={12'b100000010100,playerPosition[1],playerPosition[0]}+1;
        if(playerPosition[0]>1)
            next_playerBullet[startPos+6]<={12'b100000001010,playerPosition[1],playerPosition[0]}-2;
        if(playerPosition[0]<7'd78)
            next_playerBullet[startPos+7]<={12'b100000010100,playerPosition[1],playerPosition[0]}+2;
    end
    else begin
        startPos<=startPos+7;
        next_playerBullet[startPos+3]<={12'b100000010100,playerPosition[1],playerPosition[0]};
        if(playerPosition[0]>0)
            next_playerBullet[startPos+4]<={12'b100000001010,playerPosition[1],playerPosition[0]}-1;
        if(playerPosition[0]<7'd79)
            next_playerBullet[startPos+5]<={12'b100000010100,playerPosition[1],playerPosition[0]}+1;
        if(playerPosition[0]>1)
            next_playerBullet[startPos+6]<={12'b100000001010,playerPosition[1],playerPosition[0]}-2;
        if(playerPosition[0]<7'd78)
            next_playerBullet[startPos+7]<={12'b100000010100,playerPosition[1],playerPosition[0]}+2;
        if(playerPosition[0]>2)
            next_playerBullet[startPos+8]<={12'b100000001010,playerPosition[1],playerPosition[0]}-3;
        if(playerPosition[0]<7'd77)
            next_playerBullet[startPos+9]<={12'b100000010100,playerPosition[1],playerPosition[0]}+3;
    end
end
endmodule