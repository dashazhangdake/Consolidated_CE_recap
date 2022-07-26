.import ../src/utils.s
.import ../src/../coverage-src/zero_one_loss.s

.data
m0: .word 1 2 3 4 5 6 7 8 9
m1: .word 1 6 1 6 1 6 1 6 1
m2: .word -1 -1 -1 -1 -1 -1 -1 -1 -1

.globl main_test
.text
# main_test function for testing
main_test:

    # load address to array m0 into a0
    la a0 m0

    # load address to array m1 into a1
    la a1 m1

    # load address to array m2 into a3
    la a3 m2

    # load 0 into a2
    li a2 0

    # call zero_one_loss function
    jal ra zero_one_loss
    # we expect zero_one_loss to exit early with code 36

    # exit normally
    li a0 0
    jal exit
