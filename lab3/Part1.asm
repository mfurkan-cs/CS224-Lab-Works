# CS224
# Lab 3
# Section 3
# Murat Furkan Uðurlu
# 21802062

# This program finds the number of add and lw instructions in the code written.

.data
	# This part is a part of previous labs (just chosen as an arbitrary example code)
	noOfAddsPrompt:	.asciiz "\nNo of add  instructions: "
	noOfLwPrompt:	.asciiz "\nNo of lw   instructions: "
	array:		.word 1, 2, 7, 11

.text
MainStart:
	#--------------EXAMPLE CODE---------------------
	# This is a part of previous labs (just put here as an arbitrary example)
	# Allocate room for 5 items
	addi	$sp, $sp, -20
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	
	la	$s0, array
	
	lw	$s1, 0($s0)	# 1. lw instruction
	addi	$s0, $s0, 4
	lw	$s2, 0($s0)	# 2. lw instruction
	addi	$s0, $s0, 4
	lw	$s3, 0($s0)	# 3. lw instruction
	addi	$s0, $s0, 4
	lw	$s4, 0($s0)	# 4. lw instruction
	
	add	$s5, $s4, $s3	# 1. add instruction
	add	$s6, $s4, $s2	# 2. add instruction
	add	$s1, $s0, $s3	# 3. add instruction
	add	$s7, $s6, $s3	# 4. add instruction
	add	$s3, $s2, $s3	# 5. add instruction
	
	add	$s5, $s4, $s3	# 6. add instruction
	add	$s6, $s4, $s2	# 7. add instruction
	
	lw	$s0, 0($sp)	# 5. lw instruction
	lw	$s1, 4($sp)	# 6. lw instruction
	lw	$s2, 8($sp)	# 7. lw instruction
	lw	$s3, 12($sp)	# 8. lw instruction
	lw	$s4, 16($sp)	# 9. lw instruction
	addi	$sp, $sp 20
	
	#---------END OF EXAMPLE CODE------------
		
	# put start and end addresses of main into $a0 and $a1 correspondingly
	la	$a0, MainStart
	la	$a1, MainEnd
	
	# call counter subprogram first time for the main part
	jal	CountNoOfOperations
	
	# put start and end addresses of subprogram into $a0 and $a1 correspondingly
	la	$a0, CountNoOfOperations
	la	$a1, goBack
	
	# call counter subprogram second time for the counter itself
	jal	CountNoOfOperations
	
	# ---------------print the results-----------
	# print no of add inst label
	li	$v0, 4
	la	$a0, noOfAddsPrompt
	syscall
	
	# print no of add insts
	li	$v0, 1
	move	$a0, $s0
	syscall
	
	# print no of lw inst label
	li	$v0, 4
	la	$a0, noOfLwPrompt
	syscall
	
	# print no of lw insts
	li	$v0, 1
	move	$a0, $s1
	syscall
	
	
	lw	$s0, 0($sp)	# 10. lw instruction
	lw	$s1, 4($sp)	# 11. lw instruction
	lw	$s2, 8($sp)	# 12. lw instruction
	lw	$s3, 12($sp)	# 13. lw instruction
	lw	$s4, 16($sp)	# 14. lw instruction
	
	addi	$sp, $sp, 20
	
	# Finally, finish the execution
	li	$v0, 10
	syscall

MainEnd: # finish address of the main part
	
CountNoOfOperations:
	# allocate 5 rooms from the stack
	addi	$sp, $sp, -20
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	
	# $s4 will hold the code in order to determine add instructions
	li	$s4, 1		# add 1
	sll	$s4, $s4, 31	# shift left --> 1000....000 --> for hex 0x8.... (will be compared with func code of add)
	
	# $s5 will hold the code in order to determine lw instructions
	li	$s5, 35		# add 35 --> 100011
	sll	$s5, $s5, 26	# shift left --> 100011.... --> for hex 0x8...

StartCounting:
	# if start address reaches to end address, then go back to main
	beq	$a0, $a1, goBack
	lw	$s2, 0($a0)	# 15. lw instruction
	sll	$s2, $s2, 26	# make arrangements to check if it is add instr
	lw	$s3, 0($a0)	# 16. lw instruction
	sra	$s3, $s3, 26
	sll	$s3, $s3, 26	# make arrangements to check if it is lw instr
	beq	$s2, $s4, increaseAdd	# increase $s0, if $s2 is add instr
	beq	$s3, $s5, increaseLw	# increase $s1, if $s3 is lw instr
	addi	$a0, $a0, 4	# increase address to pass next one
	j	StartCounting	# loop
	
increaseAdd:
	addi	$s0, $s0, 1	# increase $s0 (no of add instr)
	addi	$a0, $a0, 4	# increase address to pass next one
	j	StartCounting	# go back to loop
	
increaseLw:
	addi	$s1, $s1, 1	# increase $s1 (no of lw instr)
	addi	$a0, $a0, 4	# increase address to pass next one
	j	StartCounting	# go back to loop
	
goBack:
	jr	$ra	# go back to main code
