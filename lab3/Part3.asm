# CS224
# Lab 3
# Section 3
# Murat Furkan Uðurlu
# 21802062

# This program prints the elements of an array in reverse order. It is implemented with recursion.

#----------------------------------------------------------------
	.text
# CS224 Spring 2021, Program to be used in Lab3
# February 23, 2021
# 
Menu:
	# print menu
	li	$v0, 4
	la	$a0, menu
	syscall
	
	# print operation label
	li	$v0, 4
	la	$a0, operationLabel
	syscall
	
	# get input from user to choose an operation
	li	$v0, 5
	syscall
	
	# move the operation number to $s0 reg
	move	$s0, $v0
	
	# if operation is 1, then goCreateList
	beq	$s0, 1, goCreateList
	
	# if operation is 2, then goPrintList
	beq	$s0, 2, goPrintList
	
	# if operation is 3, then goExit
	beq	$s0, 3, goExit
	
	# jump menu to stay menu
	j	Menu

goCreateList:
	# print get size label
	li	$v0, 4
	la	$a0, getSizeLabel
	syscall
	
	# get input for size
	li	$v0, 5
	syscall
	
	# pass size to $a0 and $s3(backup to use inside subprogram) regs
	move	$a0, $v0
	move	$s3, $v0
	
	# go to corresponding subprogram to create array
	jal	createLinkedList
	
	# hold head address in $s1 to have backup
	move	$s1, $v0	
	
	# print message to show that list is created successfully
	li	$v0, 4
	la	$a0, successfulCreationLabel
	syscall
	
	# go back to menu
	j	Menu
	
goPrintList:
	# pass head of list to $a0 from backup
	move	$a0, $s1
	
	# go corresponding subprogram to print list in reverse order
	jal	printLinkedList
	j	Menu
	
goExit:
	# finish the execution
	li	$v0, 10
	syscall
	
createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
# Node 1 contains 4 in the data field, node i contains the value 4*i in the data field.
# By 4*i inserting a data value like this
# when we print linked list we can differentiate the node content from the node sequence no (1, 2, ...).
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	addi	$s0, $s0, 0
	addi	$s1, $s1, 0
	addi	$s2, $s2, 0
	addi	$s3, $s3, 0
	addi	$s4, $s4, 0
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	
	# print message to get element
	li	$v0, 4
	la	$a0, getElementLabel
	syscall
	
	# get element from user
	li	$v0, 5
	syscall
	
	move	$s4, $v0	
	
	sw	$s4, 4($s2)	# Store the data value.
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	
	# continue getting element
	li	$v0, 5
	syscall
	
	move	$s4, $v0
		
	sw	$s4, 4($s2)	# Store the data value.
	j	addNode
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
#=========================================================
printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

# Save $s registers used
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
	
print:
	# store $ra reg
	sw	$ra, 0($sp) 
	
	# if $s0 is not zero, then go to printNextNode
	bne	$s0, $zero, printNextNode
	
	# if zero, then lw from stack
	lw	$s0, 16($sp)
	lw	$s1, 12($sp)
	lw	$s2, 8($sp)
	lw	$s3, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 20
	jr	$ra
	
printNextNode:
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
	
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	
	move	$s0, $s1 	# Consider next node.
	jal	print		# here the function calls itself (recursion)

	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.

printedAll:
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
	
#=========================================================		
	.data
line:	
	.asciiz "\n --------------------------------------"

menu:	
	.asciiz "\n--------MENU--------\n1-Create list\n2-Print reverse list\n3-Exit"

operationLabel:
	.asciiz "\nEnter your operation: "
	
getSizeLabel:
	.asciiz "\nEnter size: "
	
getElementLabel:
	.asciiz "\nEnter  elements: "
	
successfulCreationLabel:
	.asciiz "\nList created successfully...\n"
	
nodeNumberLabel:
	.asciiz	"\n Node No.: "
	
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "
