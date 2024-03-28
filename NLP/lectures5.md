# Lectures 5

### LSTMs

```
c * f (f = forget vector (binary))
```

### Seq2seq models

Useful for translation.
We get the whole sequence (we remeber what we process) and then we generate the output sequence.
Basically encode whole sequence into single vector. (this vector can be pretty short)

```
Sequence [encoder] -> context vector -> [decoder] -> sequence
```

To improve model we want to store all the intermediate vectors not just the last one. This is called **attention** mechanism.

```
Attention

alpha    [   ] <- attention vector
h1       [   ] <- hidden state 1
h2       [   ] <- hidden state 2
h3       [   ] <- hidden state 3
....
```

Attention vector basically tells us how much we should focus on each hidden state.
Applies softmax to the hidden state values and then multiplies it with the hidden states.
And then cobines it to a single vector.
Passed to the encoder.

```
RNN -> LSTM -> LSTM(attention) = extending the memory of the network.
```

```
The ma_n who walked the street buy_s an icecream.
```

Problems:

- Long time to converge and train
- Cannot parallelize
- Cannot handle long sequences

### Cnns

Most common use: As an input layer working on character-level (e.g. text correction)
Or speach recognition.

## Transformers

```
[   ] - [   ] - [   ] - ....... - [     ] (long sequences)
For each postion the attention will check the contribution of each word (self-attention)
```

- Currently the most successful DNN
- Non-recurrent
- Encoder-decoder model
- Fixed input length
- Adapted for GPU parallelization
- Well scalable
- Includes level jumping
- Based on extreme use of attention

### Encoder

- Two layers
- No weight sharing between encoders

```
[ FFN            ]
[ Self-Attention ]
```

### Decoder

```
[   FFN                     ]
[ Encoder-Decoder Attention ]
[ Self-Attention            ]
```

### Word embedding

```
|Je| sui|s| |etudian|t|.
 ix  ix ix    ix     ix
```

For each of these indexes we produce `512` dimensional embedding.

### Self-attention

For each word we want to have information about all the other words. (`nxn`)

```
The animal didn't cross the street, because it was too tired.
----------------------------------------------------------
the -> animal, didn't cross the streed because it was too tired
animal -> the didn't cross the streed because it was too tired
didn't -> The animal cross the street because it was too tired
.....
```

Before computing attention we project them to the lower dimension e.g. `512` -> `64` (Abstractions to be used in computations)

```
Q -> Query vector
K -> Key vector
V -> Value vector

K <- E * X_k (512 x 64) -> (64 x 1)
Q <- E * X_q
V <- E * X_v
```

Computing self-attention score:
The more similar representation the higher the score.

```
(self attention for first token)
q_1 * k_1 = ..
q_1 * k_2 = ..
q_1 * k_3 = ..
....
```

After that apply `softmax` function to the attention score to get the probabilities.

After that `Softmax * value` -> Sum of the values. -> `FFN`.

### Example:

#### Input Representation

- **Embedding**
  - `X1` Thinking
  - `X2` Machines

#### Attention Calculation Steps

1. **Queries**
   - `q1`, `q2`
2. **Keys**
   - `k1`, `k2`
3. **Values**
   - `v1`, `v2`

#### Score Calculation

- Score of `q1` with `k1` = 112
- Score of `q1` with `k2` = 96

#### Scaling the Score

- Divide by \(8 \times \sqrt{d_k} \)
  - Resulting in 14 for `q1` and `k1`
  - Resulting in 12 for `q1` and `k2`

#### Applying Softmax

- Softmax score for `q1` with `k1` = 0.88
- Softmax score for `q1` with `k2` = 0.12

#### Output Calculation

- **Softmax**
  - `X Value` -> `V1`
  - `Sum` -> `Z1`
  - `X Value` -> `V2`
  - `Sum` -> `Z2`

### Multi-headed Attention

Multiple representation subspaces.
For longer sentences we should use more attention heads.

(Gpt-3 -> 16 attention heads), (Cpgt -> 32 attention heads)

Concatenate the results of the attention heads and then apply the linear transformation. to get the final output.

Basically each self attention outputs different representation of the same input. Because it is initialized randomly with different weights.
Usually random samples in the neighbourhood `[0.000001, 0.1]`.

```
Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7 * W0 -> Z
```

### Encoder block

Each block has two `sublayers`:

We use `feedforward` at the end to integrate the information from all the attention scores we had.

By using residual/skip connections we preserve positional information more efficently. The model is able to learn faster.

`Autoregressive Attention` -> We can only look at the previous generated tokens.

#### Chatgpt

It uses only the decoder part of the transformer.
Question is given as the input to the decoder. It does not use the encoder part.

### Training the transformer

We this time know what the output is, so we compute the loss between predicted and the actual output. And then perform GD based on that loss.
Usually it loss that is used is [Kullback-Leibler divergence](https://en.wikipedia.org/wiki/Kullback%E2%80%93Leibler_divergence).
