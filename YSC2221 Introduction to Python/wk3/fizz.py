
for i in range(1,101):
    if not i % 15:
        print("FIZZ BUZZ")
    elif not i % 3:
        print("FIZZ")
    elif not i % 5:
        print("BUZZ")
    else:
        print(i)

