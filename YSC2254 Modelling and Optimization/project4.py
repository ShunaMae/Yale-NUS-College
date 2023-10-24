
def stochastic_gradient_descent(x1, x2, y, a, b, learning_rate, num_iter):
    # Define initial values for the weights
    a_curr = a
    b_curr = b
    
    # Loop through the number of epochs
    for i in range(num_iter):
        # Randomly select a single training example from the data
        random_index = random.randint(0, len(x1)-1)
        x1_curr = x1[random_index]
        x2_curr = x2[random_index]
        y_curr = y[random_index]
        
        # Calculate the gradient of the error for the current training example
        grad_a, grad_b = calculate_gradient(x1_curr, x2_curr, y_curr, a_curr, b_curr)
        
        # Update the weights using the gradient and the learning rate
        a_curr = a_curr - learning_rate * grad_a
        b_curr = b_curr - learning_rate * grad_b
    
    # Return the final values of the weights
    return a_curr, b_curr

def calculate_gradient(x1, x2, y, a, b):
    # Calculate the predicted output using the current weights and the input features
    y_pred = a * x1 + b * x2
    
    # Calculate the error by subtracting the predicted output from the actual output
    error = y - y_pred
    
    # Calculate the gradients of the error with respect to the weights
    grad_a= -x1 * error
    grad_b = -x2 * error
    
    # Return the gradients
    return grad_a, grad_b

from sklearn.datasets import load_diabetes
import random

diabetes = load_diabetes()
X = diabetes.data.tolist()
y = diabetes.target.tolist()

# Initialize weights with random values
w = [random.uniform(-1, 1) for i in range(10)]

# Call SGD function with learning rate of 0.001
w, errors = sgd(X, y, w, 0.001)

# Print the final weights and errors
print("Final weights:", w)
print("Errors:", errors)

x1 = [random.uniform(0, 1) for i in range(30)]
x2 = [random.uniform(0, 1) for i in range(30)]
y = [3*x1[i] + 6*x2[i] for i in range(30)]
def f(x, y):
    z = x ** 2 + y ** 2
    return z


def df(x, y):
    dzdx = 2 * x
    dzdy = 2 * y
    dz = [dzdx, dzdy]
    return dz


learning_rate = 0.01                     
num_iter = 1000   

# starting point (random)        
x0 = -10                            
y0 = 10                             
x_pred = [x0]                       
y_pred = [y0]  
z_pred = []

for i in range(num_iter):
    dfx, dfy = df(x0, y0)
    x0 = x0 - (learning_rate * dfx)
    y0 = y0 - (learning_rate * dfy)
    
    x_pred.append(x0)               
    y_pred.append(y0)               


for i in range(len(x_pred)):
    z_pred.append(f(x_pred[i], y_pred[i]))

print(round(x_pred[-1],2), round(y_pred[-1],2))
# -0.0, 0.0

print("The function yields", round(z_pred[-1],2), "when x = ", round(x_pred[-1], 2), "and y =", round(y_pred[-1], 2))

a, b = stochastic_gradient_descent(x1, x2, y, 1,1,0.01, 10000)
print(a, b)

# Define the x, y, and z coordinates for the data points
x = x1
y = x2
z = y

# Create a 3D plot
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Plot the data points
ax.scatter(x, y, z, c='b', marker='o')

xx, yy = np.meshgrid(np.linspace(0, 1, 10), np.linspace(0, 1, 10))

# Calculate the corresponding z values for the hyperplane
zz = a*xx + b*yy

# Plot the hyperplane
ax.plot_surface(xx, yy, zz, alpha=0.2)

# Set the labels for the x, y, and z axes
ax.set_xlabel('x1')
ax.set_ylabel('x2')
ax.set_zlabel('y')


plt.show()