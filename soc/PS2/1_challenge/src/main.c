#include <stdio.h>
int main(int argc, char** argv) {
    if (argc < 3) {
        printf("Input and output file paths, you dumb dumb!");
        return 1;
    }
    FILE *input_file = fopen(argv[1], "r");
    FILE *output_file = fopen(argv[2], "w");
    char c;
    while ((c = fgetc(input_file)) != EOF) {
        c = (c > 0x60 && c < 0x7B ? c - 32 : c);
        fputc(c, output_file);
    }
    fclose(input_file);
    fclose(output_file);
    return 0;
}