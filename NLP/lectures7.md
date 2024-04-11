# Lectures 7

## Gpt models

- Generative Pre-trained Transformer
- Using only the decoder part of transformer
- Once we generate something we cannot fix it (hallucination)

- _Autoregressive generators_: When we generate the next word, we have attention from all the previous words
  GPT does not use full attention anymore, but now it uses sparse attention.

In Gpt-4, we have also MOE (Mixture of Experts) which is a way to have multiple models and then combine them.

```
               out
              GPT-4

GPT-4.1     GPT-4.2     GPT-4.3

            controller

            input
```

Models after more than 4B/5B become sensible to humans.

**In-context learning**: We don't need to fine-tune / pre-train the model.
We can just craft the good prompt. It basically isn't even learning, it's just a search problem.
In context learning asusmes that the dataset is hard.

| Fine tuning                                                             | In context learning                           |
| ----------------------------------------------------------------------- | --------------------------------------------- |
| Change the network                                                      | No weight sharing                             |
| Zero shot: Directly prompt the model (no additional examples)           | Prompt the model                              |
| Few shot: Fine tune on a few additional examples (changing the network) | Provide few additional examples in the prompt |

## RLHF: Reinforcement Learning from Human Feedback

- Slow, we use it with adapters.
- We use it because the loss of the human feedback cannot be computed.

Idea: Train a separate model on a human feedbac, this model can generate a reward to be used during training of LLM.

Reward models:

```
[M1] > [M2] : binary comparison

[M1] [M2] [M3] [M4] [M5] [M6] [M7] [M8] [M9] [M10] : ranking
 8    2    3    4    1    10   9    5    6    7
```

No absolute scores! We humans are better at comparing than giving absolute scores.

Stages:

- Pre-train a LLM (new word prediction) 2T data
- Gathering data and training a reward model
  Firstly we take the prompts from the LLM and then we ask the human to compare them. We can also ask the human to rank them.
  After that we train a reward model on this data (basically scalar prediction).

- Fine-tuning the LLM with RLHF

Pretraining:

- Next word prediction
- Instruction following (question answering, summarization, translation, ..)

### PE

- A small variance in prompt can produce large variance in results

Do not say what not to do, but say what to do.

```
A jay is a _____ [bird]
A jay is not a ____ [bird]
```

Prompt chaining: We can use the output of one model as an input to another model. We can chain multiple models together.
We can get more reliable answers by chaining multiple models together.

```
[] - []  - [] -> (much easier to debug smaller prompts than one big one)
- [        ] ->
```
