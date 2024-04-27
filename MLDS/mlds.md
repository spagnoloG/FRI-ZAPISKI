# MLDS

## Gradient descent

$$
W \leftarrow W - \alpha \frac{\partial L}{\partial W}
$$

## Backrpopagation

### Loss function

Firstly lets define our loss function (MSE):

$$
L = \frac{1}{n} \sum_{i} (y_i^* - y_i)^2
$$

where $y_i^*$ is desired output and $y_i$ is the actual output.

And the derivative of the loss function is given by:

$$
\frac{\partial L}{\partial Y} =
\begin{bmatrix}
\frac{\partial L}{\partial y_1} & \cdots & \frac{\partial E}{\partial y_i}
\end{bmatrix}
$$

$$
= \frac{2}{n}
\begin{bmatrix}
y_1 - y_1^* & \cdots & y_i - y_i^*
\end{bmatrix}
= \frac{2}{n} (Y - Y^*)
$$

For single element lets say $y_2$:

$$
\frac{\partial L}{\partial y_2}
= \frac{\partial}{\partial y_2} \left( \frac{1}{n} \sum_{i} (y_i^* - y_i)^2 \right)
$$

$$
= \frac{\partial}{\partial y_2} \left( \frac{1}{n} (y_1^* - y_1)^2 + \frac{1}{n} (y_2^* - y_2)^2 + \cdots + \frac{1}{n} (y_n^* - y_n)^2 \right)
$$

$$
=  \frac{1}{n} \frac{\partial}{\partial y_2} (y_2^* - y_2)^2
=  \frac{1}{n} 2 (y_2 - y_2^*)
$$

### Activation function

Our vector of outputs is given by:

$$
Y = \begin{bmatrix} y_1 & y_2 & \cdots & y_n \end{bmatrix}
$$

$$
= \begin{bmatrix} f_1(x) & f_2(x) & \cdots & f_n(x) \end{bmatrix}
$$

Where $f_i(x)$ is the output of the $i^{th}$ neuron in the output layer.

The derivative of the loss function with respect to the inputs is given by:

$$
\frac{\partial L}{\partial X} =
\left[ \frac{\partial L}{\partial x_1} \cdots \frac{\partial L}{\partial x_i} \right]
$$

$$
= \left[ \frac{\partial L}{\partial y_1} \frac{\partial y_1}{\partial x_1} \cdots \frac{\partial L}{\partial y_i} \frac{\partial y_i}{\partial x_i} \right]
$$

$$
\left[ \frac{\partial L}{\partial y_1} f'(x_1) \cdots \frac{\partial L}{\partial y_i} f'(x_i) \right]
$$

$$
= \frac{\partial L}{\partial Y} \odot \left[ f'(x_1) \cdots f'(x_i) \right]
$$

$$
= \frac{\partial L}{\partial Y} \odot f'(X)
$$

### Fully connected layer

The derivative of the loss function with respect to the weights is given by:

$$
\frac{\partial L}{\partial W} =
\begin{bmatrix}
\frac{\partial L}{\partial w_{11}} & \cdots & \frac{\partial L}{\partial w_{1j}} \\
\vdots & \ddots & \vdots \\
\frac{\partial L}{\partial w_{i1}} & \cdots & \frac{\partial L}{\partial w_{ij}}
\end{bmatrix}
$$

Using the chain rule we can write:

$$
\frac{\partial L}{\partial w_{ij}} = \frac{\partial L}{\partial y_1} \frac{\partial y_1}{\partial w_{ij}} + \cdots + \frac{\partial L}{\partial y_j} \frac{\partial y_j}{\partial w_{ij}}
$$

$$
= \frac{\partial L}{\partial y_j} x_i
$$

Therefore:

$$
\frac{\partial L}{\partial W} =
\begin{bmatrix}
\frac{\partial L}{\partial y_1} x_1 & \cdots & \frac{\partial L}{\partial y_j} x_1 \\
\vdots & \ddots & \vdots \\
\frac{\partial L}{\partial y_1} x_i & \cdots & \frac{\partial L}{\partial y_j} x_i
\end{bmatrix}
$$

Simplifies to:

$$
\frac{\partial L}{\partial W} =
\begin{bmatrix}
x_1 \\
\vdots \\
x_i
\end{bmatrix}
\begin{bmatrix}
\frac{\partial L}{\partial y_1} & \cdots & \frac{\partial L}{\partial y_j}
\end{bmatrix}

= \frac{\partial L}{\partial W} = X^t \frac{\partial L}{\partial Y}
$$

The derivative of the loss function with respect to the inputs is given by:

$$
\frac{\partial L}{\partial X} = \left[ \frac{\partial L}{\partial x_1} \ \frac{\partial L}{\partial x_2} \ \cdots \ \frac{\partial L}{\partial x_i} \right]
$$

Lets write the derivative of the loss function with respect to the single input $x_i$:

$$
\frac{\partial L}{\partial x_i} = \frac{\partial L}{\partial y_1} \frac{\partial y_1}{\partial x_i} + \cdots + \frac{\partial L}{\partial y_j} \frac{\partial y_j}{\partial x_i}
$$

