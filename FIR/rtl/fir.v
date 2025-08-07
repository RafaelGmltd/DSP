`timescale 1ns / 1ps

module FIR_Filter
#(
    parameter INPUT_WIDTH  = 16,
    parameter OUTPUT_WIDTH = 32,
    parameter TAPS = 32
)
(
    input  wire                    clk,
    input  wire [INPUT_WIDTH-1:0] data_in,
    output reg  [OUTPUT_WIDTH-1:0] data_out
);

    // Коэффициенты фильтра (signed 11-бит)
    wire signed [10:0] coeffs [0:31];
    assign coeffs[ 0] = 11'sd0;  assign coeffs[ 1] = 11'sd1;
    assign coeffs[ 2] = 11'sd2;  assign coeffs[ 3] = 11'sd2;
    assign coeffs[ 4] = 11'sd2;  assign coeffs[ 5] = 11'sd2;
    assign coeffs[ 6] =  -11'sd1;  assign coeffs[ 7] =  -11'sd5;
    assign coeffs[ 8] =  -11'sd14; assign coeffs[ 9] =  -11'sd25;
    assign coeffs[10] =  -11'sd40; assign coeffs[11] =  -11'sd56;
    assign coeffs[12] =  -11'sd73; assign coeffs[13] =  -11'sd89;
    assign coeffs[14] =  -11'sd103; assign coeffs[15] =  -11'sd111;
    assign coeffs[16] =  11'sd1023;assign coeffs[17] =  -11'sd111;
    assign coeffs[18] =  -11'sd103; assign coeffs[19] =  -11'sd89;
    assign coeffs[20] =  -11'sd73; assign coeffs[21] =  -11'sd56;
    assign coeffs[22] =  -11'sd40; assign coeffs[23] =  -11'sd25;
    assign coeffs[24] =  -11'sd14;  assign coeffs[25] =  -11'sd5;
    assign coeffs[26] = -11'sd1;  assign coeffs[27] = 11'sd2;
    assign coeffs[28] = 11'sd2;  assign coeffs[29] = 11'sd2;
    assign coeffs[30] = 11'sd2;  assign coeffs[31] = 11'sd1;

    // Задерживающая линия - FIFO для входных данных (signed 16 бит)
    reg signed [INPUT_WIDTH-1:0] delay_line [0:TAPS-1];

    // Массив произведений (signed)
    reg signed [26:0] products [0:TAPS-1]; // 16 + 11 bits = 27 bits (включая знак)

    // Суммирующие стадии (pipeline)
    reg signed [27:0] sum_stage1 [0:(TAPS/2)-1];
    reg signed [28:0] sum_stage2 [0:(TAPS/4)-1];
    reg signed [29:0] sum_stage3 [0:(TAPS/8)-1];
    reg signed [30:0] sum_stage4 [0:(TAPS/16)-1];
    reg signed [31:0] final_sum;

    integer i;

    // Задерживающая линия - сдвиг данных
    always @(posedge clk) begin
        for (i = TAPS-1; i > 0; i = i - 1) begin
            delay_line[i] <= delay_line[i-1];
        end
        delay_line[0] <= $signed(data_in);  // конвертация входа в signed
    end

    // Умножение входных значений на коэффициенты
    always @(posedge clk) begin
        for (i = 0; i < TAPS; i = i + 1) begin
            products[i] <= delay_line[i] * coeffs[i];
        end
    end

    // Суммирующая стадия 1: 32 -> 16
    always @(posedge clk) begin
        for (i = 0; i < TAPS/2; i = i + 1) begin
            sum_stage1[i] <= $signed(products[2*i]) + $signed(products[2*i+1]);
        end
    end

    // Суммирующая стадия 2: 16 -> 8
    always @(posedge clk) begin
        for (i = 0; i < TAPS/4; i = i + 1) begin
            sum_stage2[i] <= $signed(sum_stage1[2*i]) + $signed(sum_stage1[2*i+1]);
        end
    end

    // Суммирующая стадия 3: 8 -> 4
    always @(posedge clk) begin
        for (i = 0; i < TAPS/8; i = i + 1) begin
            sum_stage3[i] <= $signed(sum_stage2[2*i]) + $signed(sum_stage2[2*i+1]);
        end
    end

    // Суммирующая стадия 4: 4 -> 2
    always @(posedge clk) begin
        for (i = 0; i < TAPS/16; i = i + 1) begin
            sum_stage4[i] <= $signed(sum_stage3[2*i]) + $signed(sum_stage3[2*i+1]);
        end
    end

    // Итоговое суммирование: 2 -> 1
    always @(posedge clk) begin
        final_sum <= $signed(sum_stage4[0]) + $signed(sum_stage4[1]);
    end

    // Вывод результата
    always @(posedge clk) begin
        data_out <= final_sum;
    end

endmodule
