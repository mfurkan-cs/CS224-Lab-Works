.data
array:		.word 900, 0, -10, 4, 5, 1
arraySize:	.word 6
byte:		.word 4
space:		.asciiz "           "
newLine:		.asciiz "\n"
prompt:		.asciiz "Memory Address   Array Element\nPosition (hex)   Value (int)\n=============    ============\n"
average:		.asciiz "Average: "
max:		.asciiz "Max: "
min:		.asciiz "Min: "

.text
# Print the prompt
li $v0, 4
la $a0, prompt
syscall

# Compute $t0 (where the execution stop)
lw $t1, arraySize
lw $t2, byte
mul $t0, $t1, $t2

# Print the contents of $t0 as an hexadecimal number.
print:
	beq $t0, $t3, reset
	
	la $t4, array($t3)
	li $v0, 34
	add $a0, $zero, $t4
	syscall
	
	li $v0, 4
	la, $a0, space
	syscall
	
	li $v0, 1
	lw, $a0, array($t3)
	syscall
	
	addi $t3, $t3, 4
	
	li, $v0, 4
	la, $a0, newLine
	syscall
	
	j print

# Reset registers and initially hold min & max & average
reset:
	addi $t5, $zero, 0
	addi $t4, $zero, 0
	addi $t3, $zero, 0
	lw $t7, array($t3)  # $t7 is used to store max value
	lw $t6, array($t3)  # $t6 is used to store min value
	j find

# Find max, min and average
find:
	lw $t5, array($t3)  # $t5 is used to hold the current value
	
	bgt $t5, $t7, increase
	blt $t5, $t6, decrease
	
	beq $t0, $t3, exit
	add $t4 , $t4, $t5  # $t4 is used to hold the sum
	addi $t3, $t3, 4    # increase the address to reach next eleman
	
	j find

increase:
	lw $t7, array($t3) # set new max
	j find
	
decrease:
	lw $t6, array($t3) # set new min
	j find

# Finish program execution after print min & max & average
exit:
	li $v0, 4
	la, $a0, average  # average prompt
	syscall

	mtc1.d $t4, $f2  # int to double
	mtc1.d $t1, $f4
	div.s $f6, $f2, $f4 # division for single precision
	
	#add.s $f6, $f6, $f2 
	
	li $v0, 2
	mov.s $f12, $f6 # print average
	syscall
	
	li, $v0, 4
	la, $a0, newLine # switch to new line
	syscall
	
	li $v0, 4
	la, $a0, max # print max prompt
	syscall
	
	li $v0, 1
	move $a0, $t7  # print max
	syscall
	
	li, $v0, 4
	la, $a0, newLine # switch to next line
	syscall
	
	li $v0, 4
	la, $a0, min  # print min prompt
	syscall
	
	li $v0, 1
	move $a0, $t6  # print min
	syscall
	
	li $v0, 10 # finish program
	syscall
