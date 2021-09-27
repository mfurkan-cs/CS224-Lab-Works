# CS224
# Sec3
# @author: Murat Furkan Uðurlu
# Id: 21802062

.data
	intToBeSearched:		.word -1600085856
	intPattern:		.word 41120
	patternLength:		.word 16
	promptNumber:		.asciiz "Number:  "
	promptPattern:		.asciiz "Pattern: "
	promptMessage:		.asciiz "Occurence: "
	newLine:			.asciiz "\n"

.text
Main:
	
	lw	$a2, patternLength    	# load pattern length
	move	$s7, $a2
	lw	$a1, intToBeSearched	# load integer to be searched
	li	$s2, 1  			# Control bit
	lw	$a0, intPattern		# load pattern code
	li	$s5, 0			# 
	li	$s1, 32			# load 32 to know where to stop
	
	# allocate 3 rooms from stack
	sub	$sp, $sp, 12
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	
	# jump and link to getLastBytes
	jal	getLastBytes
	
	# jump and link to printInfo
	jal	printInfo
	
	# finish the execution
	li	$v0, 10
	syscall
	
getLastBytes:
	beq	$s0, $s1, finish			# if 32 times the cycle is processed, then exit
	beq	$a2, $s3, adjustBeforeShift	# if $s3 reaches to patternlength, then exit
	and	$s4, $a1, $s2			# check a bit in the integer to be searched
	add	$s6, $s6, $s4			# add to $s6 the checked bit (here we find the last digits)
	sll	$s2, $s2, 1			# shift left $s2 to check every digit
	addi	$s3, $s3, 1			# add 1 to $s3
	
	j	getLastBytes			# loop
	
# Make some adjustments to continue
adjustBeforeShift:
	li	$s3, 0				# set to zero to use again
	li	$s2, 1				# re-set the control bit
	j	shiftIntToBeSearched		# jump to next part

# Shift original integer to be searched right
shiftIntToBeSearched:
	beq	$a2, $s3, FindPattern		# if $s3 reaches to patternlength, then exit
	sra	$a1, $a1, 1			# shift integer 1 bit right
	addi	$s3, $s3, 1			# increase $s3 by one
	j	shiftIntToBeSearched		# loop
	
# Examine the pattern
FindPattern:
	add	$s0, $s0, $s7			# increase $s0 to calculate where to stop whole find code...
	beq	$s6, $a0, increase		# if digits gotten from original number is equal to pattern, increase
	li	$s3, 0				# set to 0 to reuse
	li	$s6, 0				# set to 0 to reuse
	li	$s2, 1				# set to 1 to reuse control bit
	j	getLastBytes			# jump to initial part
	
increase:
	addi	$s5, $s5, 1			# increase no of occurences by 1
	li	$s3, 0				# set to zero to reuse
	li	$s6, 0				# set to zero to reuse
	li	$s2, 1				# set to 1 to reuse
	j	getLastBytes			# jump to initial part to check remaining parts
	
finish:
	jr	$ra				# go back to main
	
printInfo:
	li	$v0, 4				# print prompt
	la	$a0, promptPattern
	syscall
	
	lw	$a0, 0($sp)			# store original values from stack
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	addi	$sp, $sp, 12
	
	li	$v0, 34				# print pattern to be searched
	move	$a0, $a0
	syscall
		
	li	$v0, 4				# print new Line
	la	$a0, newLine
	syscall
	
	li	$v0, 4				# print prompt
	la	$a0, promptNumber
	syscall
	
	li	$v0, 34				# print number to be searched
	move	$a0, $a1
	syscall
	
	li	$v0, 4				# print new line
	la	$a0, newLine	
	syscall
		
	li	$v0, 4				# print prompt
	la	$a0, promptMessage
	syscall
	
	li	$v0, 1				# print no of occurences
	move	$a0, $s5
	syscall
	
	jr	$ra				# go back to main
