SELECT *
FROM order_detail;

SELECT
	MIN(order_date) AS first_t,
	MAX(order_date) AS last_t
FROM order_detail;

SELECT *
FROM sku_detail;

SELECT *
FROM payment_detail;

-- Selama transaksi yang terjadi selama 2021, pada bulan apa total nilai transaksi 
--- (after_discount) paling besar? Gunakan is_valid = 1 untuk memfilter data transaksi.
SELECT
	EXTRACT(MONTH FROM order_date) AS month,
	ROUND(SUM(after_discount)::numeric,2) AS total_transaction
FROM order_detail
WHERE EXTRACT(YEAR FROM order_date) = 2021
AND is_valid = 1
GROUP BY month
ORDER BY total_transaction DESC;

-- deeper analysis
SELECT
	EXTRACT(MONTH FROM order_date) AS month,
	COUNT(customer_id) AS total_customers,
	SUM(qty_ordered) AS total_qty_ordered,
	ROUND(SUM(after_discount)::numeric,2) AS total_transaction
FROM order_detail
WHERE EXTRACT(YEAR FROM order_date) = 2021
AND is_valid = 1
GROUP BY month
ORDER BY total_transaction DESC;

-- Selama transaksi pada tahun 2022, kategori apa yang menghasilkan nilai transaksi paling
-- besar? Gunakan is_valid = 1 untuk memfilter data transaksi.

SELECT
    sd.category AS category,
	COUNT(od.customer_id) AS total_customers,
	SUM(od.qty_ordered) AS total_quantity_ordered,
    ROUND(SUM(od.after_discount)::numeric,2) AS total_transaction
FROM order_detail od
LEFT JOIN sku_detail sd ON od.sku_id = sd.id
WHERE EXTRACT(YEAR FROM od.order_date) = 2022
AND od.is_valid = 1
GROUP BY sd.category
ORDER BY total_quantity_ordered DESC;

-- Bandingkan nilai transaksi dari masing-masing kategori pada tahun 2021 dengan 2022.
-- Sebutkan kategori apa saja yang mengalami peningkatan dan kategori apa yang mengalami
--- penurunan nilai transaksi dari tahun 2021 ke 2022. Gunakan is_valid = 1 untuk memfilter data transaksi.

WITH transactions_2021 AS(
	SELECT
		sd.category AS category,
		SUM(od.after_discount) AS total_transaction_2021
	FROM order_detail od
	LEFT JOIN sku_detail sd ON od.sku_id = sd.id
	WHERE EXTRACT(YEAR FROM od.order_date) = 2021
	AND od.is_valid = 1
	GROUP BY sd.category
),
transactions_2022 AS(
	SELECT
		sd.category AS category,
		SUM(od.after_discount) AS total_transaction_2022
	FROM order_detail od
	LEFT JOIN sku_detail sd ON od.sku_id = sd.id
	WHERE EXTRACT(YEAR FROM od.order_date) = 2022
	AND od.is_valid = 1
	GROUP BY sd.category
)
SELECT
    COALESCE(t2021.category, t2022.category) AS category,
    COALESCE(t2021.total_transaction_2021, 0) AS total_transaction_2021,
    COALESCE(t2022.total_transaction_2022, 0) AS total_transaction_2022,
    COALESCE(t2022.total_transaction_2022, 0) - COALESCE(t2021.total_transaction_2021, 0) AS difference,
    CASE
        WHEN COALESCE(t2022.total_transaction_2022, 0) - COALESCE(t2021.total_transaction_2021, 0) > 0 THEN 'Increase'
        WHEN COALESCE(t2022.total_transaction_2022, 0) - COALESCE(t2021.total_transaction_2021, 0) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS change_type
FROM transactions_2021 t2021
FULL OUTER JOIN transactions_2022 t2022 ON t2021.category = t2022.category
ORDER BY difference DESC;

-- Others

WITH transactions_2021 AS(
	SELECT
		sd.sku_name AS product_name,
		SUM(od.qty_ordered) AS total_qty_ordered_2021
	FROM order_detail od
	LEFT JOIN sku_detail sd ON od.sku_id = sd.id
	WHERE EXTRACT(YEAR FROM od.order_date) = 2021
	AND category = 'Others'
	AND od.is_valid = 1
	GROUP BY sd.sku_name
),
transactions_2022 AS(
	SELECT
		sd.sku_name AS product_name,
		SUM(od.qty_ordered) AS total_qty_ordered_2022
	FROM order_detail od
	LEFT JOIN sku_detail sd ON od.sku_id = sd.id
	WHERE EXTRACT(YEAR FROM od.order_date) = 2022
	AND category = 'Others'
	AND od.is_valid = 1
	GROUP BY sd.sku_name
)
SELECT
    COALESCE(t2021.product_name, t2022.product_name) AS product_name,
    COALESCE(t2021.total_qty_ordered_2021, 0) AS total_qty_ordered_2021,
    COALESCE(t2022.total_qty_ordered_2022, 0) AS total_qty_ordered_2022,
    COALESCE(t2022.total_qty_ordered_2022, 0) - COALESCE(t2021.total_qty_ordered_2021, 0) AS difference,
    CASE
        WHEN COALESCE(t2022.total_qty_ordered_2022, 0) - COALESCE(t2021.total_qty_ordered_2021, 0) > 0 THEN 'Increase'
        WHEN COALESCE(t2022.total_qty_ordered_2022, 0) - COALESCE(t2021.total_qty_ordered_2021, 0) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS change_type
FROM transactions_2021 t2021
INNER JOIN transactions_2022 t2022 ON t2021.product_name = t2022.product_name
ORDER BY difference DESC
LIMIT 5;

-- Mobile & Tablets
WITH transactions_2021 AS(
	SELECT
		sd.sku_name AS product_name,
		SUM(od.qty_ordered) AS total_qty_ordered_2021
	FROM order_detail od
	LEFT JOIN sku_detail sd ON od.sku_id = sd.id
	WHERE EXTRACT(YEAR FROM od.order_date) = 2021
	AND category = 'Mobiles & Tablets'
	AND od.is_valid = 1
	GROUP BY sd.sku_name
),
transactions_2022 AS(
	SELECT
		sd.sku_name AS product_name,
		SUM(od.qty_ordered) AS total_qty_ordered_2022
	FROM order_detail od
	LEFT JOIN sku_detail sd ON od.sku_id = sd.id
	WHERE EXTRACT(YEAR FROM od.order_date) = 2022
	AND category = 'Mobiles & Tablets'
	AND od.is_valid = 1
	GROUP BY sd.sku_name
)
SELECT
    COALESCE(t2021.product_name, t2022.product_name) AS product_name,
    COALESCE(t2021.total_qty_ordered_2021, 0) AS total_qty_ordered_2021,
    COALESCE(t2022.total_qty_ordered_2022, 0) AS total_qty_ordered_2022,
    COALESCE(t2022.total_qty_ordered_2022, 0) - COALESCE(t2021.total_qty_ordered_2021, 0) AS difference,
    CASE
        WHEN COALESCE(t2022.total_qty_ordered_2022, 0) - COALESCE(t2021.total_qty_ordered_2021, 0) > 0 THEN 'Increase'
        WHEN COALESCE(t2022.total_qty_ordered_2022, 0) - COALESCE(t2021.total_qty_ordered_2021, 0) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS change_type
FROM transactions_2021 t2021
INNER JOIN transactions_2022 t2022 ON t2021.product_name = t2022.product_name
ORDER BY difference DESC;

--- pikul
WITH transx_2021 AS (
SELECT
	sd.sku_name,
	SUM(od.after_discount) transaction_value
FROM
	order_detail od
INNER JOIN
	sku_detail sd
ON
	od.sku_id = sd.id
WHERE
	od.is_valid = 1
	AND sd.category = 'Others'
	AND EXTRACT(YEAR FROM od.order_date) = 2021
GROUP BY
	1
ORDER BY
	1
),

transx_2022 AS (
SELECT
	sd.sku_name,
	SUM(od.after_discount) transaction_value
FROM
	order_detail od
INNER JOIN
	sku_detail sd
ON
	od.sku_id = sd.id
WHERE
	od.is_valid = 1
	AND sd.category = 'Others'
	AND EXTRACT(YEAR FROM od.order_date) = 2022
GROUP BY
	1
ORDER BY
	1
)

SELECT
	sd.sku_name,
	transx_2021.transaction_value AS trans_val_2021,
	transx_2022.transaction_value AS trans_val_2022,
	transx_2022.transaction_value - transx_2021.transaction_value AS income_difference,
	case
		when transx_2022.transaction_value - transx_2021.transaction_value > 0 then 'naik'
		when transx_2022.transaction_value - transx_2021.transaction_value < 0 then 'turun'
		when transx_2022.transaction_value - transx_2021.transaction_value = 0 then 'stabil'
	end AS condition
FROM
	sku_detail sd
INNER JOIN
	transx_2021 ON sd.sku_name = transx_2021.sku_name
INNER JOIN
	transx_2022 ON sd.category = transx_2022.sku_name
ORDER BY
	4;

-- Tampilkan top 5 metode pembayaran yang paling populer digunakan selama 2022
--- (berdasarkan total unique order). Gunakan is_valid = 1 untuk memfilter data transaksi.

SELECT
	pd.payment_method AS payment_method,
	COUNT(DISTINCT od.id) AS total_unique_order
