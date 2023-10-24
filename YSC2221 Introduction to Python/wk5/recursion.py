# sum of 1+2+3+4+ . . .+n
def sumofn(n):
    if n == 1 :
        return 1
    return n+sumofn(n-1)

#factorial of n! = n*(n-1)*(n-2)*(n-3)*. . .*1
def factorial(n):
    if n == 0 or n == 1:
        return 1
    return n*factorial(n-1) 

# n = int(input("Please enter a positive integer: "))
# print("n = ", n)
# if n < 0:
#    print("Didn't read that the number must be positive? Are you testing me?")
# else:
#     print("sumof(n) = ", sumofn(n))
#     print("factorial(n) = ", factorial(n))

#
# Try with input 0 and see Stack Overflow in sumofn
#

factorial(100)

