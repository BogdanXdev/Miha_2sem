#include <stdio.h>
#include <stdint.h>
#include <mechanics.h>
#include "cma_api.h"
#include <fcntl.h> // O_RDWR, O_SYNC

#define _I(fmt, args...) printf(fmt "\n", ##args)
#define _E(fmt, args...) printf("ERROR: " fmt "\n", ##args)

#define VIDEO_ARRAY_LENGTH 640 * 512
#define DESC_OFFSET 0x20
#define CSR_OFFSET 0x00
#define ACP_WINDOW 0x80000000
#define READ_REG 0x00
#define LENGTH_REG 0x08
#define CONTROL_REG 0x0C
#define CONTROL_GO 0x80000000
#define CONTROL_PR_EOP_SOP 0x700 // control reg options - PR, EOP, SOP

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

/* utilities */
#define _I(fmt, args...) printf(fmt "\n", ##args)
#define _E(fmt, args...) printf("ERROR: " fmt "\n", ##args)
/* physical address spans */
#define LWHPS2FPGA_BASE 0xff200000 /* physical address of the LWH2F bridge */
#define LWHPS2FPGA_SPAN 0x3000     /* address span to map */
// #define HPS2FPGA_BASE 0xc0000000   /* physical address of the H2F bridge */
// #define HPS2FPGA_SPAN 0x1000       /* address span to map */

void main()
{

    _I("Compiled at %s %s", __DATE__, __TIME__);

    _I("initializing CMA APIs");
    if (cma_init() != 0)
    {
        _E("failed to initialize CMA");
        return 1;
    }

    _I("allocating contiguous memory");
    uint32_t *buffer_src = (uint32_t *)cma_alloc_noncached(VIDEO_ARRAY_LENGTH * sizeof(uint32_t));

    int fd;                            /* file descriptor */
    volatile unsigned char *mem_lwh2f; /* memory pointer for LW HPS2FPGA bridge */

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

    _I("running FPGA memcpy:");

    _I("filling descriptor...");

    while (1)
    {
        // TO DO: write a function for filling the read register with video data
        /* TO DO: describe the concept of video data
         for example - sending to FPGA part coord-s of the centers of the primitives(primitives are
         unified pero...) => the video stream could become a sequence of the x-s and y-s for every px
         on every row
           */
        pads_move();
        ball_move();
        for (uint16_t j = 0; j < 512; j++)
        { //compare objects to j
            buffer_src[j] = j;
            _I("constructing one row");
            for (uint16_t i = 0; i < 640; i++)
            { //compare objects to i
                buffer_src[i] = i;
            }

            *((volatile uint32_t *)(mem_lwh2f + DESC_OFFSET + READ_REG)) =
                ACP_WINDOW + cma_get_phy_addr(buffer_src); ///< read address
            *((volatile uint32_t *)(mem_lwh2f + DESC_OFFSET + LENGTH_REG)) =
                640 * sizeof(uint8_t); ///< length - one row
            *((volatile uint32_t *)(mem_lwh2f + DESC_OFFSET + CONTROL_REG)) =
                CONTROL_PR_EOP_SOP; // PR EOP SOP bits
            *((volatile uint32_t *)(mem_lwh2f + DESC_OFFSET + CONTROL_REG)) |=
                0x80000000; ///< control->go

            /// ------ DMA transaction executes here -----
            _I("DMA transaction executes...");

            /// Waiting for DMA transaction to complete:
            if (!((*((volatile uint32_t *)(mem_lwh2f + CSR_OFFSET + 0x00))) & 0x00000001))
            {
                _I("finished successfully!");
                break;
            }
        }
        pads_move();
        ball_move();
    }

    return 0;
}
