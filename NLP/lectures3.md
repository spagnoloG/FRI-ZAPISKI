# Lectures 3

### Problems with BoW vector embeddings

- spaseness
- size
- assumes independent dimensions
- all words have the same impact
- Frequency is semantically important

## Term document matrix

We are using cosine distance between vectors, becosuse we are basically measuring the angle beteween the vectors.

-> Distance between two words: - Levenhstein distance (insert, delete, replacement) - Edit distance (insert, delete)
`     house
    horse
    -> two operations: insert and delete <- edit distance
    -> one operation: replace <- Levenhstein distance
    subhousing
    house
    -> 5 insertions and 1 replacement <- Levenhstein distance
    `
We count how many characters do we need to replace. - spelling similarity - sinonymy -> solve with vector embeddings - homography -> (same spelling, different meaning): `rasie, raze, rays` - semantic similarity -> (same meaning, different spelling): `car, automobile` - sentence -> paraphrases
`     We drove to Ljubljana.
    We have visited the capital.
    `
Same meaning, different words.
Good sentence embeddings should map those two sentences close to each other! - Crosslingual

### Comparisson of documents in BoW representation

- using cosine similarity
  --> stop words: Words that do not bring a lot of content to the sentence. (the, a, an, in, on, at, ...). We want them to be less influential in the similarity measure.
  Thats why we use some weighted similarity.
- frequency of words <- inverse document frequency
  We log it to flatten the score. So that the implication is no that large.

### Alternative to TF-IDF

-> Positive Mutual Information (PPMI)

### Embedings

- Word
- Sentence
- Paragraph
- Document -> hard to capture whole document in one vector, we usually use all the weights in the network to represent a document.

```
F@1     |
F@5     |
F@100   v
```

recall increases, precision decreases

### Information retrival

Compute cosine similarity between the query and the documents.
But beforehand we need to have some evaluation.

## N-gram language models

Statistical language models are based on the probability of a sequence of words.

P(I | am) = ...
...

### n-grams:

- unigram: single words
- bigrams: sequences of two consecutive words
- trigrams: sequences of three consecutive words
- n-grams: sequences of n consecutive words

we ususally dont use more than 3-grams, becouse the probablitly of four words to be together is very low.
unigrams are a little bit to simple, they don't capture the context.

### Evaluation (perplexity)

```
-> This sentence will be measured
M1: p1   p2      p3   p4   p5
M2: q1   q2      q3   q4   q5

sqrt(1/(p1 * p2 * p3 * p4 * p5)) = pM1
sqrt(1/(q1 * q2 * q3 * q4 * q5)) = pM2

Lower perplexity -> better model
```
