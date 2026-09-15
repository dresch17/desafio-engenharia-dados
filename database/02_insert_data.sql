-- INSERE ASSOCIADOS
INSERT INTO associado (nome, sobrenome, idade, email)
VALUES
('João', 'Silva', 35, 'joao.silva@email.com'),
('Maria', 'Oliveira', 29, 'maria.oliveira@email.com'),
('Carlos', 'Souza', 42, 'carlos.souza@email.com'),
('Ana', 'Pereira', 31, 'ana.pereira@email.com'),
('Lucas', 'Ferreira', 27, 'lucas.ferreira@email.com'),
('Fernanda', 'Almeida', 38, 'fernanda.almeida@email.com'),
('Rafael', 'Costa', 45, 'rafael.costa@email.com'),
('Juliana', 'Rocha', 33, 'juliana.rocha@email.com'),
('Bruno', 'Martins', 40, 'bruno.martins@email.com'),
('Patricia', 'Lima', 36, 'patricia.lima@email.com');


-- INSERE CONTAS
INSERT INTO conta (tipo_conta, data_criacao, id_associado)
VALUES
('CORRENTE', '2024-01-10 10:00:00', 1),
('POUPANCA', '2024-02-15 14:30:00', 1),
('CORRENTE', '2024-03-20 09:15:00', 2),
('POUPANCA', '2024-04-02 11:40:00', 2),
('CORRENTE', '2024-04-05 11:00:00', 3),
('CORRENTE', '2024-05-01 08:20:00', 4),
('POUPANCA', '2024-05-18 15:10:00', 5),
('CORRENTE', '2024-06-12 13:50:00', 6),
('CORRENTE', '2024-07-08 10:30:00', 7),
('POUPANCA', '2024-07-20 16:40:00', 7),
('CORRENTE', '2024-08-03 09:00:00', 8),
('CORRENTE', '2024-08-28 17:25:00', 9),
('POUPANCA', '2024-09-10 12:15:00', 10),
('CORRENTE', '2024-09-22 18:00:00', 10);


-- INSERE CARTOES
INSERT INTO cartao (num_cartao, nom_impresso, id_conta, id_associado)
VALUES
('1111222233334444', 'JOAO SILVA', 1,1),
('5555666677778888', 'JOAO SILVA', 2,1),
('9999000011112222', 'MARIA OLIVEIRA', 3,2),
('2222333344445555', 'MARIA OLIVEIRA', 4,2),
('3333444455556666', 'CARLOS SOUZA', 5,3),
('4444555566667777', 'ANA PEREIRA', 6,4),
('5555777788889999', 'LUCAS FERREIRA', 7,5),
('6666888899990000', 'FERNANDA ALMEIDA', 8,6),
('7777999900001111', 'RAFAEL COSTA', 9,7),
('8888000011112222', 'RAFAEL COSTA',10,7),
('9999111122223333', 'JULIANA ROCHA',11,8),
('1111333344445555', 'BRUNO MARTINS',12,9),
('2222444455556666', 'PATRICIA LIMA',13,10),
('3333555566667777', 'PATRICIA LIMA',14,10),
('4444666677778888', 'JOAO SILVA',1,1),
('5555888899991111', 'CARLOS SOUZA',5,3),
('6666999900002222', 'ANA PEREIRA',6,4),
('7777000011113333', 'BRUNO MARTINS',12,9);


-- INSERE MOVIMENTOS
INSERT INTO movimento (vlr_transacao, des_transacao, data_movimento, id_cartao)
VALUES
(150.90,'Supermercado','2026-09-01 10:30:00',1),
(89.50,'Posto de Combustivel','2026-09-02 18:15:00',1),
(45.90,'Padaria','2026-09-03 07:40:00',1),

(250.00,'Restaurante','2026-09-03 20:45:00',2),
(18.50,'Cafe','2026-09-04 09:20:00',2),

(1200.00,'Loja de Eletronicos','2026-09-04 14:20:00',3),
(220.00,'Farmacia','2026-09-05 11:05:00',3),

(380.40,'Mercado','2026-09-06 17:10:00',4),

(75.90,'Farmacia','2026-09-05 09:10:00',5),
(980.00,'Hotel','2026-09-07 22:15:00',5),

(210.35,'Supermercado','2026-09-08 16:50:00',6),
(35.00,'Aplicativo de Transporte','2026-09-09 08:45:00',6),

(560.00,'Loja de Roupas','2026-09-10 13:30:00',7),

(99.90,'Streaming','2026-09-11 20:00:00',8),
(310.50,'Academia','2026-09-12 18:30:00',8),

(1450.00,'Passagem Aerea','2026-09-13 09:15:00',9),
(67.20,'Lanchonete','2026-09-13 12:20:00',9),

(420.00,'Mercado','2026-09-14 19:45:00',10),
(890.00,'Moveis','2026-09-15 10:10:00',10),

(155.75,'Combustivel','2026-09-16 08:30:00',11),
(78.90,'Padaria','2026-09-16 17:20:00',11),

(240.00,'Cinema','2026-09-17 21:00:00',12),
(530.00,'Eletrodomesticos','2026-09-18 14:45:00',12),

(62.40,'Pet Shop','2026-09-19 16:00:00',13),
(840.00,'Curso Online','2026-09-20 11:10:00',13),

(180.00,'Supermercado','2026-09-21 18:20:00',14),
(59.90,'Assinatura Digital','2026-09-22 07:30:00',15),

(320.00,'Restaurante','2026-09-23 20:50:00',16),
(410.00,'Loja Esportiva','2026-09-24 15:35:00',17),
(28.50,'Cafeteria','2026-09-25 08:15:00',18);