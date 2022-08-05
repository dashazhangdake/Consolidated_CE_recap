li t2, 1

Try:
    lr t1, s1
    bne t1, t0, Try # if t0 != t1 then target
    sc t0, s1, t2
    bne t0, x0, Try

Locked:
    # critical section

Unlocked:  
    sw x0, 0(s1)