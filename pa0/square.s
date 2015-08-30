# Building Mach-O binaries on Mac OS X
# references:
# https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/MachORuntime/
# https://developer.apple.com/library/mac/documentation/DeveloperTools/Reference/Assembler/040-Assembler_Directives/asm_directives.html
#
# .section  segname , sectname [[[ , type ] , attribute ] , sizeof_stub ]
# clang emitted:
#	.section	__TEXT,__text,regular,pure_instructions
#
# But we can use the builtin directive .text as a shorthand
	.text

# Make this symbol visible from other object files during linking
# .global and .globl spellings both work
	.global	_square

_square:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %edi
	imull	-4(%rbp), %edi
	movl	%edi, %eax
	popq	%rbp
	retq
