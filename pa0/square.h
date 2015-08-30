
/*
  Square the given value, i.e. multiply it by itself
*/
int square(int);

/*
  The linker will assume that this symbol will appear in the form "_square" so
  that's how it's labeled in the .s file. It's possible to override this using:
    extern int square(int x) asm("square");
  but this is another indirection so let's not fight it and just conform to the
  naming/linking convention.
*/
