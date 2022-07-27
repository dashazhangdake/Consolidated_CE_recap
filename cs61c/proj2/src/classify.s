.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
	# Prolouge
	addi sp, sp, -52 # Use 3 saved registers for argument, And 4 registers to saved internal variables
	sw ra, 0(sp)
	sw s0, 4(sp) # s0 ~ s2 for input args, s0 can be released after check argc error
	sw s1, 8(sp)
	sw s2, 12(sp)  
	sw s3, 16(sp) # s3 for m0, s4 for m1, s5 for input matrix, s6 for hmatrix ,s7 for omatrix
	sw s4, 20(sp) # s4 for m0->row, m0->col
	sw s5, 24(sp) # s5 for m1
	sw s6, 28(sp) # s6 for m1->row, m1->col
	sw s7, 32(sp) # s7 for input
	sw s8, 36(sp) # s8 for input->row, input->col
	sw s9, 40(sp) # s9 for h
	sw s10, 44(sp)
	sw s11, 48(sp)
	# Check argc error before we store arguments to saved registers
	mv s0, a0  # number of arguments provided
	li t0, 5  # We know argc should be 5
	bne s0, t0, argc_error # If argc != 5, jump to error handing

	mv s1, a1  # ptr2 argument strings
	mv s2, a2  # if set to 0, print the classification, otherwise, no print

    #================================================================
    # calling read_matrix
		# a0 is a ptr to fname string
		# a1 is a ptr to integer, *(a1) = #rows
		# a2 is a ptr to integer, *(a2) = #cols 
	# Returns a0, which is a ptr to matrix in the array
    #================================================================
	# Read pretrained m0
	# Allocate space for s4 storing #row and #col of m0
	li a0, 8 
	jal malloc
	beq a0, x0, malloc_error
	mv s4, a0  
    lw a0, 4(s1) # Get the ptr2 file path string to m0, and put it in t0
	addi a1, s4, 0  # &(m0->row)
	addi a2, s4, 4  # &(m0->col)
	jal read_matrix
	mv s3, a0  # &(m0)  


	# Read pretrained m1
	li a0, 8 
	jal malloc
	beq a0, x0, malloc_error
	mv s6, a0  
    lw a0, 8(s1) # Get the ptr2 file path string to m0, and put it in t0
	addi a1, s6, 0  # &(m0->row)
	addi a2, s6, 4  # &(m0->col)
	jal read_matrix
	mv s5, a0  # &(m1)  

	# Read input matrix
	li a0, 8 
	jal malloc
	beq a0, x0, malloc_error
	mv s8, a0  
    lw a0, 12(s1) # Get the ptr2 file path string to m0, and put it in t0
	addi a1, s8, 0  # &(m0->row)
	addi a2, s8, 4  # &(m0->col)
	jal read_matrix
	mv s7, a0  # &(input)  

    #================================================================
    # calling matmul
		# a0: ptr 2 matA
		# a1: # rows of matA
		# a2: # cols of matA
		# a3: ptr 2 matB
		# a4: # rows of MatB
		# a5: # cols of MatB
		# a6: # ptr to MatRes
    #================================================================
	# Compute h = matmul(m0, input)
	lw t0, 0(s4) # row for m1
	lw t1, 4(s8) # col for input
	mul t1, t0, t1 # t1 = row_m0 * col_input
	slli t1, t1, 2 # Byte for malloc
	mv a0, t1
	jal malloc
	beq a0, x0, malloc_error
	mv s9, a0 # s9 for &h

	# Get arguments ready and do MxM on m0 and input
	mv a0, s3
	lw a1, 0(s4)
	lw a2, 4(s4)
	mv a3, s7
	lw a4, 0(s8)
	lw a5, 4(s8)
	mv a6, s9
	jal matmul

	# Compute h = relu(h)
	mv a0, s9
	lw t0, 0(s4) # row for m1
	lw t1, 4(s8) # col for input
	mul t1, t0, t1 # t1 = row_m0 * col_input
	mv a1, t1
	jal relu

	# Compute o = matmul(m1, h)
	lw t0, 0(s6) # row for m1
	lw t1, 4(s8) # col for h
	mul t1, t0, t1 # t1 = row_m0 * col_input
	slli t1, t1, 2 # Byte for malloc
	mv a0, t1
	jal malloc
	beq a0, x0, malloc_error
	mv s10, a0 # s10 for &o
	# Get arguments ready and do MxM on m0 and input
	mv a0, s5
	lw a1, 0(s6)
	lw a2, 4(s6)
	mv a3, s9
	lw a4, 0(s4)
	lw a5, 4(s8)
	mv a6, s10
	jal matmul

	# Write output matrix o
	lw a0, 16(s1)
	mv a1, s10
	lw a2, 0(s6)
	lw a3, 4(s8)
	jal write_matrix

	# Compute and return argmax(o)
	mv a0, s10
	lw t0, 0(s6) # row for m1
	lw t1, 4(s8) # col for h
	mul t1, t0, t1
	mv a1, t1
	jal argmax
	mv s11, a0
	ebreak

	# If enabled, print argmax(o) and newline
	bne s2, x0, no_print # If not, jump to the finalstage
	mv a0, s11
	jal print_int

	# I hear you also want to get the newline printed
	li a0, '\n'
	jal print_char

no_print:
	# Free allocated memory
	mv a0, s3
	jal free
	mv a0, s4
	jal free
	mv a0, s5
	jal free
	mv a0, s6
	jal free
	mv a0, s7
	jal free
	mv a0, s8
	jal free
	mv a0, s9
	jal free
	mv a0, s10
	jal free

	# Remember to save argmax(o) to a0, which is the return argument
	mv a0, s11 
	
	# Epilogue , recover s0 - s4, ra, and sp
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
    lw s3, 16(sp)
	lw s4, 20(sp)
	lw s5, 24(sp)
    lw s6, 28(sp)
	lw s7, 32(sp)
	lw s8, 36(sp) # S8 ~ S11 for mat sizes for matmul
	lw s9, 40(sp)
	lw s10, 44(sp)
	lw s11, 48(sp)
	addi sp, sp, 52
	ret

malloc_error:
	li a0, 26
	j exit

argc_error:
	li a0, 31
	j exit
