---
title: Overview Tables - Research Data & Technology Reference
---

<colgroup>
<col style="width: 18%">
<col style="width: 15%">
<col style="width: 67%">
</colgroup>

# Datensätze

| Name/Abkürzung | Paper | Erläuterung |
| --- | --- | --- |
| CommonCrawl | All | Öffentlicher Web-Crawl mit Petabytes an Daten; primäre Quelle für alle drei Pipelines |
| RefinedWeb | RefinedWeb, Nemotron | 5T Token englisches Dataset aus CommonCrawl (RefinedWeb); 600GT öffentlich verfügbar |
| RW-Raw | RefinedWeb | Minimale Filterung: nur Extraktion + Sprach-ID |
| RW-Filtered | RefinedWeb | Nach Dokumenten- und Zeilen-Filterung |
| The Pile | All | 340GT kuratiertes Dataset mit 18% Web-Daten, 82% hochwertige Quellen (Bücher, Papers, etc.) |
| C4 (Colossal Clean Crawled Corpus) | RefinedWeb, Nemotron | ~360GT aus CommonCrawl mit NSFW-Filterung und 3-Satz-Deduplizierung |
| OSCAR-21.09 | RefinedWeb | ~370GT Web-Daten mit Zeilen-basierter Deduplizierung |
| OSCAR-22.01 | RefinedWeb | ~283GT, neuere Version ohne Standard-Deduplizierung |
| DCLM (DataComp-LM) | Nemotron, FineInstructions | 3.8T Token (1T unique), aggressive modellbasierte Filterung auf Instruktionsdaten |
| FineWeb-Edu | Nemotron, FineInstructions | 1.3T Token (0.2T unique), fokussiert auf educational content |
| FineWeb-Edu-2 | Nemotron | 5.4T Token (1.1T unique), erweiterte Version |
| Nemotron-CC | Nemotron | 6.3T Token (4.4T real + 1.9T synthetic) aus CommonCrawl |
| Nemotron-CC-HQ | Nemotron | 1.1T Token High-Quality Subset für faire Vergleiche |
| FineInstructions | FineInstructions | 1B+ Instruction-Answer Paare aus ~18M Templates |
| WildChat | FineInstructions | 657K User-Queries für Template-Erstellung |
| LMSys Chat | FineInstructions | 559K User-Queries |
| Reddit QA | FineInstructions | 7.47M User-Fragen |
| GooAQ | FineInstructions | 3.01M Fragen aus Google-Suchen |
| BookCorpus | RefinedWeb | Frühe LLM-Trainingsdaten, dokumentfokussiert |
| Wikipedia | All | Hochwertige kuratierte Daten; explizit aus RefinedWeb/Nemotron-CC entfernt |
| IPT Corpus | FineInstructions | ~23B Token aus RefinedWeb für Instruction Pre-Training |

# Technologie & Modelle

