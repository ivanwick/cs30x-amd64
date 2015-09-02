
	.text
	.global _displayDiamond

_displayDiamond:
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
