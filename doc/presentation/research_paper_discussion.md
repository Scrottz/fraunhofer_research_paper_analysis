---
footer-date: "15.06.2026"
footer-center-text: ""
---

::: {.slide .title}

# **Scaling Synthetic Data for LLM Pre-Training**  

## Von Web-Filterung zu Instruction-Tuning
## Fraunhofer IAIS 


::: {.speaker-info}
::: {.name}
Franz Keilholz, MA.
:::
::: {.date}
15.06.2026
:::
:::

:::

---

::: {.slide .content footer-center-text="Literatur"}

# Literaturverzeichnis & Zitationen

## Paper 1: RefinedWeb

Penedo, G., Malartic, Q., Hesslow, D., Cojocaru, R., Cappelli, A., Alobeidli, H., Pannier, B., Almazrouei, E., and Launay, J. (2023). 'The RefinedWeb Dataset for Falcon LLM: Outperforming Curated Corpora with Web Data, and Web Data Only'. arXiv:2306.01116. doi: 10.48550/arXiv.2306.01116

## Paper 2: Nemotron-CC

Su, D., Kong, K., Lin, Y., Jennings, J., Norick, B., Kliegl, M., Patwary, M., Shoeybi, M., and Catanzaro, B. (2024). 'Nemotron-CC: Transforming Common Crawl into a Refined Long-Horizon Pretraining Dataset'. arXiv:2412.02595. doi: 10.48550/arXiv.2412.02595

## Paper 3: FineInstructions

Patel, A., Raffel, C., and Callison-Burch, C. (2025). 'FineInstructions: Scaling Synthetic Instructions to Pre-Training Scale'. arXiv:2601.22146. doi: 10.48550/arXiv.2601.22146

:::

---

::: {.slide .content footer-center-text="Einleitung"}

# Motivation: Das Data-Bottleneck Problem

## LLM Training braucht Billionen von Tokens

Größere Datenmengen führen zu besserer Generalisierung, reduzieren Overfitting und ermöglichen es dem Modell, komplexere Muster zu lernen.

- **Llama 3.1** (8B–405B): 15T Tokens
- **Gemma 2** (27B): 13T Tokens

## Problem: Aggressive Filterung entfernt Großteil der Daten

  - FineWeb-Edu: 1.3T → **0.2T unique tokens** (80% Duplikate)
  - DCLM: 3.8T → **1.0T unique tokens** (80% Duplikate)

:::

---

::: {.slide .content footer-center-text="Einleitung"}

# Motivation: Das Data-Bottleneck Problem

## Drei Paper, ein Ziel: Mehr nutzbare Daten

**Pipeline-Evolution**

| Stage | Operation |
|-------|-----------|
| **CommonCrawl (Raw)** | Input |
| **RefinedWeb** | Extract + Filter + Deduplicate |
| **Nemotron-CC** | + Quality Buckets + Rephrasing |
| **FineInstructions** | + Template Matching + Q&A Format |

:::

---

::: {.slide .content footer-center-text="Einleitung"}

# Research Goals: Zusammenhänge der drei Paper

## Chronologische & konzeptionelle Progression

| Paper | Jahr | Kernfrage | Ansatz |
|-------|------|-----------|--------|
| **RefinedWeb** | 2023 | Kann Web-Data allein mit Curated Data konkurrieren? | Aggressive Deduplizierung (Fuzzy + Exact) |
| **Nemotron-CC** | 2025 | Wie maximiert man Quality UND Quantity? | Classifier-Ensemble + Synthetic Rephrasing |
| **FineInstructions** | 2026 | Kann Pre-Training wie Instruction-Tuning aussehen? | Template-basierte Q&A-Generierung |

:::

---

::: {.slide .content footer-center-text="Einleitung"}

# Research Goals: Zusammenhänge der drei Paper

## Gemeinsamer Nenner

- **CommonCrawl**

    - Wird von RefinedWeb und Nemotron explizit und FineInstruction implizit genutzt

- **Alle kämpfen gegen Duplikate** 

  - Memorization vs. Generalization

- **Progression**: Minimal → Moderate → Maximal Transformation

:::

---

::: {.slide .content footer-center-text="RefinedWeb"}

# Paper 1: RefinedWeb (Falcon LLM)

**Penedo et al., 2023**

## Ausgangslage

**Conventional Wisdom (vor 2023)**:

