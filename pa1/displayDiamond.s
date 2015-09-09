
	.text
	.global _displayDiamond

_displayDiamond:
	pushq	%rbp
	movq	%rsp, %rbp

	subq	$48, %rsp
	movq	%rdi, -8(%rbp) # size is coming in as a long, save all 8 bytes

	# Pack the following params in single bytes because they're chars
	# If they don't come in on one of the registers with low-bytes then
	# move to %eax first.
	movl	%esi, %eax
	movb	%al, -9(%rbp) # diamondChar: long but effectively char
	movb	%dl, -10(%rbp) # fillerChar: long but effectively char
	movb	%cl, -11(%rbp) # borderChar: long but effectively char

	# Local variables
	# -16(%rbp)	numOfDigits(size, 10)
	# -24(%rbp)	counterA (count border lines) and
	#               drawrep (computed foreground line size)
	# -32(%rbp)	counterB (counts down from size to 0 in diamond loop)
	# -40(%rbp)	step (in diamond loop, flips between 2 and -2 halfway)
	# -48(%rbp)	bgrep (computed background line size)

	# size is already in %rdi
	movl	$10, %esi
	callq	_numOfDigits
	movl	%eax, -16(%rbp) # save numOfDigits(size, 10) in local stack var

	movslq	-16(%rbp), %rax
	movq	%rax, -24(%rbp)
LtopBorder:
	cmpl	$0, -24(%rbp) # counterA
	jbe	LtopBorderEnd

	movl	$0, %eax # clear first because we're only reading in low byte
	movb	-11(%rbp), %al
	movl	%eax, %edi

	movslq	-8(%rbp), %rdx # size
	movslq	-16(%rbp), %rcx # numdigits
	movq	$2, %rsi # load into a register for mul (both sides of border)
	imulq	%rcx, %rsi # times = numdigits * 2
	addq	%rdx, %rsi # times += size
	callq	_printCharRepeat

	movl	$'\n', %edi
	callq	_printChar

	subl	$1, -24(%rbp)
	jmp	LtopBorder
LtopBorderEnd:


	/* Pseudocode for the below loop:

	counterB = size;
	drawrep = 1;
	step = 2;

	while (counterB > 0) {
	  bgrep = (size - drawrep) / 2;

	  // print a row
	  printCharRepeat(borderChar, numDigits);
	  printCharRepeat(fillerChar, bgrep);
	  printCharRepeat(diamondChar, drawrep);
	  printCharRepeat(fillerChar, bgrep);
	  printCharRepeat(borderChar, numDigits);
	  printChar('\n');

	  if (drawrep >= size) {
	    step = step * -1;
	  }
	  drawrep += step;
	  counterB -= 1;
	}
	*/


	# Initialization:
	# counterB = size
	movq	-8(%rbp), %rax
	movq	%rax, -32(%rbp)

	movq	$1, -24(%rbp) # drawrep = 1
	movq	$2, -40(%rbp) # step = 2
LdiamondLoop:
	cmpl	$0, -32(%rbp) # counterB
	jbe	LdiamondLoopEnd

	# left side border
	movl	$0, %eax # clear first because we're only reading in low byte
	movb	-11(%rbp), %al
	movl	%eax, %edi
	movslq	-16(%rbp), %rsi
	callq	_printCharRepeat

	# diamond body
	# computations
	#
	# bgrep = (size - drawrep) / 2
	movq	-8(%rbp), %rax
	subq	-24(%rbp), %rax
	cqto
	movq	$2, %rbx
	idivq	%rbx
	movq	%rax, -48(%rbp) # bgrep

	## background
	movl	$0, %eax # clear first because we're only reading in low byte
	movb	-10(%rbp), %al
	movl	%eax, %edi

	movq	-48(%rbp), %rsi
	callq	_printCharRepeat

	## foreground
	movl	$0, %eax # clear first because we're only reading in low byte
	movb	-9(%rbp), %al
	movl	%eax, %edi

	movq	-24(%rbp), %rsi
	callq	_printCharRepeat

	## background
	movl	$0, %eax # clear first because we're only reading in low byte
	movb	-10(%rbp), %al
	movl	%eax, %edi

	movq	-48(%rbp), %rsi
	callq	_printCharRepeat
	# end diamond body

	# right side border
	movl	$0, %eax # clear first because we're only reading in low byte
	movb	-11(%rbp), %al
	movl	%eax, %edi
	movslq	-16(%rbp), %rsi
	callq	_printCharRepeat

	# end of line
	movl	$'\n', %edi
	callq	_printChar

	# flip sign of step when drawrep gets to size
	movq	-24(%rbp), %rax  # load drawrep.
	cmpq	%rax, -8(%rbp)   # when size is still greater than drawrep,
	jg	LdiamondLoopIncr # skip the sign flip
	negq	-40(%rbp)

LdiamondLoopIncr:
	movq	-40(%rbp), %rax
	addq	%rax, -24(%rbp)

	subq	$1, -32(%rbp) # counterB
	jmp	LdiamondLoop
LdiamondLoopEnd:


	movslq	-16(%rbp), %rax
	movq	%rax, -24(%rbp)
LbottomBorder:
	cmpl	$0, -24(%rbp) # counterA
	jbe	LbottomBorderEnd

	movl	$0, %eax # clear first because we're only reading in low byte
	movb	-11(%rbp), %al
	movl	%eax, %edi

	movslq	-8(%rbp), %rdx # size
	movslq	-16(%rbp), %rcx # numdigits
	movq	$2, %rsi # load into a register for mul (both sides of border)
	imulq	%rcx, %rsi # times = numdigits * 2
	addq	%rdx, %rsi # times += size
	callq	_printCharRepeat

	movl	$'\n', %edi
	callq	_printChar

	subl	$1, -24(%rbp)
	jmp	LbottomBorder
LbottomBorderEnd:

	addq	$48, %rsp
	popq	%rbp
	retq


# void printCharRepeat( char c, long times )
_printCharRepeat:
	pushq	%rbp
	movq	%rsp, %rbp

	# Save our parameters
	# Not packed but we need to reserve 16 bytes of stack space to
	# maintain alignment anyway
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)

Lreploop:
	cmpq	$0, -16(%rbp)
	jbe	Lrepend

	movl	-4(%rbp), %edi
	callq	_printChar

	subq	$1, -16(%rbp)
	jmp	Lreploop

Lrepend:
	addq	$16, %rsp
	popq	%rbp
	retq
