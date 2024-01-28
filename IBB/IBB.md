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


### Hong's Method for Fingerprint Recognition

### Overview
Hong's method, developed by Lin Hong, is a widely recognized algorithm for automatic fingerprint recognition. It focuses on the extraction and matching of minutiae points in fingerprints.

### Key Components
- **Minutiae Extraction**: Identification of unique features in fingerprints, such as ridge endings and bifurcations.
- **Image Enhancement**: Improving the clarity of the fingerprint image for more accurate minutiae detection.

### Process
1. **Preprocessing**: 
   - **Image Normalization**: Adjusts the intensity distribution of the fingerprint image.
   - **Orientation Field Estimation**: Determines the local ridge orientation at each point in the fingerprint.
2. **Ridge Segmentation**: 
   - Separates ridges from the background, focusing on areas where minutiae are likely to be found.
3. **Image Enhancement**: 
   - **Gabor Filtering**: Enhances the quality of the ridge patterns, improving minutiae extraction accuracy.
4. **Minutiae Extraction**:
   - Detects ridge endings and bifurcations using the enhanced image.
   - Refines minutiae points based on their quality and the quality of surrounding ridges.
5. **Post-processing**:
   - **Minutiae Filtering**: Removes false minutiae based on specific criteria like the quality of ridges.
   - **Minutiae Verification**: Verifies the detected minutiae through a local quality check.

### Advantages
- **Robustness**: Effective in processing low-quality fingerprint images.
- **Accuracy**: High level of precision in minutiae extraction and matching.
- **Adaptability**: Suitable for a wide range of fingerprint types and qualities.

## Scale-Invariant Feature Transform (SIFT)

### Key Features
- **Scale-Invariance**: Works well across various scales.
- **Rotation-Invariance**: Maintains performance regardless of image rotation.
- **Robustness**: Effective in different lighting conditions, noise, and minor changes in viewpoint.

### Algorithm Steps
1. **Scale-Space Extrema Detection**: Identify potential interest points by looking for stable features across multiple scales.
2. **Keypoint Localization**: Refine the position and scale of keypoints and discard weak responses.
3. **Orientation Assignment**: Assign orientations based on local image gradient directions to achieve rotation invariance.
4. **Keypoint Descriptor**: 
   - This step creates a unique fingerprint for each keypoint based on local image gradients.
   - The region around each keypoint is divided into smaller regions.
   - For each region, a histogram of gradient directions is computed.
   - These histograms are concatenated to form a descriptor vector for the keypoint.
   - This descriptor is robust to changes in illumination, noise, and minor variations in viewpoint.
   - The vector is normalized to enhance invariance to changes in illumination and contrast.


## Short-Time Fourier Transform (STFT) Approach in Signal Analysis

### Process Details

1. **Block Fourier Spectrum Calculation**
   - **Orientation (b) and Frequency (d) Analysis**: STFT is used to calculate the orientation and frequency of a signal within local sections or blocks.
   - **Method**: The Fourier spectrum of each block captures the signal's frequency content, revealing important features like orientation and frequency variations.

2. **Energy Image Utilization (c)**
   - **Purpose**: The energy image derived from the STFT highlights areas with significant signal energy.
   - **Application**: This energy image is used for masking, focusing the analysis on parts of the signal with relevant information.

3. **Angle Coherence Image Calculation (e)**
   - **Using Orientation (b)**: The angle coherence image is computed based on the orientation data obtained from the block Fourier spectrum.
   - **Function**: This image represents the coherence or consistency of angles across the signal, providing insight into the signal's structural characteristics.

4. **Window Filtering in Fourier Domain**
   - **Information Utilization**: The previously obtained information (orientation, frequency, energy) guides the filtering process in the Fourier domain.
   - **Process**: Each window of the signal is filtered according to the characteristics identified, ensuring a tailored approach to signal processing.

5. **Combining Windows for Final Result (f)**
   - **Final Assembly**: After filtering, the windows are combined to reconstruct the signal.
   - **Outcome**: This results in a processed signal that highlights or enhances specific features, offering a detailed and refined analysis.

