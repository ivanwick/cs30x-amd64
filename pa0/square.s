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

# When clang emitted this function, it prepended the function name with a
# leading underscore. http://stackoverflow.com/a/2628384
# It would be possible to use extern with an asm label in the header file and
# name this whatever we want, but let's just leave it this way.

# http://eli.thegreenplace.net/2011/09/06/stack-frame-layout-on-x86-64/
# First 6 integer/pointer args are passed in registers:
#   rdi  rsi  rdx  rcx  r8  r9

# Leaf function, all args fit in registers, no stack
_square:
	movl	%edi, %eax      # copy result to eax for return later
	imull	%eax, %eax      # multiply it by itself
	retq
