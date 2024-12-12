module GeneratePlayerBullet (
    input clk,
    input [3:0] state,
    input [5:0] level,
    input [7:0] playerPosition[0:1],

    output reg [27:0] next_playerBullet[0:39]
);
integer counter;
integer i;
initial begin
    counter<=0;
    for(i=0;i<40;i++)
        next_playerBullet[i]<=0;
end
always @(posedge clk) begin
    if(state==2) begin
        if(counter<32'd160000000)
            counter++;
        else
            counter<=0;
    end
    else
        counter<=0;
end
always @(*) begin
    if(state==1||state==2) begin
        next_playerBullet[0]=(counter==32'd20000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+(1<<8):0;
        next_playerBullet[1]=(counter==32'd20000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}-3+(1<<8):0;
        next_playerBullet[2]=(counter==32'd20000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+3+(1<<8):0;
        next_playerBullet[3]=(counter==32'd40000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+(1<<8):0;
        next_playerBullet[4]=(counter==32'd40000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}-3+(1<<8):0;
        next_playerBullet[5]=(counter==32'd40000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+3+(1<<8):0;
        next_playerBullet[6]=(counter==32'd60000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+(1<<8):0;
        next_playerBullet[7]=(counter==32'd60000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}-3+(1<<8):0;
        next_playerBullet[8]=(counter==32'd60000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+3+(1<<8):0;
        next_playerBullet[9]=(counter==32'd80000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+(1<<8):0;
        next_playerBullet[10]=(counter==32'd80000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}-3+(1<<8):0;
        next_playerBullet[11]=(counter==32'd80000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+3+(1<<8):0;
        next_playerBullet[12]=(counter==32'd100000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+(1<<8):0;
        next_playerBullet[13]=(counter==32'd100000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}-3+(1<<8):0;
        next_playerBullet[14]=(counter==32'd100000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+3+(1<<8):0;
        next_playerBullet[15]=(counter==32'd120000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+(1<<8):0;
        next_playerBullet[16]=(counter==32'd120000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}-3+(1<<8):0;
        next_playerBullet[17]=(counter==32'd120000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+3+(1<<8):0;
        next_playerBullet[18]=(counter==32'd140000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+(1<<8):0;
        next_playerBullet[19]=(counter==32'd140000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}-3+(1<<8):0;
        next_playerBullet[20]=(counter==32'd140000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+3+(1<<8):0;
        next_playerBullet[21]=(counter==32'd160000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+(1<<8):0;
        next_playerBullet[22]=(counter==32'd160000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}-3+(1<<8):0;
        next_playerBullet[23]=(counter==32'd160000000)?{12'b100110001111,playerPosition[1],playerPosition[0]}+3+(1<<8):0;
        for(i=24;i<40;i++)
            next_playerBullet[i]=0;
    end
    else begin
        for(i=0;i<40;i++)
            next_playerBullet[i]=0;
    end
end
endmodule