// `timescale 1ns / 1ps

// module fir_tb;

//     // Inputs
//     reg clk;
//     reg rst;
//     reg signed [15:0] filter_in;

//     // Outputs
//     wire signed [31:0] filter_out;

//     // Instantiate the Unit Under Test (UUT)
//     my_fir uut (
//         .clk(clk), 
//         .rst(rst), 
//         .filter_in(filter_in), 
//         .filter_out(filter_out)
//     );

//     // define reset time
//     initial begin
//         rst = 1;
//         #15;
//         rst = 0;
//     end

//     // define clock
//     initial begin
//         clk = 0;
//         forever #10 clk = ~clk;  // 50 MHz clock
//     end

//     // define a RAM store input signal
//     reg signed [15:0] mem [0:199];  // 200 данных

//     // read data from disk (используем путь, который подходит под вашу систему)
//     initial begin
//         $readmemb("/home/rafael/Git/DSP/FIR/mathlab_python/dds_combined.data", mem);  // Замените на ваш путь
//     end

//     // send data to filter
//     integer i;
//     initial begin
//         #15;  // delay for reset
//         i = 0;
//         // Циклическая отправка данных в фильтр
//         forever begin
//             filter_in = mem[i];  // Подаем данные на вход фильтра
//             #20;  // Задержка для симуляции

//             // Увеличиваем индекс с цикличностью
//             i = i + 1;
//             if (i == 200) i = 0;  // Если достигли конца массива, возвращаемся в начало
//         end
//     end

//     // write data to txt file
//     integer file;
//     integer cnt = 0;
//     initial begin
//         file = $fopen("dataout1.txt", "w");  // Открытие файла для записи
//     end

//     // write data that was filtered by FIR to txt file
//     always @(posedge clk) begin
//         $fdisplay(file, filter_out);  // Записываем результат на выходе фильтра
//     end

//     always @(posedge clk) begin
//         $display("Data out (%d)------> : %d", cnt, filter_out);  // Выводим данные в консоль
//         cnt = cnt + 1;
//         if (cnt == 250) begin  // После обработки 250 данных (с учетом цикличности)
//             #20;
//             $fclose(file);  // Закрытие файла
//             rst = 0;
//             #20;
//             $stop;  // Останавливаем симуляцию
//         end
//     end

// endmodule


`timescale 1ns / 1ps

module fir_tb;

    // Inputs
    reg clk;
    reg rst;
    reg signed [15:0] filter_in;

    // Outputs
    wire signed [31:0] filter_out;

    // Instantiate the Unit Under Test (UUT)
    my_fir uut (
        .clk(clk), 
        .rst(rst), 
        .filter_in(filter_in), 
        .filter_out(filter_out)
    );

    // define reset time
    initial begin
        rst = 1;
        #15;
        rst = 0;
    end

    // define clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 50 MHz clock
    end

    // define a RAM store input signal
    reg signed [15:0] mem [0:199];  // 200 данных

    // input sin wave data from mem file
    initial
        $readmemb("data.mem", mem);

    reg [7:0] Address; 
    initial
        Address = 0; 

    // Read RAM data and give to filter
    always @(posedge clk or posedge rst) begin
        if (rst)
            filter_in <= 0;  // reset filter_in
        else
            filter_in <= mem[Address]; 
    end

    // Cycle Address to duplicate sin wave
    always @(posedge clk or posedge rst) begin
        if (rst)
            Address <= 0;
        else if (Address == 199)
            Address <= 0; 
        else
            Address <= Address + 1; 
    end 

endmodule

