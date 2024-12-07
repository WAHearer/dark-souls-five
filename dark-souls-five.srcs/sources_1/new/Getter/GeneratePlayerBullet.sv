module GeneratePlayerBullet (
    input clk,
    input [3:0] state,
    input [5:0] level,
    input [7:0] playerPosition[0:1],

    output reg [27:0] next_playerBullet[0:39]
);
integer counter,startPos;
integer i;
initial begin
    counter<=0;
    startPos<=0;
    for(i=0;i<40;i++)
        next_playerBullet[i]<=0;
end
always @(posedge clk) begin
    if(state==2) begin
        if(counter<32'd20000000)
            counter<=counter+1;
        else
            counter<=0;
        if(counter==0) begin
            startPos<=(startPos+3)<40?(startPos+3):(startPos+3)-40;
            next_playerBullet[(startPos+3)<40?(startPos+3):(startPos+3)-40]<={12'b100110010100,playerPosition[1],playerPosition[0]}+(1<<8);
            next_playerBullet[(startPos+4)<40?(startPos+4):(startPos+4)-40]<={12'b100110001010,playerPosition[1],playerPosition[0]}-3+(1<<8);
            next_playerBullet[(startPos+5)<40?(startPos+5):(startPos+5)-40]<={12'b100110010100,playerPosition[1],playerPosition[0]}+3+(1<<8);
        end
        else if(counter==1) begin
            next_playerBullet[startPos]<=0;
            next_playerBullet[(startPos+1)<40?(startPos+1):(startPos+1)-40]<=0;
            next_playerBullet[(startPos+2)<40?(startPos+2):(startPos+2)-40]<=0;
            next_playerBullet[(startPos+3)<40?(startPos+3):(startPos+3)-40]<=0;
        end
    end
    else begin
        counter<=0;
        if(state!=1) begin
            startPos<=0;
            for(i=0;i<40;i++)
                next_playerBullet[i]<=0;
        end
    end
end
endmodule