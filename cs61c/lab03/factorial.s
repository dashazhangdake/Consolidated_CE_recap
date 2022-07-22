.globl factorial

.data
n: .word 3

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial
	
    addi a1, a0, 0 # a0 is the actual result
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    addi t0, a0, 0 # upper bound of for loop in t0 
    addi t1, x0, 1 # iterative variable i in t1
    addi a0, x0, 1 # set a0 to 1
loop:
    blt t0, t1, exit # i <= upperbound is equivalent to upperbound > i
	mul a0, a0, t1 # res = res * i
    addi t1, t1, 1 # update iterative variable i
    jal x0, loop
exit:
	ret