## National Institute of Standards and Technology Fingerprint Image Quality (NFIQ)

### Purpose
- **Quality Measurement**: Provides a reliable measure of fingerprint image quality.
- **Performance Enhancement**: Helps in improving the accuracy of fingerprint matching algorithms.

### Key Features
- **Standardized Scoring**: Rates fingerprint image quality on a scale from 1 (highest quality) to 5 (lowest quality).
- **Compatibility**: Works with various fingerprint capture technologies.
- **Widely Used**: Adopted by numerous biometric systems globally.

### Algorithm Details
- NFIQ analyzes specific characteristics of fingerprint images, such as ridge flow, ridge clarity, and the presence of artifacts.
- It considers factors like pixel density, contrast, and noise levels.
- The algorithm is designed to predict the likelihood of a fingerprint image being accurately matched to a pre-existing template.
- It is a local and global quality assessment algorithm that uses a combination of local and global features to predict the quality of a fingerprint image.

## Levels of Fingerprint Features: L1, L2, and L3

### Overview
Fingerprint features are categorized into three levels based on their detail and visibility: Level 1 (L1), Level 2 (L2), and Level 3 (L3). Each level provides different types of information used for identification and analysis.

### Level 1 (L1) Features ~ 250 ppi
- **Description**: General ridge flow and pattern configuration.
- **Examples**: tainted arch (3%), plain arch (4%), right or left loop (65%), whorl (28%), left and right loop (4%).
- **Use**: Used for initial sorting and classification of fingerprints.
- **Visibility**: Easily visible to the naked eye.

### Level 2 (L2) Features ~ 500 ppi
- **Description**: Specific formations within the ridges.
- **Examples**: Minutiae points, including ridge endings, bifurcations, and short ridges.
- **Use**: The primary source of information in fingerprint matching algorithms.
- **Visibility**: Requires magnification for detailed examination.

### Level 3 (L3) Features ~ 1000 ppi
- **Description**: Fine-grained and intricate details of the ridge and pore structure.
- **Examples**: Ridge path deviation, width variation, pores, incipient ridges, and scars.
- **Use**: Provides additional accuracy in identification, especially in forensic analysis.
- **Visibility**: Visible only with high-resolution capture methods and significant magnification.

### Comparative Overview
- **Detail and Accuracy**: L3 > L2 > L1
- **Visibility and Ease of Detection**: L1 > L2 > L3
- **Application Complexity**: L3 (most complex) > L2 > L1 (least complex)


## Levels of Facial Feature Points: L1, L2, and L3

Facial feature points are categorized into three levels based on the level of detail they represent. These levels are crucial in facial analysis, ranging from basic structural recognition to detailed micro-expression analysis.

### Level 1 (L1) Features
#### Description
- **General Facial Features**: Basic structure and shape of the face.
#### Examples
- **Overall Face Shape**: Oval, round, square, heart-shaped.
- **Major Landmarks**: Position of eyes, nose, and mouth.
#### Applications
- **Initial Recognition**: Used in general facial recognition and classification.
- **Primary Identification**: Helps in distinguishing basic facial features.

### Level 2 (L2) Features
#### Description
- **Detailed Facial Features**: Specific attributes and positions of facial components.
#### Examples
- **Eye Position**: Distance between the eyes.
- **Nose and Mouth Shape**: Size and shape of the nose and mouth.
- **Eyebrow Shape**: Arch and length of eyebrows.
#### Applications
- **Enhanced Recognition**: Used for more detailed facial recognition and expression analysis.
- **Personal Identification**: Assists in identifying individuals based on more detailed facial features.

### Level 3 (L3) Features
#### Description
- **Micro-level Details**: Fine-grained features including skin texture and minute expressions.
#### Examples
- **Skin Pores and Texture**: Fine lines, pores, skin texture.
- **Micro-expressions**: Minor facial muscle movements.
- **Scars or Unique Marks**: Small scars, freckles, or moles.
#### Applications
- **High Precision Identification**: Useful in high-security scenarios and detailed expression analysis.
- **Forensic Analysis**: Critical for identifying individuals in forensic science.

### Comparative Overview
- **Detail and Specificity**: L3 > L2 > L1
- **Visibility and Recognition Difficulty**: L1 (most visible, easiest to recognize) > L2 > L3 (least visible, hardest to recognize)
- **Application Complexity**: L3 (most complex) > L2 > L1 (least complex)

## Viola-Jones Algorithm and Haar Cascades for Object Detection


### Key Components

#### Haar-like Features
- **Concept**: Patterns of contrasting rectangular regions, inspired by Haar wavelets.
- **Function**: Capture inherent features of objects by summing pixel intensities in adjacent rectangular regions and calculating their differences.
- **Variety**: Includes edge features, line features, and four-rectangle features.
- **Application**: Efficient at detecting edges and changes in texture.

#### Integral Images
- **Purpose**: Accelerate the calculation of Haar-like features by allowing rapid summing of pixel values in a rectangular subset of an image.
- **Process**: Converts an image into a sum-table where each point contains the sum of the pixel values above and to the left of it.
- **Advantage**: Drastically reduces the computational complexity, enabling real-time processing.

#### Adaboost Training
- **Goal**: Select the most effective features from a large set and train classifiers.
- **Method**: A machine learning algorithm that combines multiple "weak" classifiers to form a strong classifier.
- **Feature Selection**: Prioritizes features that best improve the classifier's performance.

#### Cascade Classifier
- **Structure**: Composed of several stages, where each stage is a collection of weak classifiers.
- **Operation**: An object must pass all stages of the classifier to be detected. Each stage acts as a gatekeeper, quickly eliminating negative samples.
- **Efficiency**: Reduces computation time by focusing on likely object areas and discarding non-object areas early in the process.

### Advantages
- **Speed**: Enables real-time detection.
- **Effectiveness**: Robust against variations in lighting and facial expressions.
- **Versatility**: Adaptable to different object detection tasks, and can be trained for various objects.

### Limitations
- **Rotation Sensitivity**: Less effective with rotated faces or objects.
- **Background Sensitivity**: Performance can be affected by complex backgrounds.


## Eigenfaces for Facial Recognition


### Principal Component Analysis (PCA)
- **Purpose**: Reduces the dimensionality of facial image data, retaining only the most variance-contributing features.
- **Process**: 
    - Converts correlated facial images into a smaller set of uncorrelated variables (principal components).
    - Based on the eigenvectors of the covariance matrix of the facial image dataset.

### Creating Eigenfaces
- **Training Phase**:
    - **Data Preparation**: Collect a large set of facial images.
    - **Normalization**: Align and normalize these faces.
    - **Covariance Matrix Calculation**: Compute this matrix from the normalized images.
    - **Eigenvalue Decomposition**: Find eigenvectors and eigenvalues of the covariance matrix.
    - **Principal Components Selection**: Choose a subset of eigenvectors as eigenfaces, representing significant facial features.
- **Eigenfaces**: 
    - Principal components of the face dataset.
    - Represent standard facial components.

### Recognition Process
- **Representation**: Express each face as a weighted sum of eigenfaces.
- **Weight Calculation**: For a new face, calculate weights by projecting onto the eigenfaces.
- **Classification**: Identify the closest match by comparing weights.

### Handling N_samples < N_dim
- **The Small Sample Size Problem**: When the number of samples is less than the number of dimensions, it leads to computational challenges.
- **Consequence**: The covariance matrix becomes singular, making it difficult to compute eigenvectors directly.
- **Solution**:
    - **Dimensionality Reduction**: Reduce the dimensionality to less than the number of samples before applying PCA.
    - **Regularization Techniques**: Apply techniques to stabilize the covariance matrix.

### Limitations
- **Sensitivity to Variations**: Less effective in changing lighting, expressions, and angles.
- **Generalization Issues**: Performance may suffer with unfamiliar faces.


## Fisherfaces: Facial Recognition Technique


### Principal Component Analysis (PCA)
- **Purpose**: To reduce the dimensionality of facial image data while preserving most of the variance.
- **Process**: 
    - Transforms the original set of images into a new set of uncorrelated variables, known as principal components.
    - This is achieved by eigendecomposition of the data covariance matrix or singular value decomposition.
