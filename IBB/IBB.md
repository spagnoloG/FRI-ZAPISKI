# Theory


## Receiver Operating Characteristic (ROC) Curve

###  Overview

The ROC curve is a plot that illustrates the diagnostic ability of a binary classifier system as its discrimination threshold is varied. 
It is created by plotting the True Positive Rate (TPR) against the False Positive Rate (FPR) at various threshold settings.

#### True Positive Rate (TPR)

TPR, also known as Sensitivity or Recall, is calculated as:

```
TPR = TP / (TP + FN)
```
Where:
- TP = Number of true positives
- FN = Number of false negatives

#### False Positive Rate (FPR)

FPR is calculated as:

```
FPR = FP / (FP + TN)
```

Where:
- FP = Number of false positives
- TN = Number of true negatives


### Computation of ROC Curve

1. **Rank Predictions**: Order all predictions by the classifier’s estimated probabilities or scores in descending order.

2. **Threshold Setting**: For each unique predicted score (acting as a threshold):
   - Label all instances with a predicted score above the threshold as positive and below as negative.
   - Calculate TPR and FPR at this threshold.

3. **Plotting**: Plot the FPR on the X-axis and the TPR on the Y-axis for each threshold.

#### Area Under the Curve (AUC)

- The AUC represents the degree or measure of separability achieved by the model.
- It tells how much the model is capable of distinguishing between classes.
- The higher the AUC, the better the model is at predicting 0s as 0s and 1s as 1s.

#### Example

Consider a binary classification problem with the following outcomes:

- TP = 50, FP = 10
- FN = 5, TN = 35

Calculating TPR and FPR:

```
TPR = 50 / (50 + 5) = 0.91
FPR = 10 / (10 + 35) = 0.22
```

These values can be plotted on the ROC curve.


## Cumulative Match Characteristic (CMC) Curve

### Overview

The CMC curve is a performance evaluation method primarily used in the fields of biometrics and computer vision, especially in recognition tasks such as face recognition, fingerprint identification, etc. 
It illustrates the probability of a query identity being correctly identified within the top \( k \) ranks of a system's output.

### Key Concepts

- **Rank-k Identification Rate**: The probability that the correct match of a query appears in the top \( k \) positions of the rank-ordered list of candidates.

### Computation of CMC Curve

1. **Perform Identification Trials**: For each query instance (e.g., a face image), the system generates a ranked list of possible matches from a database.

2. **Rank-k Success**: Determine for each query whether the correct match appears within the top \( k \) ranks.

3. **Calculate Identification Rates**: For each rank \( k \), compute the proportion of queries where the correct match was within the top \( k \) ranks.

4. **Plotting**: The CMC curve is plotted with rank \( k \) on the X-axis and the identification rate on the Y-axis.

### Example

Assuming a face recognition system evaluated with 100 queries:

- If the correct match is found in the top 1 rank for 90 out of 100 queries, the rank-1 identification rate is 90%.
- If the correct match is found in the top 5 ranks for 95 out of 100 queries, the rank-5 identification rate is 95%.

These identification rates at different ranks \( k \) can be plotted to form the CMC curve.

### Interpretation

- A higher curve indicates better performance.
- The curve starts at rank 1 identification rate and monotonically increases, potentially reaching 100%.
- The rate at which the curve ascends (e.g., reaching a high identification rate at lower ranks) indicates how effective the system is at correctly identifying an individual with fewer tries.

### Application

The CMC curve is particularly useful in situations where there are multiple potential matches (e.g., a database of many faces), and the goal is to understand how often the correct match appears near the top of the ranked list.

