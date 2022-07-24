.globl main

.data
source:
    .word   3
    .word   1
    .word   4
    .word   1
    .word   5
    .word   9
    .word   0
dest:
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0

.text
fun: # Function itself is simple: take argument a0(which denotes x), and do tasks
    addi t0, a0, 1 # t0 = a0 + 1
    sub t1, x0, a0 # t1 = -x
    mul a0, t0, t1 # res = t0 * t1 = -x * (x + 1)
    jr ra # equivalent to jalr x0, ra, 0 and finally equivalent to ret

main:
    # BEGIN PROLOGUE
    addi sp, sp, -20 # Just in case, store a copy of registers that might be used
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)
    # END PROLOGUE
    addi t0, x0, 0 # initiate iteration variable k at t0
    addi s0, x0, 0 # initiate returned value sum at s0
    la s1, source # load the ptr pointing to source array
    la s2, dest # load the ptr pointing to dest array
loop:
    slli s3, t0, 2 # calculate offset using shifting left by 2bits (*4), put offset value in s3 
    add t1, s1, s3 # pointer arithmetic, t1 = s1 + s3 <=> ptr2source2handle = ptr2source + offset
    lw t2, 0(t1) # load the source *ptr2source2handle (which is source[k]) to t2
    beq t2, x0, exit # terminate the loop if source[k] == 0
    add a0, x0, t2 # assign sum = source[k]
    addi sp, sp, -4 # I believe the Line52 and line 55 are unnecessary, sp decrement is reduced to 4
    sw t0, 0(sp) # t0 being used in fun, store its original value
    # sw t2, 4(sp)
    jal fun # a0 will be overwriten anyway later by s0, we don't need to save a copy of a0 in this case
    lw t0, 0(sp) # retrieve t0 after usage
    # lw t2, 4(sp)
    addi sp, sp, 4 # mv stack pointer back
    add t2, x0, a0 # a0 stores fun(source[k]), recall source[k] is in t2, set source[k] to func(source[k])
    add t3, s2, s3 # t3 = base_addr_dest + offset, i.e. dest[k]
    sw t2, 0(t3) # store func[source[k]] into dest[k]
    add s0, s0, t2 # accumulate s0, which is sum
    addi t0, t0, 1 # update iterative variable k
    jal x0, loop # j loop
exit:
    add a0, x0, s0 # store sum s0 to a0, which is the return value of main function
    # BEGIN EPILOGUE
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20 # Recover register values being used
    # END EPILOGUE
    jr ra
