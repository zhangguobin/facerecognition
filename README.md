# facerecognition
Download Face Recognition dataset from: http://vision.ucsd.edu/content/yale-face-database

## trainsets
center-light, w/glasses, happy, left-light, sleepy, surprised, wink
## testsets
w/no glasses, normal, right-light, sad

## Performance Comparisions
| Accuracy | One-vs-All | Multi-Class |
|:--------:|:--------------:|:------:|
| PCA | 75.0% | 75.0% |
| LDA | 86.7% | 90.0% |
| PCA+SVM* | 88.3% | N/A |
* 95% variance are kept after dimensionality reduction, which degrades SVM performance
