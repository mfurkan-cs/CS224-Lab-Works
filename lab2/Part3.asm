.data
	array:		.word
	arraySize:	.space 4
	byte:		.word 4
	space:		.asciiz " "
	newLine:		.asciiz "\n"
	emptyArray:	.asciiz "The array has no elements in it..."
	symmetricMes:	.asciiz "This array is symmetric or not: "
	notSpecified:	.asciiz "--Cannot be defined--"
	min:		.asciiz "Min: "
	max:		.asciiz "Max: "
	sizePrompt:	.asciiz "Please enter the size of your array: "
	elemanPrompt:	.asciiz "Please enter your array elemans: "

.text
	jal	getArray			# go getArray subprogram
	move	$a1, $v1
	move	$a0, $v0
	beq	$a1, $zero, emptyControl
	
	jal	CheckSymmetric		# check is array symemtric
	move	$s7, $v0

	jal	FindMinMax		# find min max
	move	$s1, $v0
	move	$s2, $v1
	
Main:
	
	li	$v0, 4			# symetric prompt
	la	$a0, symmetricMes
	syscall
	
	li	$v0, 1			# print 1 or 0 (symetric message)
	move	$a0, $s7
	syscall
	
	li	$v0, 4			# new line
	la	$a0, newLine
	syscall
	
	
	li	$v0, 4			# min prompt
	la	$a0, min
	syscall
	
	li	$v0, 1			# show min
	move	$a0, $s1
	syscall
	
	li	$v0, 4			# new line
	la	$a0, newLine
	syscall
	
	li	$v0, 4			# show max prompt
	la	$a0, max
	syscall
	
	li	$v0, 1			# show max
	move	$a0, $s2
	syscall
	
	li	$v0, 10			# finish execution
	syscall
	
	
PrintArray:
	# Allocate room for 4 items
	addi	$sp, $sp, -20
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	
	# load regs with 0
	li	$s0, 0
	li	$s1, 0
	li	$s2, 0
	li	$s3, 0
	li	$s4, 0
	
	# Set $s2 to $a0 (array)
	move	$s2, $a0
	move	$s4, $a0
	
	j 	Print

Print:
	# If $s1 reaches to $a1 (size), then exit
	beq 	$s1, $a1, exitPrint
	
	lw	$s3, 0($s2)
	
	addi	$s2, $s2, 4	# increase by 4
	addi	$s1, $s1, 1	# increase by 1
	
	li 	$v0, 1		# print eleman
	move	$a0, $s3
	syscall
	
	li	$v0, 4		# print space
	la	$a0, space
	syscall
	
	j 	Print		# loop
	
exitPrint:
	
	li	$v0, 4		# print new line
	la	$a0, newLine
	syscall

	move	$a0, $s4		# get from backup
	
	lw	$s0, 0($sp)	# reload previous values
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	addi	$sp, $sp, 20
	
	jr	$ra		# go back

CheckSymmetric:
	# Allocate room for 4 items
	addi	$sp, $sp, -24
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	
	move	$s0, $a0
	move	$s1, $a0
	
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
	li	$v0, 0
	
	move	$a0, $s2
	
	lw	$s5, 20($sp)
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
	
symmetric:
	li	$v0, 1
	
	move	$a0, $s2
	
	lw	$s5, 20($sp)
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 24
	
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

	move	$s0, $a0
	lw	$s4, ($s0)  # $s4 is used to hold min
	lw	$s5, ($s0)  # $s5 is used to hold max
	j	Find
	
Find:
	lw 	$s1, 0($s0)  # $s1 is used to hold the current value
	
	bgt 	$s1, $s5, increase
	blt 	$s1, $s4, decrease
	
	addi 	$s0, $s0, 4    # increase the address to reach next eleman
	addi 	$s3, $s3, 1
	
	beq 	$s3, $a1, exitFind
	
	j Find

increase:
	move $s5, $s1 # set new max
	j Find
	
decrease:
	move $s4, $s1 # set new min
	j Find

exitFind:
	move	$a0, $s2
	move	$v1, $s5
	move	$v0, $s4
	
	# reload previous values
	lw	$s5, 20($sp)
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
	
emptyControl:
	li	 $v0, 4			# empty array prompt
	la	 $a0, emptyArray
	syscall
	
	li	$v0, 4			# new line
	la	$a0, newLine
	syscall
	
	li	$v0, 4			# symetric prompt
	la	$a0, symmetricMes
	syscall
	
	li	$v0, 4			# not specified message
	la	$a0, notSpecified
	syscall
	
	li	$v0, 4			# new line
	la	$a0, newLine
	syscall
	
	
	li	$v0, 4			# min prompt
	la	$a0, min
	syscall
	
	li	$v0, 4			# not specified message
	la	$a0, notSpecified
	syscall
		
	li	$v0, 4			# new line
	la	$a0, newLine
	syscall
	
	li	$v0, 4			# max prompt
	la	$a0, max
	syscall
	
	li	$v0, 4			# not specified message
	la	$a0, notSpecified
	syscall
	
	li	$v0, 10			# finish
	syscall
	
getArray:
	sub	$sp, $sp, 24	# allocate 6 rooms from stack
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	
	li	$v0, 4		# print size prompt
	la	$a0, sizePrompt
	syscall
	
	li	$v0, 5 		# input from user for size
	syscall
	
	move	$s0, $v0  	# hold size
	
	li	$v0, 4
	la	$a0, elemanPrompt	# elements prompt
	syscall
	
	li	$s3, 4		# load byte size (4)
	mul	$s1, $s0, $s3	# calculate total size of array
	
	move 	$a0, $s1 	# The bytes size of the memory location to be allocated
	li 	$v0, 9   	# Used for dynamic allocation
	syscall
	
	add	$s3, $zero, $v0	# load address to $s3 reg
	add	$s4, $zero, $v0 # backup
	j	getElemans	# jump to next part
	
getElemans:
	beq	$s5, $s1, exitGetArray	# if total size is fulled, then exit
	
	li	$v0, 5		# get input from user
	syscall
	
	sw	$v0, 0($s3)	# load $s3 with input
	
	addi	$s3, $s3, 4	# increase $s3 (holding starting address of array) by 4 which holds elemans
	
	addi	$s5, $s5, 4	# increase $s5 by 4
	
	j	getElemans
	
exitGetArray:
	move	$a0, $s4		# move start address to $a0
	move	$a1, $s0		# move size to $a1
	
	lw	$s5, 20($sp)	# reload previous values
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 24
	
	move	$s0, $a0		# backup start address
	move	$s1, $a1		# backup size
	move	$s2, $ra		# backup $ra reg
	
	jal	PrintArray	# go to print
	j	finishArrayImp

finishArrayImp:
	move	$v0, $s0		# upload backups
	move	$v1, $s1
	move	$ra, $s2
	
	li	$s0, 0		# load zero to regs
	li	$s1, 0
	li	$s2, 0
	
	jr	$ra		# go back