- Web-Daten < Curated Corpora (Books, Wikipedia, Papers)
- State-of-the-art: Mix aus Web (60%) + Curated (40%)
- Beispiel GPT-3: 300GT, davon 60% Web

**Problem**: Curation ist nicht skalierbar

- Llama 3.1 braucht 15T Tokens
- Größte öffentliche Datasets: ~1T Tokens (The Pile, C4, OSCAR)

**Forschungsfrage**: Kann **Web-only** mit Curated mithalten?

:::

---

::: {.slide .content footer-center-text="RefinedWeb"}

# RefinedWeb: Methoden (MDR Pipeline)

## MacroData Refinement: 3 Design-Prinzipien

1. **Scale First**: 3–6T Tokens Ziel (keine manuelle Curation)
2. **Strict Deduplication**: Fuzzy (MinHash) + Exact (Suffix Array)
3. **Neutral Filtering**: Nur Heuristiken, kein ML-Filter (Bias-Vermeidung)

## Pipeline-Stufen

1. **Document Prep**: Trafilatura → FastText LangID (threshold 0.65)
2. **Filtering**: Repetition removal + Document/Line-wise heuristics
3. **Deduplication**: MinHash (9K hashes, 20 buckets) + Exact (≥50 tokens)

:::

---

::: {.slide .content footer-center-text="RefinedWeb"}

# RefinedWeb: Deduplication Details

## Warum so aggressiv?

- **Memorization-Problem**: Duplikate bei 175B Modellen schädlich (Hernandez et al., 2022)
- **MinHash-Konfiguration**: 9K hashes (vs. The Pile: 10 hashes)
  - 5-grams, 20 buckets à 450 hashes
  - Removal Rate: ~50% der Daten

## Exact Substring Deduplication

**Methode**: Suffix Array → ≥50 Token Matches → Remove/Mask/Drop

- Suffix Arrays über konkatenierte Dokumente: 
  - Jede Textposition wird zum Suffix-Startpunkt 

:::

---

::: {.slide .image-slide footer-center-text="RefinedWeb"}

# RefinedWeb: Experimente & Results

::: {.image-container}
![](nodoc/assets/2306.01116v01/figure_1.png)

::: {.image-caption}
Models trained on RefinedWeb EB alone outperform models trained on curated corpora
:::
:::

:::

---

::: {.slide .content footer-center-text="RefinedWeb"}

# RefinedWeb: Experimente & Results

## Key Findings

**Small-Scale (1B @ 27GT, 3B @ 60GT)**:

- RefinedWeb > C4 > The Pile auf MMLU
- C4 stark, aber RefinedWeb +2–3% besser

**Full-Scale (7B @ 350GT)**:

- **RefinedWeb matches GPT-3** (same eval setup)
- Open models (OPT, Pythia) underperform
- **Web-only funktioniert!**

:::

---

::: {.slide .content footer-center-text="RefinedWeb"}

# RefinedWeb: Ablations & Takeaways

## Ablation: Do Other Corpora Benefit from MDR?

**Although improvements from filtering are not systematic across datasets, deduplication brings a steady performance boost
across the board**

| Dataset | Base MMLU | +Filtered | +Dedup | +Both |
|---------|-----------|-----------|--------|-------|
| OSCAR-21.09 | 55.0% | +0.4 | +0.6 | +0.5 |
| C4 | 55.7% | +0.5 | +0.2 | +0.7 |
| **The Pile** | **53.4%** | **+0.8** | **+1.1** | **+1.8** |
| RefinedWeb | 52.7% | +1.6 | - | +3.5 |

**Erkenntnis**: Deduplication hilft **konsistent**, Filtering ist dataset-spezifisch

:::

---

::: {.slide .content footer-center-text="RefinedWeb"}

# RefinedWeb: Ablations & Takeaways

## Limitations

- Toxicity ≈ The Pile (Perspective API)
- Multiple Epochs: Unklar ob deduplizierte Daten mehr Epochs erlauben
- Pythia-Studie: Dedup auf The Pile hatte **wenig Impact** (Widerspruch?)

:::

---

::: {.slide .content footer-center-text="Nemotron-CC"}

# Paper 2: Nemotron-CC

**Su et al., 2024**

## Ausgangslage

**RefinedWeb-Problem**: ~90% Gesamtreduktion (alle Pipeline-Stufen kombiniert) → Bottleneck für 15T Training

