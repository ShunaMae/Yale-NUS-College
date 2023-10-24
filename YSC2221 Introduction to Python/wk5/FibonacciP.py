import time

# Python program to display the Fibonacci sequence
# Recursive version
def recur_fibo(n):

    if n <= 1:
        
        return n
    else:
        return(recur_fibo(n-1) + recur_fibo(n-2))


# check if the number of terms is valid
# nterms = int(input("Please enter a positive integer: "))
# if nterms <= 0:
#    print("Please enter a positive integer")
# else:
# # Call Fibonacci recursively
#     print("Fibonacci recursive:")
#     for i in range(nterms):
#         print(recur_fibo(i))

# time.sleep(1)
# print()

# # Fibonacci non-recursive, i.e. iterative
# a = 0
# b = 1
# print("Fibonacci non-recursive")
# print(a,b,end=" ")
# while (nterms-2):
#     c=a+b
#     a=b
#     b=c
# #    a,b = b,c
#     print(c,end=" ")
#     nterms = nterms-1



from functools import lru_cache
@lru_cache()
def fast_recur_fibo(n):
    if n <= 1:
        return n
    else:
        return fast_recur_fibo(n-1) + fast_recur_fibo(n-2)

for i in range(200):
    print(fast_recur_fibo(i))

