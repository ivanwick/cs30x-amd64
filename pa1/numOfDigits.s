
# This assembly module will count the number of base digits in its argument.
#
# The base argument can be in the range [2-36]. Use checkRange() to ensure the
# base argument is within this range. If it is out of range, return -1.
#
# As a special case, if num is the value 0, return with the value 1. For the
# general case, you can simply set up a loop: while num is not equal to 0,
# increment a counter and set num equal to num divided by base (this gets rid
# of the right-most base digit). Then return the counter value.
#
# You can use the following assembler constants:
# MIN_BASE = 2
# MAX_BASE = 36
#
# Note: This module must handle positive and negative values. If you code it
# correctly you should not have to add any additional code to account for
# negative values.

	.text
	.global _numOfDigits

_numOfDigits:
	pushq	%rbp
	movq	%rsp, %rbp

	# This is not a leaf function so we'll need to store callee-saved regs
	# Allocate 16 bytes for the two longs we need to save.
	subq	$16, %rsp
	movq	%rdi, -8(%rbp) # long num
	movl	%esi, -16(%rbp) # int base

	# We'll be calling a function below but don't worry about caller-saved
	# regs because we haven't done anything yet that needs to be saved.

	# Function call to do a range check on the int base argument
	movslq	%esi, %rdx # long value (do now because we overwrite %rsi below)
	movq	$2, %rdi # long minRange
	movq	$36, %rsi # long maxRange
	callq	_checkRange

	movl	%eax, %ecx # move the return value aside
	movl	$-1, %eax # threaten to return -1 based on the comparison
	cmpl	$0, %ecx
	jz	end

	# get our saved arguments back into the registers
	movq	-8(%rbp), %rdi # long num
	movl	-16(%rbp), %esi # int base

	# special case, numOfDigits(0, x): 1
	# %ecx is the counter in the loop below which we'll be returning
	movl	$1, %eax
	cmpq	$0, %rdi # passed in as 8-byte long
	jz	end

loopinit:
	# Intiailize %rax to the num argument so that we can repeatedly idivq
	# and it will put the result back into %rax.
	movq	%rdi, %rax
	# Initialize %ecx as a counter of how many times we divided.
	movl	$0, %ecx

	# %esi came in as a 4-byte int but we need to use it later to idivq.
	# Be explicit about promoting it with sign extension (even though we
	# have the range check above).
	movslq	%esi, %rsi

loopcontinue:
	cmpq	$0, %rax
	jz	loopfinish

	# Sign-extend %rax into oct word %rdx:%rax because idivq uses that.
	# A previous wrong version zeroed-out %rdx here but it did not work
	# when %rax was negative.
	cqto

	idivq	%rsi
	incl	%ecx # we divided again so increment the counter

	jmp	loopcontinue

loopfinish:
	movl	%ecx, %eax
end:
	addq	$16, %rsp
	popq	%rbp
	retq
