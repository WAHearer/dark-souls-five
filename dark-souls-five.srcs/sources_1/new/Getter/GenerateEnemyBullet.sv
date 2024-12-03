module GenerateEnemyBullet (
    input clk,
    input [3:0] state,
    input [5:0] level,
    input [7:0] playerPosition[0:1],
    input [7:0] enemyPosition[0:1],
    input [20:0] enemyHp,

    output reg [27:0] next_enemyBullet[0:599]
);
integer i,counter1,counter2,startPos;
always @(posedge clk) begin
    if(state==2) begin
        if(level==1) begin
            if(counter1<32'd30000000)
                counter1<=counter1+1;
            else begin
                counter1<=0;
                startPos<=(startPos+7)%600;
                next_enemyBullet[(startPos+7)%600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-(1<<8);
                next_enemyBullet[(startPos+8)%600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-2-(1<<8);
                next_enemyBullet[(startPos+9)%600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-4-(1<<8);
                next_enemyBullet[(startPos+10)%600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-6-(1<<8);
                next_enemyBullet[(startPos+11)%600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}+2-(1<<8);
                next_enemyBullet[(startPos+12)%600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}+4-(1<<8);
                next_enemyBullet[(startPos+13)%600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}+6-(1<<8);
            end
            if(counter1==0) begin
                next_enemyBullet[startPos]<=0;
                next_enemyBullet[(startPos+1)%600]<=0;
                next_enemyBullet[(startPos+2)%600]<=0;
                next_enemyBullet[(startPos+3)%600]<=0;
                next_enemyBullet[(startPos+4)%600]<=0;
                next_enemyBullet[(startPos+5)%600]<=0;
                next_enemyBullet[(startPos+6)%600]<=0;
            end
            if(counter2<32'd50000003)
                counter2<=counter2+1;
            else begin
                counter2<=0;
                startPos<=(startPos+6)%600;
                next_enemyBullet[(startPos+6)%600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-1-(1<<8);
                next_enemyBullet[(startPos+7)%600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-3-(1<<8);
                next_enemyBullet[(startPos+8)%600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-5-(1<<8);
                next_enemyBullet[(startPos+9)%600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}+1-(1<<8);
                next_enemyBullet[(startPos+10)%600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}+3-(1<<8);
                next_enemyBullet[(startPos+11)%600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}+5-(1<<8);
            end
            if(counter2==0) begin
                next_enemyBullet[startPos]<=0;
                next_enemyBullet[(startPos+1)%600]<=0;
                next_enemyBullet[(startPos+2)%600]<=0;
                next_enemyBullet[(startPos+3)%600]<=0;
                next_enemyBullet[(startPos+4)%600]<=0;
                next_enemyBullet[(startPos+5)%600]<=0;
            end
        end
    end
    else if(state!=1) begin
        counter1<=0;
        counter2<=0;
        startPos<=0;
        for(i=0;i<600;i++)
            next_enemyBullet[i]<=0;
    end
end
endmodule