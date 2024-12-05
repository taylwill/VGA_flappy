// Updated bitgen module
module bitgen(
    input clk,
    input start_game, end_game,
    input [7:0] bird_1_height,
    input [7:0] pipe_height,
    input [9:0] h_counter, // Horizontal pixel counter from VGA_timer
    input [9:0] v_counter, // Vertical pixel counter from VGA_timer
    output [2:0] rgb // RGB output (2: Green, 1: Blue, 0: Red)
);

    // Internal positions controlled by the controller
    wire [9:0] pipe_x; // Horizontal position of the pipe
    wire [9:0] square_y1; // Vertical position of the first square
    wire [9:0] square_y2; // Vertical position of the second square

    // RGB wires from submodules
    wire [2:0] pixel_rgb;
    wire [2:0] startscreen_rgb;
    wire [2:0] endscreen_rgb;

    // Instantiate the pixel calculation module
    pixel_calc pixel_calc_inst(
        .h_counter(h_counter),
        .v_counter(v_counter),
        .bird_1_height(bird_1_height),
        .pipe_height(pipe_height),
        .pipe_x(pipe_x),
        .square_y1(square_y1),
        .square_y2(square_y2),
        .rgb(pixel_rgb)
    );

    // Instantiate the startscreen module
    startscreen startscreen_inst(
        .h_counter(h_counter),
        .v_counter(v_counter),
        .rgb(startscreen_rgb)
    );

    // Instantiate the endscreen module
    endscreen endscreen_inst(
        .h_counter(h_counter),
        .v_counter(v_counter),
        .rgb(endscreen_rgb)
    );

    // Select RGB output based on start game signal and the endgame signal
    assign rgb = end_game ? endscreen_rgb : (start_game ? startscreen_rgb : pixel_rgb);

endmodule

// New module for pixel calculations
module pixel_calc(
    input [9:0] h_counter,
    input [9:0] v_counter,
    input [7:0] bird_1_height,
    input [7:0] pipe_height,
    input [9:0] pipe_x,
    input [9:0] square_y1,
    input [9:0] square_y2,
    output reg [2:0] rgb
);

    // Screen resolution
    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;

    // Pipe dimensions
    parameter PIPE_WIDTH = 50;
    parameter PIPE_HEIGHT = 170;
    parameter BIRD_SIZE = 15;

    // Position of the first white square
    parameter SQUARE_SIZE = 30; // Size of the square (30x30 pixels)
    parameter SQUARE_X = (SCREEN_WIDTH - SQUARE_SIZE) / 2; // Center horizontally

    always @(*) begin
        // Default background color (black)
        rgb = 3'b000;

        // Pipe: Top and bottom sections
        if ((h_counter >= pipe_x && h_counter < (pipe_x + PIPE_WIDTH) &&
             (v_counter < PIPE_HEIGHT || v_counter >= (SCREEN_HEIGHT - PIPE_HEIGHT)))) begin
            rgb = 3'b010; // Green
        end
        // Draw the first white square
        else if ((h_counter >= SQUARE_X) && (h_counter < (SQUARE_X + SQUARE_SIZE)) &&
                 (v_counter >= square_y1) && (v_counter < (square_y1 + SQUARE_SIZE))) begin
            rgb = 3'b111; // White color
        end
    end
endmodule

module startscreen(
    input [9:0] h_counter,
    input [9:0] v_counter,
    output reg [2:0] rgb
);

    // Screen resolution
    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;

    // Position and size of the "FLAPPY" text blocks
    parameter TEXT_START_X = 220;
    parameter TEXT_START_Y = 180;
    parameter BLOCK_SIZE = 20;

    always @(*) begin
        // Default background color (black)
        rgb = 3'b000;

        if (
            // F
            ((h_counter >= TEXT_START_X && h_counter < TEXT_START_X + BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y && v_counter < TEXT_START_Y + 5 * BLOCK_SIZE)) ||
            ((h_counter >= TEXT_START_X && h_counter < TEXT_START_X + 3 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y && v_counter < TEXT_START_Y + BLOCK_SIZE)) ||
            ((h_counter >= TEXT_START_X && h_counter < TEXT_START_X + 3 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y + 2 * BLOCK_SIZE && v_counter < TEXT_START_Y + 3 * BLOCK_SIZE)) ||

            // L
            ((h_counter >= TEXT_START_X + 5 * BLOCK_SIZE && h_counter < TEXT_START_X + 6 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y && v_counter < TEXT_START_Y + 5 * BLOCK_SIZE)) ||
            ((h_counter >= TEXT_START_X + 5 * BLOCK_SIZE && h_counter < TEXT_START_X + 8 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y + 4 * BLOCK_SIZE && v_counter < TEXT_START_Y + 5 * BLOCK_SIZE)) ||

            // A
            ((h_counter >= TEXT_START_X + 10 * BLOCK_SIZE && h_counter < TEXT_START_X + 11 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y && v_counter < TEXT_START_Y + 5 * BLOCK_SIZE)) ||
            ((h_counter >= TEXT_START_X + 11 * BLOCK_SIZE && h_counter < TEXT_START_X + 12 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y + BLOCK_SIZE && v_counter < TEXT_START_Y + 4 * BLOCK_SIZE)) ||
            ((h_counter >= TEXT_START_X + 10 * BLOCK_SIZE && h_counter < TEXT_START_X + 13 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y && v_counter < TEXT_START_Y + BLOCK_SIZE)) ||
            ((h_counter >= TEXT_START_X + 10 * BLOCK_SIZE && h_counter < TEXT_START_X + 13 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y + 2 * BLOCK_SIZE && v_counter < TEXT_START_Y + 3 * BLOCK_SIZE)) ||

            // P (First)
            ((h_counter >= TEXT_START_X + 15 * BLOCK_SIZE && h_counter < TEXT_START_X + 16 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y && v_counter < TEXT_START_Y + 5 * BLOCK_SIZE)) ||
            ((h_counter >= TEXT_START_X + 16 * BLOCK_SIZE && h_counter < TEXT_START_X + 17 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y && v_counter < TEXT_START_Y + 2 * BLOCK_SIZE)) ||
            ((h_counter >= TEXT_START_X + 15 * BLOCK_SIZE && h_counter < TEXT_START_X + 18 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y && v_counter < TEXT_START_Y + BLOCK_SIZE)) ||
            ((h_counter >= TEXT_START_X + 15 * BLOCK_SIZE && h_counter < TEXT_START_X + 18 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y + 2 * BLOCK_SIZE && v_counter < TEXT_START_Y + 3 * BLOCK_SIZE)) ||

            // P (Second)
            ((h_counter >= TEXT_START_X + 20 * BLOCK_SIZE && h_counter < TEXT_START_X + 21 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y && v_counter < TEXT_START_Y + 5 * BLOCK_SIZE)) ||
            ((h_counter >= TEXT_START_X + 21 * BLOCK_SIZE && h_counter < TEXT_START_X + 22 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y && v_counter < TEXT_START_Y + 2 * BLOCK_SIZE)) ||
            ((h_counter >= TEXT_START_X + 20 * BLOCK_SIZE && h_counter < TEXT_START_X + 23 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y && v_counter < TEXT_START_Y + BLOCK_SIZE)) ||
            ((h_counter >= TEXT_START_X + 20 * BLOCK_SIZE && h_counter < TEXT_START_X + 23 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y + 2 * BLOCK_SIZE && v_counter < TEXT_START_Y + 3 * BLOCK_SIZE)) ||

            // Y
            ((h_counter >= TEXT_START_X + 25 * BLOCK_SIZE && h_counter < TEXT_START_X + 26 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y + 2 * BLOCK_SIZE && v_counter < TEXT_START_Y + 5 * BLOCK_SIZE)) ||
            ((h_counter >= TEXT_START_X + 26 * BLOCK_SIZE && h_counter < TEXT_START_X + 27 * BLOCK_SIZE) &&
             (v_counter >= TEXT_START_Y && v_counter < TEXT_START_Y + 3 * BLOCK_SIZE))
        ) begin
            rgb = 3'b111; // White
        end
    end
endmodule

module endscreen(
    input [9:0] h_counter,
    input [9:0] v_counter,
    output reg [2:0] rgb
);

    // Screen resolution
    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;

    // Position and size of the frowny face
    parameter FACE_CENTER_X = 320;
    parameter FACE_CENTER_Y = 240;
    parameter BLOCK_SIZE = 10;

    always @(*) begin
        // Default background color (black)
        rgb = 3'b000;

        // Draw the frowny face as a blocky representation
        if (
            // Left eye
            ((h_counter >= FACE_CENTER_X - 50 && h_counter < FACE_CENTER_X - 40) &&
             (v_counter >= FACE_CENTER_Y - 40 && v_counter < FACE_CENTER_Y - 30)) ||

            // Right eye
            ((h_counter >= FACE_CENTER_X + 40 && h_counter < FACE_CENTER_X + 50) &&
             (v_counter >= FACE_CENTER_Y - 40 && v_counter < FACE_CENTER_Y - 30)) ||

            // Mouth (frown)
            ((h_counter >= FACE_CENTER_X - 50 && h_counter < FACE_CENTER_X - 40) &&
             (v_counter >= FACE_CENTER_Y + 20 && v_counter < FACE_CENTER_Y + 30)) ||
            ((h_counter >= FACE_CENTER_X - 40 && h_counter < FACE_CENTER_X - 30) &&
             (v_counter >= FACE_CENTER_Y + 30 && v_counter < FACE_CENTER_Y + 40)) ||
            ((h_counter >= FACE_CENTER_X - 30 && h_counter < FACE_CENTER_X + 30) &&
             (v_counter >= FACE_CENTER_Y + 40 && v_counter < FACE_CENTER_Y + 50)) ||
            ((h_counter >= FACE_CENTER_X + 30 && h_counter < FACE_CENTER_X + 40) &&
             (v_counter >= FACE_CENTER_Y + 30 && v_counter < FACE_CENTER_Y + 40)) ||
            ((h_counter >= FACE_CENTER_X + 40 && h_counter < FACE_CENTER_X + 50) &&
             (v_counter >= FACE_CENTER_Y + 20 && v_counter < FACE_CENTER_Y + 30))
        ) begin
            rgb = 3'b111; // White
        end
    end
endmodule

