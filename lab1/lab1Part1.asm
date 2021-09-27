.data
array:		.word 5, 3, 12, 3, 2, 3, 12, 3, 5
arraySize:	.word 9
byte:		.word 4
space:		.asciiz " "
newLine:		.asciiz "\n"
equalMessage:	.asciiz "The above array is symmetric"
notEqualMessage:	.asciiz "The above array is not symmetric"

.text

# Compute $t1 (where the execution stops)
lw $t2, arraySize
lw $t3, byte
mul $t1, $t2, $t3

print:
	# If $t0 reaches to $t1 in terms of byte value, exit
	beq $t0, $t1, exit
	lw $t6, array($t0) # load array eleman to $t6
	addi $t0, $t0, 4
	
	li, $v0, 1
	move $a0, $t6 # print eleman
	syscall
	
	li, $v0, 4
	la, $a0, space # add space btw elemans
	syscall
	
	j print # jump back to print
	
# Initialize regs to zero and pass to next line
exit:
	addi $t0, $zero, 0
	addi $t1, $zero, 0
	addi $t2, $zero, 0
	addi $t3, $zero, 0
	addi $t6, $zero, 0
	li, $v0, 4
	la, $a0, newLine
	syscall
	j adjust
	
# Make adjustments before comparing elemans
adjust:
	addi $t7, $zero, 1
	lw $t4, arraySize   # Load arraySize to $t4
	sub $t4, $t4, $t7   # Array size - 1
	lw $t5, byte       # Load 1 byte size to $t5
	mul $t3, $t5, $t4   # Calculate the byte size to make comparison in all elemans
	j compare
	
# Compare symmetric positions
compare:
	lw $t1, array($t0)
	lw $t2, array($t3)
	
	bne $t1, $t2, exit2
	lw $t4, array($t0)
	addi $t0, $t0, 4
	sub $t3, $t3, $t5
	
	beq $t0, $t3, exit3
	
	j compare
	
# If array is not symmetric, print corresponding message and finish the program
exit2:
	li $v0, 4
	la $a0, notEqualMessage
	syscall
	
	li $v0, 10
	syscall
	
# If array is symmetric, print corresponding message and finish the program
exit3:
	li $v0, 4
	la $a0, equalMessage
	syscall
	
	li $v0, 10
	syscall