- DCLM/FineWeb-Edu: ~90% Removal, nur 1T unique tokens
- **Trade-off**: Quality vs. Quantity

**Forschungsfrage**: Besserer Trade-off durch:

1. Classifier Ensembling (mehr Recall)
2. Synthetic Rephrasing (mehr Unique Tokens)
3. Weniger Heuristic Filters (mehr Yield)

:::

---

::: {.slide .image-slide footer-center-text="Nemotron-CC"}

# Paper 2: Nemotron-CC

::: {.image-container}
![](nodoc/assets/2412.02595v2/figure_1.png)

::: {.image-caption}
MMLU scores for 8B parameter models trained for 1T tokens.
:::
:::

:::

---

::: {.slide .content footer-center-text="Nemotron-CC"}

# Nemotron-CC: Methoden (3-Komponenten-Ansatz)

## 1. HTML-to-Text Extractor & Filter

**Extractor-Wahl**: Justext > Trafilatura (+28.6% HQ tokens)

**Filter-Strategie**: 
- **Heuristic Filters NUR auf Low-Quality Data**
- High-Quality Data: Unfiltered (vermeidet 18.1% Token-Verlust)

**Ablation studies on extractor and filter**

| Experiment | MMLU | Avg (9 tasks) |
|------------|------|---------------|
| Trafilatura filtered | 55.4 | 60.6 |
| Justext filtered | 54.1 | 60.9 |
| Justext unfiltered | 55.5 | 60.3 |
| **Justext HQ-unfiltered** | **57.5** | **60.6** |

**Erkenntnis**: Filter auf HQ-Daten = -18% Tokens, +2% MMLU

:::

---

::: {.slide .content footer-center-text="Nemotron-CC"}

# Nemotron-CC: Model-Based Quality Labeling

## Classifier-Ensemble (3 Modelle)

**Klassifikatoren**:

1. Mistral 8x22B-annotiert (Educational Value 0–5)
2. Nemotron-340B-annotiert (Educational Value 0–5)
3. DCLM FastText (Instruction + ELI5 Reddit)

**Ensemble-Strategie**: Maximum-Operation → 20 Buckets → 5 Quality Labels

:::

---

::: {.slide .content footer-center-text="Nemotron-CC"}

# Nemotron-CC: Model-Based Quality Labeling

## High-Quality Documents Overlap Analysis

| Kategorie | Dokumente | Total unique % | Erklärung |
|-----------|-----------|---|-----------|
| **Intersection** (alle 3 Classifier) | 1.15M | 10.1% | Dokumente, die von ALLEN 3 Klassifikatoren als High-Quality bewertet wurden |
| **FineWeb-Edu only** | 4.02M | 35.4% | Nur Mistral 8x22B + Nemotron-340B stimmen überein (DCLM weicht ab) |
| **DCLM only** | 6.18M | 54.4% | Nur DCLM FastText bewertet als High-Quality (andere Klassifikatoren nicht) |


## Common Crawl quality labels statistics

| Label | Buckets | Tokens (B) | % |
|-------|---------|------------|---|
| High | 19 | 553 | 12.6% |
| Medium-High | 18 | 504 | 11.5% |
| Medium | 12–17 | 2,023 | 46.2% |

:::

---

::: {.slide .content footer-center-text="Nemotron-CC"}

# Nemotron-CC: Synthetic Data Generation

## Strategie: Low-Quality vs. High-Quality

**Low-Quality (403B → 336B)**:

- **Ziel**: Noise/Error Reduction
- **Methode**: Wikipedia-Style Rephrasing
- **Resultat**: -16.6% (Qualitätskontrolle)

**High-Quality (451B → 1.5T)**:

- **Ziel**: Token Diversity + Knowledge Condensation
- **Methode**: 5 Prompts (QA, Distill, Extract, List, Wikipedia)
- **Resultat**: +232% (Unique Token Variants)

→ Verhindert Overfitting durch Repetition (Muennighoff et al.)

:::

---

::: {.slide .content footer-center-text="Nemotron-CC"}

# Nemotron-CC: Synthetic Data Generation (2)

## Synthetic data token count statistics

| Prompt | Tokens | Beschreibung |
|--------|--------|--------------|
| Diverse QA Pairs | 499.5B | Yes/No, Open-ended, Multi-choice |
| Distill | 157.6B | Concise passage |
| Extract Knowledge | 303.6B | Facts only, discard filler |
| Knowledge List | 203.2B | Organized bullet points |

