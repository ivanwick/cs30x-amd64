
	.text
	.global _isOdd

_isOdd:
	movl %edi, %eax
	xor %edx, %edx # clear edx, top bits of the operand used by idivl
	movl $2, %esi

	# idivl is a SIGNED division as opposed to divl unsigned
	idivl %esi

	# %edx has the remainder
	# no additional processing necessary here because
	# 1: true, it is odd
	# 0: false, it's not odd

	movl %edx, %eax
	retq
