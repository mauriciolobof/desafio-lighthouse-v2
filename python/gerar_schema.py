import csv 
import os 
import re 
from datetime import datetime 

DATA_DIR = "data/raw" 
OUTPUT_FILE = "schema.sql"
DATETIME_PATTERN = re.compile(r"^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$") 
DATE_PATTERN = re.compile(r"^\d{4}-\d{2}-\d{2}$") 
BOOL_VALUES = {"TRUE", "FALSE", "true", "false"}

def eh_inteiro(valor: str) -> bool:
    if valor == "":  
        return False
    v = valor[1:] if valor[0] in "+-" else valor
    return v.isdigit()

def eh_numerico(valor: str) -> bool:
    if valor == "":
        return False
    try:
        float(valor)
        return True
    except ValueError:
        return False

def eh_data(valor: str) -> bool:
    return bool(DATE_PATTERN.match(valor))

def eh_datetime(valor: str) -> bool:
    return bool(DATETIME_PATTERN.match(valor))

def eh_booleano(valor: str) -> bool:
    return valor in BOOL_VALUES

def inferir_tipo_coluna(valores: list) -> str:
    valores_preenchidos = [v for v in valores if v != ""]
    if not valores_preenchidos:
        return "VARCHAR(255)"
    if all(eh_booleano(v) for v in valores_preenchidos):
        return "BOOLEAN"
    if all(eh_datetime(v) for v in valores_preenchidos):
        return "TIMESTAMP"
    if all(eh_data(v) for v in valores_preenchidos):
        return "DATE" 
    if all(eh_inteiro(v) for v in valores_preenchidos):
        maior_valor = max(abs(int(v)) for v in valores_preenchidos)
        return "BIGINT" if maior_valor > 2_147_483_647 else "INTEGER"
    if all(eh_numerico(v) for v in valores_preenchidos):
        return "NUMERIC(14,2)"
    maior_tamanho = max(len(v) for v in valores_preenchidos)
    tamanho_coluna = max(50, int(maior_tamanho * 1.5))
    return f"VARCHAR({tamanho_coluna})"

def coluna_aceita_null(valores: list) -> bool:
    return any(v == "" for v in valores)

def nome_tabela_valido(nome_arquivo: str) -> str:
    return os.path.splitext(nome_arquivo)[0]

def gerar_create_table(nome_tabela: str, caminho_csv: str) -> str:
    with open(caminho_csv, newline="", encoding="utf-8") as f:    
        leitor = csv.reader(f)
        cabecalho = next(leitor)
        valores_por_coluna = {coluna: [] for coluna in cabecalho}
        for linha in leitor:
            for coluna, valor in zip(cabecalho, linha):
                valores_por_coluna[coluna].append(valor.strip())
    linhas_ddl = []          
    for coluna in cabecalho:
        valores = valores_por_coluna[coluna]
        tipo = inferir_tipo_coluna(valores)
        aceita_null = coluna_aceita_null(valores)
        if coluna == "id":
            linha_col = f'    "{coluna}" {tipo} PRIMARY KEY'
        else:
            nulabilidade = "" if aceita_null else " NOT NULL"
            linha_col = f'    "{coluna}" {tipo}{nulabilidade}'
        linhas_ddl.append(linha_col)
    ddl = f'CREATE TABLE "{nome_tabela}" (\n'
    ddl += ",\n".join(linhas_ddl)
    ddl += "\n);"
    return ddl              


def main():
    arquivos_csv = sorted(
        f for f in os.listdir(DATA_DIR) if f.lower().endswith(".csv")
    )    
    blocos_ddl = []
    blocos_ddl.append(
        f"-- schema.sql gerado automaticamente em {datetime.now().isoformat(timespec='seconds')}\n"
        f"-- Fonte: {len(arquivos_csv)} arquivos CSV em {DATA_DIR}\n"
    )
    for arquivo in arquivos_csv:
        nome_tabela = nome_tabela_valido(arquivo)
        caminho = os.path.join(DATA_DIR, arquivo)
        ddl = gerar_create_table(nome_tabela, caminho)
        blocos_ddl.append(ddl)
        print(f"Tabela '{nome_tabela}' processada ({arquivo}).")
    with open(OUTPUT_FILE, "w", encoding="utf-8") as saida:
        saida.write("\n\n".join(blocos_ddl) + "\n")
    print(f"\nSchema gerado com sucesso em: {OUTPUT_FILE}")
    print(f"Total de tabelas: {len(arquivos_csv)}")  


if __name__ == "__main__":
    main()                      