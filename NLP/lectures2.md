# Lectures 2

## Text normalization

Transforming / preprocessing text before inputing it into some model.

- **upper/lower casing**
- **rediacritisation** ~ basically adding punctuals and accents to the text (eng -> slovene fine tuning)
- **notation of acronyms** ~ U.S.A -> USA
- **standard format of dates, time and numbers** ~ Basically unified form for all the inputs (inputs are transfered)
- **stress marks, quotation marks, punctuation**

```
quotation marks in different countries:
"X" == <X> == ,,X"
```

- **non-informative words** ~ removing words that don't add any value to the text (stop words)
- **spelling e.g., color vs. colour** ~ American vs. British English
- **emoticons, emoji, hashtags, web links** ~ Maybe transforming meaning of emoticons, maybe removing them, maybe transforming them into words

```
#niceday -> nice day
```

- **editing and presentation markup e.g., html tags** ~ Mostly we throw them away, becouse they may not be as informative.

```
<b> President </b> was visiting the cave.
```

- **spelling correction** ~ We can use some spell checker to correct the spelling of the words. If small number of words have the errors, then it should not affect the model in negative way.
- **subword tokenization**

```
asymetrical -> a symetric i cal
```

- **lemmatization and stemming** ~ Transforming words into their base form. Useful for searching words usually. And for disambiguation.
  Stemming can produce unambiguous results, but it's faster than lemmatization. Lemmatization is more accurate, but slower. We normally don't do stemming anymore.

```
Lemmatization:
He was training (lemma: train)
He attendend the training (lemma: training)
Stemming:
tied -> ti (no longer sementical)
```

### Token, type, term

- **token** ~ Instance of a sequence of characters in some particular document that are grouped together as a useful semantic unit for processing.
- **type** ~ Class of all tokens containing the same character sequence.
- **term** ~ Some word that is in our system's dictionary.

### How many words?

N = number of tokens
V = vocabulary = set of types
|V| = size of vocabulary (number of distinct types)

```
Heaps Law = Herdan's Law: 𝑉 = 𝑘𝑁^𝛽 where often .67 < β < .75
```

i.e., vocabulary size grows with > square root of the number of word tokens.

## Tokenization problems

### Corpora

- Large ammount of text.
- Words that don't appear anywhere.
- many differnt types.
- datasheet.
- 7097 languages in the world.
- Variety, like African American Language varieties. (iont -> I don't)
- Code switching, mixing languages.
- Dictionaries of propper names

```
Finland’s capital →  Finland Finlands Finland’s ?
what’re, I’m, isn’t →  What are, I am, is not
Hewlett-Packard →  Hewlett Packard ?
state-of-the-art →  state of the art ?
Lowercase →  lower-case lowercase lower case ?
San Francisco →  one token or two?
```

- French and German have different rules for hyphenation.

```
L'ensemble →  one token or two?
    L ? L’ ? Le ?
    Want l’ensemble to match with un ensemble

Lebensversicherungsgesellschaftsangestellter
    ‘life insurance company employee’
    German information retrieval needs compound splitter
```

- Word Tokenization in Chinese

```
Chinese words are composed of characters called hanzi.
Each one represents a meaning unit called a morpheme.
Characters are generally 1 syllable and 1 morpheme.
Average word is 2.4 characters long.
The standard algorithms are neural sequence models trained by supervised machine learning.
```

### Formal languages and models

```
ε alphabet
-> concatenation
εε
->
ε* = ε U εε U εεε U ...

L is a subset of ε*.
ε = {0,1}
L = {0, 1, 00, 01, 000, 010, 100, 001, ...}
```

### Language hierarching

- Regular Languages, RE
- Contex free Languages, CFL
- Context dependent Languages, CDL
- Turing Languages

## Sparse text representation

### 1 hot encoding

Vocabulary of words:

- 1.  aaclvark
- 2. alphabet
- .
- .
- 7439. house
- .
- .
- |v| zyba

```
"house": At the 7439th position in the vocabulary, we put 1.
[000000000000 .... 010.... 0000000000000]

"This is a document"
[0000001...00010...001.00000000100000000]
```

### Bow - Bag Of Words

Same as 1 hot encoding, but we count the number of times the word appears in the document.

```
"This is his house and this is his kingdom."
[000000200...10000002...00000000000000000]
```
