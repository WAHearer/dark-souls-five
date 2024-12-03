module GeneratePlayerBullet (
    input clk,
    input [3:0] state,
    input [5:0] level,
    input [7:0] playerPosition[0:1],

    output reg [27:0] next_playerBullet[0:599]
);
integer counter,startPos;
integer i;
always @(posedge clk) begin
    if(state==2) begin
        if(counter<32'd50000000)
            counter<=counter+1;
        else
            counter<=0;
        if(counter==1) begin
            next_playerBullet[startPos]<=0;
            next_playerBullet[(startPos+1)%600]<=0;
            next_playerBullet[(startPos+2)%600]<=0;
            next_playerBullet[(startPos+3)%600]<=0;
            next_playerBullet[(startPos+4)%600]<=0;
            next_playerBullet[(startPos+5)%600]<=0;
            next_playerBullet[(startPos+6)%600]<=0;
        end
    end
    else begin
        counter<=0;
        if(state!=1) begin
            startPos<=0;
            for(i=0;i<600;i++)
                next_playerBullet[i]<=0;
        end
    end
end
wire fire=(counter==0);
always @(posedge fire) begin
    if(level==1||level==2) begin
        startPos<=(startPos+3)%600;
        next_playerBullet[(startPos+3)%600]<={12'b100000010100,playerPosition[1],playerPosition[0]}+(1<<8);
        if(playerPosition[0]>0)
            next_playerBullet[(startPos+4)%600]<={12'b100000001010,playerPosition[1],playerPosition[0]}-1+(1<<8);
        if(playerPosition[0]<8'd199)
            next_playerBullet[(startPos+5)%600]<={12'b100000010100,playerPosition[1],playerPosition[0]}+1+(1<<8);
    end
    else if(level==3||level==4) begin
        startPos<=(startPos+5)%600;
        next_playerBullet[(startPos+3)%600]<={12'b100000010100,playerPosition[1],playerPosition[0]}+(1<<8);
        if(playerPosition[0]>0)
            next_playerBullet[(startPos+4)%600]<={12'b100000001010,playerPosition[1],playerPosition[0]}-1+(1<<8);
        if(playerPosition[0]<8'd199)
            next_playerBullet[(startPos+5)%600]<={12'b100000010100,playerPosition[1],playerPosition[0]}+1+(1<<8);
        if(playerPosition[0]>1)
            next_playerBullet[(startPos+6)%600]<={12'b100000001010,playerPosition[1],playerPosition[0]}-2+(1<<8);
        if(playerPosition[0]<8'd198)
            next_playerBullet[(startPos+7)%600]<={12'b100000010100,playerPosition[1],playerPosition[0]}+2+(1<<8);
    end
    else begin
        startPos<=(startPos+7)%600;
        next_playerBullet[(startPos+3)%600]<={12'b100000010100,playerPosition[1],playerPosition[0]}+(1<<8);
        if(playerPosition[0]>0)
            next_playerBullet[(startPos+4)%600]<={12'b100000001010,playerPosition[1],playerPosition[0]}-1+(1<<8);
        if(playerPosition[0]<8'd199)
            next_playerBullet[(startPos+5)%600]<={12'b100000010100,playerPosition[1],playerPosition[0]}+1+(1<<8);
        if(playerPosition[0]>1)
            next_playerBullet[(startPos+6)%600]<={12'b100000001010,playerPosition[1],playerPosition[0]}-2+(1<<8);
        if(playerPosition[0]<8'd198)
            next_playerBullet[(startPos+7)%600]<={12'b100000010100,playerPosition[1],playerPosition[0]}+2+(1<<8);
        if(playerPosition[0]>2)
            next_playerBullet[(startPos+8)%600]<={12'b100000001010,playerPosition[1],playerPosition[0]}-3+(1<<8);
        if(playerPosition[0]<8'd197)
            next_playerBullet[(startPos+9)%600]<={12'b100000010100,playerPosition[1],playerPosition[0]}+3+(1<<8);
    end
end
endmodule