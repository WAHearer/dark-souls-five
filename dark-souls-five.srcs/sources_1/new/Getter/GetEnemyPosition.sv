module GetEnemyPosition (
    input clk,
    input [3:0] state,
    input [5:0] level,
    input [7:0] enemyPosition[0:1],

    output reg [7:0] next_enemyPosition[0:1]
);
integer counter1,counter2;
reg flag;
always @(posedge clk) begin
    if(state==2) begin
        if(level==1) begin
            if(counter1<32'd300000000)
                counter1<=counter1+1;
            else begin
                counter1<=0;
                flag<=~flag;
            end
            if(counter2<32'd4000000)
                counter2<=counter2+1;
            else begin
                counter2<=0;
                if(flag==0)
                    next_enemyPosition[0]<=enemyPosition[0]-1;
                else
                    next_enemyPosition[0]<=enemyPosition[0]+1;
            end
        end
    end
    else if(state!=1) begin
        counter1<=0;
        counter2<=0;
        flag<=0;
        next_enemyPosition[0]<=enemyPosition[0];
        next_enemyPosition[1]<=enemyPosition[1];
    end
end
endmodule