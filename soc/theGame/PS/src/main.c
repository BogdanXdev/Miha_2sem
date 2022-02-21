#include <stdio.h>
#include <stdint.h>

typedef struct {
    uint16_t x;
    uint16_t y;
    uint16_t side;
} primitive;

primitive object_0[3]= {{0,0,10},{0,10,10},{0,20,10}};
primitive object_1[1]= {{50,50,10}};
primitive object_2[3]= {{200,0,10},{200,10,10},{200,20,10}};

primitive* frame[]= {object_0, object_1, object_2}; 

void object_movement ();
void collision_detec ();
void button_get ();

void main()
{




}