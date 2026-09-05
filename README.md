# Snowflake Revenue Intelligence

An interactive executive brief by [Ryan Hadi](https://www.linkedin.com/in/ryanhadi/), built from public Snowflake disclosures.

**[Open the live report](https://snowflake-revenue-retention-intelli.vercel.app/)**

## The business question

Revenue is growing quickly. What should leadership fund next, and what evidence should change the plan?

The report connects public results to three proposed operating decisions. Quarterly detail, sources, calculations, and limitations are available on demand.

## The finding that changes the interpretation

Q2 FY27 product revenue reached **$1.492B**, up **37% year over year** and **11.8% sequentially**. Existing customer revenue expansion was **126%**, and customers with more than $1M in trailing product revenue increased to **828**.

Total remaining performance obligations (RPO) fell **2.2%** from Q1. That alone is an incomplete demand signal. Management's expected recognition share within the next 12 months rose from **50% to 54%**. Multiplying these rounded shares by each quarter's RPO implies approximately **$4.60B → $4.86B**, or **+5.6%**, in the respective near-term windows.

The latter is an **analyst calculation**, not a separately reported growth rate. The 12-month horizon advances each quarter; these are not fixed contract cohorts. Renewal timing, contract duration, and other factors also affect RPO.

## Recommendation

Use management's **$1.588–1.593B** Q3 FY27 product revenue range as the reference plan. Stage additional spending against customer usage and renewal evidence, protect expansion in major accounts, and examine both GAAP and adjusted margins before increasing fixed costs.

The **$1.64B** value in the scenario tool is an illustrative upside assumption. No statistically validated predictive model or forecast accuracy is claimed.

## What the portfolio demonstrates

- Business framing: a focused question, a recommendation, and evidence that would change it.
- Analytical judgment: separating recognized revenue, contracted revenue, and expected recognition timing.
- Reproducibility: source inputs, runnable SQL, assumptions, and metric definitions.
- Communication: professional plain English and ranked actions with proposed owners.
- Frontend implementation: responsive layouts, accessible controls, native SVG charts, and a scenario tool.

## Explore the evidence

| Artifact | What it provides |
| --- | --- |
| [Methodology](technical/methodology.md) | Sources, formulas, rounding, interpretation, and limits |
| [SQL analysis](technical/analysis.sql) | Growth comparisons, guidance midpoint, and near-term RPO calculation |
| [Quarterly inputs](artifacts/fy27-q2-metric-snapshot.csv) | Five reported quarters of revenue, RPO, expansion, and large customers |
| [RPO recognition inputs](artifacts/rpo-recognition.csv) | Quarter-end balances, rounded shares, and primary source |
| [Scenario inputs](artifacts/forecast-scenarios.csv) | Actual, management guidance, and illustrative upside |
| [Decision logic](technical/decision-logic.md) | Priorities, proposed owners, and review conditions |
| [Metric definitions](technical/metric-definitions.md) | What each metric measures and cannot establish |
| [Architecture](technical/architecture.md) | How the static report and analytical artifacts relate |

## Experience and design

Snowflake-inspired blue and white styling meets a compact editorial layout:

1. Product revenue trajectory and four operating indicators.
2. A two-quarter contract chart explaining the recognition horizon.
3. An interactive Q3 outcome comparison against management's guidance.
4. Three ranked operating recommendations.

Optional detail opens in place. Controls support keyboard interaction; the report includes reduced motion, mobile navigation, and print styling. Reported bars use zero baselines. The optional NRR line explicitly labels its 100–130% scale. Guidance is visually distinct from reported results.

## Implementation

| Field | Detail |
| --- | --- |
| Author | Ryan Hadi |
| Role demonstrated | Data & BI Analyst |
| Project | Self-initiated public-data portfolio case study |
| Audience | Finance, Sales, Customer Success, Operations, and leadership |
| Frontend | HTML, CSS, JavaScript, and native SVG |
| Hosting | Vercel |
| Analytical artifact | PostgreSQL / DuckDB-compatible SQL |
| Snapshot | Q2 FY27; quarter ended July 31, 2026; released September 2, 2026 |

This is a static snapshot with embedded data, not a live warehouse connection. No build step or package installation is required:

```bash
python3 -m http.server 8000
```

Open `http://localhost:8000`. Texta and Lato fonts load from Snowflake's public website, with system fallbacks. Charts render locally without charting libraries.

## Primary sources

- [Q2 FY27 earnings release — SEC exhibit 99.1](https://www.sec.gov/Archives/edgar/data/1640147/000164014726000033/fy2027q2earnings.htm)
- [Q2 FY27 investor presentation — RPO recognition shares on page 19](https://investors.snowflake.com/files/doc_financials/2027/q2/Q2-FY2027-Investor-Presentation_vF.pdf)
- [September 2, 2026 Form 8-K](https://www.sec.gov/Archives/edgar/data/1640147/000164014726000033/snow-20260902.htm)

## Scope

Independent portfolio analysis, not affiliated with or endorsed by Snowflake Inc. No internal customer data or realized business impact is claimed. Recommendations are proposed operating actions, not investment advice.
