import pandas as pd
import psycopg2

DB_NAME = "lh_nautical"
ID_PRODUTO = 74
NOME_PRODUTO = "Bússola de Bordo 702"


def buscar_vendas_produto():
    conexao = psycopg2.connect(dbname=DB_NAME)
    query = """
        SELECT
            o.created_at::date AS data_venda,
            oi.quantity
        FROM orders o
        JOIN order_items oi ON oi.order_id = o.id
        JOIN product_variants pv ON pv.id = oi.product_variant_id
        WHERE pv.product_id = %s
    """
    df = pd.read_sql_query(query, conexao, params=(ID_PRODUTO,))
    conexao.close()
    return df  


def montar_serie_mensal(df):
    df["data_venda"] = pd.to_datetime(df["data_venda"])
    df["mes"] = df["data_venda"].dt.to_period("M")
    vendas_mensais = df.groupby("mes")["quantity"].sum()
    mes_inicio = df["mes"].min()
    mes_fim = pd.Period("2026-03", freq="M")
    calendario_mensal = pd.period_range(start=mes_inicio, end=mes_fim, freq="M")
    serie_completa = vendas_mensais.reindex(calendario_mensal, fill_value=0)
    return serie_completa


def calcular_previsao(serie_completa):
    meses_teste = pd.period_range(start="2026-01", end="2026-03", freq="M")
    previsoes = []
    for mes in meses_teste:
        historico = serie_completa[serie_completa.index < mes].tail(3)
        previsao = historico.mean() if len(historico) > 0 else 0
        valor_real = serie_completa.get(mes, 0)
        previsoes.append({
            "mes": str(mes),
            "real": valor_real,
            "previsao": round(previsao, 2)
        })
    return pd.DataFrame(previsoes)


def main():
    df = buscar_vendas_produto()
    serie_completa = montar_serie_mensal(df)
    df_previsoes = calcular_previsao(serie_completa)
    mae = (df_previsoes["real"] - df_previsoes["previsao"]).abs().mean()
    print(f"Produto: {NOME_PRODUTO} (id {ID_PRODUTO})")
    print(df_previsoes)
    print(f"\nMAE: {mae:.4f}")
    soma_prevista = round(df_previsoes["previsao"].sum())
    print(f"\nSoma total prevista para o 1º trimestre de 2026: {soma_prevista} unidades")


if __name__ == "__main__":
    main()    