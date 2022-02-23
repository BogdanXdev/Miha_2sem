#include <stdio.h>
#include <stdint.h>

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
    if (_2d_vector_ball.y_vec = 0)
    {
        _2d_vector_ball.y_vec = 0;
    }
    else if (_2d_vector_ball.y_vec = primitive_side)
    {
        _2d_vector_ball.y_vec = -primitive_side;
    }
    else if (_2d_vector_ball.y_vec = -primitive_side)
    {
        _2d_vector_ball.y_vec = primitive_side;
    }
    if (_2d_vector_ball.x_vec = primitive_side)
    {
        _2d_vector_ball.x_vec = -primitive_side;
    }
    else if (_2d_vector_ball.x_vec = -primitive_side)
    {
        _2d_vector_ball.x_vec = primitive_side;
    }
}

void ball_collision(primitive *ball, primitive *pad0, primitive *pad1)
{ // ball out of the gaming field
    if (ball
            [0]
                .x = 0 || ball[0].x = 640 ||
                                      ball[0].y = 0 || ball[0].y = 512)
    {
        printf("GAME OVER!!!/n Take it easy. Go get some coffee. Relax./n");
    }

    for (i = 0; i < 2; i++)
    { // ball collissions with the platforms
        if (ball
                [0]
                    .x = pad0_x + primitive_side && ball[0].y = pad0[i].y)
        {
            printf("collision with pad0 /n");
            ballvector_change();
        }
        if (ball
                    [0]
                        .x +
                primitive_side = pad1_x && ball[0].y = pad1[i].y)
        {
            printf("collision with pad1 /n");
            ballvector_change();
        }
    }
}

void ball_move()
{
    ball_collission();
    object_movement(ball, 1, _2d_vector_ball);
}

void pads_move()
{
    // poll the buttons
    object_movement(pad_0, 3, _2d_vector_pad0);
    object_movement(pad_1, 3, _2d_vector_pad1);
}

/* utilities */
#define _I(fmt, args...) printf(fmt "\n", ##args)
#define _E(fmt, args...) printf("ERROR: " fmt "\n", ##args)
/* physical address spans */
#define LWHPS2FPGA_BASE 0xff200000 /* physical address of the LWH2F bridge */
#define LWHPS2FPGA_SPAN 0x3000     /* address span to map */

void main()
{

    int fd;                   /* file descriptor */
    unsigned char *mem_lwh2f; /* memory pointer for LW HPS2FPGA bridge */

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

    _I("Waiting for button press..."); // 5 buttons should be implemented
    while ((*(mem_lwh2f + 0x0000) & 0x1))
        ; /* polling for button to be pressed */
    while ((*(mem_lwh2f + 0x0000) & 0x1))
        ; /* polling for button to be pressed */
    while ((*(mem_lwh2f + 0x0000) & 0x1))
        ; /* polling for button to be pressed */
    while ((*(mem_lwh2f + 0x0000) & 0x1))
        ; /* polling for button to be pressed */
    while ((*(mem_lwh2f + 0x0000) & 0x1))
        ; /* polling for button to be pressed */

    while (1)
    {
        // draw object()
        // uslovije dlja knopok
        // slovitj knopki       0000 0000 ... 0000 000f  h2f_lw_axi_master
        // debounce

        pads_move();
        ball_move();

        // video potok - potok s kazhdim pixelom? ili toljko informacija ob
        // ramka igrovogo polja vtraivaetsa v video potok
        //  ostaljnije dannije
    }
}