| Name/Abkürzung | Paper | Erläuterung |
| --- | --- | --- |
| MDR (MacroData Refinement) | RefinedWeb | Pipeline für Filterung und Deduplizierung bei sehr großem Maßstab |
| Trafilatura | RefinedWeb, Nemotron | HTML-zu-Text Extraktor; entfernt Menüs, Ads, Footer |
| Justext | Nemotron | Alternativer HTML-Extraktor; höherer Token-Yield (+28.6% HQ tokens) |
| warcio | RefinedWeb, Nemotron | Bibliothek zum Lesen von WARC-Dateien (Web ARChive) |
| pycld2 | RefinedWeb, Nemotron | Sprach-Identifikations-Tool |
| FastText lid176 | RefinedWeb, Nemotron | Sprach-Klassifikator für 176 Sprachen (n-gram basiert) |
| MinHash | All | Locality-Sensitive Hashing für Fuzzy-Deduplizierung; approximiert Jaccard-Similarity |
| Exact Substring Deduplication | All | Suffix-Array-basiert; findet exakte Token-Matches ≥50 Tokens |
| KenLM | Nemotron | Perplexity-Filter basierend auf Wikipedia/Books-Modell |
| CCNet | RefinedWeb, Nemotron | CommonCrawl-Verarbeitungs-Pipeline mit FastText-Klassifikator |
| FineWeb-Edu Classifier | Nemotron, FineInstructions | Modellbasierter Qualitätsfilter für educational content (Scores 0-5) |
| DCLM Classifier | Nemotron | FastText-basiert; trainiert auf Instruktionsdaten + ELI5 Reddit |
| Mistral 8x22B-Instruct | Nemotron | LLM für Qualitäts-Annotation und Synthetic Data Generation |
| Nemotron-340B-Instruct | Nemotron | Großes LLM für Qualitäts-Scoring |
| Mistral NeMo 12B | Nemotron | Für Synthetic Data Generation (FP8 inference) |
| Llama-3.3 70B Instruct | FineInstructions | LLM für Silver-Standard Data Generation |
| Llama-3.2 1B/3B Instruct | FineInstructions | Distilled Models für Query Genericizer und Instantiator |
| BGE-M3 | FineInstructions | Embedding-Modell für Template-Document Matching |
| Flow Judge | FineInstructions | 3.8B Parameter Judge-Modell (5-Punkt Likert-Skala) |
| Snowflake-arctic-embed-m | Nemotron | Embedding-Modell für Quality Classifier Training |
| GPT-3 | RefinedWeb, Nemotron | Baseline-Modell für Vergleiche (175B Parameter) |
| GPT-4 / GPT-5 mini | FineInstructions | Judge-Modelle für Benchmark-Evaluation |
| PaLM | RefinedWeb | Google's Pathways Language Model (8B-540B) |
| Falcon-40B | RefinedWeb | Trainiert auf RefinedWeb; state-of-the-art bei Release |
| Llama 3.1 | Nemotron | Meta's Modell (8B-405B); trainiert auf 15T Tokens |
| OPT | RefinedWeb, Nemotron | Open Pre-trained Transformer von Meta |
| Pythia | RefinedWeb, Nemotron | Suite von Modellen (70M-12B) für Deduplizierungs-Studien |
| Cerebras-GPT | RefinedWeb | Modelle mit μ-parametrization |
| ALiBi (Attention with Linear Biases) | RefinedWeb, Nemotron | Positional Encoding-Technik |
| FlashAttention | RefinedWeb, Nemotron | Effiziente Attention-Implementierung |
| SwiGLU | FineInstructions | Aktivierungsfunktion (Swish + GLU) |
| GQA (Grouped Query Attention) | FineInstructions | Effiziente Attention mit Query-Gruppen |

# Filter Strategien & Techniken

| Name/Abkürzung | Paper | Erläuterung |
| --- | --- | --- |
| URL Filtering | RefinedWeb, Nemotron | Blocklist (4.6M Domains) + URL-Scoring für NSFW/Spam |
| NSFW Filtering | All | Entfernung von pornografischen/gewaltätigen Inhalten |
| Language Identification | All | FastText-basiert; Threshold 0.3-0.65 für Spracherkennung |
| Repetition Removal | RefinedWeb, Nemotron | Entfernt Dokumente mit exzessiven Zeilen/Paragraph-Wiederholungen |
| Document-wise Filtering | RefinedWeb, Nemotron | Heuristische Filter für Länge, Symbol-zu-Wort-Ratio, etc. |
| Line-wise Corrections | RefinedWeb, Nemotron | Entfernt Navigation-Buttons, Social-Media-Counter, etc. |
| Fuzzy Deduplication | All | MinHash mit 9,000 Hashes/Dokument, 20 Buckets (RefinedWeb) |
| Exact Deduplication | All | Suffix-Array-basiert; ≥50 Token Matches |
| URL Deduplication | RefinedWeb, Nemotron | Entfernt URLs, die über Dumps hinweg revisited wurden |
| Global Deduplication | Nemotron, FineInstructions | Über alle Snapshots hinweg, nicht nur innerhalb |
| Perplexity Filtering | Nemotron | KenLM-basiert; entfernt low-quality Text |
| Quality Bucketing | Nemotron | 20 Buckets (0-19) basierend auf Classifier-Ensemble |
| Quality Labeling | Nemotron | 5 Kategorien: High, Medium-High, Medium, Medium-Low, Low |
| Annealing | Nemotron | 50B Token Continued Pre-Training zur Bucket-Qualitäts-Messung |
| Decontamination | FineInstructions | Entfernung von Benchmark-Overlap (Tulu 3 Prozedur) |
| Gaussian Pooling | FineInstructions | Custom Pooling für K Dokument-Chunks (K=5) |
| Ensemble Filtering | Nemotron | Maximum-Operation über 3 Classifier-Scores |

