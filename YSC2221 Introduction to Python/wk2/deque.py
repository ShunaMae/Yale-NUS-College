from time import perf_counter
from collections import deque 
import statistics

t_list = []
t1 = 1
for i in range(9):
    li = [j for j in range(10**i)]
    list_time = []
    for _ in range(10):
        start = perf_counter()
        d = deque(li)
        t = perf_counter() - start
        t_list.append(t)
    t_mean = statistics.mean(t_list)
    k = t_mean // t1
    t_list.append(k)
    print(i, t_mean*1000, "ms", k)
    t1 = t_mean


print(statistics.mean(t_list))