**Post-Processing**: Remove incomplete, strip Markdown, filter <50 tokens

:::

---

::: {.slide .content footer-center-text="Nemotron-CC"}

# Nemotron-CC: Results

## Short Horizon (1T tokens, 8B model)

**Results for 8B parameter models trained on 1T tokens**

| Dataset | MMLU | ARC-C | Avg (10 tasks) |
|---------|------|-------|----------------|
| **Nemotron-CC-HQ** | **59.0** | **52.9** | **60.1** |
| DCLM | 53.4 | 47.0 | 57.0 |
| Nemotron-CC | 53.0 | 50.7 | 57.8 |
| FineWeb-Edu | 42.9 | 48.0 | 53.2 |

**Erkenntnis**: HQ-Subset +5.6 MMLU, Full dataset = DCLM aber 4× mehr Daten

:::

---

::: {.slide .content footer-center-text="Nemotron-CC"}

# Nemotron-CC: Results

## Long Horizon (15T tokens, 8B model)

**Comparison of our 8B parameter model vs Llama 3.1 8B**

| Model | MMLU | ARC-C | Avg (10 tasks) |
|-------|------|-------|----------------|
| **Ours (7.2T from Nemotron-CC)** | **70.3** | **58.1** | **64.7** |
| Llama 3.1 8B | 65.3 | 55.0 | 64.2 |

**Erkenntnis**: State-of-the-art über langen Horizont

:::

---

::: {.slide .content footer-center-text="Nemotron-CC"}

# Nemotron-CC: Ablations

## Classifier Comparison

**Different classifiers comparison**

| Classifier | HQ % | MMLU | Avg (9 tasks) |
|------------|------|------|---------------|
| FineWeb-Edu | 8% | 55.4 | 59.0 |
| DCLM | 11% | 56.0 | 58.4 |
| **Ours-Ensembled** | **25%** | **56.4** | **59.4** |

**Erkenntnis**: Ensemble verdoppelt HQ-Recall, hält Performance

:::

---

::: {.slide .content footer-center-text="Nemotron-CC"}

# Nemotron-CC: Ablations

## Synthetic Data Impact

**Impact of incorporating synthetic data**

| Blend | MMLU | ARC-E | Avg |
|-------|------|-------|-----|
| LQ-Base | 48.2 | 67.7 | 52.5 |
| **LQ-Synthetic** | **47.1** | **71.3** | **54.0** (+1.5) |
| HQ-Base (8 epochs) | 53.4 | 74.2 | 55.8 |
| **HQ-Synthetic (4 epochs real + 4 synthetic)** | **53.6** | **76.7** | **56.7** (+0.9) |

**Erkenntnis**: Rephrasing hilft, Fresh Tokens > Repeated Tokens

:::

---

::: {.slide .content footer-center-text="FineInstructions"}

# Paper 3: FineInstructions

**Patel, Raffel, Callison-Burch, 2026**

## Ausgangslage

**Pre-Training Misalignment**:

- Standard: Self-supervised "predict next word" auf unstrukturiertem Text
- Instruction-Tuning: Supervised auf wenigen 1000–100K Beispielen
- **Problem**: Pre-Training-Objective ≠ Downstream Usage (User prompts)

**Existing Instruction Datasets**:

- Klein (few thousand) oder schmal (academic NLP tasks)
- LLM-generiert → Distillation, kein echtes Wissen

:::

---

::: {.slide .content footer-center-text="FineInstructions"}

# Paper 3: FineInstructions (2)

**Forschungsfrage**: Kann Pre-Training **direkt** als Instruction-Tuning erfolgen?

- **Idee**: Pre-Training-Dokumente → Instruction-Answer-Paare (1B+ Paare)

:::

---

::: {.slide .content footer-center-text="FineInstructions"}

# FineInstructions: Methoden (Pipeline)

## 4-Stufen-Prozess

### 1. Instruction Template Generation (~18M Templates)

**Input**: ~18M User-Queries (WildChat, LMSys, Reddit QA, GooAQ, etc.)

**Prozess**:

| Schritt | Beschreibung |
|---------|--------------|
| **LLM** | Llama-3.3 70B generiert 50K "Silver-Standard" Templates |
| **Format** | `"Between <fi>Entity A</fi> and <fi>Entity B</fi> which is more <fi>characteristic</fi>?"` |
| **Distillation** | Llama-3.2 1B trainiert auf 50K → generalisiert auf 18M |