# Synthetic Data Generation

| Name/Abkürzung | Paper | Erläuterung |
| --- | --- | --- |
| SDG (Synthetic Data Generation) | Nemotron, FineInstructions | Generierung synthetischer Trainingsdaten |
| Wikipedia-Style Rephrasing | Nemotron, FineInstructions | Umschreibung in Wikipedia-Stil für low-quality Daten |
| Diverse QA Pairs | Nemotron, FineInstructions | Verschiedene Fragetypen (Yes/No, Open-ended, Multi-choice) |
| Distill | Nemotron | Kondensierung in prägnante Passagen |
| Extract Knowledge | Nemotron | Extraktion von Fakten unter Ignorierung uninformativer Inhalte |
| Knowledge List | Nemotron | Organisierte Listen von Key-Information |
| WRAP (Web Rephrase Augmented Pre-training) | Nemotron, FineInstructions | Baseline-Technik für Rephrasing |
| IPT (Instruction Pre-Training) | FineInstructions | Konvertierung von Dokumenten in Instruction-Answer Paare |
| Template Instantiation | FineInstructions | Füllen von <fi></fi> Tags mit Dokument-Inhalten |
| Query Genericizer | FineInstructions | Llama-3.2 1B Model; konvertiert Queries zu Templates |
| Instantiator Model | FineInstructions | Llama-3.2 3B Model; füllt Templates + generiert Antworten |
| Excerpt Tags | FineInstructions | <excerpt>...<...>...</excerpt> für effiziente lange Textgenerierung |
| Silver-Standard Data | FineInstructions | LLM-generierte Trainingsdaten für Distillation |

# Evaluation & Benchmarks

| Name/Abkürzung | Paper | Erläuterung |
| --- | --- | --- |
| MMLU (Massive Multitask Language Understanding) | All | 57 akademische Tasks; Wissens-Benchmark |
| HellaSwag | All | Sentence Completion; Common Sense Reasoning |
| ARC-Easy / ARC-Challenge | All | AI2 Reasoning Challenge; Multiple Choice Science QA |
| Winogrande | All | Coreference Resolution; Common Sense |
| PIQA | All | Physical Interaction QA; Physical Common Sense |
| LAMBADA | RefinedWeb | Sentence Completion; Long-range Dependencies |
| BoolQ | RefinedWeb, Nemotron | Yes/No Questions; Reading Comprehension |
| COPA | RefinedWeb | Choice of Plausible Alternatives; Causal Reasoning |
| OpenBookQA | RefinedWeb, Nemotron | Multiple Choice mit externem Wissen |
| CommonsenseQA | All | Common Sense Knowledge QA |
| Social IQA | Nemotron | Social Interaction Reasoning |
| RACE | Nemotron | Reading Comprehension from Examinations |
| MixEval | FineInstructions | Subset akademischer Benchmarks; korreliert mit Human Judgment |
| MT-Bench-101 | FineInstructions | Multi-Turn Benchmark; realistische User-Queries (Likert 0-10) |
| AlpacaEval | FineInstructions | Head-to-head LLM Comparison; Length-Bias korrigiert |
| EAI Harness (Eleuther AI) | All | Standard Evaluation Framework |
| Perspective API | RefinedWeb, Nemotron | Toxicity-Messung ("rude or disrespectful") |
| ToxicBERT | FineInstructions | Toxicity Detection für Daten-Curation |

