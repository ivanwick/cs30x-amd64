
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
	retq
