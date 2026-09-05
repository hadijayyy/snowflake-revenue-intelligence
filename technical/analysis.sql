-- Snowflake Revenue Intelligence | Reproducible analytical proof
-- Dialect: PostgreSQL 14+ / DuckDB-compatible SQL
--
-- The inline VALUES block keeps this artifact runnable without credentials.
-- In production, replace raw_metrics with a governed warehouse table and
-- retain the same calculation layer plus scheduled data-quality checks.

-- Query 1: trend, sequential growth, year-over-year growth, and Q1 index
WITH raw_metrics (
    period,
    fiscal_year,
    fiscal_quarter,
    product_revenue_usd_m,
    contracted_future_revenue_usd_m,
    nrr_pct,
    customers_over_1m
) AS (
    SELECT *
    FROM (VALUES
        ('Q2 FY26', 2026, 2, 1090.496, 6932.0, 125.0, 654),
        ('Q3 FY26', 2026, 3, 1158.377, 7881.0, 125.0, 688),
        ('Q4 FY26', 2026, 4, 1226.631, 9772.0, 125.0, 733),
        ('Q1 FY27', 2027, 1, 1334.329, 9205.0, 126.0, 780),
        ('Q2 FY27', 2027, 2, 1491.861, 9004.0, 126.0, 828)
    ) AS values_table (
        period,
        fiscal_year,
        fiscal_quarter,
        product_revenue_usd_m,
        contracted_future_revenue_usd_m,
        nrr_pct,
        customers_over_1m
    )
),
ordered_metrics AS (
    SELECT
        raw_metrics.*,
        LAG(product_revenue_usd_m) OVER (
            ORDER BY fiscal_year, fiscal_quarter
        ) AS previous_product_revenue_usd_m,
        LAG(contracted_future_revenue_usd_m) OVER (
            ORDER BY fiscal_year, fiscal_quarter
        ) AS previous_contracted_future_revenue_usd_m,
        LAG(product_revenue_usd_m, 4) OVER (
            ORDER BY fiscal_year, fiscal_quarter
        ) AS prior_year_product_revenue_usd_m
    FROM raw_metrics
),
q1_baseline AS (
    SELECT
        product_revenue_usd_m AS q1_product_revenue_usd_m,
        contracted_future_revenue_usd_m AS q1_contracted_future_revenue_usd_m
    FROM raw_metrics
    WHERE period = 'Q1 FY27'
),
growth_signals AS (
    SELECT
        ordered_metrics.period,
        ordered_metrics.product_revenue_usd_m,
        ordered_metrics.contracted_future_revenue_usd_m,
        ordered_metrics.nrr_pct,
        ordered_metrics.customers_over_1m,
        ROUND(
            ((ordered_metrics.product_revenue_usd_m
                / NULLIF(ordered_metrics.previous_product_revenue_usd_m, 0)) - 1) * 100,
            1
        ) AS product_revenue_qoq_pct,
        ROUND(
            ((ordered_metrics.contracted_future_revenue_usd_m
                / NULLIF(ordered_metrics.previous_contracted_future_revenue_usd_m, 0)) - 1) * 100,
            1
        ) AS contracted_future_revenue_qoq_pct,
        ROUND(
            ((ordered_metrics.product_revenue_usd_m
                / NULLIF(ordered_metrics.prior_year_product_revenue_usd_m, 0)) - 1) * 100,
            1
        ) AS product_revenue_yoy_pct,
        ROUND(
            (ordered_metrics.product_revenue_usd_m
                / NULLIF(q1_baseline.q1_product_revenue_usd_m, 0)) * 100,
            1
        ) AS product_revenue_index_q1,
        ROUND(
            (ordered_metrics.contracted_future_revenue_usd_m
                / NULLIF(q1_baseline.q1_contracted_future_revenue_usd_m, 0)) * 100,
            1
        ) AS contracted_future_revenue_index_q1
    FROM ordered_metrics
    CROSS JOIN q1_baseline
)
SELECT
    period,
    product_revenue_usd_m,
    product_revenue_qoq_pct,
    product_revenue_yoy_pct,
    product_revenue_index_q1,
    contracted_future_revenue_usd_m,
    contracted_future_revenue_qoq_pct,
    contracted_future_revenue_index_q1,
    nrr_pct,
    customers_over_1m
