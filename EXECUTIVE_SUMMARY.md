# Executive summary — Stack Overflow SQL Case Study

## 3 key insights
- **Technology adoption shifts over time:** tags like `dataframe`, `node.js`, and `python-3.x` show very large growth from 2010 → 2022 (clear “what people are learning/building” signal).
- **Recent years are dominated by a small set of ecosystems:** 2020–2022 question volume is led by `python`, `javascript`, `java`, `reactjs`, and `c#`.
- **Question clarity impacts responsiveness:** narrower questions (fewer tags / shorter titles) get faster first answers on average, while higher-score questions tend to wait longer (often because they are harder / more complex).

## 2 limitations
- **Country parsing is approximate** because Stack Overflow `users.location` is free-text and must be cleaned heuristically.
- **“Beginner vs expert” is a proxy** based on reputation buckets (useful signal, but not perfect ground truth).

## 2 next actions
- Add **accepted-answer time** and **answer quality** measures (accepted vs not, answer score) to validate the “faster answers” conclusions.
- Replace heuristic country extraction with a more robust approach (e.g., geo parsing library + validation) and build a small “top countries over time” dashboard.
