from random import randint
# randomly roll a die
die = randint(1, 6)

rolls = ["one", "two", "three", "four", "five", "six"]
frame = frame = "_"*len(rolls[die-1])
# how many time did you guess?
cnt = 0
while True:
    guess = input("Please enter your guess in integer: ")
    cnt += 1 
    if not guess.isdigit():
        print("Your guess is not an integer.")
    elif int(guess) < 1:
        print("Your guess is too small for a dice roll")
    elif int(guess) > 6:
        print("Your guess is too big for a dice roll")
    else:
        if int(guess) == die:
            print("Your guess is right.")
            print("*" + frame + "*")
            print("|", rolls[die-1], "|", sep = "")
            print("*" + frame + "*")
        else:
            print("Your guess is wrong. Try again.")
    if int(guess) == die:
        break 
    # if you make guesses more than 10 times 
    # no more 
    if cnt >= 10:
        break 

    
