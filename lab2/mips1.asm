.data
	array:		.word	-8, -2, 256, 1, 16
	arraySize:	.word	5
	prompt8:		.asciiz 	"No of eights: "
	prompt16:		.asciiz 	"No of sixteens: "
	newLine:		.asciiz "\n"


.text
Main:
	la	$a0, array
	lw	$a1, arraySize
	jal	CounterProgram
	jal	print
	li	$v0, 10
	syscall

CounterProgram:
	li	$v0, 0
	li	$v1, 0
	j	count
count:
	beq	$a1, $zero, exit
	lw	$s0, 0($a0)
	abs	$s0, $s0
	lw	$s1, 0($a0)
	abs	$s1, $s1
	addi	$a0, $a0, 4
	addi	$a1, $a1, -1
	j	countEight
	
countEight:
	blt	$s0, $zero, checkEight
	sub	$s0, $s0, 8
	j	countEight
	
checkEight:
	beq	$s0, -8, increaseEight
	j	countSixteen

increaseEight:
	addi	$v0, $v0, 1
	j	countSixteen
	
countSixteen:	
	blt	$s1, $zero, checkSixteen
	sub	$s1, $s1, 16
	j	countSixteen
	
checkSixteen:
	beq	$s1, -16, increaseSixteen
	j	count

increaseSixteen:
	addi	$v1, $v1, 1
	j	count

exit:
	jr	$ra
	
print:
	move	$s3, $v0
	move	$s4, $v1
	
	li	$v0, 4
	la	$a0, prompt8
	syscall
	
	li	$v0, 1
	move	$a0, $s3
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	li	$v0, 4
	la	$a0, prompt16
	syscall
	
	li	$v0, 1
	move	$a0, $s4
	syscall
	
	jr	$ra
