import os
import glob
import shutil
import sys

from pyspark.sql import SparkSession
from pyspark.sql.functions import col


# Cria a sessão do Spark
spark = (
    SparkSession.builder
    .appName("Desafio Engenharia de Dados")
    .getOrCreate()
)


# Configurações de conexão com o PostgreSQL
jdbc_url = "jdbc:postgresql://postgres:5432/cooperativa"

connection_properties = {
    "user": "postgres",
    "password": "postgres",
    "driver": "org.postgresql.Driver"
}


# Função responsável pela leitura das tabelas
def carregar_tabela(nome_tabela):
    return spark.read.jdbc(
        url=jdbc_url,
        table=nome_tabela,
        properties=connection_properties
    )


# Carrega as tabelas do PostgreSQL
df_associado = carregar_tabela("associado")
df_conta = carregar_tabela("conta")
df_cartao = carregar_tabela("cartao")
df_movimento = carregar_tabela("movimento")


# Realiza os relacionamentos entre as tabelas
df_flat = (
    df_movimento.alias("m")
    .join(
        df_cartao.alias("ca"),
        df_movimento["id_cartao"] == df_cartao["id"],
        "inner"
    )
    .join(
        df_conta.alias("co"),
        df_cartao["id_conta"] == df_conta["id"],
        "inner"
    )
    .join(
        df_associado.alias("a"),
        df_cartao["id_associado"] == df_associado["id"],
        "inner"
    )
)

#Seleciona as colunas
df_movimento_flat = df_flat.select(
    col("a.nome")
        .cast("string")
        .alias("nome_associado"),

    col("a.sobrenome")
        .cast("string")
        .alias("sobrenome_associado"),

    col("a.idade")
        .cast("string")
        .alias("idade_associado"),

    col("m.vlr_transacao")
        .cast("string")
        .alias("vlr_transacao_movimento"),

    col("m.des_transacao")
        .cast("string")
        .alias("des_transacao_movimento"),

    col("m.data_movimento")
        .cast("string")
        .alias("data_movimento"),

    col("ca.num_cartao")
        .cast("string")
        .alias("numero_cartao"),

    col("ca.nom_impresso")
        .cast("string")
        .alias("nome_impresso_cartao"),

    col("co.tipo_conta")
        .cast("string")
        .alias("tipo_conta"),

    col("co.data_criacao")
        .cast("string")
        .alias("data_criacao_conta")
)


print("\n=== MOVIMENTO FLAT ===")

df_movimento_flat.show(
    50,
    truncate=False
)

quantidade_registros = df_movimento_flat.count()

print(
    "Quantidade de registros:",
    quantidade_registros
)

df_movimento_flat.printSchema()

# Define o diretório de saída.
# Caso não seja informado, utiliza "output" como padrão.
diretorio_saida = sys.argv[1] if len(sys.argv) > 1 else "output"

# Como o ETL executa dentro do container, o diretório informado
# é considerado relativo ao diretório de trabalho do Spark.
caminho_saida = os.path.join(
    "/opt/spark/work-dir",
    diretorio_saida
)

diretorio_temporario = os.path.join(
    caminho_saida,
    "movimento_flat_temp"
)

arquivo_final = os.path.join(
    caminho_saida,
    "movimento_flat.csv"
)

# Garante que o diretório de saída exista
os.makedirs(
    caminho_saida,
    exist_ok=True
)


# Remove o arquivo final anterior, caso exista
if os.path.exists(arquivo_final):
    os.remove(arquivo_final)


# Spark grava o resultado em um diretório
df_movimento_flat.coalesce(1).write \
    .mode("overwrite") \
    .option("header", "true") \
    .option("sep", ";") \
    .csv(diretorio_temporario)


# Localiza o arquivo CSV criado pelo Spark
arquivos_csv = glob.glob(
    os.path.join(diretorio_temporario, "part-*.csv")
)


# Move o arquivo gerado para o nome definitivo
shutil.move(
    arquivos_csv[0],
    arquivo_final
)


# Remove o diretório temporário e arquivos auxiliares
shutil.rmtree(diretorio_temporario)


print("\n")
print("=" * 60)
print("ETL FINALIZADO COM SUCESSO")
print(f"Arquivo gerado: {arquivo_final}")
print(f"Quantidade de registros: {quantidade_registros}")
print("=" * 60)


# Finaliza a sessão
spark.stop()