.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
	# Prologue
    # Sanity check on a0, a1, a3, a4 as required before we write any saved register
    li t4, 1
    li t0, 0
    slt t0, a2, t4
    slt t2, a3, t4
    slt t3, a4, t4
    
    or t1, t2, t3 # if any stride < 1
    
    bnez t0 length_fail
    bnez t1 stride_fail


    # Make copies of registers 
    addi sp, sp, -24 # 5x4 for s0~s5, 4 for ra register
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    
    # Move argument registers to saved registers
	add s0, a0, x0 # ptr2 a1
    add s1, a1, x0 # ptr2 a2
    add s2, a2, x0 # number of elements
    add s3, a3, x0 # stride1
    add s4, a4, x0 # stride2
    
    # t0 for iterative varible
    add t0, x0, x0 #(t0 = i = j)
    # We won't use the original content a0 anymore, write 0 to it, prepare for returning 
    add a0, x0, x0
    
loop_start:
	beq t0, s2, loop_end
    slli t1, t0, 2 # set t1 to 0, 4, 8, ..... (i * 4)
	mul t2, t1, s3 # Offset of a1: stride1 * (i * 4)
	mul t3, t1, s4 # Offset of a2: stride2 * (i * 4)
	
    add t2, s0, t2 # Get the address of element in a1
    add t3, s1, t3 # Get the address of element in a2
    
    lw t2, 0(t2)
    lw t3, 0(t3) # Get desired element from memory
    
    mul t3, t2, t3 # arr1[i] * arr2[j]
    add a0, a0, t3
    
    addi t0, t0, 1
    jal x0, loop_start
    
length_fail:
	li a0 36
    j exit
stride_fail:
	li a0 37
    j exit
loop_end:
	# Epilogue
    lw ra, 0(sp)
   	lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
	ret
