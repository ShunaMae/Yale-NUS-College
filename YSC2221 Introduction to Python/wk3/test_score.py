score = int(input("Please enter your score: "))
if score >= 60: print("Passed")
else: print("Failed")

grade = int(input("Please enter your score: "))
if grade >= 90: print('A')
elif grade >= 80: print('B')
elif grade >= 70: print('C')
elif grade >= 60: print('D')
else: print('F')

names = ['Jon', 'Sam', "Lucy"]
name = input("Enter a name: ")
if name in names:
    print(names.index(name))
else:
    print(name, "does not exist in list")