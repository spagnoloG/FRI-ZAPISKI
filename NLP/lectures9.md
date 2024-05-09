# Lectures 9

## Word senses and disambiguation

### Lemma and Wordform

- _Lemma_: base form of a word
- _Wordform_: inflected form of a word

```
Wordform    lemma
banks       bank
sung        sing
plese       plesati
```

Lemmas have senses, One lemma "bank" can have many meaning.

S1: "a bank can hold the investments in a custodial account"
S2: "as agriculture burgeons on the east bank the river will shrink even more"

### Homonys (enakozvocnice)

Words that share a form but have unrelated, distinct meanings.

```
bank1: financial institution, bank2 : sloping land
bat1: club for hitting a ball, bat2: nocturnal flying mammal
bass: stringed insturment, bass: fish
```

### Polysemy (večpomenskost)

How do we know whan a word has more than one sense?

LLM: Are the senses of word "severe" in S1 and S2 identical?

- zero shot
- few shot
- fine tuning

S1, S2, <word> SAME/DIFFERENT

### Synonims

Word that have the same meaning in some or all contexts.

– filbert / hazelnut
– couch / sofa
– big / large
– automobile / car
– vomit / throw up
– Water / H20

### Antonyms

Senses that are opposites with respect to one feature of meaning.

### Hyponyms

House is a hyponym of building, building is a hyponym of property.
Car is hyponym of vehicle.
Mango is a hyponym of fruit.

A sense A is a hyponym of sense B if being an A entails being a B.

### Meronymy

A leg is a part of a chair; a wheel is a part of a car.

Wheel is a meronym of car and car is holonym of wheel

### Supersenses

A words supersense can be useful coarse-grained representation of its meaning.

```
fasttext } merge all sense into one vector
word2vec }
```

BERT - one vector per context.

### Path based similarity

Two concetps are similar if they are near to eachoter in thesaurs hiearchy. - Have a short path between them - concepts have path 1 to themselves

```
pathlen(c1, c2) = 1 + number of edges in the shortest path between c1 and c2

sim_path(c1, c2) = 1/pathlen(c1, c2)

wordsim(c1, c2) = max simpath(c1, c2) for all senses of c1 and c2
```

#### Path Diagram

- **medium of exchange**
  - **currency**
    - **coinage**
      - **coin**
        - **nickel**
        - **dime**
    - **fund**
      - **budget**
  - **money**
    - **standard**
      - **scale**
        - **Richter scale**

### Calculated Similarities

- `simpath(nickel, coin) = 1/2 = 5`
- `simpath(fund, budget) = 1/2 = 5`
- `simpath(nickel, currency) = 1/4 = 25`
- `simpath(nickel, money) = 1/6 = 17`
- `simpath(coinage, Richter scale) = 1/6 = 17`

### Dekang similarity

This year skipped...

### Evaluating similarity

Extrinsic evaluation: - Question answering - Spell checking - Essay grading

Intrinsic evaluation: - Correlation between algorithm and human word similarity raitings - taking TOEFL multiple-choice vocabulary test

### Word sense disambiguation (WSD)

Given a word context and a fixed inventory of potential senses, decide which sense is intended.

### Word in context (WiC)

Word in Contex (WiC) dataset: determine if two sentences contain a word with the same or different sense, Contains senses mostly from the WordNet.

### WiC fro WSD evaluation

    - WSD on S1 and S2; if the same sense is predicted, the answer is True, otherwise False.

### WiC for WSD prediction

    - WiC classifier; apply S and to sense glosses, predict the sense with the highest score.

What is a classification ceiling for WiC? around 80%.

### Word sense induction

How to use WSD to detect new senses?

```
bass
1 ------ G1
2 ------ G2
3 ------ G3
....
8 ------ G8
9 ------ G9 <- new sense
```

Compare new sense with all the existing senses. If the similarity is low, then it is a new sense.
Clustering fails in practice, because of the huge overlap of the senses.

## Affective computing

Why compute affective meaning?

- Sentiment towards politicians, products, countries, ideas
- Frustration of callers to a help line
- Stress in drivers or pilots
- Depression and other medical conditions
- Confusion in students talking to e-tutors.
- Emotions in novels

### Scherer's typology of affective states

- **Emotions**: short-lived, intense, specific, directed at an object
- **Moods**: longer-lived, less intense, not directed at an object
- **Interpersonal stances**: attitudes towards others
- **Attitudes**: general evaluations of objects
- **Personality traits**: stable individual differences

### Emotions

Atomic basic emotions: - A finite list of 6 or 8. from which all other emotions are constructed.

Dimensions of emotion: - Valence: positive or negative - Arousal: strong or weak - Dominance: in control, active vs controlled, passive
