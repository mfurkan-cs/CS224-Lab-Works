# CS224
# Section No.: 3
# Spring 2021
# Lab No.: 6
# Murat Furkan Uðurlu
# ID: 21802062
	
	.data
Menu:			.asciiz "\n-------MENU-------\n1-Allocate an array with proper size\n2-Display desired element\n3-Obtain and display arithmetic in row major\n4-Obtain and display arithmetic in column major\n5-Exit"
instrInputPrompt:	.asciiz "\nPlease enter your instruction: "
sizeInputPrompt:		.asciiz "\nPlease enter dimsension size: "
rowInputPrompt:		.asciiz "\nPlease enter row number: "
colInputPrompt:		.asciiz "\nPlease enter column number: "
desiredElementPrompt:	.asciiz "\nDesired value is "
averageRowPrompt:	.asciiz "\nAverage in row major traversal is "
averageColPrompt:	.asciiz "\nAverage in column major traversal is "
				
	.text
Main:
	# print Menu prompt
	la	$a0, Menu
	li	$v0, 4
	syscall
	
	# print instruction prompt to get from user
	la	$a0, instrInputPrompt
	li	$v0, 4
	syscall
	
	# get instruction (int) from user
	li	$v0, 5
	syscall
	
	# move the instruction to $t0 reg
	move	$t0, $v0
	
	# go to the corresponding part, accordingg to the instruction number
	beq	$t0, 1, allocateArray
	beq	$t0, 2, displayDesiredElement
	beq	$t0, 3, inRowMajor
	beq	$t0, 4, inColMajor
	beq	$t0, 5, exit
	
	# in case of undefined instruction, stay in Main
	j	Main
	
	
getDimensionSize:
	# print enter dim size input
	la	$a0, sizeInputPrompt
	li	$v0, 4
	syscall
	
	# get dimension size input from user
	li	$v0, 5
	syscall
	
	# keep dimension size in $t1
	move	$t1, $v0
	
	# go back to Main
	jr	$ra
	
	
allocateArray:
	# get dimension size
	jal	getDimensionSize
	
	# calculate dim^2 and put it into $t2 reg
	mul	$t2, $t1, $t1
	
	# calculate total size and put it into $a0 reg
	mul	$a0, $t1, 4
	
	# create dynamically allocated array
	li	$v0, 9
	syscall
	
	# put array start address into $t3 and $t4 reg
	move	$t3, $v0		# backup
	move	$t4, $v0		# for use of now
	
	# put consecutive elements into the array
	li	$t5, 0
	
	fillArray:
		addi	$t5, $t5, 1	# increment $t5
		sw	$t5, 0($t4)	# store the value into corresponding address in array
		addi	$t4, $t4, 4	# pass to next address in array
		bne	$t5, $t2, fillArray
	
	# go back to Main
	j	Main
	

displayDesiredElement:
	
	# print prompt to get row no
	la	$a0, rowInputPrompt
	li	$v0, 4
	syscall
	
	# get row no
	li	$v0, 5
	syscall
	
	# move row no to $t4 reg
	move	$t4, $v0
	
	# print prompt to get column no
	la	$a0, colInputPrompt
	li	$v0, 4
	syscall
	
	# get column no
	li	$v0, 5
	syscall
	
	# move column no to $t5 reg
	move	$t5, $v0
	
	# calculate the position in the array
	addi	$t4, $t4, -1
	mul	$t6, $t1, $t4	# go to corresponding row's upper row
	add	$t6, $t6, $t5	# go to corresponding column in the desired row
	addi	$t6, $t6, -1	# now we are in the corresponding index
	mul	$t6, $t6, 4	# multiply with 4 to go to corresponding address (4 byte size)
	add	$t3, $t3, $t6	# now we are in the corresponding address
	lw	$t4, 0($t3)	# load desired value to $t4 reg
	sub	$t3, $t3, $t6	# go back to array's start address
	
	# now print the element with prompt
	la	$a0, desiredElementPrompt
	li	$v0, 4
	syscall
	
	move	$a0, $t4
	li	$v0, 1
	syscall
	
	# go back to Main
	j	Main
	
inRowMajor:
	# initialize $t6 to zero (it will hold the sum)
	addi	$t6, $zero, 0
	addi	$t5, $zero, 0
	addi	$t4, $zero, 0
	
	# $t4 reg holds start address of the array now
	move	$t4, $t3
	
	sumInRow:
		lw	$t5, 0($t4)
		add	$t6, $t6, $t5
		addi	$t4, $t4, 4
		addi	$t2, $t2, -1
		bne	$t2, $zero, sumInRow
	
	# put old value of $t2
	mul	$t2, $t1, $t1
	
	# divide $t6 (the sum) into $t2 (total no of elements) to find avrage
	div	$t6, $t2
	
	# put the result into $t6 reg
	mflo	$t6
	
	# print the average prompt
	la	$a0, averageRowPrompt
	li	$v0, 4
	syscall
	
	# print the average
	move	$a0, $t6
	li	$v0, 1
	syscall
	
	# go back to Main
	j	Main

inColMajor:
	# initialize $t6 to zero (it will hold the sum)
	addi	$t6, $zero, 0
	addi	$t5, $zero, 0
	addi	$t4, $zero, 0
	addi	$s0, $zero, 0
	
	mul	$t7, $t1, 4
	
	
	adjust:
		# $t4 reg holds start address of the array now
		move	$t4, $t3
		mul	$s1, $s0, 4
		add	$t4, $t4, $s1
		addi	$s0, $s0, 1
		move	$t2, $t1
	
	sumInCol:
		lw	$t5, 0($t4)
		add	$t6, $t6, $t5
		add	$t4, $t4, $t7
		addi	$t2, $t2, -1
		bne	$t2, $zero, sumInCol
		bne	$s0, $t1, adjust
		
	# put old value of $t2
	mul	$t2, $t1, $t1
	
	# divide $t6 (the sum) into $t2 (total no of elements) to find avrage
	div	$t6, $t2
	
	# put the result into $t6 reg
	mflo	$t6
	
	# print the average prompt
	la	$a0, averageColPrompt
	li	$v0, 4
	syscall
	
	# print the average
	move	$a0, $t6
	li	$v0, 1
	syscall
	
	# go back to Main
	j	Main
	
	
exit:
	# end the execution
	li	$v0, 10
	syscall