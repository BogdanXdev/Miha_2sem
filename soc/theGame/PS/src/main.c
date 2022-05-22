#include <stdio.h>
#include <stdint.h>
#include <mechanics.h>
#include "cma_api.h"
#include <fcntl.h>			// O_RDWR, O_SYNC

#define _I(fmt, args...)	printf(fmt "\n", ##args)
#define _E(fmt, args...)	printf("ERROR: " fmt "\n", ##args)

#define ARRAY_LENGTH		64
#define DESC_OFFSET			0x20
#define CSR_OFFSET			0x00
#define ACP_WINDOW			0x80000000

void display_buffer(uint32_t *buffer, int length)
{
	for(int i=0; i<length; i++)
	{
		printf("%.6u ", buffer[i]);

		// new line after each 8th element
		if(i % 8 == 7)
			putchar('\n');
	}
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

    _I("Compiled at %s %s", __DATE__, __TIME__);

    _I("initializing CMA APIs");
	if (cma_init() != 0)
	{
		_E("failed to initialize CMA");
		return 1;
	}

    _I("allocating contiguous memory");
	uint32_t *buffer_src = (uint32_t*)cma_alloc_noncached(ARRAY_LENGTH*sizeof(uint32_t));
	uint32_t *buffer_dst = (uint32_t*)cma_alloc_noncached(ARRAY_LENGTH*sizeof(uint32_t));

    _I("filling memory (src array)");
	for (uint32_t i=0; i<ARRAY_LENGTH; i++)
	buffer_src[i] = i;

    _I("displaying memory contents (src)");
	display_buffer(buffer_src, ARRAY_LENGTH);
	_I("displaying memory contents (dst)");
	display_buffer(buffer_dst, ARRAY_LENGTH);


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