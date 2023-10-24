
cnt = 0
while True:
    temp = input("Please enter a CElsius temperature value: ")
    temp_list = list(temp)
    if "." in temp_list and temp_list.count(".") == 1:
        integer_part = "".join(temp_list[:temp_list.index(".")])
        float_part = "".join(temp_list[temp_list.index(".")+1:])
        if integer_part.isdigit() and float_part.isdigit():
            c_temp = float(temp)
            break
    
    print("It is not float. Enter again.")
    cnt += 1
    if cnt >= 100: break 
print(c_temp)

