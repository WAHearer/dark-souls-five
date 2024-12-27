module Music(
    input clk,              // 100MHz 时钟输入
    output sd,
    output reg pwm        // PWM 输出
);
assign sd = 1;
reg start;

// 参数定义
parameter SAMPLE_RATE = 4000;  // 采样率4000Hz
parameter CLK_FREQ = 100_000_000;  // 时钟频率100MHz
parameter DIVIDER = CLK_FREQ/SAMPLE_RATE;  // 分频系数

// 内部信号
reg [31:0] sample_cnt;     // 采样计数器
reg [17:0] addr;          // ROM地址
wire [7:0] music_data;    // ROM数据
reg [15:0] pwm_cnt;       // PWM计数器

// ROM实例化
blk_mem_gen_3 music(
    .clka(clk),
    .addra(addr),
    .douta(music_data)
);

// 4000Hz采样时钟生成
always @(posedge clk) begin
    if (sample_cnt >= DIVIDER-1) begin
        sample_cnt <= 0;
        start <= 1'b1;
    end else begin
        sample_cnt <= sample_cnt + 1'b1;
        start <= 1'b0;
    end
end

// ROM地址控制
always @(posedge clk) begin
    if (start) begin
        if (addr >= 240000)  // ROM地址上限
            addr <= 0;
        else
            addr <= addr + 1;
    end
end

// PWM输出生成
always @(posedge clk) begin
    pwm_cnt <= start ? 0 : pwm_cnt + 1;
    pwm <= (pwm_cnt < (music_data << 7 )) ? 1'b1 : 1'b0;
end

endmodule