import os
import csv


ARQUIVO = "output/movimento_flat.csv"


def test_arquivo_foi_gerado():
    assert os.path.exists(ARQUIVO), \
        "O arquivo movimento_flat.csv não foi gerado"


def test_quantidade_registros():
    with open(ARQUIVO, "r", encoding="utf-8") as arquivo:
        leitor = csv.DictReader(arquivo, delimiter=";")
        registros = list(leitor)

    assert len(registros) == 30, \
        f"Esperados 30 registros, encontrados {len(registros)}"

COLUNAS_ESPERADAS = [
    "nome_associado",
    "sobrenome_associado",
    "idade_associado",
    "vlr_transacao_movimento",
    "des_transacao_movimento",
    "data_movimento",
    "numero_cartao",
    "nome_impresso_cartao",
    "tipo_conta",
    "data_criacao_conta"
]


def test_colunas_esperadas():
    with open(ARQUIVO, "r", encoding="utf-8") as arquivo:
        leitor = csv.DictReader(arquivo, delimiter=";")

        assert leitor.fieldnames == COLUNAS_ESPERADAS, \
            f"Colunas encontradas: {leitor.fieldnames}"


def test_campos_obrigatorios():
    campos_obrigatorios = [
        "nome_associado",
        "sobrenome_associado",
        "vlr_transacao_movimento",
        "data_movimento",
        "numero_cartao",
        "nome_impresso_cartao",
        "tipo_conta"
    ]

    with open(ARQUIVO, "r", encoding="utf-8") as arquivo:
        leitor = csv.DictReader(arquivo, delimiter=";")

        for numero_linha, registro in enumerate(leitor, start=2):
            for campo in campos_obrigatorios:
                assert registro[campo], \
                    f"Campo {campo} vazio na linha {numero_linha}"