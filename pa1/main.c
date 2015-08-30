#include <stdio.h>
#include <stdlib.h> /* strtol */
#include <errno.h>

/*
 ./pa1 diamond_size diamond_char bg_char border_char
*/

#include "pa1.h"

int main(int argc, char* argv[])
{
    long parsed_arg[4];
    /*  [0] diamond_size
        [1] diamond_char
        [2] bg_char
        [3] border_char
    */
    long valid_range[4][2] = {
        {3, 77},
        {32, 126},
        {32, 126},
        {32, 126}
    };

    if (argc != 5) {
        fprintf(stderr, "%s: Wrong number of arguments\n", argv[0]);
        fprintf(stderr,
            "Usage: %s X_size X_char bg_char border_char\n", argv[0]);
        fprintf(stderr,
            "diamond_size (odd number within the range of [3 - 77])\n"
            "diamond_char (ASCII value within the range [32 - 126])\n"
            "bg_char      (ASCII value within the range [32 - 126])\n"
            "             (must be different than X_char)\n"
            "border_char  (ASCII value within the range [32 - 126])\n"
            "             (must be different than X_char)\n" );
        return 1;
    }


    int parsed_i;
    int parsed_max = argc-1;
    int anyerror = 0;
    for (parsed_i = 0; parsed_i < parsed_max; parsed_i++) {
        int argi = parsed_i + 1; /* index in argv is offset by 1 from parsed */
        errno = 0;
        parsed_arg[parsed_i] = strtol(argv[argi], NULL, 0);
        if (errno) {
            fprintf(stderr, "\"%s\": ", argv[argi]);
            perror("strtol");
            anyerror = 1;
        }
    }

    /* opportunity to bail out here because all the validation below depends
       on having parsed actual integers out of the cmd line args */
    if (anyerror) {
        return 1;
    }

    for (parsed_i = 0; parsed_i < parsed_max; parsed_i++) {
        if (!checkRange(parsed_arg[parsed_i],
                       valid_range[parsed_i][0], valid_range[parsed_i][1])) {
            fprintf(stderr, "%ld needs to be within the range [%ld - %ld]\n",
                            parsed_arg[parsed_i],
                            valid_range[parsed_i][0], valid_range[parsed_i][1]);
            anyerror = 1;
        }
    }

    /* certain argument values must be different from each other */
    if (parsed_arg[1] == parsed_arg[2]) {
        fprintf(stderr, "diamond_char must be different from bg_char\n");
        anyerror = 1;
    }
    if (parsed_arg[1] == parsed_arg[3]) {
        fprintf(stderr, "diamond_char must be different from border_char\n");
        anyerror = 1;
    }

    /* diamond size must be odd */
    if (!isOdd(parsed_arg[0])) {
        fprintf(stderr, "diamond_char literally can't even\n");
        anyerror = 1;
    }

    if (anyerror) {
        return 1;
    }

    displayDiamond(parsed_arg[0], parsed_arg[1], parsed_arg[2], parsed_arg[3]);
    return 0;
}
