# Methodology

## Objective and reporting boundary

Translate Snowflake's Q2 FY27 public results into a Q3 operating recommendation. The quarter ended July 31, 2026; results were released September 2, 2026. This is a dated snapshot, not a continuous financial feed.

Primary sources: [earnings release](https://www.sec.gov/Archives/edgar/data/1640147/000164014726000033/fy2027q2earnings.htm) and [investor presentation](https://investors.snowflake.com/files/doc_financials/2027/q2/Q2-FY2027-Investor-Presentation_vF.pdf). The associated filing is a Form 8-K. No internal customer, pipeline, or account-level data is available.

## Evidence categories

| Category | Example | Treatment |
| --- | --- | --- |
| Reported result | Q2 product revenue of $1,491.861M | Historical actual |
| Management outlook | Q3 product revenue range of $1.588–1.593B | Official guidance; not guaranteed |
| Analyst calculation | Approximate next-12-month RPO increase of 5.6% | Arithmetic using rounded source inputs |
| Analyst assumption | $1.64B Q3 upside | Illustrative scenario; no probability or accuracy claimed |
| Proposed decision | Stage additional spending | Conditional on evidence unavailable in public aggregates |

## Growth calculations

```text
Sequential change = (current quarter / prior quarter − 1) × 100
Revenue: (1,491.861 / 1,334.329 − 1) × 100 = 11.8%
Total RPO: (9,004 / 9,205 − 1) × 100 = −2.2%
```

Year-over-year growth uses the same fiscal quarter one year earlier. Calculate before display rounding. Revenue inputs are USD millions; charts convert to billions. The 37% headline follows management's rounded disclosure.

## Expected recognition horizon

Page 19 of the presentation reports total RPO and the approximate percentage expected to be recognized within the following 12 months.

| Quarter | Total RPO, USD M | Rounded next-12-month share | Implied next-12-month RPO, USD M |
| --- | ---: | ---: | ---: |
| Q1 FY27 | 9,205 | 50% | 4,602.50 |
| Q2 FY27 | 9,004 | 54% | 4,862.16 |

```text
Implied amount = total RPO × management's rounded recognition share
Change = (4,862.16 / 4,602.50 − 1) × 100 = 5.6417…% ≈ 5.6%
```

This is derived from rounded shares, not a separately disclosed exact current-RPO growth rate. Each observation has its own forward 12-month horizon; this is not a fixed-cohort conversion analysis. No uncertainty interval is inferred from rounded inputs.

Both quarter-end balances use the same zero-based scale. The later-period segment is total RPO minus the implied near-term amount and is also calculated.

Total RPO may change with renewal timing, contract duration, size, foreign exchange, seasonality, and other disclosed factors. Its decline does not alone establish weakening demand. The analysis cannot identify each factor's causal contribution.

## Scenario tool

```text
Company midpoint = (1.588 + 1.593) / 2 = 1.5905B
Midpoint lift from Q2 = (1.5905 / 1.491861 − 1) × 100 ≈ 6.6%
```

The slider compares hypothetical Q3 product revenue with the guidance interval, including both bounds. The Q2 preset asks what happens if Q3 repeats Q2; Q2 is not a miss against later-quarter guidance.

The $1.64B upside is an illustrative assumption. There is no documented trained model, time-stamped pre-result freeze, or validation dataset supporting it. Earlier language suggesting verified forecast accuracy has been removed. One later reported quarter would not alone validate a predictive model.

## Interpretation limits

- NRR measures trailing customer-cohort revenue; it is not a customer survival percentage or direct churn measure.
- $1M+ customers use trailing revenue and do not reveal concentration, profitability, or individual renewal risk.
- Adjusted operating margin is 15.3%; GAAP operating margin is −17.0%. Keep the accounting bases separate.
- A positive near-term contract signal does not establish profit quality or justify fixed spending without internal evidence.
- Proposed owners and review conditions are analyst recommendations, not management commitments.

## Reproduction

`analysis.sql` contains three independent statements: quarterly growth, guidance arithmetic, and the recognition-horizon comparison. Inline values run without credentials. CSV artifacts preserve inputs and evidence types.

The frontend embeds the same snapshot instead of querying SQL at runtime; updates must reconcile both representations. For a new period, verify all inputs and dates, update guidance, rerun calculations, and reassess the narrative.
