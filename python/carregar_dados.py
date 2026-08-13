import os
import psycopg2

DATA_DIR = "data/raw"
DB_NAME = "lh_nautical"

def carregar_csv(cursor, nome_tabela, caminho_csv):
    with open(caminho_csv, "r", encoding="utf-8") as f:
        cabecalho = next(f).strip()  
        colunas = cabecalho.split(",")
        colunas_sql = ", ".join(f'"{c}"' for c in colunas)
        comando_copy = f'COPY "{nome_tabela}" ({colunas_sql}) FROM STDIN WITH (FORMAT csv)'
        cursor.copy_expert(comando_copy, f)
    linhas_carregadas = cursor.rowcount
    return linhas_carregadas     


def main():
    conexao = psycopg2.connect(dbname=DB_NAME)
    conexao.autocommit = True    
    cursor = conexao.cursor()
    arquivos_csv = sorted(
        f for f in os.listdir(DATA_DIR) if f.lower().endswith(".csv")
    )
    total_geral = 0
    for arquivo in arquivos_csv:
        nome_tabela = os.path.splitext(arquivo)[0]
        caminho = os.path.join(DATA_DIR, arquivo)
        linhas = carregar_csv(cursor, nome_tabela, caminho)
        total_geral += linhas
        print(f"Tabela '{nome_tabela}': {linhas} linhas carregadas.")
    cursor.close()
    conexao.close()
    print(f"\nCarregamento concluído. Total geral de linhas: {total_geral}")


if __name__ == "__main__":
    main()
