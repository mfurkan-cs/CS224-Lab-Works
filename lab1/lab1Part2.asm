# ---------------------------
# LAB 1 / PART-2
# ---------------------------
.data
inputA:	.asciiz "Enter an integer for a: "
inputB:	.asciiz "Enter an integer for b: "
inputC:	.asciiz "Enter an integer for c: "
inputD:	.asciiz "Enter an integer for d: "
result:	.asciiz "The Calculation is x = a*(b-c)%d \nResult is "

.text
# Print message for a
li $v0, 4
la $a0, inputA
syscall

# User input for a
li $v0, 5
syscall

# Store a to $t0
move $t0, $v0

# Print message for b
li $v0, 4
la $a0, inputB
syscall

# User input for b
li $v0, 5
syscall

# Store b to $t1
move $t1, $v0

# Print message for c
li $v0, 4
la $a0, inputC
syscall

# User input for c
li $v0, 5
syscall

# Store c to $t2
move $t2, $v0

# Print message for d
li $v0, 4
la $a0, inputD
syscall

# User input for d
li $v0, 5
syscall

# Store d to $t3
move $t3, $v0

# Subtraction operation (b-c) = k
sub $t4, $t1, $t2

# Multiplication operation a*k = m
mult $t0, $t4
mflo $t5

# Modulo Operation m%d = m-(m/d)*d
div $t5, $t3
mfhi $t2

# Print Operation and Result message 
li $v0, 4
la $a0, result
syscall


	
# Store result to $a0 and print it
adjustAndPrintTheFinalResult:
	bltz $t2, increase
	move $a0, $t2
	li $v0, 1
	syscall
	j finish

increase:
	abs $t3, $t3
	add $t2, $t2, $t3
	j adjustAndPrintTheFinalResult
	
# Finish the program
finish:
	li $v0, 10
	syscall
