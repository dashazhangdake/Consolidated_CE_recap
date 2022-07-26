.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
ebreak
relu:
	# Prologue
	addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    addi t0, x0, 1
    add s0, a0, x0 # s0 = &[arr[0]]
    add s1, a1, x0 # s1 = n
    blt s1, t0, exception0
    add t0, x0, x0 # index counter
loop_start:
	beq t0, s1, loop_end
    slli t1, t0, 2  # t1 is the offset
    add t2, s0, t1
    lw t3, 0(t2)
    bge t3, x0, loop_continue
    sw x0, 0(t2)
    addi t0, t0, 1
    j loop_start
loop_continue:
	addi t0, t0, 1
	j loop_start
loop_end:
	# Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    ret 

exception0:
    li a0, 36
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    j exit

exit:
