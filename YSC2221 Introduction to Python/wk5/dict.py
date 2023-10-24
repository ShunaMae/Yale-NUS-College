from collections import defaultdict 
my_string = "Hello World"
my_dict = defaultdict(int)

for letter in my_string:
    my_dict[letter] += 1 

print(my_dict)

def characters_count(s: str) -> dict:
    my_dict = defaultdict(int)
    for letter in s:
        my_dict[letter] += 1 
    return my_dict 
        