**Output**: 18M Templates + "Compatible Document Descriptions"

:::

---

::: {.slide .content footer-center-text="FineInstructions"}

# FineInstructions: Methoden (Pipeline)

### 2. Template ⇔ Document Matching

**Embedding Model**: BGE-M3 (fine-tuned 2×)

- **Round 1**: Hard positives/negatives (LLM-judged compatibility)
- **Round 2**: Gaussian Pooling Layer (K=5 chunks per document)

:::

---

::: {.slide .content footer-center-text="FineInstructions"}

# FineInstructions: Gaussian Pooling (Technical Detail)

## Problem: Long Documents

- Global mean pooling → verliert lokale Information
- Templates relevant für **spezifische Abschnitte**, nicht ganzes Dokument

## Lösung: K=5 Local Embeddings + 1 Global

**Parameter**: K=5, α=1.0 (pure local), σ=0.05

**Validation**: Pearson correlation 0.99 zwischen Chunk-Index und Answer-Location

**Retrieval**: Cosine Similarity > 0.865 → Match

:::

---

::: {.slide .content footer-center-text="FineInstructions"}

# FineInstructions: Instantiation & Judging

### 3. Instruction & Answer Generation

**Instantiator Model**: Llama-3.2 3B (distilled from 70B)

**Groundedness**: ≥80% der Antwort = Direct Excerpt aus Dokument

**Compute Optimization**: Excerpt Tags

- Original: "It is known that no preferred inertial frame exists according to the principle of relativity" 
- Generated: "<excerpt>It is known that <...> the principle of relativity.</excerpt>"

**Training**: 2-Round Distillation

- Round 1: 100K Silver-Standard (Llama-3.3 70B)
- Round 2: 100K filtered by LLM-as-Judge (stratified: length, complexity, topics)

:::

---

::: {.slide .content footer-center-text="FineInstructions"}

# FineInstructions: Instantiation & Judging

### 4. Quality Filtering

**Judge**: Flow Judge (3.8B, 5-point Likert: 1=irrelevant, 5=perfect)

- Threshold: ≥4
- **Final Output**: 1B+ Instruction-Answer Pairs

:::

---

::: {.slide .image-slide footer-center-text="FineInstructions"}

# FineInstructions: Methoden (Pipeline)

::: {.image-container}
![](nodoc/assets/2601.22146v1/figure_2.png)

::: {.image-caption}
The FineInstructions pipeline for efficiently generating diverse, pre-training scale, synthetic instruction-answer pairs.
:::
:::

:::

---

::: {.slide .content footer-center-text="FineInstructions"}

# FineInstructions: Experiments

## Setup

**Baselines**:

- **IPT** (Instruction Pre-Training): 23B tokens, Q&A from academic NLP
- **Nemotron-CC**: 300B tokens (Q&A, WRAP, Full Mix)

**Models**: 1.8B parameters (Llama-3 tokenizer, Lingua framework)

**Data Blend**: 73% CC (varied) + 27% fixed (code, papers, books)

**Evaluation**: 3 Benchmarks

:::

---

::: {.slide .content footer-center-text="FineInstructions"}

# FineInstructions: Experiments (2)

## Benchmarks

- **MixEval**: Academic tasks (MMLU, TriviaQA, etc.) + LLM-as-Judge (GPT-5 mini)
- **MT-Bench-101**: Realistic user queries, 10-point Likert
- **AlpacaEval**: Head-to-head, length-bias corrected (GPT-4-Turbo)

:::

---

::: {.slide .content footer-center-text="FineInstructions"}

# FineInstructions: Results

**1.8B parameter models across two pre-training corpora**

| Corpus | Method | MixEval Std | MT-Bench | AlpacaEval |
|--------|--------|-------------|----------|------------|
| IPT 23B | Standard Pre-Training | 17.8 | 1.9 | +47.2 |
| IPT 23B | IPT | 19.8 | 2.4 | +36.4 |
| IPT 23B | FineInstructions | 31.7 | 2.8 | Ref. |
| Nemotron 300B | Standard Pre-Training | 24.0 | 3.5 | +27.2 |
| Nemotron 300B | WRAP | 22.8 | 3.6 | +30.2 |
| Nemotron 300B | Nemotron Q&A | 27.1 | 3.4 | +52.2 |
| Nemotron 300B | Nemotron-CC Full | 24.5 | 3.6 | +31.8 |
| Nemotron 300B | FineInstructions | 33.0 | 3.9 | Ref. |

