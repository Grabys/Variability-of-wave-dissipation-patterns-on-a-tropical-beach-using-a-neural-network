# 🌊 Wave Dissipation Patterns Classification using Computer Vision

This repository provides a complete workflow for processing coastal video imagery and classifying beach morphodynamic states based on wave dissipation patterns.

The pipeline integrates:

* MATLAB-based image processing
* Python-based dataset preparation
* Neural network inference using Roboflow

---

## 📌 Overview

The workflow follows a structured sequence:

Raw Images → Registration → Timex → Registration (timex) → Rectification →
Manual Classification → Validation → Dataset Preparation → Neural Network →
Inference → Results

The goal is to identify beach states from spatial patterns of wave breaking.

---

## ⚙️ Requirements

### MATLAB

Used for:

* Image registration
* Timex generation
* Rectification

### Python (>= 3.8)

Install dependencies:

```bash
pip install -r requirements.txt
```

---

## 🚀 Pipeline Execution

### 1. Image Registration (Raw Frames)

`scripts/00_IMAGE_REG_TIMEX.m`

---

### 2. Timex Registration

`scripts/01_REG_AVERAGE_IMGS.m`

**Input:**

```
data/sample_images/02_Medias/
```

**Output:**

```
data/sample_images/03_Registradas/
```

---

### 3. Rectification

`scripts/02_RECTIFICATION.m`

**Input:**

```
data/sample_images/03_Registradas/
```

**Output:**

```
data/sample_images/04_Retificadas/
```

---

### 4. Manual Classification

`scripts/03_IMG_CLASSIFICATION.m`

**Output:**

```
data/processed/classEP_5830.mat
```

⚠️ **Note:** This file corresponds to the initial manual classification.
After the full validation process, only the updated file
`classEP_valid_posShort.mat` is retained and used in subsequent steps.

---

### 5. Classification Validation

`scripts/04_VALID_IMGS_CLASSIFICTION.m`

**Output:**

```
data/processed/classEP_valid_posShort.mat
```

---

### 6. Update Classification

`scripts/05_UPDATE_CLASSIFICATION.m`

💡 This is the final validated classification file used for dataset preparation and analysis.

---

### 7. Image Cropping & Resizing

```bash
python scripts/06_REDIM_IMGS.py
```

**Output:**

```
data/sample_images/05_Redimensionadas/
```

---

### 8. Select Images by Class

```bash
python scripts/07_IMGS_SELECT_BY_CLASS.py
```

⚠️ **Adjust according to the target class:**

```python
valor_interessante = 1.0
nome_classe = "refletivo"
```

---

### 9. Random Sampling

```bash
python scripts/08_RANDOM_SELECT.py
```

---

### 10. Model Inference (Roboflow)

```bash
python scripts/09_RUN_INFERENCE.py
```

⚠️ **Set your API key before running:**

```python
API_KEY = "your_API_here"
```

**Input:**

```
data/sample_images/05_Redimensionadas/
```

**Output:**

```
data/processed/inference_results/
```

---

### 11. Extract Results

```bash
python scripts/10_EXTRACT_RESULTS.py
```

**Output:**

```
data/processed/inference_summary.csv
```
