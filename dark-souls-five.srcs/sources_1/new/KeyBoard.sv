module KeyBoard(
    input  logic        clk,         
    input  logic        rst_n,       
    input  logic        UART_TXD_IN,
    input  logic        UART_RXD_OUT,
    input  logic        UART_CTS,
    input  logic        UART_RTS,
    output logic [7:0]  key_data,    
    output logic        key_valid,    
    output logic [127:0] key_status  
);

    // UART 接收参数设置
    localparam BAUD_RATE = 1500000;
    localparam CLOCK_FREQ = 100000000;
    
    // UART 接收相关信号
    logic [7:0] rx_data;
    logic rx_valid;
    
    // HID 报文缓存
    logic [7:0] hid_buffer[8];
    logic [2:0] byte_count;
    
    // UART 接收器实例化
    uart_rx #(
        .CLOCK_FREQ(CLOCK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uart_rx_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rx(UART_RXD_OUT),
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

    // HID 报文处理状态机
    enum logic [1:0] {IDLE, RECEIVE, PROCESS} state;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            byte_count <= '0;
            key_valid <= 1'b0;
            key_status <= '0;
            key_data <= '0;
        end else begin
            case (state)
                IDLE: begin
                    if (rx_valid) begin
                        state <= RECEIVE;
                        hid_buffer[0] <= rx_data;
                        byte_count <= 3'd1;
                    end
                end
                
                RECEIVE: begin
                    if (rx_valid) begin
                        hid_buffer[byte_count] <= rx_data;
                        if (byte_count == 3'd7) begin
                            state <= PROCESS;
                            byte_count <= '0;
                        end else begin
                            byte_count <= byte_count + 1'b1;
                        end
                    end
                end
                
                PROCESS: begin
                    // 处理按键状态
                    key_valid <= 1'b1;
                    key_data <= hid_buffer[2]; // 通常第3个字节包含按键扫描码
                    
                    // 更新键盘状态表
                    // 修饰键状态 (Ctrl, Shift, Alt 等)
                    key_status[7:0] <= hid_buffer[0];
                    
                    // 常规按键状态
                    for (int i = 2; i < 8; i++) begin
                        if (hid_buffer[i] != 8'h00) begin
                            key_status[hid_buffer[i]] <= 1'b1;
                        end
                    end
                    
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule

module uart_rx #(
    parameter CLOCK_FREQ = 1500000,
    parameter BAUD_RATE = 100000000
)(
    input  logic clk,
    input  logic rst_n,
    input  logic rx,
    output logic [7:0] rx_data,
    output logic rx_valid
);
    // 计算每个波特周期的时钟数
    localparam CLKS_PER_BIT = CLOCK_FREQ/BAUD_RATE;
    
    // 状态定义
    typedef enum logic [2:0] {
        IDLE,       // 空闲等待起始位
        START_BIT,  // 检测起始位
        DATA_BITS,  // 接收数据位
        STOP_BIT,   // 检测停止位
        CLEANUP     // 完成清理
    } state_t;
    
    // 寄存器定义
    state_t state;
    logic [$clog2(CLKS_PER_BIT)-1:0] clk_counter;
    logic [2:0] bit_counter;
    logic [7:0] rx_data_reg;
    
    // 同步器防止亚稳态
    logic rx_sync1, rx_sync2;
    always_ff @(posedge clk) begin
        {rx_sync2, rx_sync1} <= {rx_sync1, rx};
    end
    
    // 主状态机
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            clk_counter <= '0;
            bit_counter <= '0;
            rx_data_reg <= '0;
            rx_valid <= 1'b0;
            rx_data <= '0;
        end else begin
            case (state)
                IDLE: begin
                    rx_valid <= 1'b0;
                    if (rx_sync2 == 1'b0) begin  // 检测起始位
                        state <= START_BIT;
                        clk_counter <= '0;
                    end
                end
                
                START_BIT: begin
                    if (clk_counter == CLKS_PER_BIT/2) begin
                        if (rx_sync2 == 1'b0) begin  // 确认起始位
                            clk_counter <= '0;
                            state <= DATA_BITS;
                        end else
                            state <= IDLE;
                    end else
                        clk_counter <= clk_counter + 1'b1;
                end
                
                DATA_BITS: begin
                    if (clk_counter == CLKS_PER_BIT-1) begin
                        clk_counter <= '0;
                        rx_data_reg[bit_counter] <= rx_sync2;
                        
                        if (bit_counter == 3'd7) begin
                            bit_counter <= '0;
                            state <= STOP_BIT;
                        end else
                            bit_counter <= bit_counter + 1'b1;
                    end else
                        clk_counter <= clk_counter + 1'b1;
                end
                
                STOP_BIT: begin
                    if (clk_counter == CLKS_PER_BIT-1) begin
                        if (rx_sync2 == 1'b1) begin  // 验证停止位
                            rx_valid <= 1'b1;
                            rx_data <= rx_data_reg;
                        end
                        state <= CLEANUP;
                        clk_counter <= '0;
                    end else
                        clk_counter <= clk_counter + 1'b1;
                end
                
                CLEANUP: begin
                    rx_valid <= 1'b0;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule