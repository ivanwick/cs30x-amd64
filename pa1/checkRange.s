
# This assembly module will check to make sure the value of the first argument
# is within the range of minRange and maxRange, inclusive.
# Return 0 for false; return non-zero for true.

# First 6 integer/pointer args are passed in registers:
#   rdi  rsi  rdx  rcx  r8  r9

	.text
	.global	_checkRange

_checkRange:
	# Leaf function

	movl	$0, %eax # get ready to return 0 unless it passes all the tests
	cmpq	%rdi, %rdx # beware "backward" AT&T syntax
	jl	end        # tests whether %rdx < %rdi

	cmpq	%rsi, %rdx
	jg	end

	movl	$1, %eax
end:
	retq
