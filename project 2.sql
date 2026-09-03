CREATE TABLE global_ecommerce_raw (
    transaction_id BIGINT,
    customer_id BIGINT,
    date DATE,
    marketing_channel VARCHAR(100),
    campaign_name VARCHAR(150),
    customer_segment VARCHAR(100),
    city VARCHAR(100),
    product_category VARCHAR(100),
    sessions INTEGER,
    pages_viewed INTEGER,
    cart_abandonment_rate NUMERIC(10,2),
    marketing_spend NUMERIC(12,2),
    conversion_rate NUMERIC(10,2),
    orders INTEGER,
    average_order_value NUMERIC(12,2),
    revenue NUMERIC(14,2),
    discount_pct NUMERIC(10,2),
    payment_method VARCHAR(100),
    returns INTEGER,
    email_open_rate NUMERIC(10,2),
    loyalty_score NUMERIC(10,2),
    churn_flag INTEGER
);


SELECT COUNT(*)
FROM global_ecommerce_raw;

select  * from global_ecommerce_raw;

SELECT *
FROM global_ecommerce_raw
LIMIT 10;



SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'global_ecommerce_raw'
ORDER BY ordinal_position;


--handling__nulls
SELECT
    COUNT(*) FILTER (WHERE transaction_id IS NULL) AS transaction_id_nulls,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls,
    COUNT(*) FILTER (WHERE date IS NULL) AS date_nulls,
    COUNT(*) FILTER (WHERE marketing_channel IS NULL) AS marketing_channel_nulls,
    COUNT(*) FILTER (WHERE campaign_name IS NULL) AS campaign_name_nulls,
    COUNT(*) FILTER (WHERE customer_segment IS NULL) AS customer_segment_nulls,
    COUNT(*) FILTER (WHERE city IS NULL) AS city_nulls,
    COUNT(*) FILTER (WHERE product_category IS NULL) AS product_category_nulls,
    COUNT(*) FILTER (WHERE sessions IS NULL) AS sessions_nulls,
    COUNT(*) FILTER (WHERE pages_viewed IS NULL) AS pages_viewed_nulls,
    COUNT(*) FILTER (WHERE cart_abandonment_rate IS NULL) AS cart_abandonment_rate_nulls,
    COUNT(*) FILTER (WHERE marketing_spend IS NULL) AS marketing_spend_nulls,
    COUNT(*) FILTER (WHERE conversion_rate IS NULL) AS conversion_rate_nulls,
    COUNT(*) FILTER (WHERE orders IS NULL) AS orders_nulls,
    COUNT(*) FILTER (WHERE average_order_value IS NULL) AS average_order_value_nulls,
    COUNT(*) FILTER (WHERE revenue IS NULL) AS revenue_nulls,
    COUNT(*) FILTER (WHERE discount_pct IS NULL) AS discount_pct_nulls,
    COUNT(*) FILTER (WHERE payment_method IS NULL) AS payment_method_nulls,
    COUNT(*) FILTER (WHERE returns IS NULL) AS returns_nulls,
    COUNT(*) FILTER (WHERE email_open_rate IS NULL) AS email_open_rate_nulls,
    COUNT(*) FILTER (WHERE loyalty_score IS NULL) AS loyalty_score_nulls,
    COUNT(*) FILTER (WHERE churn_flag IS NULL) AS churn_flag_nulls
FROM global_ecommerce_raw;

SELECT *
FROM global_ecommerce_raw
WHERE marketing_channel IS NULL
   OR city IS NULL
   OR email_open_rate IS NULL
LIMIT 20;

SELECT marketing_channel, COUNT(*) AS count
FROM global_ecommerce_raw
GROUP BY marketing_channel
ORDER BY count DESC;


SELECT city , COUNT(*) AS count
FROM global_ecommerce_raw
GROUP BY city
ORDER BY count DESC;

SELECT
    MIN(email_open_rate) AS min_email_open_rate,
    MAX(email_open_rate) AS max_email_open_rate,
    ROUND(AVG(email_open_rate), 2) AS avg_email_open_rate
FROM global_ecommerce_raw;


SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY email_open_rate) AS median_email_open_rate
FROM global_ecommerce_raw
WHERE email_open_rate IS NOT NULL;


