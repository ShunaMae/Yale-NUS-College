import matplotlib.pyplot as plt

# .plot(x,y, color = "while", lw = 2)
## plots a curve by connecting the pounts in x, y 
## color value can be 'r', 'b', 'g', 'm', 'c'

plt.plot([1,2,3], [1,2,4], color = 'b', lw = 3)
# plt.show()
plt.savefig("fig.png")