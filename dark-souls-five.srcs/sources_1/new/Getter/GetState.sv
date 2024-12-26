module GetState (
    input clk,enter,pause,left,down,right,
    input [3:0] state,
    input [9:0] textId,
    input [5:0] level,
    input [20:0] playerHp,
    input [20:0] enemyHp,

    output reg [3:0] next_state,
    output reg [9:0] next_textId,
    output reg [5:0] next_level,
    output reg [1:0] next_attackLevel,
    output reg [1:0] next_healthLevel,
    output reg [1:0] next_dexLevel
);
reg ableToPress;
integer counter;
initial begin
    next_state<=0;
    next_level<=0;
    next_textId<=0;
    next_attackLevel<=0;
    next_healthLevel<=0;
    next_dexLevel<=0;
    counter<=0;
    ableToPress<=1;
end
always @(posedge clk) begin
    if(ableToPress==0) begin
        if(counter<32'd20000000)
            counter++;
        else begin
            counter<=0;
            ableToPress<=1;
        end
    end
    case(state)
        0:begin
            if(enter&&ableToPress) begin
                ableToPress<=0;
                next_state<=7;
                next_textId<=0;
            end
        end
        1:begin
            if(enter)
                next_state<=2;
        end
        2:begin
            if(playerHp==0)
                next_state<=5;
            else if(enemyHp==0)begin
                if(level==5)
                    next_state<=4;
                else
                    next_state<=3;
            end
            else if(pause)
                next_state<=1;
        end
        3:begin
            if(enter&&ableToPress) begin
                ableToPress<=0;
                next_state<=7;
            end
        end
        4:begin
            if(pause&&ableToPress) begin
                ableToPress<=0;
                next_state<=0;
            end
        end
        5:begin
            if(enter&&ableToPress) begin
                ableToPress<=0;
                next_state<=2;
            end
            if(pause&&ableToPress) begin
                ableToPress<=0;
                next_state<=0;
            end
        end
        6:begin
            if(enter&&ableToPress) begin
                ableToPress<=0;
                case(textId)
                    0:begin
                        next_textId<=1;
                        next_level<=1;
                    end
                    1:begin
                        next_textId<=2;
                        next_state<=2;
                    end
                    2:begin
                        next_textId<=3;
                        next_level<=2;
                    end
                    3:begin
                        next_textId<=4;
                        next_state<=2;
                    end
                    4:begin
                        next_textId<=5;
                        next_level<=3;
                    end
                    5:begin
                        next_textId<=6;
                        next_state<=2;
                    end
                    6:begin
                        next_textId<=7;
                        next_level<=4;
                    end
                    7:begin
                        next_textId<=8;
                        next_state<=2;
                    end
                    8:begin
                        next_textId<=9;
                        next_level<=5;
                    end
                    9:begin
                        next_state<=2;
                    end
                endcase
            end
        end
        7:begin
            if(ableToPress&&left&&next_attackLevel<3) begin
                ableToPress<=0;
                next_attackLevel++;
                next_state<=6;
            end
            else if(ableToPress&&down&&next_healthLevel<3) begin
                ableToPress<=0;
                next_healthLevel++;
                next_state<=6;
            end
            else if(ableToPress&&right&&next_dexLevel<3) begin
                ableToPress<=0;
                next_dexLevel++;
                next_state<=6;
            end
        end
    endcase
end
endmodule