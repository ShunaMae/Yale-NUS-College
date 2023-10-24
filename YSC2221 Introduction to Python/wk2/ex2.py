# input
name = input("Please enter your first and last name:")
birth = input("Please enter your birthday in 8 digit number (eg., mmddyyyyy):")

day = birth[2:4]
month = birth[:2]
year = birth[4:]
# output
print(name.title(), "was borh on", end = " ")
print(day, month, year, sep = "/")