- **Benefits**: 
    - Reduces the computational cost and complexity.
    - Helps in noise reduction and data simplification.

### Linear Discriminant Analysis (LDA)
- **Application**: Applied to the dimensionality-reduced data from PCA.
- **Goal**: 
    - To maximize the ratio of between-class variance to within-class variance.
    - This enhances the separability between different facial classes.
- **Result**: Yields a set of linear combinations, or Fisherfaces, that best distinguish between individual faces.

### Fisherfaces Method
- **Combination of PCA and LDA**: 
    - PCA is used first for dimensionality reduction.
    - LDA is then applied to the reduced data for optimal class separation.
- **Advantage**: Fisherfaces are less sensitive to variations in lighting and facial expressions compared to using PCA alone (Eigenfaces).

### Handling \( N < d \) in Fisherfaces
- **The Problem**: When the number of samples \( N \) is less than the dimensionality of the data \( d \), the "small sample size" problem arises.
- **Consequence**: The within-class scatter matrix becomes singular, and LDA cannot be computed directly.
- **Solution**:
    - **PCA for Dimensionality Reduction**: PCA is used to reduce the dimension to \( N - 1 \) or less, preventing singularity.
    - **LDA for Classification**: With reduced dimensions, LDA can be effectively applied for facial classification.

### Conclusion
Fisherfaces method, by combining PCA and LDA, provides an efficient and effective solution for facial recognition, adept at handling variations in lighting and expressions. 
The PCA step is crucial, especially in scenarios where the dataset has high dimensionality and a relatively small number of samples.


## Comparison of Principal Component Analysis (PCA) and Independent Component Analysis (ICA)

### Principal Component Analysis (PCA)
#### Purpose
- **Dimensionality Reduction**: Reduces the dimensionality of data while preserving as much variance as possible.
#### Method
- **Orthogonal Transformation**: Transforms the data to a new coordinate system, where the greatest variances lie on the first coordinates.
#### Key Aspect
- **Variance Maximization**: Aims to find the directions (principal components) that maximize the variance in the dataset.
#### Applications
- **Data Compression**: Reduces the size of the dataset.
- **Noise Reduction**: Eliminates irrelevant features.
- **Visualization**: Helps in visualizing high-dimensional data. (but usefull only for 2D or 3D, otherwise t-SNE is better ;) )

### Independent Component Analysis (ICA)
#### Purpose
- **Signal Separation**: Separates a multivariate signal into additive, independent non-Gaussian signals.
#### Method
- **Statistical Independence**: Assumes components are statistically independent and non-Gaussian.
#### Key Aspect
- **Independence Maximization**: Focuses on maximizing the statistical independence of the components.

### Key Differences
- **Statistical Property Used**:
  - **PCA**: Uses covariance. Seeks directions that maximize variance.
  - **ICA**: Seeks components that are statistically independent.
- **Assumptions**:
  - **PCA**: Assumes Gaussian distribution of components.
  - **ICA**: Works best with non-Gaussian distributions.
- **End Result**:
  - **PCA**: Principal components are orthogonal.
  - **ICA**: Independent components are not necessarily orthogonal.

### Conclusion
While PCA is primarily used for reducing dimensionality by focusing on variance, 
ICA is used for separating independent sources from mixed signals. Both have distinct applications and are chosen based on the specific requirements of the data analysis task.

## Score-Level Fusion in Biometric Systems

### Overview
Score-level fusion is a technique used in biometric systems to combine scores from multiple biometric modalities, enhancing the accuracy and reliability of identity verification or identification.

### Concept
- **Integration of Scores**: Involves combining the individual scores from different biometric sources, such as fingerprints, facial recognition, or iris scans.
- **Decision Making**: The fused score is then used to make a final decision regarding the identity of an individual.

