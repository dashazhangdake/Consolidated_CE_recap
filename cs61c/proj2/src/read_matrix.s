.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

	# Prologue
	addi sp, sp, -24
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)

	mv s0, a0  # s0 saves the copy of a0 (ptr to fname charstring)
	mv s1, a1  # s1 saves the copy of a1 (ptr will point to an integer - #ofrows)
	mv s2, a2  # s2 saves the copy of a2 (ptr will point to an integer - #ofcols)
    # We expect to return a ”new“ a0, a ptr points to the matrix in memory


    #================================================================
    # Calling fopen function:
    # Function fopen args: 
        # a0 is ptr2fname. 
        # a1 is permission bit; 
        # returns a0, which is a file descriptor
    #================================================================
 
	li a1, 0  # in this function, we believe the file is readable, set a1 to read (a1 = 0) 
	jal ra, fopen
	li t0, -1 # check open error
	beq a0, t0, fopen_error # fopen returns -1, get an error
    # From this point, we only use a0 == file_descriptor, we may overwrite s0
    mv s0, a0  # Now s0 contains the file descriptor, which will be used by subsequent functions fread, fwrite, and fclose
   

    #================================================================
    # Calling fread function to get #ofrows and #ofcols:
    # function fread args: 
        # a0 is file descriptor 
        # a1 is ptr to the buffer of bytes being read; 
        # a2 is the # of bytes to be read
        # Returns a0, the nubmer of byte being actually read
    # In this case, since the data we are reading are #col and #rows, ptrs to these data
    # are simply argument registers a1, a2 of read_matrix function 

    # Note that subsequent reads will read from the later parts of the file, no need to 
    # add/subtract offsets of the read bytes
    #================================================================
    
    # Read the first byte (#ofroww) in matrix bin-file
	mv a1, s1 # ptr pointing to an integer - #ofrows (argument a1 of read_matrix function)
    li s3, 4 # just read 4 byte
    mv a2, s3
	jal ra, fread
	bne a0, s3, fread_error
    # Then read the second byte
    mv a0, s0 # Retrieve a0 from s0, cuz it was written by fread function
	mv a1, s2 # ptr pointing to an integer - #ofcols (argument a2 of read_matrix function)
    mv a2, s3
	jal ra, fread # We are happy with a2 = 4, jump to fread
	bne a0, s3, fread_error
    # Load #row/#col from memory. s1, s2 are ptr to the read byte. put #row/col in t1, t2
	lw t1, 0(s1)  # t1 = the number of rows 
	lw t2, 0(s2)  # t2 = the number of columns


    #================================================================
    # Allocate memory space for the matrix using malloc
        # malloc args: 
            # a0: size of memory to allocate in bytes
            # Returns a0, which is the ptr to the allocated memory
                # malloc fails when returned a0 is 0
    # Calling fread function to read elements into the memory
    #================================================================
	mul t3, t1, t2  # Mat size = row * col = t1 * t2
	slli t3, t3, 2  # Mat size in byte  = Mat size * 4
    mv s4, t3  # Save mat size at s4
	mv a0, s4  # Set a0 to s4
	jal malloc
	beqz a0, malloc_error # a0 is 0, fail and exit
    mv s3, a0  # Temporarilt put returned a0 of malloc in s3, as s3 no longer being used  
	mv a0, s0  # Retrive ptr2 file descriptor 
	mv a1, s3  # a0 = ptr2 allocated memory
	mv a2, s4  # size of byte we want to read
	jal fread
	bne a0, s4, fread_error  # read fail if #readbyte doesn't match  


    #================================================================
    # Close file args:
        # a0: ptr to file descriptor
        # return a0 = 0 for sucess, -1 for fail
    #================================================================
	mv a0, s0
	jal fclose
	bnez a0, fclose_error
    
    
    #================================================================
    # DO NOT forget we need to return a0, a0 is the address to the matrix in memory
        # In this case, this address is the one we allocated for martix using malloc
        # I saved this address in s3 
    #================================================================
    mv a0, s3  # Put ptr2matrix back to a0, and finish the program 


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

fread_error:
	li a0, 29
	j exit

malloc_error:
	li a0, 26
	j exit

fclose_error:
	li a0, 28
	j exit