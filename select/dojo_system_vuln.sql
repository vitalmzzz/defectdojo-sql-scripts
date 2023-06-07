SELECT
dojo_product.name AS "Наименование продукта в Dojo",
dojo_engagement.product_id AS "Идентифкатор продукта",
dojo_engagement.description AS "Описание", 
dojo_engagement.name AS "Наименование Engagements", 
dojo_engagement.target_start AS "Дата начала сканирования", 
dojo_engagement.target_end "Дата завершения сканирования",
dojo_engagement.source_code_management_uri AS "MR инициатор" ,
dojo_test.scan_type AS "Инструмент",
SUM(CASE WHEN  dojo_finding.severity = 'Critical' THEN 1 ELSE 0 END) AS "Количество уязвимостей Critical",
SUM(CASE WHEN  dojo_finding.severity = 'High' THEN 1 ELSE 0 END) AS "Количество уязвимостей High"
FROM public.dojo_engagement
INNER JOIN dojo_product
ON dojo_product.id = dojo_engagement.product_id 
INNER JOIN dojo_test
ON dojo_engagement.id = dojo_test.engagement_id
INNER JOIN dojo_finding
ON dojo_test.id = dojo_finding.test_id
WHERE dojo_engagement.description LIKE '%ndbo%'
GROUP BY dojo_product.name, dojo_engagement.product_id, dojo_engagement.description, dojo_engagement.name, dojo_engagement.target_start, dojo_engagement.target_end,
dojo_engagement.source_code_management_uri, dojo_test.scan_type, dojo_finding.severity
HAVING SUM (CASE WHEN  dojo_finding.severity = 'Critical' THEN 1 ELSE 0 END) > 0 OR
(CASE WHEN  dojo_finding.severity = 'High' THEN 1 ELSE 0 END) > 0
ORDER BY dojo_engagement.description
