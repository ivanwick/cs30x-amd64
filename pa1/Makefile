#
# Makefile template for CSE 30 -- PA1
#

HEADERS		= pa1.h

C_SRCS		= main.c

C_OBJS		= main.o

ASM_SRCS	= checkRange.s displayDiamond.s numOfDigits.s isOdd.s printChar.s

ASM_OBJS	= checkRange.o displayDiamond.o numOfDigits.o isOdd.o printChar.o

OBJS		= ${C_OBJS} ${ASM_OBJS}

BIN		= pa1

CC		= clang
ASM		= clang

CFLAGS		= -c -g -W -Wall -Werror
ASM_FLAGS	= -c -g
LD_FLAGS	= -g -W -Wall


.s.o:
	${ASM} ${ASM_FLAGS} $<

.c.o:
	${CC} ${CFLAGS} $<

${BIN}: ${OBJS}
	${CC} -o ${BIN} ${LD_FLAGS} ${OBJS}

${C_OBJS}: ${HEADERS}

clean:
	/bin/rm -f *.o ${BIN}