### Methods of Score-Level Fusion
1. **Sum Rule**: Adds the scores from each biometric system.
2. **Weighted Sum Rule**: Similar to sum rule but assigns different weights to each score based on reliability.
3. **Product Rule**: Multiplies the individual scores, assuming they are independent.
4. **Max Rule**: Takes the maximum of the individual scores.
5. **Min Rule**: Takes the minimum of the individual scores.
6. **Bayesian Fusion**: Based on Bayesian inference, combining scores using prior probabilities.

### Advantages
- **Improved Accuracy**: Combining multiple scores reduces the error rate compared to single modality systems.
- **Flexibility**: Can be adjusted for different security levels by varying the fusion method or weights.
- **Robustness**: More resilient to spoofing attacks and environmental variations.

### Challenges
- **Score Normalization**: Requires normalization of scores from different modalities to a common scale.
- **Optimal Weighting**: Determining the best weights for the weighted sum rule can be complex. (it can be learned tho :D )
- **Dependency Assumption**: In methods like product rule, the independence assumption may not hold true.


## Multibiometric Systems

### Overview
Multibiometric systems are advanced biometric solutions that integrate multiple physiological or behavioral characteristics for identification or verification. 
They aim to enhance accuracy, security, and robustness compared to single-modality biometric systems.

### Key Aspects

#### Multiple Modalities
- **Traits Used**: Combines different biometric traits like fingerprints, facial recognition, iris scans, voice recognition, etc.
- **Diversity**: Offers a range of biometric options to cater to different situations and user preferences.

#### Improved Accuracy
- **Error Reduction**: By leveraging multiple biometric indicators, these systems significantly lower the probability of identification errors.
- **Reliability**: Provides more consistent results across diverse user groups and conditions.

#### Enhanced Security
- **Spoof Resistance**: More challenging for intruders to spoof multiple biometric traits simultaneously.
- **Robustness**: Offers a higher degree of security, making it suitable for critical applications.

#### User-Friendly
- **Flexibility**: Users can choose from multiple biometric options for authentication.
- **Inclusivity**: Accommodates users who might have difficulties with a specific biometric trait.

#### Reduced Failure to Enroll Rates
- **Backup Options**: In case one biometric trait is unusable (e.g., injured finger), another trait can be used.
- **Versatility**: Ensures broader coverage and usability.

#### Fusion Methods
- **Integration Levels**: Can combine biometric data at sensor level, feature level, score level, or decision level.
- **Customization**: The system can be tailored to specific security needs and contexts.

### Applications
- **High-Security Areas**: Ideal for places requiring stringent security measures.
- **Border Control**: Enhances efficiency and accuracy in identity verification.
- **Financial Transactions**: Used in banking for secure customer authentication.
- **Personal Devices**: Common in smartphones and laptops for robust security.


## Rank-Level Fusion in Biometric Systems

### Overview
Rank-level fusion is a method used in biometric systems, especially in identification mode, where the system outputs a ranking of enrolled identities. 
This technique consolidates the ranks from individual biometric subsystems to derive a consensus rank for each identity.

### Key Concepts
- **Rank vs. Match Scores**: Ranks provide less information than match scores but are inherently comparable across different systems, eliminating the need for normalization.
- **Rank Matrix**: Denoted as `R = [rn,m]`, where `rn,m` is the rank assigned to identity `In` by the `m-th` matcher.
- **Statistic for Identity**: Denoted as `rˆn`, a statistic computed for each user such that the user with the lowest value is assigned the highest consensus rank.

### Highest Rank Method
- **Process**: Assigns each user the highest rank (minimum `r` value) as computed by different matchers.
- **Application**: Effective when the number of users is large compared to the number of matchers.

### Borda Count Method
- **Process**: Utilizes the sum of the ranks assigned by the individual matchers.
- **Statistic**: Measures the degree of agreement among different matchers.
- **Assumptions**: 
    - Ranks assigned by matchers are statistically independent.
    - All matchers perform equally well.

### Logistic Regression Method
- **Process**: A generalization of the Borda count method, calculating a weighted sum of individual ranks.
- **Statistic**: Weights are determined through logistic regression.
- **Advantages**:
    - Useful when there are significant differences in the accuracies of different biometric matchers.
    - Requires a training phase for determining the weights.
