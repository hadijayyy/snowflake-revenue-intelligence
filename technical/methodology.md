# Methodology

## Objective

The objective is to answer one operating question:

> What should leadership use as the planning baseline for FY27 Q3 product revenue?

The analysis is designed for a stakeholder who needs a decision, not a list of disconnected metrics.

## Data boundary

The project uses public Snowflake Investor Relations materials and the FY27 Q2 SEC filing. Reported results, management's forecast, and the independent estimate are kept separate throughout the analysis.

No internal Snowflake data is used.

## Measures

| Measure | Meaning in this project | Role |
| --- | --- | --- |
| Product revenue | Revenue recognized in the quarter, in USD millions | Current performance |
| Contracted future revenue | Revenue already under contract for future periods | Forward coverage signal |
| Net revenue retention | Revenue growth from the existing customer base | Expansion and retention health |
| $1M+ customers | Customers generating more than $1M in trailing product revenue | Scale of large-customer base |

## Signal construction

Sequential growth is calculated as:

```text
(current quarter value / previous quarter value) - 1
```

Using the reported values in the artifact:

- Product revenue: `(1,491.861 / 1,334.329) - 1 = 11.8%`
- Contracted future revenue: `(9,004 / 9,205) - 1 = -2.2%`

To make direction comparable in the leadership signal map, Q1 FY27 is indexed to 100:

- Product revenue moves to **111.8** in Q2 FY27.
- Contracted future revenue moves to **97.8** in Q2 FY27.

The index is for direction only. The two measures are not the same type of revenue and should not be added or directly compared as dollars.

## Scenario framing

Three values are shown as different evidence types:

1. **Q2 actual — $1.492B:** the latest reported result and reference point.
2. **Company forecast — $1.588–1.593B:** management's official planning range.
3. **Independent estimate — $1.64B:** a separate, directional analyst hypothesis.

The company forecast is recommended as the operating baseline because it is the official outlook. The independent estimate is retained as an upside case rather than blended into the baseline.

## Validation and limitations

The independent estimate was frozen before the Q2 result was known. The prior test miss is kept visible in the dashboard rather than hidden. The history is short, so the estimate should not be treated as a confidence interval or a causal forecast.

The next reported quarter is the validation event. A stronger production model would add a longer history, a defined training window, an error metric, uncertainty bounds, and sensitivity analysis.

## Reproducibility

The source snapshot and decision rules are available in `artifacts/`. The live page contains the interaction layer and visual explanation. Every displayed figure should be checked against the linked primary source before the project is reused for a new reporting period.