UPDATE global_ecommerce_raw
SET marketing_channel = 'Unknown'
WHERE marketing_channel IS NULL;




UPDATE global_ecommerce_raw
SET city = 'Unknown'
WHERE city IS NULL;

UPDATE global_ecommerce_raw
SET email_open_rate = 50.2
WHERE email_open_rate IS NULL;

__check_-nulls___no nullss
SELECT
    COUNT(*) FILTER (WHERE marketing_channel IS NULL) AS marketing_channel_nulls,
    COUNT(*) FILTER (WHERE city IS NULL) AS city_nulls,
    COUNT(*) FILTER (WHERE email_open_rate IS NULL) AS email_open_rate_nulls
FROM global_ecommerce_raw;


SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT transaction_id) AS unique_transaction_ids
FROM global_ecommerce_raw;

SELECT 
    transaction_id,
    COUNT(*) AS duplicate_count
FROM global_ecommerce_raw
GROUP BY transaction_id
HAVING COUNT(*) > 1;

SELECT *
FROM global_ecommerce_raw
WHERE transaction_id IN (
    SELECT transaction_id
    FROM global_ecommerce_raw
    GROUP BY transaction_id
    HAVING COUNT(*) > 1
)
ORDER BY transaction_id
LIMIT 20;

SELECT 
    COUNT(*) AS duplicate_rows
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY 
                   transaction_id,
                   customer_id,
                   date,
                   marketing_channel,
                   campaign_name,
                   customer_segment,
                   city,
                   product_category,
                   sessions,
                   pages_viewed,
                   cart_abandonment_rate,
                   marketing_spend,
                   conversion_rate,
                   orders,
                   average_order_value,
                   revenue,
                   discount_pct,
                   payment_method,
                   returns,
                   email_open_rate,
                   loyalty_score,
                   churn_flag
               ORDER BY transaction_id
           ) AS row_num
    FROM global_ecommerce_raw
) t
WHERE row_num > 1;




DELETE FROM global_ecommerce_raw
WHERE ctid IN (
    SELECT ctid
    FROM (
        SELECT 
            ctid,
            ROW_NUMBER() OVER (
                PARTITION BY 
                    transaction_id,
                    customer_id,
                    date,
                    marketing_channel,
                    campaign_name,
                    customer_segment,
                    city,
                    product_category,
                    sessions,
                    pages_viewed,
                    cart_abandonment_rate,
                    marketing_spend,
                    conversion_rate,
                    orders,
                    average_order_value,
                    revenue,
                    discount_pct,
                    payment_method,
                    returns,
                    email_open_rate,
                    loyalty_score,
                    churn_flag
                ORDER BY ctid
            ) AS row_num
        FROM global_ecommerce_raw
    ) AS duplicates
    WHERE row_num > 1
);

select count (*) from global_ecommerce_raw;







SELECT
    MIN(sessions) AS min_sessions,
    MAX(sessions) AS max_sessions,

    MIN(pages_viewed) AS min_pages_viewed,
    MAX(pages_viewed) AS max_pages_viewed,

    MIN(cart_abandonment_rate) AS min_cart_abandonment,
    MAX(cart_abandonment_rate) AS max_cart_abandonment,

    MIN(marketing_spend) AS min_marketing_spend,
    MAX(marketing_spend) AS max_marketing_spend,

    MIN(conversion_rate) AS min_conversion_rate,
    MAX(conversion_rate) AS max_conversion_rate,

    MIN(orders) AS min_orders,
    MAX(orders) AS max_orders,

    MIN(average_order_value) AS min_aov,
    MAX(average_order_value) AS max_aov,

    MIN(revenue) AS min_revenue,
    MAX(revenue) AS max_revenue,

    MIN(discount_pct) AS min_discount,
    MAX(discount_pct) AS max_discount,

    MIN(returns) AS min_returns,
    MAX(returns) AS max_returns,

    MIN(email_open_rate) AS min_email_open_rate,
    MAX(email_open_rate) AS max_email_open_rate,

    MIN(loyalty_score) AS min_loyalty_score,
    MAX(loyalty_score) AS max_loyalty_score,

    MIN(churn_flag) AS min_churn_flag,
    MAX(churn_flag) AS max_churn_flag
