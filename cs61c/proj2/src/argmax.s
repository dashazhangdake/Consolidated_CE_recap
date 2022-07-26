.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
	# Prologue
    # Sanity check on a1
    li t0, 1 # set t0 to 1 for comparison
    slt t0, a1, t0 # set t0 to 1 if a1 < 1
    bnez t0 lenght_fail

    # Real prologue, decrement sp, save saved registers
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)

    # move argument registers to saved registers
    mv s0, a0  # s0 for address 
    mv s1, a1  # s1 for array size

    add t0, x0, x0 # t0 for iterative variable i to traverse the array
    add t3 x0, x0 # t3 for current maximum ?

    # get a0 ready for returning
    add a0, x0, x0

loop_start:
    beq t0, s1, loop_end
    slli t1, t0, 2  # t1 = 4 * i
    add t2, s0, t1  # t2 = &(arr[i])
    lw t2, 0(t2) # t2 = arr[i] after load
     
    ble t2, t3, loop_continue # jump to next index if arr[i] <= current_max(t3) 

    add t3, t2, x0  # Otherwise, set local max to arr[i]
    add a0, t0, x0  # and set a0 to i

    addi t0, t0, 1  # accumulate t0 (i)
    j loop_start    # then go to next iteration

loop_continue:
    # Do nothing on local max or max index
    addi t0, t0, 1  # accumulate t0 (i) and jump to next iteration
    j loop_start
    
loop_end:
	# Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    addi sp, sp, 12
	ret

lenght_fail:
    li a0, 36
    j exit
