module GetState (
    input enter,pause,
    input [3:0] state,
    input [9:0] textId,
    input [5:0] level,
    input [20:0] playerHp,
    input [20:0] enemyHp,

    output reg [3:0] next_state,
    output reg [9:0] next_textId,
    output reg [5:0] next_level
);
always @(posedge enter or posedge pause) begin
    case(state)
        0:begin
            if(enter) begin
                next_state<=6;
                next_textId<=0;
            end
        end
        1:begin
            if(enter)
                next_state<=2;
        end
        2:begin
            if(pause)
                next_state<=1;
            else if(playerHp==0)
                next_state<=5;
            else if(enemyHp==0)
                next_state<=3;
        end
        3:begin
            if(enter)
                next_state<=6;
        end
        6:begin
            if(enter) begin
                case(textId)
                    0:next_textId<=1;
                    1:next_textId<=2;
                    2:begin
                        next_textId<=3;
                        next_state<=2;
                        next_level<=1;
                    end
                    3:next_textId<=4;
                    4:next_textId<=5;
                    5:next_textId<=6;
                    6:begin
                        next_textId<=7;
                        next_state<=2;
                        next_level<=2;
                    end
                endcase
            end
        end
    endcase
end
endmodule