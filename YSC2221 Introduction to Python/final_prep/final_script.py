hello = 10 
test5 = 1
TTT = 10
" ".isdigit()
s = "Debugging is like being the detective in a crime movie where you are also the murderer!"
print(s[-1::-10])


def add_odd(x, y):
    sum = 0
    for i in range(x, y+1):
        if i % 2 == 1:
            sum = sum + i
    return sum 

print(add_odd(1,10))

# print(ord('a').isdigit())

def half(n):
    cnt = 0
    h = n / 2
    if h >= 1:
        cnt += 1 
        half(h)
    return cnt

print(half(20))