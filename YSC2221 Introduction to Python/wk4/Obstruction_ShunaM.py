# Obstruction Game 

# import necessary functions 
from string import ascii_uppercase
from random import randint
from os import system
from time import sleep

# determine the size of the board 
# height
HEIGHT = 6
# width 
WIDTH = 6
# prepare an empty field 
tbl = [[(" ") for _ in range(WIDTH)] for _ in range(HEIGHT)]

# implement a printing function 
ALPHABET_LIST = list(ascii_uppercase[:WIDTH])

def print_field() -> None:
    for row in range(2*HEIGHT + 2):
        # the top row, alphabets
        if row == 0:
            to_display = " " * 3
            for col in range(WIDTH):
                to_display += ALPHABET_LIST[col]
                to_display += " " * 3
            print(to_display)
        # print the borders
        elif row % 2 == 1:
            to_display = " "
            for col in range(WIDTH):
                to_display += "+---"
            to_display += "+"
            print(to_display)
        # print the cell content 
        else:
            row_num = (row - 2) // 2
            to_display = "{0}|".format(row_num)
            for col in range(WIDTH):
                to_display += " " + tbl[row_num][col] + " |"
            print(to_display)
    return 

# Strategies 
# No.1 
# if the board dimension is odd x odd and computer takes the first turn, 
# start in the middle square, 
# and then play the mirror image of the player's move
# define a function for that  
def solve_mirror(player_row: int, player_col: int) -> tuple:
    mid_row = HEIGHT // 2
    mid_col = WIDTH // 2
    # calculat the mirror image
    if player_row <= mid_row:
        computer_row = mid_row + abs(mid_row - player_row)
    else:
        computer_row = mid_row - abs(mid_row - player_row)
    if player_col <= mid_col:
        computer_col = mid_col + abs(mid_col - player_col)
    else:
        computer_col = mid_col - abs(mid_col - player_col)
    # just in case the mirror cell is alr occupied
    if not tbl[computer_row][computer_col] == ' ':
        computer_row, computer_col = greedy_seeker()    
    return (computer_row, computer_col)
        
# No.2
# find a cell with the most number of empty neighbors
def greedy_seeker() -> tuple:
    # record max degree of a cell 
    max_deg = -1
    # row of the max degree cell 
    max_deg_row = -1 
    # col of the max degree cell 
    max_deg_col = -1 
    
    # check the cells around 
    for row in range(HEIGHT):
        for col in range(WIDTH):
            if tbl[row][col] == " ":
                # degree of a cell 
                deg = 0
                for delta_row in [-1, 0, 1]:
                    for delta_col in [-1, 0, 1]:
                        if 0 <= row + delta_row < HEIGHT \
                            and 0 <= col + delta_col < WIDTH \
                                and tbl[row + delta_row][col + delta_col] == " ":
                                deg += 1 
                # update max_degree 
                max_deg = max(max_deg, deg)

                # if max_deg gets updated, 
                # update the col and row as well 
                if deg == max_deg:
                    max_deg_row = row 
                    max_deg_col = col 

    if max_deg == 0:
        # this means no cells are empty 
        return (-1, -1)
    return (max_deg_row, max_deg_col)

# update the avilable cells 
def update_table(row: int, col: int, checker: str) -> list:
    # update the main cell 
    tbl[row][col] = checker
    for delta_row in [-1, 0, 1]:
        for delta_col in [-1, 0, 1]:
            if 0 <= row + delta_row < HEIGHT \
                and 0 <= col + delta_col < WIDTH \
                    and tbl[row + delta_row][col + delta_col] == " ":
                    tbl[row + delta_row][col + delta_col] = "#"
    return tbl 

# Declare Checkers
# Checkers can be changed 
CHECKER1 = "X"
CHECKER2 = "O"
computer_checker = ""
player_checker = ""
# Ask player to take their checker
# and assign computer the other checker
while True:
    player_choice = input("Which checker do you want to use, {0} or {1}?: ".format(CHECKER1, CHECKER2))
    if player_choice == CHECKER1:
        player_checker = CHECKER1
        computer_checker = CHECKER2
        break 
    elif player_choice == CHECKER2:
        player_checker = CHECKER2
        computer_checker = CHECKER1
        break 
    else:
        print("Please enter either '{0}' or '{1}'.".format(CHECKER1, CHECKER2))
    
# Game Phase 
# decide who goes first 

def play_game(NUM_PLAYERS: int, computer_checker: str, player_checker: str):
    
    first_turn = randint(0, NUM_PLAYERS-1)

    # Start the game 

    print("You: {0}".format(player_checker))
    print("Computer: {0}".format(computer_checker))
    # if first_turn is 1, let the computer go first 
    print("First turn: {0}".format(computer_checker if first_turn else player_checker))
    sleep(1)

    # if first_turn is 1, computer goes first 
    # this is where mirror image strategy comes into play too 
    if first_turn:
        print("It's computer's turn.")
        # if odd x odd, take the center
        if HEIGHT % 2 and WIDTH % 2:
            update_table(HEIGHT//2, WIDTH//2, computer_checker)
            print_field()
        # otherwise use strategy 2
        else:
            player_row, player_col = greedy_seeker()
            update_table(player_row, player_col, computer_checker)
            print_field()
    sleep(2)
    # clear the output 
    system('cls')

    # from the second turn onwards 
    while True:
        print_field()
        print("It's your turn.")
        while True:
            # get player's choice
            print("Each cell can be specified using an alphabet and a number.")
            print("For example, the top-left cell is A0.")
            choice = list(input("Where do you want to place your checker?: "))
            # is the format appropriate
            if len(choice) == 2 \
                and choice[0] in ALPHABET_LIST \
                    and 0 <= int(choice[1]) < HEIGHT:
                # convert the input to row and col 
                chosen_row = int(choice[1])
                chosen_col = ALPHABET_LIST.index(choice[0])
                # if the chosen cell is empty, 
                # update the table
                if tbl[chosen_row][chosen_col] == " ":
                    update_table(chosen_row, chosen_col, player_checker)
                    system("cls")
                    print_field()
                    break
                # if the chosen cell is not empty, do it again. 
                else:
                    system("cls")
                    print_field()
                    print("You chose the non-empty cell.")
                    print("Try again.")
            # if the input is in the wrong format
            else:
                system("cls")
                print_field()
                print("Not in the correct format. Please enter an alphabet and a number (e.g., A0).")
                print("Try again.")
        sleep(2)
        system("cls")

        # strategy 2
        computer_row, computer_col = greedy_seeker()
        # if there's no more empty cells, 
        # end of the game and player wins
        if computer_row == -1 and computer_col == -1:
            print_field()
            print("You win!")
            break 

        # if not, 
        # if odd x odd, use strategy 1 
        # and update computer_row and computer_col
        if HEIGHT % 2 and WIDTH % 2:
            computer_row, computer_col = solve_mirror(int(choice[1]), ALPHABET_LIST.index(choice[0]))
        update_table(computer_row, computer_col, computer_checker)
        print_field()
        sleep(2)
        system('cls')

        # after computer's turn 
        # if there's no more empty cell 
        # end of the game 
        # computer wins 
        after_computer_turn = greedy_seeker()
        if after_computer_turn == (-1, -1):
            print_field()
            print("You lost!")
            break 

play_game(2, computer_checker, player_checker)

    
        

