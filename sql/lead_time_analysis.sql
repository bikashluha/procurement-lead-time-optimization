/* =========================================
   PROCUREMENT LEAD TIME OPTIMIZATION PROJECT
   ========================================= */

/* 1. Calculate Cycle Time */
SELECT 
    pr_id,
    po_id,
    DATEDIFF(day, pr_created_date, po_created_date) AS cycle_time_days
FROM procurement_data
WHERE pr_created_date IS NOT NULL
AND po_created_date IS NOT NULL;


/* 2. Average Cycle Time */
SELECT 
    AVG(DATEDIFF(day, pr_created_date, po_created_date)) AS avg_cycle_time
FROM procurement_data;


/* 3. Stage-wise Bottleneck Analysis */
SELECT 
    stage,
    AVG(delay_days) AS avg_delay
FROM (
    SELECT 
        pr_id,
        'Approval Delay' AS stage,
        DATEDIFF(day, pr_created_date, pr_approved_date) AS delay_days
    FROM procurement_data

    UNION ALL

    SELECT 
        pr_id,
        'PO Creation Delay' AS stage,
        DATEDIFF(day, pr_approved_date, po_created_date)
    FROM procurement_data
) delays
GROUP BY stage
ORDER BY avg_delay DESC;


/* 4. Top Delayed Transactions */
SELECT 
    pr_id,
    requester,
    approver,
    DATEDIFF(day, pr_created_date, po_created_date) AS total_delay
FROM procurement_data
ORDER BY total_delay DESC
LIMIT 10;


/* 5. Before vs After Improvement */
SELECT 
    CASE 
        WHEN po_created_date < '2025-01-01' THEN 'Before Improvement'
        ELSE 'After Improvement'
    END AS period,
    AVG(DATEDIFF(day, pr_created_date, po_created_date)) AS avg_cycle_time
FROM procurement_data
GROUP BY period;
