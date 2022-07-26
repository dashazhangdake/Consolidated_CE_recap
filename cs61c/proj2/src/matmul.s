.import ../src/dot.s

.globl matmul
.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
	# Error checks before we make any action
	li t6, 1  # Assign t6 to 1 for later comparisons
	slt t0, a1, t6
	slt t1, a2, t6
	or t0, t0, t1  # t0 is 1 if a1 or a2 is less than 1
	slt t1, a4, t6
	slt t2, a5, t6
	or t1, t1, t2  # t1 is 1 if a4 or a6 is less than 1
	
	or t0, t1, t0  # MatSize error in m1 or m0
	bnez t0 matsize_err

	bne a2, a4, dims_not_match # Dim not match error
	# Prologue
	addi sp, sp, -32
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	sw s5, 24(sp)
	sw s6, 28(sp)  # Save all saved registers we may use, and ra

	mv s0, a0  # Ptr to the start of m0
	mv s1, a1  # rows of m0 (dimx of d)
	mv s2, a2  # cols of m0
	mv s3, a3  # Ptr to the start of m1
	mv s4, a4  # rows of m1
	mv s5, a5  # cols of m1 (dimy of d)
	mv s6, a6  # ptr to the start of result d

	add t0, x0, x0  # Use t0 for i (loop through the rows of m0)

outer_loop_start:
	beq t0, s1, outer_loop_end 
	slli t2, t0, 2  # Set t2 to 4 * i
	mul t2, t2, s2  # The address offset (4 * i * col_m0) of the first element of m0[i, :] 


inner_loop_start:
	beq t1, s5, inner_loop_end

	add a0, s0, t2  # Set a0 to base + 4 * i * col_m0
		
	slli t3, t1, 2  # Set t3 to 4 * j
	add a1, s3, t3  # Set a1 to base + 4 * j

	add a2, x0, s2  # For each dot product, we should use #row of m1 or #col of m0 for the size of dot product
	addi a3, x0, 1  # For outter loop, stride is 1  
	addi a4, s5, 0  # For inner loop, stride is #col1

	addi sp, sp, -16 # temp registers might be overwritten by dot function
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)

	jal ra, dot  # After that a0 contains the result to be placed on d[i, j]
	
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	addi sp, sp, 16 # temp registers might be overwritten by dot function

	# # Accumulate address of return matrix to avoid messy address computation
	# sw a0, 0(s6)
	# addi s6, s6, 4

	# # If you don't like this dirty approach, let's solve this disgusting addressing problem
	slli t3, t0, 2  # i * 4
	mul t4, s1, t3  # dimx * i * 4
	slli t5, t1, 2  # ystep = j * 4
	add t5, t5, t4  # offset = dimx * 4 * i + j * 4 
	add t5, s6, t5  # address = base + offset
	sw a0, 0(t5)


	# Accumulate j (cols of m1)
	addi t1, t1, 1
	j inner_loop_start

inner_loop_end:
	# Accumularw i (rows of m0)
	addi t0, t0, 1
	add t1, x0, x0
	j outer_loop_start

outer_loop_end:
	# Epilogue
    lw ra, 0(sp)
   	lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
	lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32
	ret

matsize_err: 
	li a0 38
    j exit

dims_not_match:
	li a0 38
    j exit
