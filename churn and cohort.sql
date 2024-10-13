-- customer churn
WITH last_purchase AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date
    FROM
        order_detail
    WHERE
        is_valid = 1 -- Only consider valid transactions
    GROUP BY	
        customer_id
),
customer_status AS (
    SELECT
        od.customer_id AS customer_id,
        lp.last_order_date,
        CURRENT_DATE AS current_date,
        CASE
            WHEN (CURRENT_DATE - lp.last_order_date) > 90 THEN 'churned'
            ELSE 'active'
        END AS churn_status
    FROM
        order_detail od
    LEFT JOIN
        last_purchase lp
    ON
        od.customer_id = lp.customer_id
)
SELECT
    customer_id,
    last_order_date,
    churn_status
FROM
    customer_status;
	
-- customer churn
WITH last_purchase AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date
    FROM
        order_detail
    WHERE
        is_valid = 1 -- Only consider valid transactions
    GROUP BY	
        customer_id
),
customer_status AS (
    SELECT
        od.customer_id AS customer_id,
        lp.last_order_date,
        CURRENT_DATE AS current_date,
        CASE
            WHEN (CURRENT_DATE - lp.last_order_date) > 90 THEN 'churned'
            ELSE 'active'
        END AS churn_status
    FROM
        order_detail od
    LEFT JOIN
        last_purchase lp
    ON
        od.customer_id = lp.customer_id
)
SELECT
    churn_status,
	COUNT(DISTINCT customer_id) AS customer_count
FROM
    customer_status
GROUP BY
	churn_status;	
	
-- customer churn count
WITH last_purchase AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date
    FROM
        order_detail
    WHERE
        is_valid = 1 -- Only consider valid transactions
    GROUP BY	
        customer_id
),
customer_status AS (
    SELECT
        cd.id AS customer_id,
        lp.last_order_date,
        CURRENT_DATE AS current_date,
        CASE
            WHEN (CURRENT_DATE - lp.last_order_date) > 90 THEN 'churned'
            ELSE 'active'
        END AS churn_status
    FROM
        customer_detail cd
    LEFT JOIN
        last_purchase lp
    ON
        cd.id = lp.customer_id
)
SELECT
    churn_status,
	COUNT(customer_id) AS customer_count
FROM
    customer_status
GROUP BY
	churn_status;
	
-- cohort analysis 2021	

WITH first_invoice AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_transaction
    FROM
        order_detail
    WHERE
        EXTRACT(YEAR FROM order_date) = 2021
        AND is_valid = 1 -- Only include valid transactions
    GROUP BY
        customer_id
    ORDER BY
        first_transaction
),
cohort_index AS (
    SELECT
        od.customer_id,
        od.order_date,
        fi.first_transaction,
        EXTRACT(MONTH FROM od.order_date) - EXTRACT(MONTH FROM fi.first_transaction) AS cohort_index
    FROM
        order_detail AS od
    LEFT JOIN 
        first_invoice AS fi
    ON 
        od.customer_id = fi.customer_id
    WHERE
        EXTRACT(YEAR FROM od.order_date) = 2021 -- Only include transactions from 2021
        AND od.is_valid = 1 -- Only include valid transactions
    ORDER BY
        od.customer_id, od.order_date
),
cohort_month AS(
	SELECT 
		EXTRACT(MONTH FROM ci.first_transaction) AS cohort_month,
		COUNT(DISTINCT CASE WHEN ci.cohort_index = 0 THEN ci.customer_id END) :: numeric AS m0,
		COUNT(DISTINCT CASE WHEN ci.cohort_index = 1 THEN ci.customer_id END) :: numeric AS m1,
		COUNT(DISTINCT CASE WHEN ci.cohort_index = 2 THEN ci.customer_id END) :: numeric AS m2,
		COUNT(DISTINCT CASE WHEN ci.cohort_index = 3 THEN ci.customer_id END) :: numeric AS m3,
		COUNT(DISTINCT CASE WHEN ci.cohort_index = 4 THEN ci.customer_id END) :: numeric AS m4,
		COUNT(DISTINCT CASE WHEN ci.cohort_index = 5 THEN ci.customer_id END) :: numeric AS m5,
		COUNT(DISTINCT CASE WHEN ci.cohort_index = 6 THEN ci.customer_id END) :: numeric AS m6,
		COUNT(DISTINCT CASE WHEN ci.cohort_index = 7 THEN ci.customer_id END) :: numeric AS m7,
		COUNT(DISTINCT CASE WHEN ci.cohort_index = 8 THEN ci.customer_id END) :: numeric AS m8,
		COUNT(DISTINCT CASE WHEN ci.cohort_index = 9 THEN ci.customer_id END) :: numeric AS m9,
		COUNT(DISTINCT CASE WHEN ci.cohort_index = 10 THEN ci.customer_id END) :: numeric AS m10,
		COUNT(DISTINCT CASE WHEN ci.cohort_index = 11 THEN ci.customer_id END) :: numeric AS m11
	FROM cohort_index AS ci
	GROUP BY cohort_month
	ORDER BY cohort_month
)
SELECT
	cm.cohort_month,
	cm.m0 AS total_new_users,
	ROUND((m0/m0)*100) AS m0,
	ROUND((m1/m0)*100) AS m1,
	ROUND((m2/m0)*100) AS m2,
	ROUND((m3/m0)*100) AS m3,
	ROUND((m4/m0)*100) AS m4,
	ROUND((m5/m0)*100) AS m5,
	ROUND((m6/m0)*100) AS m6,
	ROUND((m7/m0)*100) AS m7,
	ROUND((m8/m0)*100) AS m8,
	ROUND((m9/m0)*100) AS m9,
	ROUND((m10/m0)*100) AS m10,
	ROUND((m11/m0)*100) AS m11
FROM cohort_month as cm

-- alternative
WITH first_invoice AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_transaction
    FROM
        order_detail
    WHERE
        EXTRACT(YEAR FROM order_date) = 2021
        AND is_valid = 1
    GROUP BY
        customer_id
    ORDER BY
        first_transaction
),
cohort_index AS (
    SELECT
        od.customer_id,
        od.order_date,
        fi.first_transaction,
        EXTRACT(MONTH FROM od.order_date) - EXTRACT(MONTH FROM fi.first_transaction) AS cohort_index
    FROM
        order_detail AS od
    LEFT JOIN 
        first_invoice AS fi
    ON 
        od.customer_id = fi.customer_id
    WHERE
        EXTRACT(YEAR FROM od.order_date) = 2021
        AND od.is_valid = 1
    ORDER BY
        od.customer_id, od.order_date
),
cohort_summary AS (
    SELECT
        EXTRACT(MONTH FROM fi.first_transaction) AS cohort_month,
        COUNT(DISTINCT CASE WHEN ci.cohort_index = 0 THEN ci.customer_id END) AS m0,
        COUNT(DISTINCT CASE WHEN ci.cohort_index = 1 THEN ci.customer_id END) AS m1,
        COUNT(DISTINCT CASE WHEN ci.cohort_index = 2 THEN ci.customer_id END) AS m2,
        COUNT(DISTINCT CASE WHEN ci.cohort_index = 3 THEN ci.customer_id END) AS m3,
        COUNT(DISTINCT CASE WHEN ci.cohort_index = 4 THEN ci.customer_id END) AS m4,
        COUNT(DISTINCT CASE WHEN ci.cohort_index = 5 THEN ci.customer_id END) AS m5,
        COUNT(DISTINCT CASE WHEN ci.cohort_index = 6 THEN ci.customer_id END) AS m6,
        COUNT(DISTINCT CASE WHEN ci.cohort_index = 7 THEN ci.customer_id END) AS m7,
        COUNT(DISTINCT CASE WHEN ci.cohort_index = 8 THEN ci.customer_id END) AS m8,
        COUNT(DISTINCT CASE WHEN ci.cohort_index = 9 THEN ci.customer_id END) AS m9,
        COUNT(DISTINCT CASE WHEN ci.cohort_index = 10 THEN ci.customer_id END) AS m10,
        COUNT(DISTINCT CASE WHEN ci.cohort_index = 11 THEN ci.customer_id END) AS m11
    FROM
        cohort_index AS ci
    JOIN
        first_invoice AS fi
    ON
        ci.customer_id = fi.customer_id
    GROUP BY
        cohort_month
    ORDER BY
        cohort_month
)

