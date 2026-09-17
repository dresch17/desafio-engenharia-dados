# desafio-engenharia-dados

Desafio técnico de Engenharia de Dados - POC Data Lake

# Desafio de Engenharia de Dados

## Objetivo

Este projeto foi desenvolvido como parte de uma Prova de Conceito (POC) para apoiar a construção de um Data Lake, consolidando informações relacionadas às movimentações de cartões dos associados.

A solução modela os dados em uma base relacional, realiza a ingestão e o processamento das informações utilizando Apache Spark e gera uma visão única em formato CSV contendo dados do associado, conta, cartão e suas movimentações.

O objetivo da visão consolidada é disponibilizar os dados de forma adequada para consumo por processos analíticos e outras aplicações de dados.

---

## Arquitetura da solução

O fluxo desenvolvido possui a seguinte arquitetura:

```text

PostgreSQL

    |

    | JDBC

    v

Apache Spark / PySpark

    |

    | Leitura das tabelas

    | JOINs e transformação

    v

DataFrame movimento_flat

    |

    v

CSV

output/movimento_flat.csv

```

Todo o ambiente é executado utilizando Docker e Docker Compose.

O projeto possui dois serviços principais:

- **PostgreSQL:** armazenamento dos dados relacionais.

- **Apache Spark:** processamento e transformação dos dados utilizando PySpark.

Os containers são executados na mesma rede criada pelo Docker Compose, permitindo que o Spark acesse o PostgreSQL através do nome do serviço `postgres`.

---

## Tecnologias utilizadas

- PostgreSQL 16

- Apache Spark 3.5.9

- PySpark

- Python

- Docker

- Docker Compose

- JDBC PostgreSQL

- Pytest

- Git / GitHub

---

## Modelo de dados

A base relacional é composta pelas seguintes entidades:

### Associado

Contém os dados cadastrais dos associados.

Principais campos:

- `id`

- `nome`

- `sobrenome`

- `idade`

- `email`

### Conta

Representa as contas pertencentes aos associados.

Principais campos:

- `id`

- `tipo_conta`

- `data_criacao`

- `id_associado`

### Cartao

Representa os cartões vinculados às contas e aos associados.

Principais campos:

- `id`

- `num_cartao`

- `nom_impresso`

- `id_conta`

- `id_associado`

O número do cartão foi armazenado utilizando `VARCHAR`, pois é um identificador e não um valor utilizado em operações matemáticas.

### Movimento

Contém as movimentações realizadas através dos cartões.

Principais campos:

- `id`

- `vlr_transacao`

- `des_transacao`

- `data_movimento`

- `id_cartao`

---

## Estrutura do projeto

```text

.

├── database/

│   ├── 01_create_tables.sql

│   └── 02_insert_data.sql

│

├── src/

│   └── etl.py

│

├── tests/

│   └── test_output.py

│

├── output/

│   └── movimento_flat.csv

│

├── Dockerfile.spark

├── docker-compose.yml

├── requirements.txt

├── run_etl.bat

└── README.md

```

Todos os scripts necessários para criação das estruturas e carga inicial da base estão versionados dentro do projeto.

---

## Massa de dados

Foi criada uma massa de dados para permitir a execução e validação da POC.

A base possui:

- 10 associados

- 14 contas

- 18 cartões

- 30 movimentos

Os scripts responsáveis pela criação e carga estão disponíveis em:

```text

database/01_create_tables.sql

database/02_insert_data.sql

```

Na primeira inicialização do PostgreSQL, esses scripts são executados automaticamente pelo container.

---

## Processamento ETL

O processamento está implementado em:

```text

src/etl.py

```

O processo executa as seguintes etapas:

1. Criação da SparkSession.

2. Conexão ao PostgreSQL através de JDBC.

3. Leitura das tabelas `associado`, `conta`, `cartao` e `movimento`.

4. Criação dos DataFrames.

5. Realização dos JOINs entre as entidades.

6. Seleção e padronização das colunas do flat.

7. Conversão dos campos para String conforme o layout de saída.

8. Geração do arquivo CSV.

O resultado é disponibilizado em:

```text

output/movimento_flat.csv

```

---

## Layout do arquivo de saída

