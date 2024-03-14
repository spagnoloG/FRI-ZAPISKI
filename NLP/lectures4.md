# Lectures 4

## Static neural embeddings

Problem:
Vectors embeddings are too large... Can we do this better?

```
   house
[ ... 3 ............]
            flat
[.... ..... . .1....]

```

Why static? We want to take a word and have a representation of it; without context.

### Distrubutional semantics

```
I withdraw 50€ from the bank.
I went to the river bank.
```

I will take a word and try to predict the words around it.

```
LSA - Latent Semantic Analysis -> term-term matrix
        bank
    |-----------------------------| |V|
    |                             | |V|
    |                             | |V|
    |                             | |V|
    |                             | |V|
    |                             | |V|
    |                             | |V|
    |                             | |V|
    |                             | |V|
went|   1                         | |V|
    |-----------------------------| |V|
   |V|
```

Basically train a network to predict the context of the words. -> **Word2Vec** / **FastText**.

### Training Word2Vec:

Positive training examples:

```
bank    river   1
bank    the     1
bank    to      1
bank    I       1
river   the     1
..
..

```

Negative training examples:
We solve this by negative sampling

unigram probability:

$$
\frac{C(w_j)^{\alpha}}{\sum_{k=1}^{V} C(w_i)^{\alpha}}
$$

```
bank   laydbug  0
...
bank   asymetry 0
```

<- take 10 of such samples and then average them.

And then compute loss like:

$$

L = \sum_{i=1}^{m} L(p_i) - \sum{i=1}^{m} \frac{1}{10} \sum_{j=1}^{10} L(n_{j}) \\

p_i \rightarrow \text{positive examples} \\
n_j \rightarrow \text{negative examples}
$$

### Embeddings

[Two variants](https://www.baeldung.com/cs/word-embeddings-cbow-vs-skip-gram):

- CBOW: Predict target from the bag of words
- Skipgram: Predict context fwords from target (position independent); most implementations use skipgram

### Skipgram algorithm

- Treat the target word and a neighboring word as a positive examples.
- Randomly sample other words in the lexicon to get the negative samples.
- Use logistic regression to train the classifier that distinguishes those classes.
- Use the weights of the hidden layer as the word embeddings.

Fasttext: Word2Vec with subword tokenization. It does not matter how we do tokenization as long as we are consistent.

```
Trigonometrical
tri gono metric al
```

We then sum those embeddings together for `tri` `gono` `metric` and `al` and then average them. To get the vector embedding for `Trigonometrical`.

Weighting:

```
Yesterday evening we saw a traffic accident.
-----------------          ----------------

-- <- we give more weight to these words, possible and relatively cheap, but does not guarantee better results.
```

Debiasing:

- We move the word embedding vectors closer or further from the origin to remove the bias.

### Cross lingual embeddings

```
E         S
[****   [****
*****   *****
****]   *****]
```

Basically we perform linear transformation for both word clouds.
We use some weight matrix to align the word clouds.

Nowdays the models are trained on multiple languages so this alignment is not needed anymore.

### Document representation

- word representation: `w_i`
- document representation:
  Just take the avereage of all the word vectors in the document.
  `n` - number of words
  $$
      \frac{\sum_{i=1}^{n} w_i}{n}
  $$

Or use [Doc2Vec](https://medium.com/wisio/a-gentle-introduction-to-doc2vec-db3e8c0cce5e) Should be much better.
We train it in a such way, that we take a document and try to predict the words in it. We also add a special token for the document.

## Recurrent neural networks for text

- back connections
- store information from the past

```
The man wrote a book.
The man whom I met a few weeks ago in a spa wrote a book. # Long dependency, information who wrote a book will disappear.
```

Advantages:

- Any size of input will do, because it processes word by word

```
w1 -->   [RNN]   --> h1
w2
w3
```

Vanishing gradient problem or exploding gradient problem:

- The chain of derivatives becomes very long.
- The gradient becomes very small/large and the network does not learn anything.

LSTM solution:

- Let's give the network some explicit memory.
- Use memory cell to store information at each state ("gates").
  - input gate: protect the current step from irrelevant inputs
  - forget gate: prevent the current step from passing irrelevant outputs to later steps
  - output gate: limit information passed from one cell to the other
