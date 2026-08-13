import pandas as pd
import psycopg2
from sklearn.metrics.pairwise import cosine_similarity

DB_NAME = "lh_nautical"
ID_PRODUTO_REF = 180
NOME_PRODUTO_REF = "Motor de Popa 1949"

def buscar_compras():
    conexao = psycopg2.connect(dbname=DB_NAME)
    query = """
        SELECT DISTINCT
            o.customer_id,
            pv.product_id
        FROM orders o
        JOIN order_items oi ON oi.order_id = o.id
        JOIN product_variants pv ON pv.id = oi.product_variant_id
    """  
    df = pd.read_sql_query(query, conexao)
    conexao.close()
    return df


def montar_matriz_similaridade(df):
    df["comprou"] = 1
    matriz = df.pivot_table(
        index="customer_id",
        columns="product_id",
        values="comprou",
        fill_value=0
    )
    similaridade = cosine_similarity(matriz.T)
    df_similaridade = pd.DataFrame(
        similaridade,
        index=matriz.columns,
        columns=matriz.columns
    )
    return df_similaridade


def gerar_ranking(df_similaridade, id_produto_ref):
    similares = df_similaridade[id_produto_ref].sort_values(ascending=False)
    similares = similares.drop(id_produto_ref)
    top5 = similares.head(5)
    conexao = psycopg2.connect(dbname=DB_NAME)
    query = "SELECT id, name FROM products WHERE id = ANY(%s)"
    ids_top5 = top5.index.tolist()
    df_nomes = pd.read_sql_query(query, conexao, params=(ids_top5,))
    conexao.close()
    df_nomes = df_nomes.set_index("id")
    ranking = pd.DataFrame({
        "similaridade": top5,
        "nome": df_nomes["name"]
    })
    return ranking.sort_values("similaridade", ascending=False)


def main():
    df = buscar_compras()
    df_similaridade = montar_matriz_similaridade(df)
    ranking = gerar_ranking(df_similaridade, ID_PRODUTO_REF)
    print(f"Produto de referência: {NOME_PRODUTO_REF} (id {ID_PRODUTO_REF})")
    print("\nTop 5 produtos mais similares:")
    print(ranking)

if __name__ == "__main__":
    main()    