FROM global_ecommerce_raw;



SELECT *
FROM global_ecommerce_raw
WHERE ROUND(revenue, 2) <> ROUND(orders * average_order_value, 2);


SELECT COUNT(*) AS incorrect_revenue_records
FROM global_ecommerce_raw
WHERE ROUND(revenue, 2) <> ROUND(orders * average_order_value, 2);


SELECT COUNT(*) AS invalid_return_records
FROM global_ecommerce_raw
WHERE returns > orders;

SELECT transaction_id, orders, returns
FROM global_ecommerce_raw
WHERE returns > orders;



SELECT 
    transaction_id,
    orders,
    returns,
    product_category,
    revenue
FROM global_ecommerce_raw
WHERE returns > orders
LIMIT 20;


SELECT
    orders,
    returns,
    COUNT(*) AS record_count
FROM global_ecommerce_raw
GROUP BY orders, returns
ORDER BY orders, returns;


SELECT
    COUNT(*) FILTER (
        WHERE cart_abandonment_rate < 0
           OR cart_abandonment_rate > 1
    ) AS invalid_cart_abandonment,

    COUNT(*) FILTER (
        WHERE conversion_rate < 0
           OR conversion_rate > 1
    ) AS invalid_conversion_rate,

    COUNT(*) FILTER (
        WHERE discount_pct < 0
           OR discount_pct > 100
    ) AS invalid_discount_pct,

    COUNT(*) FILTER (
        WHERE email_open_rate < 0
           OR email_open_rate > 100
    ) AS invalid_email_open_rate
FROM global_ecommerce_raw;










--check--spelling__error--

SELECT DISTINCT marketing_channel
FROM global_ecommerce_raw
ORDER BY marketing_channel;

SELECT DISTINCT campaign_name
FROM global_ecommerce_raw
ORDER BY campaign_name;

SELECT DISTINCT customer_segment
FROM global_ecommerce_raw
ORDER BY customer_segment;

SELECT DISTINCT city
FROM global_ecommerce_raw
ORDER BY city;

SELECT DISTINCT product_category
FROM global_ecommerce_raw
ORDER BY product_category;

SELECT DISTINCT payment_method
FROM global_ecommerce_raw
ORDER BY payment_method;


SELECT 'customer_segment' AS column_name, customer_segment::TEXT AS value, COUNT(*) AS count
FROM global_ecommerce_raw
GROUP BY customer_segment

UNION ALL

SELECT 'city', city::TEXT, COUNT(*)
FROM global_ecommerce_raw
GROUP BY city

UNION ALL

SELECT 'product_category', product_category::TEXT, COUNT(*)
FROM global_ecommerce_raw
GROUP BY product_category

UNION ALL

SELECT 'payment_method', payment_method::TEXT, COUNT(*)
FROM global_ecommerce_raw
GROUP BY payment_method

UNION ALL

SELECT 'churn_flag', churn_flag::TEXT, COUNT(*)
FROM global_ecommerce_raw
GROUP BY churn_flag

ORDER BY column_name, value;

--till_5pm daate 28 augg--

SELECT
    COUNT(DISTINCT transaction_id) AS total_transactions,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(orders) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(marketing_spend), 2) AS total_marketing_spend,
    ROUND(AVG(average_order_value), 2) AS avg_order_value,
    ROUND(AVG(conversion_rate) * 100, 2) AS avg_conversion_rate_pct,
    ROUND(AVG(cart_abandonment_rate) * 100, 2) AS avg_cart_abandonment_pct
FROM global_ecommerce_raw;












SELECT
    marketing_channel,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(orders) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(marketing_spend), 2) AS total_marketing_spend,
    ROUND(AVG(conversion_rate) * 100, 2) AS avg_conversion_rate_pct,
    ROUND(
        SUM(revenue) / NULLIF(SUM(marketing_spend), 0),
        2
    ) AS revenue_to_spend_ratio
FROM global_ecommerce_raw
GROUP BY marketing_channel
ORDER BY total_revenue DESC;












SELECT
    campaign_name,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(orders) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(marketing_spend), 2) AS total_marketing_spend,
    ROUND(AVG(conversion_rate) * 100, 2) AS avg_conversion_rate_pct,
    ROUND(
        SUM(revenue) / NULLIF(SUM(marketing_spend), 0),
        2
    ) AS revenue_to_spend_ratio
