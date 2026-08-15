# Desafio Lighthouse - Dados e IA | LH Nautical

Solução do desafio técnico da Lighthouse (edição 08/2026), aplicando engenharia de dados, SQL, Python e conceitos de ciência de dados sobre uma base fictícia de e-commerce/varejo náutico.

## Contexto

A LH Nautical é uma empresa fictícia de varejo náutico com lojas físicas, armazéns e e-commerce. O desafio simula um cenário real: dados brutos em 24 arquivos CSV, sem tratamento, que precisam ser modelados, carregados num banco relacional e analisados para gerar insights de negócio.

## Stack utilizada

- **SQL**: DuckDB (exploração inicial) e PostgreSQL 16 (banco relacional principal)
- **Python 3.11**: scripts de schema, carregamento, previsão e recomendação
- **Bibliotecas**: pandas, psycopg2, scikit-learn, matplotlib
- **Ambiente**: venv (ambiente virtual isolado)
- **Versionamento**: Git + GitHub
- **Dashboard**: Looker Studio + Notebook Jupyter complementar

## Estrutura do projeto

desafio-lighthouse-v2/
├── data/
│ └── raw/ # 24 CSVs originais, sem tratamento
├── sql/ # Queries de cada questão (arquivos .sql)
├── python/ # Scripts Python de cada questão
├── notebooks/
│ └── dashboard.ipynb # Dashboard consolidado com visualizações
├── docs/ # CSVs exportados, PDF do dashboard, anotações
├── schema.sql # DDL gerado automaticamente (Questão 2)
└── README.md

## Como rodar

```bash
# 1. Criar e ativar o ambiente virtual
python3 -m venv venv
source venv/bin/activate

# 2. Instalar dependências
pip install pandas numpy scikit-learn duckdb psycopg2-binary matplotlib jupyter

# 3. Criar o banco PostgreSQL local
createdb lh_nautical

# 4. Gerar o schema a partir dos CSVs
python3 python/gerar_schema.py

# 5. Aplicar o schema no banco
psql -d lh_nautical -f schema.sql

# 6. Carregar os dados
python3 python/carregar_dados.py
```

## Resumo das questões

| #   | Questão                 | Ferramenta            | Principal achado                                                                                |
| --- | ----------------------- | --------------------- | ----------------------------------------------------------------------------------------------- |
| 1   | EDA da tabela `orders`  | DuckDB                | 48.998 pedidos, sem nulos críticos, dataset confiável mas requer relação com outras tabelas     |
| 2   | Geração de schema       | Python puro           | Script de inferência de tipos, gerando DDL PostgreSQL para 24 tabelas                           |
| 3   | Carregamento            | Python + psycopg2     | 433.424 linhas carregadas; corrigido bug de overflow em `BIGINT` (chave de NF-e com 44 dígitos) |
| 4   | Clientes fiéis          | SQL (CTEs)            | Top 10 clientes por ticket médio (R$ 40-43 mil), todos com as 14 categorias compradas           |
| 5   | Dimensão de calendário  | SQL                   | Quinta-feira tem a menor média de vendas nas lojas físicas (R$ 157.154,32)                      |
| 6   | Previsão de demanda     | Python + pandas       | Baseline de média móvel (MAE 16,44); falha em capturar sazonalidade de janeiro                  |
| 7   | Sistema de recomendação | Python + scikit-learn | Motor de Popa 5331 é o produto mais similar ao Motor de Popa 1949 (similaridade 0,26)           |

## Dashboard

O dashboard interativo está disponível no Looker Studio, com uma versão em PDF de backup em [`docs/dashboard_looker_studio.pdf`](docs/dashboard_looker_studio.pdf). Um notebook comentado complementar também está disponível em [`notebooks/dashboard.ipynb`](notebooks/dashboard.ipynb), com o mesmo conjunto de visualizações e explicações passo a passo do código.

## Autor

Maurício Lobo — [GitHub](https://github.com/mauriciolobof)
