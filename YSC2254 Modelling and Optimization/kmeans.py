# write k-means algorithm 

from random import sample
from pandas import read_csv


# a function the determines initial group representatives 
def partition(k, points):
    # intial group representatives
    first_rep = sample(points, k)
    return first_rep

# given a group representative and list of points, 
# assign points to the nearest grop representative 
# rep: two dimensional list of group representatives 
# points: two dimentional list of points 
def assign(rep: list, points: list, k: int):
    dimension = len(rep[0])
    num_points = len(points)
    assigned_rep = []
    # for each point
    for i in range(num_points):
        rep_assigned_for_i = -1
        min_dist = float("inf")
        for j in range(k):
            dist = 0
            for l in range(dimension):
                # calculate the distance 
                # from the point to centroid
                dist += abs(rep[j][l] - points[i][l])
            
            min_dist = min(min_dist, dist)
            # only when the min_dist is updated
            if min_dist == dist:
                # update the assigned representatives 
                rep_assigned_for_i = j
        assigned_rep.append(rep_assigned_for_i)
    return assigned_rep
            

# define a function that updates the group repsentatives
def update(rep: list, points: list, assigned: list, k: int):
    # loop through each group representative
    for i in range(k):
        assigned_points = []
        # loop through all the points and check if they are assigned to the representative
        for j in range(len(points)):
            # if they are, append to assigned_points to take the average later 
            if assigned[j] == i:
                assigned_points.append(points[j])

        # if there are any assigned points, update the representative
        if assigned_points:
            # get the number of assigned points
            num_assigned = len(assigned_points)
            # calculate the average of each coordinate
            new_rep = []
            for dim in range(len(rep[i])):
                dim_sum = sum([point[dim] for point in assigned_points])
                new_rep.append(dim_sum / num_assigned)
            # update the representative
            rep[i] = new_rep
    return rep


def k_means(k: int, points: list):
    # partitioning to get the initial group representatives 
    reps = partition(k, points)

    assigned = [0] * len(points)

    # Keep track of the previous iteration's group representatives
    prev_reps = None

    # while the grouping converes 
    while prev_reps != reps:
        # Assign points to nearest group representatives
        assigned = assign(reps, points, k)

        # Update group representatives
        prev_reps = reps
        reps = update(reps, points, assigned, k)

    return assigned

test_data = read_csv('F:\Y4S2\modelling\hornbill_modelling.csv')

