CREATE TABLE associado (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    idade INTEGER,
    email VARCHAR(150)
);

CREATE TABLE conta (
    id SERIAL PRIMARY KEY,
    tipo_conta VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP NOT NULL,
    id_associado INTEGER NOT NULL,

    CONSTRAINT fk_conta_associado
        FOREIGN KEY (id_associado)
        REFERENCES associado(id)
);

CREATE TABLE cartao (
    id SERIAL PRIMARY KEY,
    num_cartao VARCHAR(19) NOT NULL,
    nom_impresso VARCHAR(100) NOT NULL,
    id_conta INTEGER NOT NULL,
    id_associado INTEGER NOT NULL,

    CONSTRAINT fk_cartao_conta
        FOREIGN KEY (id_conta)
        REFERENCES conta(id),

    CONSTRAINT fk_cartao_associado
        FOREIGN KEY (id_associado)
        REFERENCES associado(id)
);

CREATE TABLE movimento (
    id SERIAL PRIMARY KEY,
    vlr_transacao DECIMAL(10,2) NOT NULL,
    des_transacao VARCHAR(255),
    data_movimento TIMESTAMP NOT NULL,
    id_cartao INTEGER NOT NULL,

    CONSTRAINT fk_movimento_cartao
        FOREIGN KEY (id_cartao)
        REFERENCES cartao(id)
);