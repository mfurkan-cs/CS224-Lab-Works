# CS224
# Sec3
# @author: Murat Furkan Uðurlu
# Id: 21802062
# This program prints array elements, checks if it is symmetric and
# finally, finds its min and max values.

.data
	array:		.word 10, -21, 52, 1, 52, -21, 10
	arraySize:	.word 7
	byte:		.word 4
	space:		.asciiz " "
	newLine:		.asciiz "\n"
	emptyArray:	.asciiz "The array has no elements in it..."
	symmetricMes:	.asciiz "This array is symmetric or not: "
	notSpecified:	.asciiz "--Cannot be defined--"
	min:		.asciiz "Min: "
	max:		.asciiz "Max: "

.text
	# Pass array beginning address to reg $a0
	la 	$a0, array
	
	# Pass arraySize to reg $a1
	lw 	$a1, arraySize
	
	# If size is zero, then print related info
	beq	$a1, $zero, emptyControl
	
	# Print array
	jal 	PrintArray
	
	# Check is it symmetric
	jal	CheckSymmetric
	
	# move to $s7 the return value $v0
	move	$s7, $v0

	# Find min and max
	jal	FindMinMax
	
	# move return values to $s1 and $s2
	move	$s1, $v0
	move	$s2, $v1
	
Main:
	# print symmetric prompt
	li	$v0, 4
	la	$a0, symmetricMes
	syscall
	
	# print is it symmetric or not (1->symmetric, 0->not symmetric)
	li	$v0, 1
	move	$a0, $s7
	syscall
	
	# next line
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	# minimum value prompt
	li	$v0, 4
	la	$a0, min
	syscall
	
	# print min value
	li	$v0, 1
	move	$a0, $s1
	syscall
	
	# next line
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	# max value prompt
	li	$v0, 4
	la	$a0, max
	syscall
	
	# print max value
	li	$v0, 1
	move	$a0, $s2
	syscall
	
	# Finish execution
	li	$v0, 10
	syscall
	
	
PrintArray:
	# Allocate room for 4 items
	addi	$sp, $sp, -20
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	
	# Set $s2 and $s4 to $a0 (array)
	move	$s2, $a0
	move	$s4, $a0
	
	j 	Print

Print:
	# If $s1 reaches to $a1, then exit
	beq 	$s1, $a1, exitPrint
	
	# load current item to $s3
	lw	$s3, 0($s2)
	
	# Increase $s2 one byte, $s1 just one
	addi	$s2, $s2, 4
	addi	$s1, $s1, 1
	
	# print value
	li 	$v0, 1
	move	$a0, $s3
	syscall
	
	# put space
	li	$v0, 4
	la	$a0, space
	syscall
	
	# recall the function itself
	j 	Print
	
exitPrint:
	# next line
	li	$v0, 4
	la	$a0, newLine
	syscall

	# put the array start address back to $a0
	move	$a0, $s4
	
	# reload stored values
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	addi	$sp, $sp, 20
	
	# go back
	jr 	$ra

CheckSymmetric:
	# Allocate room for 4 items
	addi	$sp, $sp, -24
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	
	# backup for $a0
	move	$s0, $a0
	move	$s1, $a0
	
	# calculate $s0 (where the check program stop)
	lw	$s3, byte
	mul	$s2, $a1, $s3
	add	$s0, $s0, $s2
	addi	$s0, $s0, -4
	
	move	$s2, $a0
	
	j 	Check
	
Check:
	# Load elements of left side
	lw 	$s4, 0($s1)
	
	# Load element of right side
	lw 	$s5, 0($s0)
	
	# If $s4 and $s5 are not equal, then exit
	bne	$s4, $s5, notSymmetric
	
	# If addresses are intersected in the middle of the array, then exit
	beq 	$s0, $s1, symmetric
	
	# Increase left address and decrease right address
	addi 	$s1, $s1, 4
	sub 	$s0, $s0, $s3
	
	j Check
	
notSymmetric:
	# load 0 to $v0 (return value)
	li	$v0, 0
	
	# put array start address back to $a0
	move	$a0, $s2
	
	# reload stored values
	lw	$s5, 20($sp)
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 24
	
	# go back
	jr	$ra
	
symmetric:
	# load 1 to $v0 (return value)
	li	$v0, 1
	
	# put array start address back to $a0
	move	$a0, $s2
	
	# reload stored values
	lw	$s5, 20($sp)
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 24
	
	# go back
	jr	$ra

FindMinMax:
	# Allocate room for 4 items
	addi	$sp, $sp, -24
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	
	# backup for $a0
	move	$s0, $a0
	lw	$s4, ($s0)  # $s4 is used to hold min
	lw	$s5, ($s0)  # $s5 is used to hold max
	j	Find
	
Find:
	lw 	$s1, 0($s0)  # $s1 is used to hold the current value
	
	bgt 	$s1, $s5, increase
	blt 	$s1, $s4, decrease
	
	addi 	$s0, $s0, 4    # increase the address to reach next eleman
	addi 	$s3, $s3, 1    # increase $s3 to adjust when to stop
	
	beq 	$s3, $a1, exitFind  # if all elemans are checked, then exit
	
	j Find

increase:
	move $s5, $s1 # set new max
	j Find
	
decrease:
	move $s4, $s1 # set new min
	j Find

exitFind:
	# put array start address back to $a0
	move	$a0, $s2
	
	# put return values max and min
	move	$v1, $s5
	move	$v0, $s4
	
	# reload stored values
	lw	$s5, 20($sp)
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 24
	
	# go back
	jr	$ra
	
# If array size is zero, then there is no need to process all the operations
# Just printing necessary info is enough for the users
emptyControl:
	# print empty array messages
	li	 $v0, 4
	la	 $a0, emptyArray
	syscall
	
	# new line
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	# prompt
	li	$v0, 4
	la	$a0, symmetricMes
	syscall
	
	# not specified info
	li	$v0, 4
	la	$a0, notSpecified
	syscall
	
	# new line
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	# prompt
	li	$v0, 4
	la	$a0, min
	syscall
	
	# not specified info
	li	$v0, 4
	la	$a0, notSpecified
	syscall
	
	# new line
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	# not specified info
	li	$v0, 4
	la	$a0, max
	syscall
	
	# not specified info
	li	$v0, 4
	la	$a0, notSpecified
	syscall
	
	# Finish the execution
	li	$v0, 10
	syscall
