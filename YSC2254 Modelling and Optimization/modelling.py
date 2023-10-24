
from collections import deque


def BFS(graph: list, source: int, sink: int, parent: list):
    # make a list of vertecies 
    # that are already visited (checked)
    seen = [False] * len(graph)

    # prepare a stack 
    stack = deque()

    # add the first vertex to the stack 
    stack.append(source)
    seen[source] = True

    while stack:
        current_vertex = stack.pop()
        for adj_v, cost in graph[current_vertex]:
            # if the adjacent vertex is unvisited 
            # and the path is non-full
            if seen[adj_v] == False and cost > 0:
                seen[adj_v] = True
                stack.append(adj_v)
                parent[adj_v] = current_vertex
            if seen[sink]:
                break
    
    return seen[sink]


def reconstruction(graph: list, source: int, sink: int, parent: list):
    minimum_capacity = 10^6
    current_vertex = sink
    while True:
        print(current_vertex)
        for vs in graph[parent[current_vertex]]:
            if vs[0] == current_vertex:
                minimum_capacity = min(minimum_capacity, vs[1])

        current_vertex = parent[current_vertex]

        if current_vertex == source:
            break 
    
    
    return minimum_capacity

def updateGraph(graph: list, source: int, sink: int, parent: list, minimum_capacity: int):
    current_vertex = sink
    parent_vertex = parent[sink]
    while True:
        for v in graph[parent_vertex]:
            if v[0] == current_vertex:
                v[1] -= minimum_capacity
        print("parent", parent_vertex, current_vertex)
        if parent_vertex == source:
            break 
        current_vertex, parent_vertex = parent[current_vertex], parent[parent_vertex]
    
    return True 


def ford_fulkerson(graph: list, source: int, sink: int):
    
    max_flow = 0

    parent = [(-1) for _ in range(len(graph) + 1)]

    while True: 
        
        if BFS(graph, source, sink, parent):
            min_flow = reconstruction(graph, source, sink, parent)
            updateGraph(graph, source, sink, parent, min_flow)
            print(parent)
            print(graph)
            print(min_flow)
            max_flow += min_flow 
            parent = [(-1) for _ in range(len(graph) + 1)]
        
        else:
            break 
    
    return max_flow 


# graph = [[[1,10], [3,10]], [[2,4], [4,8], [3,2]], [[5,10]], [[4,9]], [[2,6], [5, 10]], []]


graph = [[[1, 20], [2,28], [3,35], [4,16]],
[[2,2], [5,15], [6,35]],
[[4,14], [5,25]],
[[2,30], [4,7]],
[[7,40]],
[[6,5], [7,35]],
[[7,22]],
[]]

print(ford_fulkerson(graph, 0, 7))
