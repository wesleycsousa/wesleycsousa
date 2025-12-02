SELECT 
    t.product_description,
    date_trunc('month', t.event_time_utc)::Date month_reference,
    Sum(t.amount_usd) as revenue_usd
  FROM   silver_transaction t
  WHERE  t.status = 'completed'
  GROUP  BY 1,2
  ORDER  BY 1,2
; 


SELECT
    t.customer_id,
    COUNT(t.transaction_id) AS tx_count,
    SUM(t.amount_usd) AS total_usd,
    ROUND(SUM(t.amount_usd) / NULLIF(COUNT(t.transaction_id),0), 2) AS avg_ticket_usd
  FROM silver_transaction t
  WHERE t.event_time_utc >= (NOW() AT TIME ZONE 'UTC') - INTERVAL '90 days'
    AND t.status = 'completed'
  GROUP BY t.customer_id
  ORDER BY total_usd DESC
  LIMIT 100
  ;
