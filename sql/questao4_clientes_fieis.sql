-- Questão 4 - Análise de Clientes Fiéis
-- Cadeia de relacionamento: customers → orders → order_items → product_variants → products → categories
-- Diversidade medida por category_id (não pelo nome, evitando problemas de grafia como "SEGURANÇA" em maiúsculas)

WITH base AS (
    SELECT
        o.id AS order_id,
        o.customer_id,
        oi.line_total,
        oi.quantity,
        p.category_id
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.id
    JOIN product_variants pv ON pv.id = oi.product_variant_id
    JOIN products p ON p.id = pv.product_id
),
metricas_cliente AS (
    SELECT
        customer_id,
        SUM(line_total) AS faturamento_total,
        COUNT(DISTINCT order_id) AS frequencia,
        COUNT(DISTINCT category_id) AS diversidade_categorias
    FROM base
    GROUP BY customer_id
),
com_ticket AS (
    SELECT
        customer_id,
        faturamento_total,
        frequencia,
        diversidade_categorias,
        faturamento_total / frequencia AS ticket_medio
    FROM metricas_cliente
),
top_10_clientes AS (
    SELECT customer_id
    FROM com_ticket
    WHERE diversidade_categorias >= 13
    ORDER BY ticket_medio DESC, customer_id ASC
    LIMIT 10
),
categoria_top10 AS (
    SELECT
        c.name AS categoria,
        SUM(b.quantity) AS quantidade_total_itens
    FROM base b
    JOIN categories c ON c.id = b.category_id
    WHERE b.customer_id IN (SELECT customer_id FROM top_10_clientes)
    GROUP BY c.name
)
SELECT * FROM categoria_top10 ORDER BY quantidade_total_itens DESC;