O arquivo possui as seguintes colunas:

```text

nome_associado

sobrenome_associado

idade_associado

vlr_transacao_movimento

des_transacao_movimento

data_movimento

numero_cartao

nome_impresso_cartao

tipo_conta

data_criacao_conta

```

O CSV utiliza `;` como delimitador e possui cabeçalho.

---

## Observação sobre `data_criacao_cartao`

O layout esperado apresenta o campo `data_criacao_cartao`.

Entretanto, o modelo de dados fornecido para a entidade `cartao` não possui o atributo `data_criacao`.

Para preservar a integridade do modelo de origem e evitar a criação de informações não fornecidas, esse campo não foi incluído no arquivo final.

Caso o atributo seja disponibilizado futuramente na origem, ele poderá ser incorporado ao pipeline sem alteração significativa da arquitetura da solução.

---

## Por que esta arquitetura foi escolhida?

O PostgreSQL foi escolhido como banco relacional por oferecer suporte adequado ao modelo proposto, incluindo chaves primárias, chaves estrangeiras e integridade referencial.

O Apache Spark com PySpark foi utilizado como camada de processamento. Embora o volume de dados desta POC seja pequeno, a utilização do Spark demonstra uma arquitetura que pode ser adaptada para volumes significativamente maiores e permite que as transformações sejam realizadas através de processamento distribuído.

O Docker foi utilizado para isolar as dependências e tornar o ambiente reproduzível, evitando a necessidade de instalar PostgreSQL, Java e Spark diretamente na máquina responsável pela execução do projeto.

O Docker Compose permite subir os componentes da solução de maneira integrada e cria a comunicação entre os containers.

---

## Como executar

### Pré-requisitos

É necessário possuir:

- Git

- Docker

- Docker Compose

Não é necessário instalar PostgreSQL, Java, Apache Spark ou Python localmente.

### 1. Clonar o repositório

```bash

git clone <URL_DO_REPOSITORIO>

cd <NOME_DO_REPOSITORIO>

```

### 2. Subir o ambiente

Execute:

```bash

docker compose up -d

```

Esse comando realiza automaticamente o provisionamento inicial da solução.

Na primeira execução, o seguinte fluxo ocorre:

```text

Docker Compose

      |

      +--> PostgreSQL

      |       |

      |       +--> cria o banco cooperativa

      |       +--> cria as tabelas

      |       +--> insere a massa de dados

      |       +--> healthcheck aguarda o banco ficar disponível

      |

      +--> Apache Spark

      |

      +--> ETL

              |

              +--> aguarda o PostgreSQL ficar disponível

              +--> lê as quatro tabelas via JDBC

              +--> realiza os JOINs

              +--> gera a visão flat

              +--> grava o arquivo CSV

              +--> encerra a execução

```

Portanto, **não é necessário executar o ETL manualmente após o

`docker compose up -d` na primeira inicialização**.

O serviço `etl` é um processo de execução única. Após concluir o processamento

com sucesso, é esperado que ele apareça com status `Exited (0)`.

Para verificar o estado dos containers:

```bash

docker compose ps -a

```

Um resultado semelhante ao seguinte indica uma execução bem-sucedida:

```text

desafio_postgres   Up (healthy)

desafio_spark      Up

desafio_etl        Exited (0)

```

### 3. Verificar o resultado

Após a execução inicial, o arquivo gerado estará disponível em:

```text

output/

└── movimento_flat.csv

```

O arquivo `movimento_flat.csv` é o resultado final do processamento e contém

a visão consolidada dos associados, contas, cartões e movimentos.

---

## Executar o ETL novamente

Após o ambiente estar em execução, o ETL pode ser executado novamente sem

recriar o banco de dados.

### Execução pelo Docker

```bash

docker compose run --rm etl

```

Ao final de uma execução bem-sucedida será exibida uma mensagem semelhante a:

```text

============================================================

ETL FINALIZADO COM SUCESSO

Arquivo gerado: /opt/spark/work-dir/output/movimento_flat.csv

Quantidade de registros: 30

============================================================

```

### Execução com diretório de saída parametrizado

No Windows também está disponível o script:

```powershell

.\run_etl.bat

```

Sem informar um diretório, a saída padrão será:

```text

output/movimento_flat.csv

```

O diretório pode ser alterado através de um parâmetro:

```powershell

.\run_etl.bat minha_saida

```

Nesse caso, o resultado será:

```text

minha_saida/

└── movimento_flat.csv

```

Dessa forma, o diretório é parametrizável sem tornar o pipeline interativo,

permitindo sua utilização em processos automatizados.

---

## Executar os testes

Com o ambiente em execução:

```bash

docker compose exec spark python3 -m pytest tests -v

```

O resultado esperado atualmente é:

```text

4 passed

```

Os testes validam:

- geração do arquivo CSV;

- quantidade esperada de registros;

- estrutura e nomes das colunas;

- preenchimento dos campos obrigatórios.

---

## Encerrar o ambiente

Para parar e remover os containers:

```bash

docker compose down

```

Os dados do PostgreSQL permanecem preservados no volume Docker.

Para remover também o volume e recriar completamente a base na próxima

execução:

```bash

docker compose down -v

```

> **Atenção:** o comando `docker compose down -v` remove o volume do

> PostgreSQL. Na próxima execução de `docker compose up -d`, o banco,

> as tabelas e a massa de dados serão criados novamente pelos scripts

> disponíveis em `database/`.

---

## Decisões técnicas

### Processamento dos JOINs no Spark

Os relacionamentos entre as tabelas são realizados no PySpark, em vez de executar uma consulta SQL já consolidada no PostgreSQL.

Essa abordagem mantém a etapa de transformação dentro da camada de processamento e demonstra o uso do framework distribuído solicitado para a solução.

### Número do cartão

O campo `num_cartao` utiliza um tipo textual (`VARCHAR`) porque representa um identificador. Não são realizadas operações aritméticas sobre esse valor.

### Geração de um único CSV

Por padrão, o Spark pode produzir múltiplos arquivos `part-*.csv`, de acordo com o número de partições.

Como a entrega solicita um único arquivo CSV e a massa utilizada nesta POC é pequena, o DataFrame é reduzido para uma partição através de `coalesce(1)`.

Após a escrita, o arquivo gerado pelo Spark é movido para:

```text

output/movimento_flat.csv

```

Em um cenário de grande volume de dados, concentrar todo o processamento de saída em uma única partição poderia causar perda de desempenho. Nesse caso, seria preferível manter a saída particionada.

---

## Dificuldades encontradas

Durante o desenvolvimento foram encontrados alguns pontos que exigiram ajustes:

- configuração inicial do WSL e Docker no Windows;

- configuração da comunicação entre os containers Spark e PostgreSQL;

- disponibilização do driver JDBC do PostgreSQL para o Spark;

- configuração do diretório utilizado pelo Ivy para resolução das dependências;

- comportamento padrão do Spark ao gerar arquivos CSV particionados;

- criação de uma imagem Spark personalizada para incluir as dependências utilizadas nos testes.

Esses pontos foram tratados através da configuração do Docker Compose, da criação do `Dockerfile.spark` e da organização dos scripts do projeto.

---

## Melhorias futuras

Com mais tempo para evolução da solução, poderiam ser implementadas melhorias como:

- testes diretamente sobre os DataFrames e regras de transformação;

- validações adicionais de qualidade dos dados;

- tratamento e registro estruturado de erros;

- logging mais controlado durante a execução do Spark;

- parametrização das credenciais e configurações através de variáveis de ambiente;

- utilização de gerenciamento seguro de secrets;

- suporte a execução do ETL também através de script shell para Linux/macOS;

- inclusão de verificações de consistência entre associado, conta e cartão;

- implementação de CI para execução automática dos testes;

- estratégias de particionamento para processamento de volumes maiores.

---

## Considerações finais

A solução implementa um fluxo completo de Engenharia de Dados, desde a criação e carga da base relacional até o processamento distribuído e geração do arquivo flat.

A utilização de Docker e Docker Compose permite reproduzir o ambiente, enquanto PostgreSQL mantém os dados relacionais e PySpark executa as etapas de leitura, relacionamento e transformação.

Os scripts de criação da estrutura, carga dos dados, processamento e testes permanecem versionados junto ao projeto, permitindo reproduzir e validar a solução.
