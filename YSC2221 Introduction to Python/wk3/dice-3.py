import random

fromInt = 1
toInt = 6

ranVal = random.randint(fromInt, toInt)

diceGuess = input("Whats your guess of the roll? ")

guessCheck = False

while guessCheck == False:
    if diceGuess.isdigit() == False:
        print("PLEASE INPUT A NUMBER")
        diceGuess = input("Try Again: ")
    elif int(diceGuess) < 0 or int(diceGuess) > 6:
        print("PLEASE INPUT VALUES BETWEEN 1 & 6")
        diceGuess = input("Try Again: ")
    elif int(diceGuess) != int(ranVal):
        diceGuess = input("Try Again: ")
    elif int(diceGuess) == int(ranVal):
        guessCheck = True


print('FANTASTIC')
print("*---*")
print("| " + str(ranVal) + " |")
print("*---*")