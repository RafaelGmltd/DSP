module cast #(
    parameter INPUT_WIDTH  = 9,
    parameter OUTPUT_WIDTH = 16
)(
    input  wire [INPUT_WIDTH-1:0] din,
    output wire [OUTPUT_WIDTH-1:0] dout
);

    // Расширение знака
    assign dout = {{(OUTPUT_WIDTH-INPUT_WIDTH){din[INPUT_WIDTH-1]}}, din};

endmodule


// module cast #(
//     parameter INPUT_WIDTH  = 9,
//     parameter OUTPUT_WIDTH = 16
// )(
//     input  wire [INPUT_WIDTH-1:0]  din,
//     output reg  [OUTPUT_WIDTH-1:0] dout
// );

//     reg signed [INPUT_WIDTH-1:0] din_signed;
//     reg signed [OUTPUT_WIDTH-1:0] tmp_out;

//     always @(*) begin
//         din_signed = $signed(din);
//         tmp_out    = din_signed; // расширение знака автоматически
//         dout       = tmp_out;
//     end

// endmodule