FROM growth_signals
ORDER BY period;

-- Query 2: scenario framing and the planning gap versus the latest actual
WITH scenario_inputs (
    scenario,
    period,
    low_usd_b,
    high_usd_b,
    evidence_type,
    planning_role
) AS (
    SELECT *
    FROM (VALUES
        ('Q2 actual', 'FY27 Q2', 1.491861, 1.491861, 'reported result', 'reference point'),
        ('Company forecast', 'FY27 Q3', 1.588, 1.593, 'management outlook', 'recommended baseline'),
        ('Illustrative upside', 'FY27 Q3', 1.640, 1.640, 'analyst assumption', 'upside only')
    ) AS values_table (
        scenario,
        period,
        low_usd_b,
        high_usd_b,
        evidence_type,
        planning_role
    )
),
latest_actual AS (
    SELECT low_usd_b AS actual_usd_b
    FROM scenario_inputs
    WHERE scenario = 'Q2 actual'
),
company_forecast AS (
    SELECT
        low_usd_b AS forecast_low_usd_b,
        high_usd_b AS forecast_high_usd_b,
        (low_usd_b + high_usd_b) / 2 AS forecast_midpoint_usd_b
    FROM scenario_inputs
    WHERE scenario = 'Company forecast'
)
SELECT
    latest_actual.actual_usd_b,
    company_forecast.forecast_low_usd_b,
    company_forecast.forecast_high_usd_b,
    ROUND(company_forecast.forecast_midpoint_usd_b, 4) AS forecast_midpoint_usd_b,
    ROUND(
        ((company_forecast.forecast_midpoint_usd_b / latest_actual.actual_usd_b) - 1) * 100,
        1
    ) AS midpoint_lift_vs_actual_pct
FROM latest_actual
CROSS JOIN company_forecast;

-- Query 3: expected recognition horizon (approximate, not fixed-cohort growth)
-- Source: Q2 FY27 investor presentation, page 19; see rpo-recognition.csv.
-- Shares are management's rounded percentages. Each quarter has its own
-- forward 12-month window. This is not a causal demand test.
WITH recognition_inputs (period_order, period, total_rpo_usd_m, next_12m_share_pct) AS (
    VALUES (1, 'Q1 FY27', 9205.0, 50.0), (2, 'Q2 FY27', 9004.0, 54.0)
),
recognition_amounts AS (
    SELECT *, total_rpo_usd_m * next_12m_share_pct / 100.0 AS implied_next_12m_usd_m
    FROM recognition_inputs
),
recognition_comparison AS (
    SELECT *,
        LAG(total_rpo_usd_m) OVER (ORDER BY period_order) AS prior_total_rpo_usd_m,
        LAG(implied_next_12m_usd_m) OVER (ORDER BY period_order) AS prior_next_12m_usd_m
    FROM recognition_amounts
)
SELECT
    period, total_rpo_usd_m, next_12m_share_pct,
    ROUND(implied_next_12m_usd_m, 2) AS implied_next_12m_usd_m,
    ROUND(total_rpo_usd_m - implied_next_12m_usd_m, 2) AS implied_later_usd_m,
    ROUND((total_rpo_usd_m / NULLIF(prior_total_rpo_usd_m, 0) - 1) * 100, 1)
        AS total_rpo_qoq_pct,
    ROUND((implied_next_12m_usd_m / NULLIF(prior_next_12m_usd_m, 0) - 1) * 100, 1)
        AS implied_next_12m_change_pct
FROM recognition_comparison
ORDER BY period_order;
