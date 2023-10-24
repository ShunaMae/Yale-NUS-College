# Make a sentence based on eight inputs. 
# Hi, in this part of the homework, I wrote a program to write an encrypted code. 
# It's a little beyond what we covered in the lecture today (week 2 monday), 
# but they are just if/elif/else and modulo calculation. 
# in fact, I used quite a lot of techniques I learned today. 

print("Hi!", "What's your name?")
name = input("Please enter your name:")
print("Hi", end = " ")
print(name, "!", sep = "")
print("Do you know what Caesar cipher is?",
"It is a type of encryption technique in which each letter of a text is shifted down/up by a fixed number of the alphabet.",
"With this program, you'll be able to write a secret letter to your friend!", 
"Do you like to make one?", sep = "\n")
ans = input("What do you say? (yes/no):")

if ans.lower() == 'no': print("whatever you want, we continue.")
elif ans.lower() == 'yes': print("That's great!")
else: print("Can you read the instruction? We proceed.")

print("So, who do you want to write a letter to?")
to_whom = input("Enter your friend's name here: ")
print("Great!", "Now, you can write your letter!")
letter = input("Please enter your letter here (in text):")
num = int(input("How many alphabets do you want to shift? (can be negative): "))

MOD = 26
new_letter = ""
for i in range(len(letter)):
    if letter[i].islower():
        ascii_code = ord(letter[i])
        start = ord('a')
        last = ord('z')
        to_test = ascii_code + num
        if to_test < start: ascii_code = start + ((to_test - start) % MOD)
        elif to_test <= last: ascii_code = to_test 
        else: ascii_code = start + ((to_test - last - 1) % MOD)
    elif letter[i].isupper():
        ascii_code = ord(letter[i])
        start = ord('A')
        last = ord('Z')
        to_test = ascii_code + num
        if to_test < start: ascii_code = start + ((to_test - start) % MOD)
        elif to_test <= last: ascii_code = to_test 
        else: ascii_code = start + ((to_test - last - 1) % MOD)
    else: ascii_code = ord(letter[i])
        
    new_letter += chr(ascii_code)

print("What about some closing words?")
closing_words = input("Enter closing words here (eg., Best wishes):")
print("Do you want to tell your friend how many alphabets you shifted?")
shift_letters = input("Enter yes or no:")
if shift_letters.lower() == 'yes': print("Okay, we include the number.")
elif shift_letters.lower() == 'no' : print("Okay, we do not include the number.")
else: print("If you can't read the instruction, we include the number.")

print(" ")
print("Great, Here is your encrypted letter!")
print(" ")
print("Dear", end = " ")
print(to_whom, ",", sep = "")
print(new_letter)
if shift_letters.lower() != 'no':
    if num == 1: print("I shifted down by 1 alphabet.")
    elif num > 1: print("I shifted down by", num, "alphabets.")
    else: print("I shifted up by", abs(num), "alphabets.")
print(closing_words, ",", sep = "")
print(name.capitalize())

print(" ")
print("Do you like it?")
response = input("Enter yes/no:")
if response.lower() == 'yes': print("Thank you so much! We love you.")
elif response.lower() == 'no': print("We hope you enjoy this next time...")
else: print("Bless you.")






        