AlpacaEval: Win margin for FineInstructions (higher = better)

:::

---

::: {.slide .content footer-center-text="FineInstructions"}

# FineInstructions: Diversity Analysis

## Template Diversity

- **4.3M unique templates** verwendet (aus 18M Pool)
- Kein Template >0.09% der Daten

**Quellen-Verteilung**:

- GooAQ: ~50%
- Reddit QA: ~27%
- LMSys Chat: ~9%
- WildChat: ~6%

:::

---

::: {.slide .image-slide footer-center-text="FineInstructions"}

# FineInstructions: Diversity Analysis

::: {.image-container}
![](nodoc/assets/2601.22146v1/all_sunburst.png)

::: {.image-caption}
A visualization of the task diversity in FineInstructions
:::
:::

:::

---

::: {.slide .content footer-center-text="FineInstructions"}

# FineInstructions: Ablation (Judging Impact)

**Incorporating a judging and filtering stage on top of FineInstructions leads to further improvements in performance**

## IPT Corpus (23B)

| Method | MixEval Std | AlpacaEval Win % (vs. Judged FI) |
|--------|-------------|----------------------------------|
| FI (No Judging) | 30.1 | 46.5% (∆ -7%) |
| **FI (Judged)** | **31.7** | **—** |

## Nemotron-CC Corpus (300B)

| Method | MixEval Std | AlpacaEval Win % (vs. Judged FI) |
|--------|-------------|----------------------------------|
| FI (No Judging) | 33.3 | 61.4% (∆ +22.8%) |
| **FI (Judged)** | **33.0** | **—** |


:::

---

::: {.slide .content footer-center-text="Discussion & Kritik"}

# Discussion: Methodische Schwachstellen

## Kritikpunkt 1: Entity Replacement (Reproduzierbarkeit)

**Problem**:

- Paper: "Queries are genericized by replacing spans with `<fi></fi>` tags"
- **Keine Erklärung**: Wie werden Entity-Boundaries erkannt?
- **Keine Heuristiken**: Token-Classification? NER? Regelbasiert?

**Konsequenz**: 

- Template-Generierung = **Black Box** (LLM-Prompts)
- Nur 1 Beispiel-Prompt in Appendix C
- **Nicht reproduzierbar** ohne Llama-3.3 70B + exakte Prompts

:::


---

::: {.slide .content footer-center-text="Discussion & Kritik"}

# Discussion: Methodische Schwachstellen (3)

## Kritikpunkt 2: Vague Prompting Methodology

**Problem**:

- Erstellung des silver standard
- "Prompting an LLM with a series of prompts" (Section 3.1)

- **Keine Details** zu:
  - Few-Shot Examples? (Anzahl, Auswahl)
  - Chain-of-Thought? (Reasoning Steps)
  - Multi-Step Verification? (Self-Consistency)
  - Temperature/Top-p Settings?

:::

---

::: {.slide .content footer-center-text="Discussion & Kritik"}

# Discussion: Methodische Schwachstellen (4)
**Konsequenz**:

- **50K Silver-Standard Templates** = Foundation für gesamte Pipeline
- Query Genericizer (Llama-3.2 1B) hängt davon ab
- **Nicht reproduzierbar** ohne Prompt-Engineering-Details

:::

---

::: {.slide .content footer-center-text="Discussion & Kritik"}

# Discussion: Statistische Validität

## Kritikpunkt 3: Pearson Correlation (Gaussian Pooling)

**Claim** (Section 3.2):

> "Pearson correlation of 0.99 between chunk index and answer location"

**Problem**:

- **Chunk Index** = diskrete Ordinalvariable (1, 2, 3, 4, 5)
- **Answer Location** = kontinuierlich (0–100% im Dokument)
- **Pearson-Annahme**: Normalverteilung, lineare Beziehung

**Frage**:

- Ist **Spearman Rank Correlation** nicht robuster?
- Non-parametrisch, keine Normalverteilungs-Annahme


:::

---

::: {.slide .content footer-center-text="Eigene Forschung"}

# Eigene Forschung: Parallelen zu FineInstructions

