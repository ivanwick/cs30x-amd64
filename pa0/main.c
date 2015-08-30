
#include <stdio.h>
#include <stdlib.h> /* atoi */
#include "square.h"

int main(int argc, char* argv[])
{
    if (argc < 2) {
        fprintf(stderr, "%s: incorrect number of arguments\n", argv[0]);
        fprintf(stderr, "Usage: %s [INTEGER]\n", argv[0]);
        fprintf(stderr, "  Integer value to square\n");
        return 1;
    }

    int num_sq;
    int num;

    num = atoi(argv[1]);
    num_sq = square(num);

    fprintf(stdout, "%d\n", num_sq);
}