$$
= \frac{\partial L}{\partial y_1} w_{i1} + \cdots + \frac{\partial L}{\partial y_j} w_{ij}
$$

And then rewrite the derivative of the loss function with respect to the inputs:

$$
\frac{\partial L}{\partial X} = \left[ \left( \frac{\partial L}{\partial y_1} w_{11} + \cdots + \frac{\partial L}{\partial y_j} w_{1j} \right) \ \cdots \ \left( \frac{\partial L}{\partial y_1} w_{i1} + \cdots + \frac{\partial L}{\partial y_j} w_{ij} \right) \right]
$$

$$
= \begin{bmatrix}
\frac{\partial L}{\partial y_1} & \cdots & \frac{\partial L}{\partial y_j}
\end{bmatrix}
\begin{bmatrix}
w_{11} & \cdots & w_{i1} \\
\vdots & \ddots & \vdots \\
w_{1j} & \cdots & w_{ij}
\end{bmatrix}
$$

$$
= \frac{\partial L}{\partial Y} W^t
$$

The derivative of the loss function with respect to the biases is given by:

$$
\frac{\partial L}{\partial B} = \left[ \frac{\partial L}{\partial b_1} \ \frac{\partial L}{\partial b_2} \ \cdots \ \frac{\partial L}{\partial b_j} \right]
$$

From the chain rule we can write the derivative of the loss function with respect to the single bias $b_j` as:

$$
\frac{\partial L}{\partial b_j} = \frac{\partial L}{\partial y_1} \frac{\partial y_1}{\partial b_j} + \cdots + \frac{\partial L}{\partial y_j} \frac{\partial y_j}{\partial b_j}
$$

$$
\frac{\partial L}{\partial b_j} = \frac{\partial L}{\partial y_j}
$$

Rewrite the derivative of the loss function with respect to the biases:

$$
\frac{\partial L}{\partial B} = \left[ \frac{\partial L}{\partial y_1} \ \frac{\partial L}{\partial y_2} \ \cdots \ \frac{\partial L}{\partial y_j} \right]
= \frac{\partial L}{\partial Y}
$$

## Putting It All Together

After understanding each component of the backpropagation algorithm, we combine them to update our model's parameters iteratively. The process follows two main phases: the forward pass, where we compute the network's output, and the backward pass, where we compute the gradients and update the parameters.

### Forward Pass

In the forward pass, we calculate the network's predictions using the current parameters:

1. Compute the neuron inputs for the first layer:

   $$
   Z^{(1)} = XW^{(1)} + B^{(1)}
   $$

2. Apply the activation function to get the outputs of the first layer:

   $$
   H = f(Z^{(1)})
   $$

3. Calculate the input to the output layer:

   $$
   Z^{(2)} = HW^{(2)} + B^{(2)}
   $$

4. For a regression task, the output layer might use an identity activation function:

   $$
   Y = Z^{(2)}
   $$

5. Calculate the loss using the Mean Squared Error (MSE):
   $$
   L = \frac{1}{n} \sum_{i} (Y^*_i - Y_i)^2
   $$

### Backward Pass (Backpropagation)

Next, we compute the gradients of the loss function with respect to the model's parameters:

1. Derivative of the loss function with respect to the output:

   $$
   \frac{\partial L}{\partial Y} = \frac{2}{n} (Y - Y^*)
   $$

2. Derivative with respect to the output layer weights:

   $$
   \frac{\partial L}{\partial W^{(2)}} = H^T \frac{\partial L}{\partial Y}
   $$

3. Derivative with respect to the output layer biases:

   $$
   \frac{\partial L}{\partial B^{(2)}} = \sum \frac{\partial L}{\partial Y}
   $$

4. Derivative with respect to the hidden layer outputs:

   $$
   \frac{\partial L}{\partial H} = \frac{\partial L}{\partial Y} (W^{(2)})^T
   $$

5. Derivative with respect to the hidden layer inputs:

   $$
   \frac{\partial L}{\partial Z^{(1)}} = \frac{\partial L}{\partial H} \odot f'(Z^{(1)})
   $$

6. Derivative with respect to the first layer weights:

   $$
   \frac{\partial L}{\partial W^{(1)}} = X^T \frac{\partial L}{\partial Z^{(1)}}
   $$

7. Derivative with respect to the first layer biases:
   $$
   \frac{\partial L}{\partial B^{(1)}} = \sum \frac{\partial L}{\partial Z^{(1)}}
   $$

### Parameter Updates

Finally, we use the computed gradients to update the weights and biases of our model:

- Update the weights in the second layer:

  $$
  W^{(2)} \leftarrow W^{(2)} - \alpha \frac{\partial L}{\partial W^{(2)}}
  $$

- Update the biases in the second layer:

  $$
  B^{(2)} \leftarrow B^{(2)} - \alpha \frac{\partial L}{\partial B^{(2)}}
  $$

- Update the weights in the first layer:

  $$
  W^{(1)} \leftarrow W^{(1)} - \alpha \frac{\partial L}{\partial W^{(1)}}
  $$

- Update the biases in the first layer:
  $$
  B^{(1)} \leftarrow B^{(1)} - \alpha \frac{\partial L}{\partial B^{(1)}}
  $$
