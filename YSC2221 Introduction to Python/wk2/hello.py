# print function 
# print("Hello World")
# print("Hello")

# # sep 
# print("Hello", "World")
# print("Hello", "World", "NoSpaceVer", sep = "")
# print("Hello", "World", "DashVer", sep = "-")

# # end 
# print("Hello", "World", end = ".")
# print("first", "line", end = "")
# print("second", "line")

# other escape characters 
# \n : adds a lune break 
# \t : adds a tab 
# \ : escape regular expression (ex. \")

# input
# name = input("plase enter your name:")
# print("Hi", name, end = ",")
# age = int(input("plase enter your age:"))
# print("You can live", 85-age, "more years.")

# exercise 
# word = input("enter a word:")
# num = int(input("how many times would you like the word to be repeated?:"))
# for _ in range(num): print(word)
# print(word * num)

# chr -> ascii 
print(ord('n'))
# ascii -> chr 
print(chr(100))

# string subsetting
# str[s:e:step]
print(' '.islower())

phrase = "Pony stash token"
# print the string slice "stash"
print(phrase[5:11])