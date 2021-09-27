# CS224
# Lab 3
# Section 3
# Murat Furkan Uðurlu
# 21802062

# This program finds the result of a division by recursion.

.data
	dividendNumber:	.asciiz "\nPlease enter dividend number: "
	dividerNumber:	.asciiz "\nPlease enter divider number: "
	divisionPrompt:	.asciiz "\nDivision:  "
	remainderPrompt:	.asciiz "\nRemainder: "
	errorMessage:	.asciiz "\nEnter appropriate values!"
	askContinueMes:	.asciiz "\nDo you want to leave? If yes, press 1. Otherwise press -1: "
	
.text
	sub	$sp, $sp, 20	# allocate 5 rooms from stack
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	
Main:
	# go to subprogram calculateDivision
	jal	calculateDivision
	
	# go to subprogram to show result
	jal	showResult
	
	# stay in main
	j	Main
	
calculateDivision:
	# initialize registers to be used (to zero)
	addi	$s0, $zero, 0
	addi	$s1, $zero, 0
	addi	$s2, $zero, 0
	addi	$s3, $zero, 0
	move	$s0, $ra
	j	getNumbers
	
getNumbers:
	# print message to get the number dividend
	li	$v0, 4
	la	$a0, dividendNumber
	syscall
	
	# get first input
	li	$v0, 5
	syscall
	
	# move dividend to $s1 reg
	move	$s1, $v0
	
	# print message to get the number divider
	li	$v0, 4
	la	$a0, dividerNumber
	syscall
	
	# get second input
	li	$v0, 5
	syscall
	
	# move divider to $s2 reg
	move	$s2, $v0
	
	# check if divider is zero, if it is, then give warning message
	beq	$s2, $zero, giveError

startDivision:
	sw	$ra, 0($sp)
	# if $s1 (dividend) is less than $s2(divider), then go to finishDivision
	blt	$s1, $s2, finishDivision

findDivision:
	
	# subtract $s2 from $s1, put the result into $s1
	sub	$s1, $s1, $s2
	
	sub	$sp, $sp, 4	# allocate 1 room from stack to hold $ra reg
	jal	startDivision	# call itself (recursion)
	
	# increase $s3 by one (it holds division)
	addi	$s3, $s3, 1
	
		finishDivision:
			# get $ra reg from stack
			lw	$ra, 0($sp)
			addi	$sp, $sp, 4
			jr	$ra

showResult:
	# set remainder, then continue showResult part
	addi	$s4, $s1, 0
	
	# print division message prompt
	li	$v0, 4
	la	$a0, divisionPrompt
	syscall
	
	# print division
	li	$v0, 1
	move	$a0, $s3
	syscall
	
	# print remainder message prompt
	li	$v0, 4
	la	$a0, remainderPrompt
	syscall
	
	# print remainder
	li	$v0, 1
	move	$a0, $s4
	syscall
	
	# ask the user if s/he wants to continue
	li	$v0, 4
	la	$a0, askContinueMes
	syscall
	
	# get input for continue or not
	li	$v0, 5
	syscall
	
	# move input to $s1
	move	$s1, $v0
	
	# if 1, continue
	beq	$s1, 1, calculateAgain
	
	# if -1, exit
	beq	$s1, -1, exit
	
calculateAgain:
	jr	$ra		
	
giveError:
	# print error message
	li	$v0, 4
	la	$a0, errorMessage
	syscall
	
	# ask the user if s/he wants to continue
	# user should press 1 either -1
	li	$v0, 4
	la	$a0, askContinueMes
	syscall
	
	# get input for continue or not
	li	$v0, 5
	syscall
	
	# move input to $s1
	move	$s1, $v0
	
	# if 1, continue
	beq	$s1, 1, goBack
	
	# if -1, exit
	beq	$s1, -1, exit
	
	j	giveError	# stay here in case the user enters another key (not 1 or -1)
	
goBack:
	j	Main

exit:
	# put old values and add space to stack
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 20
	
	# finish the execution
	li	$v0, 10
	syscall	
