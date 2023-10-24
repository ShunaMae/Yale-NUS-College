# Introduction to Python 
# Assignment 1 
# author: Shuna Maekawa


# Program: Morse code cypher and decypher 
# List of Morse codes
morse_list = [' ', '--..--', '.-.-.-', '..--..', '-----',
            '.----', '..---', '...--', '....-',
            '.....', '-....', '--...', '---..',
            '----.', '.-', '-...', '-.-.', '-..',
            '.', '..-.', '--.', '....', '..', '.---',
            '-.-', '.-..', '--', '-.', '---', '.--.',
            '--.-', '.-.', '...', '-', '..-', '...-',
            '.--', '-..-', '-.--', '--..', '-....-']

alpha_list = [' ', ',', '.', '?', 
            '0', '1', '2', '3', 
            '4','5', '6', '7', 
            '8', '9', 'A', 'B', 
            'C', 'D', 'E', 'F', 'G', 
            'H', 'I', 'J', 'K', 'L', 
            'M', 'N', 'O', 'P', 'Q', 
            'R', 'S', 'T', 'U', 'V', 
            'W', 'X', 'Y', 'Z', '-']

# normal sentence -> morse-coded sentence 
def cypher(text: str) -> str:
    # this list will be the answer 
    ans = []
    # remove spaces, capitalize all letters 
    text = text.replace(" ", "").upper()
    # for every element in the string 
    for i in range(len(text)):
        # index to convert 
        idx = alpha_list.index(text[i])
        # append from the other list 
        ans.append(morse_list[idx])
    # convert ans: list to str
    return " ".join(ans)


# morse-coded sentence -> normal sentence 
def decypher(text: str) -> str:
    # split by " "
    text_list = text.split(" ")
    # remove any empty string "", 
    # especially the one at the end of the morse-coded sentence 
    text_list = list(filter(lambda element: element != "", text_list))
    # this list will be the answer 
    ans = []
    # for every element in the list 
    for i in range(len(text_list)):
        # do the same  
        idx = morse_list.index(text_list[i])
        ans.append(alpha_list[idx])
    # convert ans: list to str 
    return "".join(ans)


# Ask for user's inputs 
normal_text = input("Please input senteces to convert:")
print("Encoded as follows: ", cypher(normal_text))
print("Decoded as follows: ", decypher(cypher(normal_text)))
# morse_text = input("Please input morse-coded sentences to decode:")
# print("Decoded as follows: ", decypher(morse_text))

message1 = "--. . . -.- ... -....- ..-. --- .-. -....- --. . . -.- ... "
message2 = "DO YOU LOVE PYTHON? I DO."

# check message 1 
print(decypher(message1))
# this should return message1
print(cypher(decypher(message1)))

# check message2
print(cypher(message2))
# this should return message2
print(decypher(cypher(message2)))