FROM global_ecommerce_raw
GROUP BY campaign_name
ORDER BY total_revenue DESC;


SELECT
    DATE_TRUNC('month', date)::DATE AS month,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(orders) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(marketing_spend), 2) AS total_marketing_spend
FROM global_ecommerce_raw
GROUP BY DATE_TRUNC('month', date)
ORDER BY month;




SELECT
    EXTRACT(YEAR FROM date) AS year,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(orders) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(marketing_spend), 2) AS total_marketing_spend,
    ROUND(
        SUM(revenue) / NULLIF(SUM(marketing_spend), 0),
        2
    ) AS revenue_to_spend_ratio
FROM global_ecommerce_raw
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY year;




SELECT
    product_category,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(orders) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(average_order_value), 2) AS avg_order_value,
    ROUND(AVG(conversion_rate) * 100, 2) AS avg_conversion_rate_pct,
    RANK() OVER (ORDER BY SUM(revenue) DESC) AS revenue_rank
FROM global_ecommerce_raw
GROUP BY product_category
ORDER BY total_revenue DESC;












SELECT
    customer_segment,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(orders) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(average_order_value), 2) AS avg_order_value,
    ROUND(AVG(loyalty_score), 2) AS avg_loyalty_score,
    ROUND(AVG(conversion_rate) * 100, 2) AS avg_conversion_rate_pct
FROM global_ecommerce_raw
GROUP BY customer_segment
ORDER BY total_revenue DESC;












SELECT
    city,
    COUNT(DISTINCT transaction_id) AS transactions,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(orders) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(average_order_value), 2) AS avg_order_value,
    ROUND(AVG(conversion_rate) * 100, 2) AS avg_conversion_rate_pct,
    RANK() OVER (ORDER BY SUM(revenue) DESC) AS revenue_rank
FROM global_ecommerce_raw
WHERE city <> 'Unknown'
GROUP BY city
ORDER BY total_revenue DESC;












SELECT
    CASE
        WHEN sessions <= 5 THEN 'Low Engagement'
        WHEN sessions <= 12 THEN 'Medium Engagement'
        ELSE 'High Engagement'
    END AS engagement_level,
    
    COUNT(*) AS transactions,
    ROUND(AVG(pages_viewed), 2) AS avg_pages_viewed,
    SUM(orders) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(conversion_rate) * 100, 2) AS avg_conversion_rate_pct,
    ROUND(AVG(cart_abandonment_rate) * 100, 2) AS avg_cart_abandonment_pct
FROM global_ecommerce_raw
GROUP BY
    CASE
        WHEN sessions <= 5 THEN 'Low Engagement'
        WHEN sessions <= 12 THEN 'Medium Engagement'
        ELSE 'High Engagement'
    END
ORDER BY total_revenue DESC;















SELECT
    churn_flag,
    COUNT(*) AS transactions,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(loyalty_score), 2) AS avg_loyalty_score,
    ROUND(AVG(email_open_rate), 2) AS avg_email_open_rate,
    ROUND(AVG(conversion_rate) * 100, 2) AS avg_conversion_rate_pct,
    ROUND(AVG(cart_abandonment_rate) * 100, 2) AS avg_cart_abandonment_pct
FROM global_ecommerce_raw
GROUP BY churn_flag
ORDER BY churn_flag;














SELECT
    CASE
        WHEN loyalty_score < 30 THEN 'Low Loyalty'
        WHEN loyalty_score < 70 THEN 'Medium Loyalty'
        ELSE 'High Loyalty'
    END AS loyalty_group,

    COUNT(DISTINCT customer_id) AS customers,

    COUNT(*) AS transactions,

    COUNT(*) FILTER (WHERE churn_flag = 1) AS churned_records,

    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_flag = 1)
        / COUNT(*),
        2
    ) AS churn_rate_pct,

    ROUND(AVG(email_open_rate), 2) AS avg_email_open_rate,

    ROUND(
        AVG(cart_abandonment_rate) * 100,
        2
    ) AS avg_cart_abandonment_pct

FROM global_ecommerce_raw

