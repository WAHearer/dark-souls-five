module KeyBoard(
    input  logic        clk,         // 系统时钟
    input  logic        rst_n,       // 异步复位，低电平有效
    input  logic        ps2_clk,     // PS/2时钟信号
    input  logic        ps2_data,    // PS/2数据信号
    output logic [7:0]  key_data,    // 按键扫描码
    output logic        key_valid,    // 数据有效信号
    output logic [127:0] key_status   // 所有按键状态(1:按下, 0:释放)
);

    // PS/2时钟同步寄存器
    logic [2:0] ps2_clk_sync;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            ps2_clk_sync <= 3'b111;
        else
            ps2_clk_sync <= {ps2_clk_sync[1:0], ps2_clk};
    end

    // PS/2时钟下降沿检测
    wire ps2_clk_neg = ps2_clk_sync[2] & ~ps2_clk_sync[1];

    // 数据接收状态机
    typedef enum logic [1:0] {
        IDLE,
        RECEIVE,
        CHECK,
        DONE
    } state_t;
    
    state_t state;
    logic [3:0] bit_cnt;
    logic [10:0] data_buff;
    logic is_break_code;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bit_cnt <= 4'd0;
            data_buff <= 11'd0;
            key_valid <= 1'b0;
            key_data <= 8'd0;
            is_break_code <= 1'b0;
            key_status <= 512'd0;
        end else begin
            key_valid <= 1'b0;
            
            case (state)
                IDLE: begin
                    if (ps2_clk_neg && !ps2_data) begin  // 检测起始位
                        state <= RECEIVE;
                        bit_cnt <= 4'd0;
                        data_buff <= {ps2_data, 10'd0};
                    end
                end

                RECEIVE: begin
                    if (ps2_clk_neg) begin
                        data_buff <= {ps2_data, data_buff[10:1]};
                        bit_cnt <= bit_cnt + 4'd1;
                        if (bit_cnt == 4'd9)
                            state <= CHECK;
                    end
                end

                CHECK: begin
                    if (data_buff[8:1] == 8'hF0)  // break code前导码
                        is_break_code <= 1'b1;
                    else begin
                        key_valid <= 1'b1;
                        key_data <= data_buff[8:1];
                        
                        // 更新按键状态
                        if (is_break_code) begin
                            key_status[data_buff[8:1]] <= 1'b0;
                            is_break_code <= 1'b0;
                        end else begin
                            key_status[data_buff[8:1]] <= 1'b1;
                        end
                    end
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule