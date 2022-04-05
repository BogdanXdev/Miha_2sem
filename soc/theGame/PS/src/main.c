#include <stdio.h>
#include <stdint.h>

// TO DO: library of gaming mechanics

//  |(0,0)____________(640,0)|      coordinates of everything in
//  |________________________|   this project are interpreted
//  |________________________|   in this manner
//  |________________________|
//  |(0,512)________(640,512)|

const uint16_t horizontal = 640;    // resolution x
const uint16_t vertical = 580;      // resolution y
const uint16_t primitive_side = 10; // also it is a basic increment
const uint16_t pad0_x = 0;
const uint16_t pad1_x = horizontal - primitive_side;

// structure of basic object building element
typedef struct
{
    uint16_t x;
    uint16_t y;

    uint16_t side;
} primitive;

// objects
primitive pad_0[3] = {{pad0_x, 0, primitive_side}, {pad0_x, 10, primitive_side}, {pad0_x, 20, primitive_side}};
primitive ball[1] = {{50, 50, primitive_side}};
primitive pad_1[3] = {{pad1_x, 0, primitive_side}, {pad1_x, 10, primitive_side}, {pad1_x, 20, primitive_side}};

// object movement vector
typedef struct
{
    sint16_t x_vec;
    sint16_t y_vec;
} _2d_vector;

_2d_vector _2d_vector_ball;
_2d_vector _2d_vector_pad0;
_2d_vector _2d_vector_pad1;

void object_movement(primitive *primitives_of_object, uint16_t obj_size, _2d_vector movement_increment)
{
    for (i = 0; i < obj_size; i++)
    {
        primitives_of_object[i].x = primitives_of_object[i].x + movement_increment.x_vec;
        primitives_of_object[i].y = primitives_of_object[i].y + movement_increment.y_vec;
    }
}

void ballvector_change()
{
    // time for a vector change, so now old vector should be updated
    //  3 variants are possible in terms of y movement projection and 2 in x

    // MOVEMENT_VECTOR_Y_PROJECTION
    //  |PP| |  | |50vt|
    //  |AA| BALL |0 eo|
    //  |DD| |  | |-50r|
    if (_2d_vector_ball.y_vec == 0)
    {
        _2d_vector_ball.y_vec = 0;
    }
    else if (_2d_vector_ball.y_vec == primitive_side)
    {
        _2d_vector_ball.y_vec = -primitive_side;
    }
    else if (_2d_vector_ball.y_vec == -primitive_side)
    {
        _2d_vector_ball.y_vec = primitive_side;
    }
    if (_2d_vector_ball.x_vec == primitive_side)
    {
        _2d_vector_ball.x_vec = -primitive_side;
    }
    else if (_2d_vector_ball.x_vec == -primitive_side)
    {
        _2d_vector_ball.x_vec = primitive_side;
    }
}
// TO DO: should be corrected in following way:
// walls behind the platforms = GAME OVER
// 640 px walls are providing bounce of the ball
void ball_collision(primitive *ball, primitive *pad0, primitive *pad1)
{ // ball out of the gaming field
    if (ball
            [0]
                .x == 0 || ball[0].x == 640 ||
                                      ball[0].y = 0 || ball[0].y == 512)
    {
        printf("GAME OVER!!!/n Take it easy. Go get some coffee. Relax./n");
    }

    for (i = 0; i < 2; i++)
    { // ball collissions with the platforms
        if (ball
                [0]
                    .x == pad0_x + primitive_side && ball[0].y == pad0[i].y)
        {
            printf("collision with pad0 /n");
            ballvector_change();
        }
        if (ball
                    [0]
                        .x +
                primitive_side == pad1_x && ball[0].y == pad1[i].y)
        {
            printf("collision with pad1 /n");
            ballvector_change();
        }
    }
}

void ball_move()
{
    ball_collision();
    object_movement(ball, 1, _2d_vector_ball);
}

void padvector_change()
{
    _I("Waiting for button press..."); // 5 buttons implemented
    while ((*(mem_lwh2f)&0x1))         /* polling for button to be pressed */
        _2d_vector_pad0.y_vec = primitive_side;
    while ((*(mem_lwh2f)&0x2))
        _2d_vector_pad0.y_vec = primitive_side;
    while ((*(mem_lwh2f)&0x4))
        _2d_vector_pad1.y_vec = -primitive_side;
    while ((*(mem_lwh2f)&0x8))
        _2d_vector_pad1.y_vec = primitive_side;
    while ((*(mem_lwh2f)&0x16))
        ;
}

void pads_move()
{
    padvector_change();
    object_movement(pad_0, 3, _2d_vector_pad0);
    object_movement(pad_1, 3, _2d_vector_pad1);
}

uint32_t pixel_nmbr = 0;
void pixel_cnt()
{
    pixel_nmbr++;
}

uint32_t line_nmbr = 0;
void line_cnt()
{
    line_nmbr++;
}

uint8_t pixel = 0;

// compare object pixel with streaming pixel 
bool pixel_compare(uint8_t x, uint8_t y, primitive* obj, uint8_t obj_size) {
    for (uint8_t i = 0; i < obj_size; i++) {
        if (obj[i].x =< x && x < obj[i].x + obj[i].side && obj[i].y =< y && y < obj[i].y + obj[i].side){
            return true;
        } 
    }
    return false;
}

/* utilities */
#define _I(fmt, args...) printf(fmt "\n", ##args)
#define _E(fmt, args...) printf("ERROR: " fmt "\n", ##args)
/* physical address spans */
#define LWHPS2FPGA_BASE 0xff200000 /* physical address of the LWH2F bridge */
#define LWHPS2FPGA_SPAN 0x3000     /* address span to map */
#define HPS2FPGA_BASE 0xc0000000   /* physical address of the H2F bridge */
#define HPS2FPGA_SPAN 0x1000       /* address span to map */

void main()
{

    int fd;                            /* file descriptor */
    volatile unsigned char *mem_lwh2f; /* memory pointer for LW HPS2FPGA bridge */
    volatile unsigned char *mem_h2f;   /* memory pointer for LW HPS2FPGA bridge */

    if ((fd = open("/dev/mem", O_RDWR | O_SYNC)) < 0)
    {
        _E("Failed to open \"/dev/mem\" file");
        return -1;
    }

    _I("Mapping physical address - LWHPS2FPGA");
    mem_lwh2f = mmap(0, LWHPS2FPGA_SPAN, PROT_READ | PROT_WRITE, MAP_SHARED, fd, LWHPS2FPGA_BASE);
    if (mem_lwh2f == NULL)
    {
        _E("Failed to map \"LWHPS2FPGA\" bridge");
        return -1;
    }

    _I("Mapping physical address - HPS2FPGA");
    mem_h2f = mmap(0, HPS2FPGA_SPAN, PROT_READ | PROT_WRITE, MAP_SHARED, fd, HPS2FPGA_BASE);
    if (mem_h2f == NULL)
    {
        _E("Failed to map \"HPS2FPGA\" bridge");
        return -1;
    }

    while (1)
    {
        pads_move();
        ball_move();

    // TO DO: some delay tuning for getting particular FPS how to connect it with a clock and for 
    //sleep(500); 

        for (i = 0; i < 512; i++)
        {
            // TO DO: some delay tuning for getting particular FPS
            for (j = 0; j < 640; j++)
            {
                //  TO DO: some delay tuning for getting particular FPS
                if (pixel_compare(j, i, ball, 1) || pixel_compare(j, i, pad_0, 3) || pixel_compare (j, i, pad_1, 3)) {
                    *mem_h2f = 255; // ??? dereferencing the void pointer ??? legal ???
                } else {
                    *mem_h2f = 0;
                }
            }
        }
    }
}