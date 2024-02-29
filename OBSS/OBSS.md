# THEORETICAL EXAM QUESTIONS

## List and describe the basic steps of the Canny edge detection algorithm.

### 1. Noise reduction

The first step is to remove noise from the image with a Gaussian filter.
The Gaussian filter is a low-pass filter that removes the high-frequency components of the image.
This step is important because the edge detection algorithm is sensitive to noise in the image.

### 2. Gradient calculation

The next step is to find the intensity gradients of the image.
The edge strength is calculated as the gradient magnitude.
The edge gradient direction is calculated as the gradient direction.

### 3. Non-maximum suppression

After getting the gradient magnitude and direction, a full scan of the image is done to remove any unwanted pixels which may not constitute the edge.
For this, we check every pixel to see if it is a local maximum in its neighborhood in the direction of the gradient.

### 4. Double threshold

Here, two thresholds are set: a high and a low threshold.
Pixels with intensities above the high threshold are marked as strong edge pixels, while those below the low threshold are suppressed.
Pixels between these thresholds are marked as weak edge pixels and are only considered as part of an edge if they are connected to strong edge pixels.

### 5. Edge tracking by hysteresis

Edges between the two thresholds are classified as follows.
If they are connected to "sure-edge" pixels, they are considered to be part of edges.
Otherwise, they are also discarded.

## List the procedures for predicting real-world performance (robustness) of an analyzer to detect transient ST segment episodes in the electrocardiogram. Write what aspect of the analyzer is estimated by each procedure.

1. **Aggregate gross statistics**

   - _Estimates how well the analyzer detects a randomly chosen ST episode._

2. **Aggregate average statistics**

   - _Estimates how well the analyzer performs on a randomly chosen record._

3. **The "Bootstrap method" with random generating new databases**

   - _Determines whether the analyzer's performance is critically dependent on the choice of the test database._

4. **The noise stress test with adding noise to records**

   - _Assesses the minimum critical signal-to-noise ratio at which the analyzer’s performance is still acceptable._

5. **The sensitivity analysis by modifying analyzer’s architecture parameters**
   - _Evaluates whether the architecture parameters are critically tuned to the development database._

## Describe the “bootstrap” method. What we are trying to assess using this method? What is necessary assumption in order to perform this method?

### Overview

The bootstrap method is a powerful statistical technique used for estimating the distribution of a statistic (like the mean, median, variance) by resampling with replacement from the original data set.
It allows for estimating the sampling distribution of almost any statistic using random sampling methods.

### Purpose

The primary objectives of the bootstrap method are:

1. **Estimating the Distribution of a Statistic:** It helps in understanding how a statistic might behave if we were to take numerous samples from a population.
2. **Assessing Uncertainty:** By generating many samples, it helps in estimating the variability or confidence intervals of the statistic.
3. **Testing Hypotheses:** Bootstrap can be used for hypothesis testing where traditional methods may not be applicable.

### Necessary Assumption

The key assumption in the bootstrap method is that the sample data represents the true population well. This means:

- The original sample must be representative of the population.
- The sample size should be sufficiently large to capture the characteristics of the population.
- There should be no systematic bias in the sample collection process.

This assumption is crucial because the bootstrap method relies on the idea that the resampled data (created by sampling with replacement from the original sample) mimics the real population from which the original sample was drawn.

## Explain the process of edge detection in images using the Marr-Hildreth edge detector. Also explain the characteristics of the Marr-Hildreth edge detector.

### Process of Edge Detection

1. **Smoothing with Gaussian Filter**:

   - The process begins by smoothing the image using a Gaussian filter.
   - This step reduces noise and variations in the image that are unrelated to edge structures.

2. **Applying the Laplacian Operator**:

   - After smoothing, the Laplacian operator, a second-order derivative operator, is applied.
   - This operator is used to identify areas where the intensity of the image changes sharply, typically indicating edges.

3. **Finding Zero Crossings**:
   - The final step involves finding zero crossings in the Laplacian of the Gaussian-filtered image.
   - A zero crossing, where the sign of the Laplacian changes, suggests a potential edge.
   - These points are marked as edges.

### Characteristics of the Marr-Hildreth Edge Detector

- **Captures Significant Edges**:

  - The Laplacian operator effectively captures significant edges, representing substantial changes in intensity.

- **Robustness to Noise**:

  - The initial Gaussian smoothing makes the Marr-Hildreth edge detector more resistant to noise compared to methods without smoothing.

- **Scale Selection**:

  - The size of the Gaussian filter is adjustable, providing control over the scale of detected edges.
  - This allows the detector to be tuned for fine details or more prominent edges.

- **Isotropic Response**:

  - The detector responds equally to edges from all directions, making it isotropic and beneficial in situations where edge orientations are unknown.

- **Produces Closed Contours**:
  - Unlike some edge detection methods, the Marr-Hildreth algorithm tends to produce closed contours, which is crucial for certain image analysis tasks.

The Marr-Hildreth edge detector is a vital tool in image processing, effectively identifying important edges while being robust to noise. Its combination of Gaussian smoothing and the Laplacian operator makes it a reliable choice for various applications.

## Describe performance evaluation matrix to evaluate performance of an event detector. Write performance measures (equations) that can be used to evaluate performance of the detector and describe them.

| Reference     | EVENT (TP)           | NON-EVENT (FN)       |
| ------------- | -------------------- | -------------------- |
| **event**     | True Positives (TP)  | False Negatives (FN) |
| **non-event** | False Positives (FP) | True Negatives (TN)  |

- **TP** - True positives, the number of correctly detected events
- **FN** - False negatives, the number of missed events
- **FP** - False positives, the number of falsely detected events
- **(TN)** - True negatives, the number of correctly rejected non-events, but this number is undefined for the detection task!

## Performance Metrics

- **Se** - Sensitivity, the proportion of _events_ which were correctly detected as _EVENTS_

  \( Se = \frac{TP}{TP + FN} \)

- **+P** - Positive Predictivity, the proportion of detected _EVENTS_ (detections) which actually were _events_

  \( +P = \frac{TP}{TP + FP} \)

- **Sp** - Specificity, the proportion of true non-events that are correctly identified as such.

  \( Sp = \frac{TN}{TN + FP} \)
