# CS224
# Sec3
# @author: Murat Furkan Uðurlu
# Id: 21802062
# This program receives a decimal number from the user.
# Then reverses the number according to its binary format.
# Finally, shows the reversed number in hexadecimal format.

.data
	inputMes:	.asciiz "Please enter a decimal number: "
	newLine:		.asciiz "\n"
	prompt:		.asciiz "Reversed version in hexadecimal: "

.text
Main:
	# print input prompt
	li	$v0, 4
	la	$a0, inputMes
	syscall
	
	# get an integer from the user
	li	$v0, 5
	syscall
	
	# Store the decimal
	move	$s0, $v0
	
	li	$s2, 0 # to store a bit (0 or 1)
	li	$s3, 1  # to check a bit is 0 or 1 (in and operand)
	li	$s4, 31 # to stop the execution in 32th loop
	li	$s5, 0 # to count the loop number
	li	$s6, 0 # will be the reverse number
	
LoopForStack:
	
	# if 32 times the loop executed, then exit
	beq	$s4, $s5, printMessage
	
	# check a bit is 1 or 0, then put it to $s2
	and	$s2, $s0, $s3
	
	# add the bit to $s6 (which will be reverse number)
	add	$s6, $s6, $s2
	
	# shift 1 bit left (to make addition into first bit)
	sll	$s6, $s6, 1
	
	# shift 1 bit right (to control the left side bit)
	sra	$s0, $s0, 1
	
	# increase counter
	addi	$s5, $s5, 1
	
	# go to loop back
	j LoopForStack
	
printMessage:
	
	# Print the prompt message
	li	$v0, 4
	la	$a0, prompt
	syscall
	
	# print the reversed number
	li	$v0, 34
	move	$a0, $s6
	syscall
	
	# finish the execution
	li	$v0, 10
	syscall
