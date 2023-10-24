text = ""
MOD = 26
def decode_caeser(text, num):
    letter = list(text)
    new_letter = ""
    for i in range(len(letter)):
        if letter[i].islower():
            ascii_code = ord(letter[i])
            start = ord('a')
            last = ord('z')
            to_test = ascii_code + num
            if to_test < start: 
                ascii_code = start + ((to_test - start) % MOD)
            elif to_test <= last: 
                ascii_code = to_test 
            else: 
                ascii_code = start + ((to_test - last - 1) % MOD)
        elif letter[i].isupper():
            ascii_code = ord(letter[i])
            start = ord('A')
            last = ord('Z')
            to_test = ascii_code + num
            if to_test < start: 
                ascii_code = start + ((to_test - start) % MOD)
            elif to_test <= last:
                ascii_code = to_test 
            else: 
                ascii_code = start + ((to_test - last - 1) % MOD)
        else: 
            ascii_code = ord(letter[i])
            
        new_letter += chr(ascii_code)
    return new_letter 


print(decode_caeser(text, 13))


    