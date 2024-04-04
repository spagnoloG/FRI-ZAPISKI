# Lectures 6

## Subword tokenization

### Byte pair encoding

Let vocabulary be the set of all individual characters

```
= {A, B, C, D,…,a, b, c, d….}
```

Repeat:
– choose the two symbols that are most frequently adjacent in training corpus (say `A`, `B`),
– adds a new merged symbol `AB` to the vocabulary
– replace every adjacent `A` `B` in corpus with `AB`.

Until k merges have been done.

## Bert

Idea:

- Use large unlabeled corpora and auxiliary task to pretrain a model for a general language representation
- fine-tune the model on a (possibly small) dataset for downstream task (typically classification)

Solution from BERT:

Mask out `k%` of the input tokens and predict them using the rest of the tokens. (15% in the original BERT paper)

- MLM (masked language model)

- NSP (next sentence classificaiton / prediction)

```
[Sentence 1] [Sentence 2] <- Do these two sentences follow each other anywhere in the text?

yes/no prediction
```

This method is too simple for these large models and it does not give as many benefits.

Roberta uses only MLM, and more data.

## NLI / NSP

```
S1: A man and a woman are walking down the street.
S2: Two people are  stralling in the street.
S2': Two people are sitting in  a caffe
S2'': Giraffes are cute.

Classification: S1-S2 Entailnment
                S1-S2' Contradiction
                S1-S2'' Neutral
```

### NER - Named entity recognition

```
George Berkley was a famous Irish philosopher.
-------------               -----
```

`Word2vecc, fastText` -> produce implicit embeddings (vectors)

```
I fed the dog.
The dog was hiding his paw.
```

How do we sum up the vectors? How do we combine them into final vector?
Sum them up, average them, concatenate them, etc. (no clear answer)

What do we do then with these vectors:

- Clustering
- Dimensionality reduction
- Visualization
- Find similar inputs (documents)

### Self supervised learning in LLMs

```
We went to the slope.
  [MASK]
```

Masking each word in the sentence and predicting the masked word. ~ Cloze test.

### Zero shot transfer (No additional training)

Without finetuning we use the model for a new task.
Lets say english llm to slovene llm.

### Few shot transfer (A few training instances in target language + fine tuning)

Most of the models now support up to 500 different languages (upper bound).
For the contrast there are more than 7000 languages in the world.

### Building models

1. Pretraining
2. Finetuning

```
CLS
[  L1     ]
[  L2     ]
[  L3     ]
| | | | | |
inputs
```

Finetuning the last layer is not enough. Thats why it is better to fine tune the whole model.
But there are more efficent ways.

### Adapter based fine tuning

```
CLS
0000 <- tuning additional per layer weights
[  L1     ]
0000
[  L2     ]
000
[  L3     ]
000
| | | | | |
inputs
```

Similar performance to full fine tuning, but much faster.
Also the other weights are frozen.

### Prefix tuning

Add two two five more transformer layers to the end of the encoder model. And freeze all the other weights.

### LoRa - Low rank approximation

- [LORA](https://www.databricks.com/blog/efficient-fine-tuning-lora-guide-llms)

#### T5

- Extension of MLM
- Span-corruption training:

We hide more than just a tokens. A bit more context.

```
A few weeks [ago we went] to the  northern part of the [ monuntaious region ].
```
