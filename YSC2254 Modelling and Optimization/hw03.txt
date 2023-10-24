first_matrix = [
    [0.1, 0.06, 0.05, 0.7],
    [0.48, 0.44, 0.1, 0.04],
    [0, 0.55, 0.52, 0.04],
    [0.04, 0.01, 0.42, 0.51]
]

second_matrix = [0.6, 0.9, 1.3, 0.5]


def matrix_multiplication(first_matrix: list, second_matrix: list):
    output = []
    for i in range(len(first_matrix)):
        if type(first_matrix[i]) == list:
            if type(second_matrix[0]) == list:
                for j in range(len(second_matrix[0])):
                    result = 0
                    for k in range(len(first_matrix[0])):
                        result += first_matrix[i][k] * second_matrix[k][j]
                    output.append(result)
            else:
                result = 0
                for k in range(len(first_matrix[0])):
                    result += first_matrix[i][k] * second_matrix[k]
                output.append(result)
        else:
            if type(second_matrix[0]) == list:
                result = 0
                for j in range(len(second_matrix[0])):
                    result += first_matrix[i] * second_matrix[0][j]
                output.append(result)
            else:
                output.append(first_matrix[i] * second_matrix[0])
    return output



# repeat it 20 times 
output = []
for _ in range(19):
    result = matrix_multiplication(first_matrix, second_matrix)
    output.append(result)
    second_matrix = result

import csv

# open a file for writing
with open('modelling.csv', 'w', newline='') as file:
    # create a csv writer object
    writer = csv.writer(file)
    # write the 2D list to the CSV file
    writer.writerows(output)