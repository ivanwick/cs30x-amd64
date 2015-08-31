
	.text
	.global _isOdd

_isOdd:
	movq	%rdi, %rax
	# sign-extend %rax into %rdx:%rax, idivl uses it like that
	cqto
	movq	$2, %rsi

	# idivl is a SIGNED division as opposed to the unsigned divq
	idivq	%rsi

	# %edx has the remainder
	# 1: true, it is odd
	# 0: false, it's not odd
	# But we can't just return it unmodified because it might be negative.
	# So we need some logic here to regularize the return value to (0, 1)
	cmpq	$0, %rdx
	jz	end
	movq	$1, %rdx

end:
	# returns int so movl is ok here instead of movq
	movl %edx, %eax
	retq