GROUP BY
    CASE
        WHEN loyalty_score < 30 THEN 'Low Loyalty'
        WHEN loyalty_score < 70 THEN 'Medium Loyalty'
        ELSE 'High Loyalty'
    END

ORDER BY
    MIN(
        CASE
            WHEN loyalty_score < 30 THEN 1
            WHEN loyalty_score < 70 THEN 2
            ELSE 3
        END
    );













	WITH campaign_performance AS (
    SELECT
        marketing_channel,
        campaign_name,
        ROUND(SUM(revenue), 2) AS total_revenue,
        SUM(orders) AS total_orders,
        ROUND(
            SUM(revenue) / NULLIF(SUM(marketing_spend), 0),
            2
        ) AS revenue_to_spend_ratio,
        RANK() OVER (
            PARTITION BY marketing_channel
            ORDER BY SUM(revenue) DESC
        ) AS campaign_rank
    FROM global_ecommerce_raw
    WHERE marketing_channel <> 'Unknown'
    GROUP BY marketing_channel, campaign_name
)

SELECT
    marketing_channel,
    campaign_name,
    total_revenue,
    total_orders,
    revenue_to_spend_ratio,
    campaign_rank
FROM campaign_performance
WHERE campaign_rank = 1
ORDER BY total_revenue DESC;

















SELECT
    marketing_channel,
    campaign_name,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(orders) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(marketing_spend), 2) AS total_marketing_spend,
    ROUND(
        SUM(revenue) / NULLIF(SUM(marketing_spend), 0),
        2
    ) AS revenue_to_spend_ratio,
    RANK() OVER (
        ORDER BY 
        SUM(revenue) / NULLIF(SUM(marketing_spend), 0) DESC
    ) AS efficiency_rank
FROM global_ecommerce_raw
WHERE marketing_channel <> 'Unknown'
GROUP BY marketing_channel, campaign_name
ORDER BY efficiency_rank;















SELECT
    customer_id,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(orders) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(loyalty_score), 2) AS avg_loyalty_score,
    MAX(churn_flag) AS churn_flag,
    RANK() OVER (
        ORDER BY SUM(revenue) DESC
    ) AS customer_revenue_rank
FROM global_ecommerce_raw
GROUP BY customer_id
ORDER BY customer_revenue_rank
LIMIT 20;













WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(revenue) AS total_customer_revenue,
        SUM(orders) AS total_orders,
        AVG(loyalty_score) AS avg_loyalty_score,
        MAX(churn_flag) AS churn_flag
    FROM global_ecommerce_raw
    GROUP BY customer_id
),

customer_segments AS (
    SELECT
        *,
        CASE
            WHEN total_customer_revenue >= 100000 THEN 'High Value'
            WHEN total_customer_revenue >= 50000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_value_segment
    FROM customer_revenue
)

SELECT
    customer_value_segment,
    COUNT(*) AS customers,

    ROUND(AVG(total_customer_revenue), 2) AS avg_customer_revenue,

    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer,

    ROUND(AVG(avg_loyalty_score), 2) AS avg_loyalty_score,

    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_flag = 1)
        / COUNT(*),
        2
    ) AS churn_rate_pct

FROM customer_segments

GROUP BY customer_value_segment

ORDER BY
    CASE customer_value_segment
        WHEN 'High Value' THEN 1
        WHEN 'Medium Value' THEN 2
        WHEN 'Low Value' THEN 3
    END;















	WITH customer_frequency AS (
    SELECT
        customer_id,
        COUNT(DISTINCT transaction_id) AS transaction_count,
        SUM(orders) AS total_orders,
        SUM(revenue) AS total_revenue,
        MAX(churn_flag) AS churn_flag
    FROM global_ecommerce_raw
    GROUP BY customer_id
)

SELECT
    CASE
        WHEN transaction_count = 1 THEN 'One-Time Customer'
        WHEN transaction_count BETWEEN 2 AND 3 THEN 'Repeat Customer'
        ELSE 'Frequent Customer'
    END AS customer_type,

    COUNT(*) AS customers,

    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue,

    ROUND(AVG(total_orders), 2) AS avg_orders_per_customer,

    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_flag = 1) / COUNT(*),
        2
    ) AS churn_rate_pct

