module GeneratePlayerBullet (
    input clk,
    input [3:0] state,
    input [5:0] level,
    input [7:0] playerPosition[0:1],

    output reg [27:0] next_playerBullet[0:69]
);
integer counter,startPos;
integer i;
initial begin
    counter<=0;
    startPos<=0;
    for(i=0;i<70;i++)
        next_playerBullet[i]<=0;
end
always @(posedge clk) begin
    if(state==2) begin
        if(counter<32'd20000000)
            counter<=counter+1;
        else
            counter<=0;
        if(counter==0) begin
            if(level==1||level==2) begin
                startPos<=(startPos+3)<70?(startPos+3):(startPos+3)-70;
                next_playerBullet[(startPos+3)<70?(startPos+3):(startPos+3)-70]<={12'b100110010100,playerPosition[1],playerPosition[0]}+(1<<8);
                next_playerBullet[(startPos+4)<70?(startPos+4):(startPos+4)-70]<={12'b100110001010,playerPosition[1],playerPosition[0]}-3+(1<<8);
                next_playerBullet[(startPos+5)<70?(startPos+5):(startPos+5)-70]<={12'b100110010100,playerPosition[1],playerPosition[0]}+3+(1<<8);
            end
            else if(level==3||level==4) begin
                startPos<=(startPos+5)<70?(startPos+5):(startPos+5)-70;
                next_playerBullet[(startPos+3)<70?(startPos+3):(startPos+3)-70]<={12'b100110010100,playerPosition[1],playerPosition[0]}+(1<<8);
                next_playerBullet[(startPos+4)<70?(startPos+4):(startPos+4)-70]<={12'b100110001010,playerPosition[1],playerPosition[0]}-3+(1<<8);
                next_playerBullet[(startPos+5)<70?(startPos+5):(startPos+5)-70]<={12'b100110010100,playerPosition[1],playerPosition[0]}+3+(1<<8);
                next_playerBullet[(startPos+6)<70?(startPos+6):(startPos+6)-70]<={12'b100110001010,playerPosition[1],playerPosition[0]}-6+(1<<8);
                next_playerBullet[(startPos+7)<70?(startPos+7):(startPos+7)-70]<={12'b100110010100,playerPosition[1],playerPosition[0]}+6+(1<<8);
            end
            else begin
                startPos<=(startPos+7)<70?(startPos+7):(startPos+7)-70;
                next_playerBullet[(startPos+3)<70?(startPos+3):(startPos+3)-70]<={12'b100110010100,playerPosition[1],playerPosition[0]}+(1<<8);
                next_playerBullet[(startPos+4)<70?(startPos+4):(startPos+4)-70]<={12'b100110001010,playerPosition[1],playerPosition[0]}-3+(1<<8);
                next_playerBullet[(startPos+5)<70?(startPos+5):(startPos+5)-70]<={12'b100110010100,playerPosition[1],playerPosition[0]}+3+(1<<8);
                next_playerBullet[(startPos+6)<70?(startPos+6):(startPos+6)-70]<={12'b100110001010,playerPosition[1],playerPosition[0]}-6+(1<<8);
                next_playerBullet[(startPos+7)<70?(startPos+7):(startPos+7)-70]<={12'b100110010100,playerPosition[1],playerPosition[0]}+6+(1<<8);
                next_playerBullet[(startPos+8)<70?(startPos+8):(startPos+8)-70]<={12'b100110001010,playerPosition[1],playerPosition[0]}-9+(1<<8);
                next_playerBullet[(startPos+9)<70?(startPos+9):(startPos+9)-70]<={12'b100110010100,playerPosition[1],playerPosition[0]}+9+(1<<8);
            end
        end
        if(counter==1) begin
            next_playerBullet[startPos]<=0;
            next_playerBullet[(startPos+1)<70?(startPos+1):(startPos+1)-70]<=0;
            next_playerBullet[(startPos+2)<70?(startPos+2):(startPos+2)-70]<=0;
            next_playerBullet[(startPos+3)<70?(startPos+3):(startPos+3)-70]<=0;
            next_playerBullet[(startPos+4)<70?(startPos+4):(startPos+4)-70]<=0;
            next_playerBullet[(startPos+5)<70?(startPos+5):(startPos+5)-70]<=0;
            next_playerBullet[(startPos+6)<70?(startPos+6):(startPos+6)-70]<=0;
        end
    end
    else begin
        counter<=0;
        if(state!=1) begin
            startPos<=0;
            for(i=0;i<70;i++)
                next_playerBullet[i]<=0;
        end
    end
end
endmodule