FROM order_detail od
LEFT JOIN payment_detail pd ON od.payment_id = pd.id
WHERE EXTRACT(YEAR FROM od.order_date) = 2022
AND od.is_valid = 1
GROUP BY payment_method
ORDER BY total_unique_order DESC
LIMIT 5;

-- adding total transaction values
SELECT
	pd.payment_method AS payment_method,
	COUNT(DISTINCT od.id) AS total_unique_order,
	ROUND(SUM(od.after_discount)::numeric, 2) AS total_transaction
FROM order_detail od
LEFT JOIN payment_detail pd ON od.payment_id = pd.id
WHERE EXTRACT(YEAR FROM od.order_date) = 2022
AND od.is_valid = 1
GROUP BY payment_method
ORDER BY total_unique_order DESC
LIMIT 5;

SELECT
	pd.payment_method AS payment_method,
	COUNT(DISTINCT od.id) AS total_unique_order,
	ROUND(SUM(od.after_discount)::numeric, 2) AS total_transaction
FROM order_detail od
LEFT JOIN payment_detail pd ON od.payment_id = pd.id
WHERE EXTRACT(YEAR FROM od.order_date) = 2022
AND od.is_valid = 1
GROUP BY payment_method
ORDER BY total_transaction DESC
LIMIT 5;


-- Urutkan dari ke-5 produk ini berdasarkan nilai transaksinya.
--- 1. Samsung
--- 2. Apple
--- 3. Sony
--- 4. Huawei
--- 5. Lenovo
--- Gunakan is_valid = 1 untuk memfilter data transaksi.

SELECT
	CASE
		WHEN sd.sku_name LIKE '%Samsung%' THEN 'Samsung'
		WHEN sd.sku_name LIKE '%Apple%' THEN 'Apple'
		WHEN sd.sku_name LIKE '%Sony%' THEN 'Sony'
		WHEN sd.sku_name LIKE '%Huawei%' THEN 'Huawei'
		WHEN sd.sku_name LIKE '%Lenovo%' THEN 'Lenovo'
		Else 'Other'
	END AS brand,
	SUM(od.after_discount) AS total_transaction
FROM order_detail od
LEFT JOIN sku_detail sd ON od.sku_id = sd.id
WHERE od.is_valid = 1
AND (
    sd.sku_name LIKE '%Samsung%' OR
    sd.sku_name LIKE '%Apple%' OR
    sd.sku_name LIKE '%Sony%' OR
    sd.sku_name LIKE '%Huawei%' OR
    sd.sku_name LIKE '%Lenovo%'
)
GROUP BY brand
ORDER BY total_transaction DESC;

-- adding total_qty_ordered
SELECT
	CASE
		WHEN sd.sku_name LIKE '%Samsung%' THEN 'Samsung'
		WHEN sd.sku_name LIKE '%Apple%' THEN 'Apple'
		WHEN sd.sku_name LIKE '%Sony%' THEN 'Sony'
		WHEN sd.sku_name LIKE '%Huawei%' THEN 'Huawei'
		WHEN sd.sku_name LIKE '%Lenovo%' THEN 'Lenovo'
		Else 'Other'
	END AS brand,
	SUM(od.qty_ordered) AS total_qty_ordered,
	SUM(od.after_discount) AS total_transaction
FROM order_detail od
LEFT JOIN sku_detail sd ON od.sku_id = sd.id
WHERE od.is_valid = 1
AND (
    sd.sku_name LIKE '%Samsung%' OR
    sd.sku_name LIKE '%Apple%' OR
    sd.sku_name LIKE '%Sony%' OR
    sd.sku_name LIKE '%Huawei%' OR
    sd.sku_name LIKE '%Lenovo%'
)
GROUP BY brand
ORDER BY total_transaction DESC;

-- adding product name to see the bigger picture
SELECT
	sd.sku_name AS product_name,
	CASE
		WHEN sd.sku_name LIKE '%Samsung%' THEN 'Samsung'
		WHEN sd.sku_name LIKE '%Apple%' THEN 'Apple'
		WHEN sd.sku_name LIKE '%Sony%' THEN 'Sony'
		WHEN sd.sku_name LIKE '%Huawei%' THEN 'Huawei'
		WHEN sd.sku_name LIKE '%Lenovo%' THEN 'Lenovo'
		Else 'Other'
	END AS brand,
	SUM(od.qty_ordered) AS total_qty_ordered,
	SUM(od.after_discount) AS total_transaction
FROM order_detail od
INNER JOIN sku_detail sd ON od.sku_id = sd.id
WHERE od.is_valid = 1
AND (
    sd.sku_name LIKE '%Samsung%' OR
    sd.sku_name LIKE '%Apple%' OR
    sd.sku_name LIKE '%Sony%' OR
    sd.sku_name LIKE '%Huawei%' OR
    sd.sku_name LIKE '%Lenovo%'
)
GROUP BY product_name, brand
ORDER BY total_transaction DESC;
