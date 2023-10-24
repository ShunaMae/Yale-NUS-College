##
#  This program creates a simple line graph that illustrates many
#  of the features of the matplotlib module.
#  Maximum and minimum average temperatures in Singapore
#  Show with plot, then bar
#  Then add title, axis, label, legend, ticks

from matplotlib import pyplot

# Plot maxium averages, then show with bars

pyplot.plot([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 
   [22, 24, 27, 31, 36, 38, 41, 40, 38, 34, 29, 24])

pyplot.plot([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 
   [19, 21, 23, 25, 28, 30, 34, 33, 31, 26, 23, 20])

# Add descriptive information such as title, axis, label, legend, ticks
#
# ADD HERE
#
#

# Display the graph.
pyplot.show()