# Training Frameworks & Tools

| Name/Abkürzung | Paper | Erläuterung |
| --- | --- | --- |
| Megatron-LM | RefinedWeb, Nemotron | NVIDIA Framework für LLM-Training |
| NeMo Curator | Nemotron | Open-Source Library für Data Curation (Apache 2.0) |
| DataDreamer | FineInstructions | Framework für Synthetic Data Generation |
| Lingua | FineInstructions | PyTorch Library für kontrollierte Pre-Training Ablations |
| TensorRT-LLM | Nemotron | NVIDIA Inference-Optimierung |
| NeMo-Skills | Nemotron | Large-Scale Data Synthesis |
| FAISS | FineInstructions | Facebook AI Similarity Search; Retrieval Index |
| deduplicate-text-datasets | Nemotron | Google Library für Exact Substring Deduplication |

# Metriken und Konzepte

| Name/Abkürzung | Paper | Erläuterung |
| --- | --- | --- |
| Token Yield | All | Anzahl extrahierter Tokens nach Verarbeitung |
| HQ Tokens | All | High-Quality Tokens nach Classifier-Bewertung |
| Unique Tokens | All | Nach Global Fuzzy Deduplication; echte Diversität |
| Fuzzy Duplicates | All | ~80% in FineWeb-Edu/DCLM; ~50% in RefinedWeb |
| Removal Rate | All | % entfernter Daten durch Filter/Deduplication |
| Jaccard Similarity | All | Maß für Set-Overlap; approximiert durch MinHash |
| Bits-per-Byte (BPB) | RefinedWeb, FineInstructions | Perplexity-Metrik für Language Modeling |
| Zero-Shot Performance | All | Modell-Performance ohne Task-spezifisches Fine-Tuning |
| Scaling Laws | All | Hoffmann et al. 2022: N (params) und D (data) gemeinsam skalieren |
| Chinchilla Optimal | RefinedWeb, Nemotron | ~20 Tokens pro Parameter für optimales Training |
| Compute Budget (PF-days) | All | Petaflop-Tage; C = 6ND (Kaplan et al. 2020) |
| Epochs | All | Durchläufe durch Dataset; >4 Epochs = diminishing returns |
| Contamination | FineInstructions | Benchmark-Overlap in Trainingsdaten |
| Length-Bias | FineInstructions | LLM-Judge bevorzugen längere Antworten |
| Win Rate | FineInstructions | % in Head-to-Head Vergleichen (AlpacaEval) |
| Likert Scale | FineInstructions | 5- oder 10-Punkt Bewertungsskala |

# Architecture Components

| Name/Abkürzung | Paper | Erläuterung |
| --- | --- | --- |
| Transformer | All | Basis-Architektur für alle Modelle |
| Decoder-Only | All | Autoregressive Architektur (wie GPT) |
| Causal Language Modeling | All | Next-Token Prediction Objective |
| Instruction-Tuning | All | Fine-Tuning auf Instruction-Answer Paaren |
| Chat Template | FineInstructions | "Instruction: {{instruction}}\n\nAnswer: {{answer}}" |
| Context Length | All | Max Sequence Length (512-2000 Tokens je nach Task) |
| FP8 Inference | Nemotron | 8-Bit Floating Point für effiziente Inference |
| μ-parametrization | RefinedWeb | Spezielle Initialisierung für bessere Skalierung |
| Rotary Embeddings | RefinedWeb | Alternative zu ALiBi für Positional Encoding |
| Parallel Attention | RefinedWeb | Attention + FFN parallel statt sequentiell |
