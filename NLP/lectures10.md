# Lectures 10

## Affective computing

### Features

```
friendly = alpha1 * feat1 + alpha2 * feat2 + alpha3 * feat3 + alpha4 * feat4 + ... +  alphaN * featN
```

Larger coefficients express stronger attitude.

### Connotation in the lexicon

Words have various connotational aspects
Methods for building connotation lexicons; Based on theoretical models of emotion, sentiment:

- By hand (mainly using crowdsourcing)
- Semi-supervised learning from seed words
- Fully supervised (when you can find a convenient signal in the world)
  Applying lexicons to detect affect and sentiment:
- Unsupervised: pick simple majority sentiment (positive/negative words)
- Supervised: learn weights for each lexical category

### Sentiment analysis

**Simplest task**: Is the attitude of this text positive or negative?
**More complex**: Rank the attitude of this text from 1 to 5
**Advanced**: Detect the target, source, or complex attitude types

## Machine translation

- [DeepL](https://www.deepl.com/translator)

Different languages have different definition of creatian concepts.
And there is only a brief overlap between different translations..
Lets say some languages have 10 colors, some have 20, some have 30.

### Statistical machine translation

The intuition for Statistical MT comes from the impossibility of
perfect translation.

### Problems with greedy decoding:

Greedy decoding has now way to undu decisions.
Input: il a mentrate

- he \_
- he hit
- he hei a \_\_\_ (wohoops no going back)
