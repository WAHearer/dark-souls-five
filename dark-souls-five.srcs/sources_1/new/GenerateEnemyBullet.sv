module GenerateEnemyBullet (
    input clk,
    input [3:0] state,
    input [5:0] level,
    input [7:0] playerPosition[0:1],
    input [7:0] enemyPosition[0:1],
    input [20:0] enemyHp,

    output reg [27:0] next_enemyBullet[0:599]
);
integer i,counter1,counter2,counter3,base,speed,startPos,cnt;
always @(posedge clk) begin
    if(state==2) begin
        if(level==1||level==2) begin
            if(counter1<32'd30000000)
                counter1<=counter1+1;
            else begin
                counter1<=0;
                startPos<=(startPos+7)<600?(startPos+7):(startPos+7)-600;
                next_enemyBullet[(startPos+7)<600?(startPos+7):(startPos+7)-600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-(1<<8);
                next_enemyBullet[(startPos+8)<600?(startPos+8):(startPos+8)-600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-2-(1<<8);
                next_enemyBullet[(startPos+9)<600?(startPos+9):(startPos+9)-600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-4-(1<<8);
                next_enemyBullet[(startPos+10)<600?(startPos+10):(startPos+10)-600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}-6-(1<<8);
                next_enemyBullet[(startPos+11)<600?(startPos+11):(startPos+11)-600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}+2-(1<<8);
                next_enemyBullet[(startPos+12)<600?(startPos+12):(startPos+12)-600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}+4-(1<<8);
                next_enemyBullet[(startPos+13)<600?(startPos+13):(startPos+13)-600]<={12'b010000001010,enemyPosition[1],enemyPosition[0]}+6-(1<<8);
            end
            if(counter1==0) begin
                for(i=0;i<7;i++)
                    next_enemyBullet[(startPos+i)<600?(startPos+i):(startPos+i)-600]<=0;
            end
            if(counter2<32'd50000003)
                counter2<=counter2+1;
            else begin
                counter2<=0;
                startPos<=(startPos+6)<600?(startPos+6):(startPos+6)-600;
                next_enemyBullet[(startPos+6)<600?(startPos+6):(startPos+6)-600]<={12'b000000011001,enemyPosition[1],enemyPosition[0]}-1-(1<<8);
                next_enemyBullet[(startPos+7)<600?(startPos+7):(startPos+7)-600]<={12'b000000011001,enemyPosition[1],enemyPosition[0]}-3-(1<<8);
                next_enemyBullet[(startPos+8)<600?(startPos+8):(startPos+8)-600]<={12'b000000011001,enemyPosition[1],enemyPosition[0]}-5-(1<<8);
                next_enemyBullet[(startPos+9)<600?(startPos+9):(startPos+9)-600]<={12'b000000011001,enemyPosition[1],enemyPosition[0]}+1-(1<<8);
                next_enemyBullet[(startPos+10)<600?(startPos+10):(startPos+10)-600]<={12'b000000011001,enemyPosition[1],enemyPosition[0]}+3-(1<<8);
                next_enemyBullet[(startPos+11)<600?(startPos+11):(startPos+11)-600]<={12'b000000011001,enemyPosition[1],enemyPosition[0]}+5-(1<<8);
            end
            if(counter2==0) begin
                for(i=0;i<6;i++)
                    next_enemyBullet[(startPos+i)<600?(startPos+i):(startPos+i)-600]<=0;
            end
        end
        if(level==2) begin
            if(counter3<32'd40000007)
                counter3<=counter3+1;
            else begin
                counter3<=0;
                startPos<=(startPos+8)<600?(startPos+8):(startPos+8)-600;
                next_enemyBullet[(startPos+8)<600?(startPos+8):(startPos+8)-600]<={12'b011000010100,enemyPosition[1],enemyPosition[0]}-1;
                next_enemyBullet[(startPos+9)<600?(startPos+9):(startPos+9)-600]<={12'b011010010100,enemyPosition[1],enemyPosition[0]}-1;
                next_enemyBullet[(startPos+10)<600?(startPos+10):(startPos+10)-600]<={12'b011000010100,enemyPosition[1],enemyPosition[0]}+1;
                next_enemyBullet[(startPos+11)<600?(startPos+11):(startPos+11)-600]<={12'b011010010100,enemyPosition[1],enemyPosition[0]}+1;
                next_enemyBullet[(startPos+12)<600?(startPos+12):(startPos+12)-600]<={12'b011000010100,enemyPosition[1],enemyPosition[0]}-1-(1<<9);
                next_enemyBullet[(startPos+13)<600?(startPos+13):(startPos+13)-600]<={12'b011010010100,enemyPosition[1],enemyPosition[0]}-1-(1<<9);
                next_enemyBullet[(startPos+14)<600?(startPos+14):(startPos+14)-600]<={12'b011000010100,enemyPosition[1],enemyPosition[0]}+1-(1<<9);
                next_enemyBullet[(startPos+15)<600?(startPos+15):(startPos+15)-600]<={12'b011010010100,enemyPosition[1],enemyPosition[0]}+1-(1<<9);
            end
            if(counter3==0) begin
                for(i=0;i<8;i++)
                    next_enemyBullet[(startPos+i)<600?(startPos+i):(startPos+i)-600]<=0;
            end
        end
        if(level==3) begin
            if(counter1<base)
                counter1<=counter1+1;
            else begin
                counter1<=0;
                startPos<=(startPos+200)<600?(startPos+200):(startPos+200)-600;
                if(cnt==0||cnt==3||cnt==6||cnt==9) begin
                    for(i=0;i<200;i++) begin
                        if(speed==0)
                            next_enemyBullet[i]<={12'b010000110010,enemyPosition[1],i}-(1<<8);
                        else
                            next_enemyBullet[i]<={12'b100000110010,enemyPosition[1],i}-(1<<8);
                    end
                end
                else if(cnt==1||cnt==4||cnt==7||cnt==10) begin
                    for(i=200;i<400;i++) begin
                        if(speed==0)
                            next_enemyBullet[i]<={12'b010000110010,enemyPosition[1],i}-(1<<8);
                        else
                            next_enemyBullet[i]<={12'b100000110010,enemyPosition[1],i}-(1<<8);
                    end
                end
                else begin
                    for(i=400;i<600;i++) begin
                        if(speed==0)
                            next_enemyBullet[i]<={12'b010000110010,enemyPosition[1],i}-(1<<8);
                        else
                            next_enemyBullet[i]<={12'b100000110010,enemyPosition[1],i}-(1<<8);
                    end
                end
            end
            if(counter1==0) begin
                case(cnt)
                    0:begin
                        base<=32'd92465192;
                        speed<=1;
                    end
                    1:begin
                        base<=32'd109058183;
                        speed<=1;
                    end
                    2:begin
                        base<=32'd85155152;
                        speed<=0;
                    end
                    3:begin
                        base<=32'd117041211;
                        speed<=1;
                    end
                    4:begin
                        base<=32'd111008611;
                        speed<=0;
                    end
                    5:begin
                        base<=32'd109146229;
                        speed<=0;
                    end
                    6:begin
                        base<=32'd99498331;
                        speed<=0;
                    end
                    7:begin
                        base<=32'd118826640;
                        speed<=1;
                    end
                    8:begin
                        base<=32'd34587456;
                        speed<=1;
                    end
                    9:begin
                        base<=32'd42875369;
                        speed<=1;
                    end
                    10:begin
                        base<=32'd97423442;
                        speed<=1;
                    end
                    11:begin
                        base<=32'd100000000;
                        speed<=0;
                    end
                endcase
                if(cnt==0||cnt==3||cnt==6||cnt==9) begin
                    for(i=0;i<200;i++) begin
                        next_enemyBullet[i]<=0;
                    end
                end
                else if(cnt==1||cnt==4||cnt==7||cnt==10) begin
                    for(i=200;i<400;i++) begin
                        next_enemyBullet[i]<=0;
                    end
                end
                else begin
                    for(i=400;i<600;i++) begin
                        next_enemyBullet[i]<=0;
                    end
                end
                cnt<=(cnt+1)%11;
                
            end
        end
    end
    else if(state!=1) begin
        counter1<=0;
        counter2<=0;
        counter3<=0;
        startPos<=0;
        base<=32'd100000000;
        speed<=0;
        cnt<=0;
        for(i=0;i<600;i++)
            next_enemyBullet[i]<=0;
    end
end
endmodule