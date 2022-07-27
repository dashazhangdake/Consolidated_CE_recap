.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

	# Prologue
	addi sp, sp, -24
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)

    mv s0, a0  # ptr to fname charstring
    mv s1, a1  # ptr to matrix
    mv s2, a2  # Number of rows
    mv s3, a3  # Number of cols


    #================================================================
    # Calling fopen function, which is similiar to its read counterparts except for the perimission bit
    # Function fopen args: 
        # a0 is ptr2fname. 
        # a1 is permission bit, which is 1 in this case; 
        # returns a0, which is a file descriptor
    #================================================================
 
	li a1, 1  # in this function, we believe the file is readable, set a1 to read (a1 = 0) 
	jal ra, fopen
	li t0, -1 # check open error
	beq a0, t0, fopen_error # fopen returns -1, get an error
    # From this point, we only use a0 == file_descriptor, we may overwrite s0
    mv s0, a0  # Now s0 contains the file descriptor
   

   #================================================================
    # Calling fwrite function, write #row and #col first
    # fwrite args:
        # a0: file descriptor
        # a1: ptr2 buffer containing we want to write to the file
        # a2: # of elements to write to file
        # a3: size of each element
    #================================================================

    mv a0, s0  # Get a0 ready (file descriptor we get in fopen)

    # As fwrite function requires arg1 to be ptr2 buffer containing what we want to write
    # We need to save #col and #row in memory first, let's use stack in this implementation
    addi sp, sp, -8 # Save # rows and # cols in 0(sp) and 4(sp)
    sw s2, 0(sp) # save #rows in 0(sp)
    sw s3, 4(sp) # save #cols in 4(sp)
    mv a1, sp # (set a1 to the ptr to the arr of [#row, #col])
    li a2, 2 # we want to write two elements
    mv s4, a2 # Save #of element for error check
    li a3, 4 # Int numbers, size of each element is 4 byte
    jal ra, fwrite

    addi sp, sp, 8  # Recover sp, discard the array [#row, #col] we saved 
    bne a0, s4, fwrite_error # Error check


    #================================================================
    # Calling fwrite function, write matrix now
    # fwrite args:
        # a0: file descriptor
        # a1: ptr2 buffer containing we want to write to the file
        # a2: # of elements to write to file
        # a3: size of each element
    #================================================================

    mv a0, s0  # Get a0 ready (file descriptor we get in fopen)
    mv a1, s1  # Easier than previous step, we have ptr2matrix ready to use, mv it from s1 to a1
    mul t0, s2, s3  # number of element = row * col = s2 * s3
    mv a2, t0  # Set a2 = row * col
    mv s4, a2  # Save a2 in s4 for error check 
    li a3, 4  # Int numbers, each element is 4 byte

    jal ra, fwrite
    bne a0, s4, fwrite_error # Check error


    #================================================================
    # Close file args:
        # a0: ptr to file descriptor
        # return a0 = 0 for sucess, -1 for fail
    #================================================================
	mv a0, s0
	jal fclose
	bnez a0, fclose_error 
    # No return value for this function, we are done now


    # Epilogue , recover s0 - s4, ra, and sp
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
    lw s3, 16(sp)
	lw s4, 20(sp)
	addi sp, sp, 24

	ret

fopen_error:
	li a0, 27
	j exit

fclose_error:
	li a0, 28
	j exit

fwrite_error:
	li a0, 30
	j exit