SELECT
    cohort_month,
    m0,
    ROUND((m1::numeric / m0) * 100, 2) AS "Month 1 Retention",
    ROUND((m2::numeric / m0) * 100, 2) AS "Month 2 Retention",
    ROUND((m3::numeric / m0) * 100, 2) AS "Month 3 Retention",
    ROUND((m4::numeric / m0) * 100, 2) AS "Month 4 Retention",
    ROUND((m5::numeric / m0) * 100, 2) AS "Month 5 Retention",
    ROUND((m6::numeric / m0) * 100, 2) AS "Month 6 Retention",
    ROUND((m7::numeric / m0) * 100, 2) AS "Month 7 Retention",
    ROUND((m8::numeric / m0) * 100, 2) AS "Month 8 Retention",
    ROUND((m9::numeric / m0) * 100, 2) AS "Month 9 Retention",
    ROUND((m10::numeric / m0) * 100, 2) AS "Month 10 Retention",
    ROUND((m11::numeric / m0) * 100, 2) AS "Month 11 Retention"
FROM
    cohort_summary
ORDER BY
    cohort_month;


	
-- cohort analysis 2022
WITH cohort AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date,
        TO_CHAR(MIN(order_date), 'YYYY-MM') AS cohort_month
    FROM
        order_detail
    GROUP BY
        customer_id
),
monthly_orders AS (
    SELECT
        customer_id,
        TO_CHAR(order_date, 'YYYY-MM') AS order_month,
        COUNT(id) AS total_orders
    FROM
        order_detail
    WHERE
        is_valid = 1 -- Only count valid orders
    GROUP BY
        customer_id, order_month
),
cohort_analysis AS (
    SELECT
        c.cohort_month,
        mo.order_month,
        COUNT(DISTINCT mo.customer_id) AS active_customers
    FROM
        cohort c
    JOIN
        monthly_orders mo
    ON
        c.customer_id = mo.customer_id
	WHERE
		c.cohort_month > '2021-12'
    GROUP BY
        c.cohort_month, mo.order_month
    ORDER BY
        c.cohort_month, mo.order_month
)
SELECT
    cohort_month,
    SUM(CASE WHEN order_month = '2022-01' THEN active_customers ELSE 0 END) AS "Month 0",
    SUM(CASE WHEN order_month = '2022-02' THEN active_customers ELSE 0 END) AS "Month 1",
    SUM(CASE WHEN order_month = '2022-03' THEN active_customers ELSE 0 END) AS "Month 2",
    SUM(CASE WHEN order_month = '2022-04' THEN active_customers ELSE 0 END) AS "Month 3",
    SUM(CASE WHEN order_month = '2022-05' THEN active_customers ELSE 0 END) AS "Month 4",
    SUM(CASE WHEN order_month = '2022-06' THEN active_customers ELSE 0 END) AS "Month 5",
    SUM(CASE WHEN order_month = '2022-07' THEN active_customers ELSE 0 END) AS "Month 6",
    SUM(CASE WHEN order_month = '2022-08' THEN active_customers ELSE 0 END) AS "Month 7",
	SUM(CASE WHEN order_month = '2022-09' THEN active_customers ELSE 0 END) AS "Month 8",
	SUM(CASE WHEN order_month = '2022-10' THEN active_customers ELSE 0 END) AS "Month 9",
	SUM(CASE WHEN order_month = '2022-11' THEN active_customers ELSE 0 END) AS "Month 10",
	SUM(CASE WHEN order_month = '2022-12' THEN active_customers ELSE 0 END) AS "Month 11"
FROM
    cohort_analysis
GROUP BY
    cohort_month
ORDER BY
    cohort_month;
	
SELECT COUNT(DISTINCT id) AS customer_count
FROM order_detail
WHERE is_valid = 1;  -- Ensures only completed transactions are considered


SELECT *
FROM customer_detail


