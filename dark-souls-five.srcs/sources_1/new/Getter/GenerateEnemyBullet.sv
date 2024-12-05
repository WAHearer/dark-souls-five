module GenerateEnemyBullet (
    input clk,
    input [3:0] state,
    input [5:0] level,
    input [7:0] playerPosition[0:1],
    input [7:0] enemyPosition[0:1],
    input [20:0] enemyHp,

    output reg [27:0] next_enemyBullet[0:69]
);
integer i,counter1,counter2,counter3,startPos;
always @(posedge clk) begin
    if(state==2) begin
        if(level==1||level==2) begin
            if(counter1<32'd15000011)
                counter1<=counter1+1;
            else begin
                counter1<=0;
                startPos<=(startPos+7)<70?(startPos+7):(startPos+7)-70;
                next_enemyBullet[(startPos+7)<70?(startPos+7):(startPos+7)-70]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-(1<<8);
                next_enemyBullet[(startPos+8)<70?(startPos+8):(startPos+8)-70]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-6-(1<<8);
                next_enemyBullet[(startPos+9)<70?(startPos+9):(startPos+9)-70]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-12-(1<<8);
                next_enemyBullet[(startPos+10)<70?(startPos+10):(startPos+10)-70]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-18-(1<<8);
                next_enemyBullet[(startPos+11)<70?(startPos+11):(startPos+11)-70]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}+6-(1<<8);
                next_enemyBullet[(startPos+12)<70?(startPos+12):(startPos+12)-70]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}+12-(1<<8);
                next_enemyBullet[(startPos+13)<70?(startPos+13):(startPos+13)-70]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}+18-(1<<8);
            end
            if(counter1==0) begin
                for(i=0;i<7;i++)
                    next_enemyBullet[(startPos+i)<70?(startPos+i):(startPos+i)-70]<=0;
            end
            if(counter2<32'd25000003)
                counter2<=counter2+1;
            else begin
                counter2<=0;
                startPos<=(startPos+6)<70?(startPos+6):(startPos+6)-70;
                next_enemyBullet[(startPos+6)<70?(startPos+6):(startPos+6)-70]<={12'b000000011001,enemyPosition[1],enemyPosition[0]}-3-(1<<8);
                next_enemyBullet[(startPos+7)<70?(startPos+7):(startPos+7)-70]<={12'b000000011001,enemyPosition[1],enemyPosition[0]}-9-(1<<8);
                next_enemyBullet[(startPos+8)<70?(startPos+8):(startPos+8)-70]<={12'b000000011001,enemyPosition[1],enemyPosition[0]}-15-(1<<8);
                next_enemyBullet[(startPos+9)<70?(startPos+9):(startPos+9)-70]<={12'b000000011001,enemyPosition[1],enemyPosition[0]}+3-(1<<8);
                next_enemyBullet[(startPos+10)<70?(startPos+10):(startPos+10)-70]<={12'b000000011001,enemyPosition[1],enemyPosition[0]}+9-(1<<8);
                next_enemyBullet[(startPos+11)<70?(startPos+11):(startPos+11)-70]<={12'b000000011001,enemyPosition[1],enemyPosition[0]}+15-(1<<8);
            end
            if(counter2==0) begin
                for(i=0;i<6;i++)
                    next_enemyBullet[(startPos+i)<70?(startPos+i):(startPos+i)-70]<=0;
            end
        end
        if(level==2) begin
            if(counter3<32'd20000007)
                counter3<=counter3+1;
            else begin
                counter3<=0;
                startPos<=(startPos+8)<70?(startPos+8):(startPos+8)-70;
                next_enemyBullet[(startPos+8)<70?(startPos+8):(startPos+8)-70]<={12'b011000010100,enemyPosition[1],enemyPosition[0]}-1;
                next_enemyBullet[(startPos+9)<70?(startPos+9):(startPos+9)-70]<={12'b011010010100,enemyPosition[1],enemyPosition[0]}-1;
                next_enemyBullet[(startPos+10)<70?(startPos+10):(startPos+10)-70]<={12'b011000010100,enemyPosition[1],enemyPosition[0]}+1;
                next_enemyBullet[(startPos+11)<70?(startPos+11):(startPos+11)-70]<={12'b011010010100,enemyPosition[1],enemyPosition[0]}+1;
                next_enemyBullet[(startPos+12)<70?(startPos+12):(startPos+12)-70]<={12'b011000010100,enemyPosition[1],enemyPosition[0]}-1-(1<<9);
                next_enemyBullet[(startPos+13)<70?(startPos+13):(startPos+13)-70]<={12'b011010010100,enemyPosition[1],enemyPosition[0]}-1-(1<<9);
                next_enemyBullet[(startPos+14)<70?(startPos+14):(startPos+14)-70]<={12'b011000010100,enemyPosition[1],enemyPosition[0]}+1-(1<<9);
                next_enemyBullet[(startPos+15)<70?(startPos+15):(startPos+15)-70]<={12'b011010010100,enemyPosition[1],enemyPosition[0]}+1-(1<<9);
            end
            if(counter3==0) begin
                for(i=0;i<8;i++)
                    next_enemyBullet[(startPos+i)<70?(startPos+i):(startPos+i)-70]<=0;
            end
        end
        if(level==3) begin
            if(counter1<32'd400000000)
                counter1<=counter1+1;
            else begin
                counter1<=0;
                startPos<=(startPos+66)<70?(startPos+66):(startPos+66)-70;
                for(i=0;i<66;i++) begin
                    next_enemyBullet[(startPos+i+66)<70?(startPos+i+66):(startPos+i+66)-70]<={12'b100000110010,enemyPosition[1],8'd0}-(1<<8)+i+i+i+2;
                end
            end
            if(counter1==0) begin
                for(i=0;i<66;i++)
                    next_enemyBullet[(startPos+i)<70?(startPos+i):(startPos+i)-70]<=0;
            end
            if(counter2<32'd15000003)
                counter2<=counter2+1;
            else begin
                counter2<=0;
                startPos<=(startPos+8)<70?(startPos+8):(startPos+8)-70;
                next_enemyBullet[(startPos+8)<70?(startPos+8):(startPos+8)-70]<={12'b011000010100,enemyPosition[1],enemyPosition[0]}-1;
                next_enemyBullet[(startPos+9)<70?(startPos+9):(startPos+9)-70]<={12'b011010010100,enemyPosition[1],enemyPosition[0]}-1;
                next_enemyBullet[(startPos+10)<70?(startPos+10):(startPos+10)-70]<={12'b011000010100,enemyPosition[1],enemyPosition[0]}+1;
                next_enemyBullet[(startPos+11)<70?(startPos+11):(startPos+11)-70]<={12'b011010010100,enemyPosition[1],enemyPosition[0]}+1;
                next_enemyBullet[(startPos+12)<70?(startPos+12):(startPos+12)-70]<={12'b011000010100,enemyPosition[1],enemyPosition[0]}-1-(1<<9);
                next_enemyBullet[(startPos+13)<70?(startPos+13):(startPos+13)-70]<={12'b011010010100,enemyPosition[1],enemyPosition[0]}-1-(1<<9);
                next_enemyBullet[(startPos+14)<70?(startPos+14):(startPos+14)-70]<={12'b011000010100,enemyPosition[1],enemyPosition[0]}+1-(1<<9);
                next_enemyBullet[(startPos+15)<70?(startPos+15):(startPos+15)-70]<={12'b011010010100,enemyPosition[1],enemyPosition[0]}+1-(1<<9);
            end
            if(counter2==0) begin
                for(i=0;i<8;i++)
                    next_enemyBullet[(startPos+i)<70?(startPos+i):(startPos+i)-70]<=0;
            end
            if(counter3<32'd30000007)
                counter3<=counter3+1;
            else begin
                counter3<=0;
                startPos<=(startPos+3)<70?(startPos+3):(startPos+3)-70;
                next_enemyBullet[(startPos+3)<70?(startPos+3):(startPos+3)-70]<={12'b110000001111,enemyPosition[1],enemyPosition[0]}-(1<<8);
                next_enemyBullet[(startPos+4)<70?(startPos+4):(startPos+4)-70]<={12'b110000001111,enemyPosition[1],enemyPosition[0]}-(1<<8)-3;
                next_enemyBullet[(startPos+5)<70?(startPos+5):(startPos+5)-70]<={12'b110000001111,enemyPosition[1],enemyPosition[0]}-(1<<8)+3;
            end
            if(counter3==0) begin
                for(i=0;i<3;i++)
                    next_enemyBullet[(startPos+i)<70?(startPos+i):(startPos+i)-70]<=0;
            end
        end
    end
    else if(state!=1) begin
        counter1<=0;
        counter2<=0;
        counter3<=0;
        startPos<=0;
        for(i=0;i<70;i++)
            next_enemyBullet[i]<=0;
    end
end
endmodule