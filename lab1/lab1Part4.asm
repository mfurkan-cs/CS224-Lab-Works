.data
inputB:	.asciiz "Enter an integer for B: "
inputC:	.asciiz "Enter an integer for C: "
inputD:	.asciiz "Enter an integer for D: "
result:	.asciiz "The Calculation is A = (B + C * (D / C)) % B\nResult is "
error:	.asciiz "Error, please enter appropriate values"

.text
# Print message for B
li $v0, 4
la $a0, inputB
syscall

# User input for B
li $v0, 5
syscall

# Store B to $t1
move $t1, $v0

# Print message for C
li $v0, 4
la $a0, inputC
syscall

# User input for C
li $v0, 5
syscall

# Store C to $t2
move $t2, $v0

# Print message for D
li $v0, 4
la $a0, inputD
syscall

# User input for D
li $v0, 5
syscall

# Store D to $t3
move $t3, $v0

# Division operation D/C = m
div $t3, $t2
mflo $t4

# Multiplication operation C*m = k
mult $t2, $t4
mflo $t5

# Addition operation B + k = x
add $t6, $t1, $t5

# Modulo Operation x % B = x-(x/B)*B
#div $t7, $t1
#mflo $t0
#mult $t0, $t1
#mflo $t0
#sub $t0, $t7, $t0
div $t6, $t1
mfhi $t0

# Check error
checkError:
	beq $t1, $zero, giveError
	j finalPart
	
# Give error
giveError:
	li $v0, 4
	la $a0, error # print error message
	syscall
	
	li $v0, 10 # finish program
	syscall

# Print Operation and Result message
finalPart:
	bltz $t0, adjust # go adjust and make positive
	
	li $v0, 4
	la $a0, result # print result prompt
	syscall
	
	move $a0, $t0 # print result
	li $v0, 1
	syscall
	
	# Finish the program
	li $v0, 10
	syscall
adjust:
	abs $t1, $t1 # abs value
	add $t0, $t0, $t1 # add to reach + value
	j finalPart
