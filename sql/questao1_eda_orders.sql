-- Questão 1.1 - EDA da tabela orders -- 
-- Visão geral: linhas, datas, estatísticas de 'total' 
SELECT COUNT(*) AS quantidade_linhas, 
  MIN(created_at) AS data_minima, 
  MAX(created_at) AS data_maxima, 
  MIN(total) AS valor_minimo, 
  MAX(total) AS valor_maximo, 
  ROUND(AVG(total), 2) AS valor_medio 
FROM read_csv_auto('data/raw/orders.csv'); 

-- Quantidade de colunas (obtida separadamente) 
DESCRIBE SELECT * FROM read_csv_auto('data/raw/orders.csv');