FROM customer_frequency

GROUP BY
    CASE
        WHEN transaction_count = 1 THEN 'One-Time Customer'
        WHEN transaction_count BETWEEN 2 AND 3 THEN 'Repeat Customer'
        ELSE 'Frequent Customer'
    END

ORDER BY















WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', date)::DATE AS month,
        SUM(revenue) AS total_revenue
    FROM global_ecommerce_raw
    GROUP BY DATE_TRUNC('month', date)
)

SELECT
    month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        LAG(total_revenue) OVER (ORDER BY month),
        2
    ) AS previous_month_revenue,
    ROUND(
        total_revenue
        - LAG(total_revenue) OVER (ORDER BY month),
        2
    ) AS revenue_change,
    ROUND(
        100.0 * (
            total_revenue
            - LAG(total_revenue) OVER (ORDER BY month)
        )
        / NULLIF(
            LAG(total_revenue) OVER (ORDER BY month),
            0
        ),
        2
    ) AS revenue_growth_pct
FROM monthly_revenue
ORDER BY month;
    CASE
        WHEN MIN(transaction_count) = 1 THEN 1
        WHEN MIN(transaction_count) BETWEEN 2 AND 3 THEN 2
        ELSE 3
    END;

















	WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', date)::DATE AS month,
        SUM(revenue) AS total_revenue
    FROM global_ecommerce_raw
    GROUP BY DATE_TRUNC('month', date)
),

monthly_comparison AS (
    SELECT
        month,
        total_revenue,
        LAG(total_revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_revenue
)

SELECT
    month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(total_revenue - previous_month_revenue, 2) AS revenue_change,
    ROUND(
        100.0 * (total_revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_growth_pct
FROM monthly_comparison
ORDER BY month;













WITH yearly_category_performance AS (
    SELECT
        EXTRACT(YEAR FROM date) AS year,
        product_category,
        SUM(revenue) AS total_revenue,
        SUM(orders) AS total_orders
    FROM global_ecommerce_raw
    GROUP BY
        EXTRACT(YEAR FROM date),
        product_category
),

ranked_categories AS (
    SELECT
        year,
        product_category,
        total_revenue,
        total_orders,
        RANK() OVER (
            PARTITION BY year
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM yearly_category_performance
)

SELECT
    year,
    product_category,
    ROUND(total_revenue, 2) AS total_revenue,
    total_orders,
    revenue_rank
FROM ranked_categories
ORDER BY year, revenue_rank;

















SELECT
    marketing_channel,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(orders) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(sessions), 2) AS avg_sessions,
    ROUND(AVG(pages_viewed), 2) AS avg_pages_viewed,
    ROUND(AVG(cart_abandonment_rate) * 100, 2) AS avg_cart_abandonment_pct,
    ROUND(AVG(conversion_rate) * 100, 2) AS avg_conversion_rate_pct,
    RANK() OVER (
        ORDER BY SUM(revenue) DESC
    ) AS revenue_rank
FROM global_ecommerce_raw
WHERE marketing_channel <> 'Unknown'
GROUP BY marketing_channel
ORDER BY revenue_rank;













WITH monthly_performance AS (
    SELECT
        EXTRACT(YEAR FROM date)::INT AS year,
        DATE_TRUNC('month', date)::DATE AS month,
        SUM(revenue) AS total_revenue
    FROM global_ecommerce_raw
    GROUP BY
        EXTRACT(YEAR FROM date),
        DATE_TRUNC('month', date)
),

yearly_comparison AS (
    SELECT
        year,
        month,
        total_revenue,
        AVG(total_revenue) OVER (
            PARTITION BY year
        ) AS avg_monthly_revenue
    FROM monthly_performance
)

SELECT
    year,
    month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(avg_monthly_revenue, 2) AS avg_monthly_revenue,
    ROUND(
        total_revenue - avg_monthly_revenue,
        2
    ) AS difference_from_year_avg,
    ROUND(
        100.0 * (
            total_revenue - avg_monthly_revenue
        ) / NULLIF(avg_monthly_revenue, 0),
        2
    ) AS pct_difference_from_year_avg
FROM yearly_comparison
ORDER BY year, month;





---end--of-- project--28-aug--