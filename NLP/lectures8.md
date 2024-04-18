# Lectures 8

## Retrival methods

- Non neural:

  - Text representations:
    - Bag of words
    - TF-IDF
    - Word2vec, fastText

- Neural:
  - Bert

### Information retrieval

```
            doc1 (could be a passage)
[query] --> doc2
            ...

            docN

we want to rank/retrive documents based on the query
```

Where do we use information retrieval:

- QA (question answering)
- [RAG](https://arxiv.org/pdf/2005.11401v4.pdf)
- Recommendations

### Ranking documents with BM25

#### IDF - inverse document frquency

$$
IDF(t) = \log \frac{N}{df(t)}
$$

Where:

- $N$ - number of documents
- $df(t)$ - number of documents containing term $t$

#### TF-IDF

$$
TFIDF(t, D) = f(t, D) \cdot IDF(t)
$$

Where:

- $f(t, D)$ - frequency of term $t$ in document $D$

#### BM25

Given a query Q, with words $t_1, t_2, ..., t_n$ and a document D, we want to rank documents based on the query.

$$
score(D, Q) = \sum_{t \in Q} IDF(t) \cdot \frac{f(t, D) \cdot (k_1 + 1)}{f(t, D) + k_1 \cdot (1 - b + b \cdot \frac{|D|}{avgdl})}
$$

Where:

- $k_1$ - hyperparameter
- $b$ - hyperparameter
- $|D|$ - length of document $D$
- $avgdl$ - average document length

### Nerual Ranking

We use neural representation of document and neural representation of query to rank documents.

#### Query document approach

- Problem with it, it is computationally to expensive. For each query we must compute the similarity between the query and all documents. And then train classifirer.

#### All to all interaction with BERT

- We use BERT to encode the query and the document,
- Problem:
  - we have to encode all documents for each query, which is computationally expensive.

Maybe we could preprocess the documents to get the embeddings and then use them to compute the similarity between the query and the document.
Without the need to encode the documents for each query.

#### Bad solution: Nerual bag-of-words

```
Q: Who is the president
D: Dr. Who did not want to be the president.
```

We lose the dependency between the words.

The most significant drawback of the NBOW model is that it ignores the order of words in the text.
It treats documents as simply the sum or average of their word embeddings.
This loss of sequential information means that NBOW cannot capture the syntactic or semantic nuances that depend on the word order, which is crucial for understanding human language.
For example, "Why not?" and "Not why?" have different implications, but would be treated identically in an NBOW model.

#### Better approach: Dense Passage Retrieval (DPR)

- BERT based passage retrieval
- Encodes each passage and each query into a 769-dimensional vector
- Ranks passages in the document collection relative to query q using the dot product similarity
- Works by maximizing the similarity between q and correct passage and minimizing the similarity between q and incorrect passages

#### LaBSE sentence encoder

- Dual encoder architecture where source and target sentences (in different languages) are encoded separately using a shared BERT-based encoder
- Model masks the target sentence during training and predicts the masked tokens using the source sentence
- The model is trained on parallel data and learns to encode sentences in a common space, enabling cross-lingual similarity search

It was trained on M parallel sentences in English + 108 other languages.

```
         loss
         /  \
      /       \
[English]   [Slovene]
```

#### Late Interactions (ColBERT)

- Compute the query and document embeddings separately
- And then compute the `MaxSim` score between the query and the document

We have stored all the documents in the matrix. Then for each query we put it through the network, and then compute the similarity with precomputed documents.

### Common Evaluation Metrics

- Accuracy (@K - how many of the top K documents are relevant)
- Mean Reciprocal Rank (MRR)
  - For each query we return a ranked list of M candidate answers
  - Query score is 1/Rank of the first relevant answer
  - And then take the mean over all queries

#### IR evaluation datasets

Trec, MS MARCO (largest public IR dataset)

## Part of Speech tagging (POS), dependency parsing and named entity recognition (NER)

Basic pipeline:

```
document -> paragraphs -> sentences -> words
words and sentences <- POS tagging
```

### Part of Speech tagging (POS)

- `walk` noun or verb?

```
INsult insult noun: /ˈɪnsʌlt/ verb: /ɪnˈsʌlt/
lead? /liːd/ or /lɛd/
```

### Morphosyntactial tagging

- Basic categories from the old Greek:
  `noun, verb, pronoun, preposition, adjective/adverb, conjunction, participle, and
article`

- Many additional features such as: gender, tense, conjugation, etc.

- Tags defined based on:
  - word morphology
  - distributional properties, i.e. neighboring words, role in sentence

#### Open and closed class words

- Closed Class (a relatively fixed membership):
  - prepositions, auxiliaries, pronouns
- Open Class (new words can be added / modified):
  - nouns, verbs, adjectives, adverbs

### Pos how?

```
Let us talk about linguistics.
Steps:
    - tokenizations
    - tag set (select one)
    - training data (annotated with tags from the tag set)
    - model (LSTM, BERT)
```

#### Universal dependencies

- universal POS tag set (17 tags for a top-level POS tag)

### Micro vs macro average

```
precision, recall <- binary measure

C1 C2 C3
p1 p2 p3


macro: (p1 + p2 + p3) / 3
micro: sum_correct / sum_all
```
