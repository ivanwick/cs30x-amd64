
# This assembly module will print the character argument to stdout.
# Use printf(). But printChar() just prints a single character.

# First 6 integer/pointer args are passed in registers:
#   rdi  rsi  rdx  rcx  r8  r9

# http://stackoverflow.com/questions/25599127/moving-a-label-into-64bit-register-inline-assembly-gcc-clang

	.cstring
fmtchar:
	.asciz "%c"

	.text
	.global _printChar

_printChar:
	pushq %rbp
	movq %rsp, %rbp

	movq %rdi, %rsi
	leaq fmtchar(%rip), %rdi
	callq _printf

	popq %rbp
	retq