**Masterarbeit (2017)**: Maschinelle Analyse sprachlicher Muster in Risikoberichten - Konzeptionierung und Evaluation inguistischer Modelle zur Beschreibung wirtschaftlicher Entwicklungen

## Konzeptionelle Übereinstimmung

| Konzept | Masterarbeit (2017) | FineInstructions (2025) |
|---------|---------------------|-------------------------|
| **Template-Abstraktion** | Phraseframes mit Slots (`XXX`) | Instruction Templates (`<fi></fi>`) |
| **Slot-Filling** | Automatisch (Korpus-basiert) | Automatisch (Dokument-Matching) |
| **Matching** | Signifikanz (Log-Likelihood) | Embeddings (BGE-M3, Cosine >0.865) |
| **Clustering** | Levenshtein-Distanz (≤2) | Semantic Similarity |
| **Weak Supervision** | Implizit (statistisch) | Explizit (Silver-Standard via LLM) |

**Beispiel Phraseframe**: 
XXX consider XXX following risk factors

:::

---

::: {.slide .content footer-center-text="Eigene Forschung"}

# Quantitativer Vergleich

| Metrik | Masterarbeit (2017) | FineInstructions (2025) |
|--------|---------------------|-------------------------|
| **Templates/Frames** | 152K signifikante Frames → 24.654 Cluster | 18M Templates → 1B+ Instruction-Paare |
| **Dokumente** | 4.456 Risikoberichte (478 Unternehmen × 10 Jahre) | ~100K Pre-Training-Dokumente |
| **Erfolgsrate** | 81/478 Unternehmen (16.9%) mit signifikanter Korrelation (Return on assets) | MMLU +5.6 vs. DCLM (1T), +5.0 vs. Llama 3.1 (15T) |
| **Reproduzierbarkeit** | Vollständige Perl-Skripte, dokumentierte Algorithmen | LLM-Prompts unvollständig, Entity-Replacement undokumentiert |
| **Skalierungs-Strategie** | Levenshtein-Clustering (Edit-Distanz ≤2) | Distillation (70B → 1B/3B) + FAISS-Index |

:::

---

::: {.slide .content footer-center-text="Zusammenfassung"}

# Lessons Learned: Die drei Papers im Vergleich

| Dimension | RefinedWeb | Nemotron-CC | FineInstructions |
|-----------|------------|-------------|------------------|
| **Kernbeitrag** | Web-only = Curated | Quality + Quantity | Pre-Training = Instruction-Tuning |
| **Daten-Transformation** | Minimal (Extract + Dedup) | Moderat (Rephrasing + Buckets) | Maximal (Q&A Format) |
| **Skalierung** | 5T tokens (600B public) | 6.3T tokens (4.4T real + 1.9T synthetic) | 1B+ Instruction-Paare |
| **Reproduzierbarkeit** | Algorithmen dokumentiert | Heuristiken + LLM-Prompts | LLM Black Box |
| **Stärke** | Aggressive Deduplication | Classifier-Ensemble | Template Diversity |
| **Schwäche** | Hohe Removal Rate (77%) | Synthetic Data Hallucinations? | Undokumentierte Prompts |

:::

---

::: {.slide .content footer-center-text="Zusammenfassung"}

# Takeaways für die Praxis

## 1. Data Engineering > Model Architecture

- **RefinedWeb**: Web-only schlägt Curated (bei richtiger Verarbeitung)
- **Nemotron-CC**: Ensemble-Filtering verdoppelt HQ-Recall
- **FineInstructions**: Format-Alignment (Q&A) verbessert Downstream-Performance

## 2. Skalierung

- **Qualität**: Aggressive Filterung (FineWeb-Edu: 90% Removal)
- **Quantität**: Weniger Filter + Synthetic Augmentation (Nemotron-CC: 4× mehr Daten)
- **Alignment**: Template-Matching (FineInstructions: Pre-Training = Instruction-Tuning)

:::

---

::: {.slide .closing}

# Danke für die Aufmerksamkeit

::: {.contact}

## Details und Code zur Präsentation finden Sie unter:

[github.com/Scrottz/fraunhofer_research_paper_analysis](https://github.com/Scrottz/fraunhofer_research_paper_analysis)

**Kontakt**: Franz Keilholz, MA.

[franz@keilholz.biz](mailto:franz@keilholz.biz)

Tel. 0174 2086631

:::

:::
