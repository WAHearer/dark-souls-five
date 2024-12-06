module KeyBoard(
    input  logic        clk,            
    input  logic        ps2_clk,
    input  logic        ps2_data,
    output logic [7:0]  key_data,    
    output logic        key_valid,    
    output logic [127:0] key_status  
);

    // 同步PS/2时钟信号
    logic ps2_clk_sync1, ps2_clk_sync2, ps2_clk_sync;
    always_ff @(posedge clk) begin
        ps2_clk_sync1 <= ps2_clk;
        ps2_clk_sync2 <= ps2_clk_sync1;
    end
    assign ps2_clk_sync = ps2_clk_sync2;

    // 检测时钟下降沿
    logic ps2_clk_prev;
    logic ps2_clk_neg;
    always_ff @(posedge clk) begin
        ps2_clk_prev <= ps2_clk_sync;
    end
    assign ps2_clk_neg = ps2_clk_prev & ~ps2_clk_sync;

    // 数据接收逻辑
    logic [10:0] data_reg = 11'h7FF;   // 11位移位寄存器
    logic [3:0]  bit_cnt = 4'd0;       // 位计数器
    logic receiving = 1'b0;            // 接收状态标志

    always_ff @(posedge clk) begin
        key_valid <= 1'b0;
        
        if (ps2_clk_neg) begin
            // 开始接收数据
            if (!receiving && !ps2_data) begin
                receiving <= 1'b1;
                bit_cnt <= 4'd0;
                data_reg <= {ps2_data, 10'h3FF};
            end
            // 继续接收数据位
            else if (receiving) begin
                bit_cnt <= bit_cnt + 4'd1;
                data_reg <= {ps2_data, data_reg[10:1]};
                
                // 接收完成
                if (bit_cnt == 4'd9) begin
                    receiving <= 1'b0;
                    // 检查起始位、停止位和奇偶校验
                    if (!data_reg[0] && data_reg[10] &&
                        ^{data_reg[9:1]} == 1'b1) begin
                        key_valid <= 1'b1;
                        key_data <= data_reg[8:1];
                    end
                end
            end
        end
    end

    // 维护按键状态表
    logic is_break_code = 1'b0;
    logic [7:0] prev_key_data = 8'h0;
    
    always_ff @(posedge clk) begin
        if (key_valid) begin
            if (key_data == 8'hF0)
                is_break_code <= 1'b1;
            else begin
                if (is_break_code) begin
                    key_status[key_data] <= 1'b0;
                    is_break_code <= 1'b0;
                end else begin
                    key_status[key_data] <= 1'b1;
                end
                prev_key_data <= key_data;
            end
        end
    end

endmodule