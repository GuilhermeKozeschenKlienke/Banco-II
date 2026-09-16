-- ================================================================
-- BANCO DE DADOS II — DESAFIO FINAL DO SEMESTRE
-- EMPRESA: SPORTZONE
-- Relatório Gerencial Executivo — Consultas SQL
-- Dialeto: MySQL
-- ================================================================
-- Este arquivo reúne todas as consultas desenvolvidas para o
-- desafio: os 3 relatórios gerenciais (Clientes, Produtos e
-- Vendedores), os 10 KPIs obrigatórios solicitados pela diretoria
-- e os 5 KPIs adicionais criados pela dupla.
--
-- Convenções adotadas:
--   * CTEs (WITH) são usadas para separar o cálculo de totais por
--     venda antes de agregar por cliente/produto/vendedor, evitando
--     o efeito de duplicação de linhas ("fan-out") que ocorreria
--     ao agregar diretamente sobre o JOIN de vendas + itens_venda.
--   * LEFT JOIN é usado sempre que a regra de negócio exige que
--     TODOS os registros de uma tabela apareçam no resultado,
--     mesmo sem correspondência (ex.: clientes sem compras).
--   * COALESCE() trata os valores nulos resultantes do LEFT JOIN,
--     transformando-os em zero ou em um texto explicativo.
-- ================================================================
-- ============================================================
-- BANCO DE DADOS II
-- DESAFIO FINAL DO SEMESTRE
-- EMPRESA: SPORTZONE
-- ============================================================

DROP DATABASE IF EXISTS sportzone;

CREATE DATABASE sportzone;


USE sportzone;


-- ============================================================
-- TABELA: CLIENTES
-- ============================================================

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    cidade VARCHAR(80) NOT NULL,
    estado CHAR(2) NOT NULL,
    renda DECIMAL(10,2),
    data_cadastro DATE NOT NULL
);


-- ============================================================
-- TABELA: VENDEDORES
-- ============================================================

CREATE TABLE vendedores (
    id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    cidade VARCHAR(80) NOT NULL,
    data_admissao DATE NOT NULL
);


-- ============================================================
-- TABELA: PRODUTOS
-- ============================================================

CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    categoria VARCHAR(60) NOT NULL,
    marca VARCHAR(60) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CHECK (preco >= 0),
    CHECK (estoque >= 0)
);


-- ============================================================
-- TABELA: VENDAS
-- ============================================================

CREATE TABLE vendas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_vendedor INT NOT NULL,
    data_venda DATE NOT NULL,
    forma_pagamento VARCHAR(30) NOT NULL,

    CONSTRAINT fk_vendas_clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),

    CONSTRAINT fk_vendas_vendedores
        FOREIGN KEY (id_vendedor)
        REFERENCES vendedores(id_vendedor)
);


-- ============================================================
-- TABELA: ITENS_VENDA
-- ============================================================

CREATE TABLE itens_venda (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_itens_vendas
        FOREIGN KEY (id_venda)
        REFERENCES vendas(id_venda),

    CONSTRAINT fk_itens_produtos
        FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto),

    CHECK (quantidade > 0),
    CHECK (preco_unitario >= 0)
);


-- ============================================================
-- INSERTS: CLIENTES
-- ============================================================

INSERT INTO clientes
(nome, cpf, cidade, estado, renda, data_cadastro)
VALUES
('Lucas Almeida',       '111.111.111-01', 'Curitiba',          'PR', 8500.00,  '2026-01-10'),
('Mariana Costa',       '111.111.111-02', 'Curitiba',          'PR', 6200.00,  '2026-01-15'),
('Rafael Martins',      '111.111.111-03', 'São José dos Pinhais','PR', 4800.00,'2026-01-20'),
('Fernanda Oliveira',   '111.111.111-04', 'Colombo',           'PR', 7300.00,  '2026-02-03'),
('Bruno Souza',         '111.111.111-05', 'Curitiba',          'PR', 3900.00,  '2026-02-12'),
('Camila Rodrigues',    '111.111.111-06', 'Pinhais',           'PR', 9100.00,  '2026-02-18'),
('Gustavo Pereira',     '111.111.111-07', 'Araucária',         'PR', 5200.00,  '2026-03-01'),
('Juliana Santos',      '111.111.111-08', 'Curitiba',          'PR', 6800.00,  '2026-03-08'),
('Felipe Lima',         '111.111.111-09', 'Campo Largo',       'PR', 4400.00,  '2026-03-15'),
('Amanda Ribeiro',      '111.111.111-10', 'Curitiba',          'PR', 12500.00, '2026-03-22'),
('Diego Ferreira',      '111.111.111-11', 'Pinhais',           'PR', 5800.00,  '2026-04-02'),
('Patrícia Gomes',      '111.111.111-12', 'Colombo',           'PR', 7600.00,  '2026-04-11'),
('André Moreira',       '111.111.111-13', 'Curitiba',          'PR', 3300.00,  '2026-04-18'),
('Larissa Alves',       '111.111.111-14', 'Araucária',         'PR', 8700.00,  '2026-05-01'),
('Rodrigo Barbosa',     '111.111.111-15', 'Curitiba',          'PR', 10200.00, '2026-05-09'),
('Beatriz Cardoso',     '111.111.111-16', 'Pinhais',           'PR', 4600.00,  '2026-05-20'),
('Eduardo Nunes',       '111.111.111-17', 'Curitiba',          'PR', 5500.00,  '2026-06-01'),
('Natália Rocha',       '111.111.111-18', 'Campo Largo',       'PR', 6900.00,  '2026-06-10'),
('Henrique Freitas',    '111.111.111-19', 'Colombo',           'PR', 4100.00,  '2026-06-18'),
('Isabela Teixeira',    '111.111.111-20', 'Curitiba',          'PR', 9800.00,  '2026-06-25');


-- ============================================================
-- INSERTS: VENDEDORES
-- ============================================================

INSERT INTO vendedores
(nome, email, cidade, data_admissao)
VALUES
('Carlos Mendes',   'carlos@sportzone.com.br',   'Curitiba', '2024-02-01'),
('Ana Paula Silva', 'ana@sportzone.com.br',      'Curitiba', '2024-05-10'),
('João Ribeiro',    'joao@sportzone.com.br',     'Pinhais',  '2025-01-15'),
('Renata Lopes',    'renata@sportzone.com.br',   'Curitiba', '2025-03-12'),
('Marcelo Torres',  'marcelo@sportzone.com.br',  'Colombo',  '2025-07-20'),
('Bianca Martins',  'bianca@sportzone.com.br',   'Curitiba', '2025-10-05'),
('Paulo Henrique',  'paulo@sportzone.com.br',    'Pinhais',  '2026-01-08'),
('Sabrina Costa',   'sabrina@sportzone.com.br',  'Curitiba', '2026-07-01');


-- Observação:
-- Sabrina Costa propositalmente não possuirá vendas.


-- ============================================================
-- INSERTS: PRODUTOS
-- ============================================================

INSERT INTO produtos
(nome, categoria, marca, preco, estoque, ativo)
VALUES
('Tênis Running Pro',           'Calçados',    'RunFast',   499.90, 18, TRUE),
('Tênis Urban Flex',            'Calçados',    'RunFast',   359.90, 25, TRUE),
('Tênis Trail Adventure',       'Calçados',    'MountainX', 549.90, 12, TRUE),

('Camiseta Dry Fit Masculina',  'Vestuário',   'SportMax',   89.90, 45, TRUE),
('Camiseta Dry Fit Feminina',   'Vestuário',   'SportMax',   89.90, 38, TRUE),
('Shorts Performance',          'Vestuário',   'SportMax',  119.90, 30, TRUE),
('Legging Training',            'Vestuário',   'FitLife',   159.90, 28, TRUE),
('Jaqueta Corta-Vento',         'Vestuário',   'MountainX', 299.90, 14, TRUE),

('Mochila Esportiva 30L',       'Acessórios',  'Adventure', 219.90, 20, TRUE),
('Garrafa Térmica 1L',          'Acessórios',  'HydroFit',  129.90, 40, TRUE),
('Luvas de Academia',           'Acessórios',  'FitLife',    79.90, 35, TRUE),
('Boné Sport Performance',      'Acessórios',  'SportMax',   69.90, 32, TRUE),

('Halter 10kg',                 'Musculação',  'StrongFit', 179.90, 15, TRUE),
('Kit Halteres 20kg',           'Musculação',  'StrongFit', 499.90, 10, TRUE),
('Banco de Musculação',         'Musculação',  'StrongFit', 899.90, 6, TRUE),

('Bola de Futebol Pro',         'Esportes',    'Arena',     149.90, 22, TRUE),
('Bola de Basquete Street',     'Esportes',    'Arena',     169.90, 16, TRUE),
('Raquete de Tênis Carbon',     'Esportes',    'Winner',    649.90, 8, TRUE),

('Corda de Pular Speed',        'Fitness',     'FitLife',    59.90, 50, TRUE),
('Colchonete Premium',          'Fitness',     'FitLife',   139.90, 26, TRUE),

('Step Aeróbico Profissional',  'Fitness',     'FitLife',   259.90, 10, TRUE),
('Kettlebell 16kg',             'Musculação',  'StrongFit', 229.90, 12, TRUE);


-- Observação:
-- Produtos 21 e 22 propositalmente nunca serão vendidos.


-- ============================================================
-- INSERTS: VENDAS
-- ============================================================

INSERT INTO vendas
(id_cliente, id_vendedor, data_venda, forma_pagamento)
VALUES
(1,  1, '2026-01-15', 'Cartão de Crédito'),
(2,  2, '2026-01-20', 'PIX'),
(3,  3, '2026-02-03', 'Cartão de Débito'),
(1,  1, '2026-02-10', 'PIX'),
(4,  4, '2026-02-17', 'Cartão de Crédito'),

(5,  2, '2026-03-02', 'PIX'),
(6,  1, '2026-03-06', 'Cartão de Crédito'),
(2,  3, '2026-03-12', 'Cartão de Crédito'),
(7,  5, '2026-03-18', 'PIX'),
(8,  4, '2026-03-25', 'Cartão de Débito'),

(10, 1, '2026-04-02', 'Cartão de Crédito'),
(3,  3, '2026-04-07', 'PIX'),
(11, 6, '2026-04-13', 'Cartão de Crédito'),
(12, 2, '2026-04-21', 'PIX'),
(1,  1, '2026-04-29', 'Cartão de Crédito'),

(14, 5, '2026-05-05', 'Cartão de Débito'),
(15, 1, '2026-05-10', 'Cartão de Crédito'),
(6,  4, '2026-05-15', 'PIX'),
(8,  2, '2026-05-22', 'Cartão de Crédito'),
(10, 3, '2026-05-30', 'PIX'),

(2,  2, '2026-06-04', 'Cartão de Crédito'),
(11, 6, '2026-06-09', 'PIX'),
(14, 5, '2026-06-14', 'Cartão de Crédito'),
(17, 7, '2026-06-19', 'PIX'),
(1,  1, '2026-06-26', 'Cartão de Crédito'),

(15, 4, '2026-07-03', 'Cartão de Crédito'),
(3,  3, '2026-07-08', 'PIX'),
(10, 1, '2026-07-14', 'Cartão de Crédito'),
(18, 7, '2026-07-21', 'PIX'),
(6,  6, '2026-07-29', 'Cartão de Crédito'),

(8,  2, '2026-08-02', 'PIX'),
(14, 5, '2026-08-08', 'Cartão de Crédito'),
(2,  3, '2026-08-15', 'Cartão de Débito'),
(15, 4, '2026-08-22', 'PIX'),
(10, 1, '2026-08-29', 'Cartão de Crédito'),

(1,  1, '2026-09-02', 'PIX'),
(17, 7, '2026-09-04', 'Cartão de Crédito'),
(6,  6, '2026-09-06', 'Cartão de Crédito'),
(14, 5, '2026-09-07', 'PIX'),
(10, 1, '2026-09-08', 'Cartão de Crédito');


-- Clientes propositalmente sem nenhuma compra:
-- 9  - Felipe Lima
-- 13 - André Moreira
-- 16 - Beatriz Cardoso
-- 19 - Henrique Freitas
-- 20 - Isabela Teixeira


-- ============================================================
-- INSERTS: ITENS_VENDA
-- ============================================================

INSERT INTO itens_venda
(id_venda, id_produto, quantidade, preco_unitario)
VALUES

-- VENDA 01
(1, 1, 1, 469.90),
(1, 4, 2, 84.90),
(1, 10, 1, 119.90),

-- VENDA 02
(2, 2, 1, 349.90),
(2, 5, 2, 89.90),

-- VENDA 03
(3, 16, 1, 139.90),
(3, 12, 1, 69.90),
(3, 19, 1, 59.90),

-- VENDA 04
(4, 13, 2, 169.90),
(4, 11, 1, 79.90),

-- VENDA 05
(5, 7, 1, 149.90),
(5, 5, 2, 84.90),
(5, 10, 1, 129.90),

-- VENDA 06
(6, 4, 3, 79.90),
(6, 6, 1, 109.90),

-- VENDA 07
(7, 14, 1, 479.90),
(7, 20, 2, 129.90),

-- VENDA 08
(8, 1, 1, 499.90),
(8, 9, 1, 209.90),

-- VENDA 09
(9, 3, 1, 529.90),
(9, 8, 1, 289.90),

-- VENDA 10
(10, 5, 2, 89.90),
(10, 7, 1, 159.90),

-- VENDA 11
(11, 15, 1, 849.90),
(11, 14, 1, 489.90),
(11, 11, 2, 74.90),

-- VENDA 12
(12, 16, 2, 144.90),
(12, 4, 1, 89.90),

-- VENDA 13
(13, 2, 1, 359.90),
(13, 10, 2, 124.90),

-- VENDA 14
(14, 17, 1, 159.90),
(14, 12, 2, 64.90),

-- VENDA 15
(15, 18, 1, 619.90),
(15, 3, 1, 519.90),

-- VENDA 16
(16, 6, 2, 119.90),
(16, 7, 1, 149.90),
(16, 19, 2, 54.90),

-- VENDA 17
(17, 1, 2, 479.90),
(17, 10, 1, 129.90),

-- VENDA 18
(18, 4, 2, 84.90),
(18, 5, 2, 84.90),
(18, 20, 1, 139.90),

-- VENDA 19
(19, 9, 1, 219.90),
(19, 12, 1, 69.90),

-- VENDA 20
(20, 13, 1, 179.90),
(20, 14, 1, 499.90),

-- VENDA 21
(21, 2, 1, 349.90),
(21, 6, 2, 114.90),

-- VENDA 22
(22, 11, 2, 79.90),
(22, 20, 1, 134.90),

-- VENDA 23
(23, 3, 1, 549.90),
(23, 8, 1, 299.90),

-- VENDA 24
(24, 16, 2, 149.90),
(24, 4, 2, 89.90),

-- VENDA 25
(25, 1, 1, 489.90),
(25, 18, 1, 629.90),

-- VENDA 26
(26, 15, 1, 899.90),
(26, 13, 2, 174.90),

-- VENDA 27
(27, 17, 1, 169.90),
(27, 12, 2, 69.90),

-- VENDA 28
(28, 14, 2, 489.90),
(28, 10, 2, 129.90),

-- VENDA 29
(29, 19, 3, 59.90),
(29, 20, 2, 139.90),

-- VENDA 30
(30, 7, 2, 154.90),
(30, 5, 1, 89.90),
(30, 11, 1, 79.90),

-- VENDA 31
(31, 4, 2, 89.90),
(31, 6, 1, 119.90),
(31, 10, 1, 129.90),

-- VENDA 32
(32, 3, 1, 539.90),
(32, 9, 1, 219.90),

-- VENDA 33
(33, 16, 2, 144.90),
(33, 17, 1, 164.90),

-- VENDA 34
(34, 1, 1, 499.90),
(34, 8, 1, 299.90),
(34, 12, 1, 69.90),

-- VENDA 35
(35, 15, 1, 879.90),
(35, 14, 1, 499.90),
(35, 20, 1, 139.90),

-- VENDA 36
(36, 18, 1, 649.90),
(36, 11, 2, 79.90),

-- VENDA 37
(37, 2, 1, 359.90),
(37, 10, 2, 129.90),

-- VENDA 38
(38, 7, 2, 159.90),
(38, 4, 2, 89.90),

-- VENDA 39
(39, 3, 1, 549.90),
(39, 9, 1, 219.90),
(39, 19, 2, 59.90),

-- VENDA 40
(40, 15, 1, 899.90),
(40, 1, 1, 499.90),
(40, 10, 1, 129.90);

USE sportzone;


-- ################################################################
-- PARTE 1 — ANÁLISE DE CLIENTES
-- Objetivo: apresentar, para cada cliente, o volume e o valor de
-- suas compras, permitindo identificar clientes mais ativos, de
-- maior valor e clientes que nunca compraram. Todos os clientes
-- devem aparecer (LEFT JOIN + COALESCE).
-- ################################################################

WITH venda_totais AS (
    -- Um único INNER JOIN entre vendas e itens_venda, já agregado
    -- por venda, evita duplicar o valor da venda ao agregarmos
    -- novamente por cliente logo abaixo.
    SELECT
        v.id_venda,
        v.id_cliente,
        v.data_venda,
        SUM(iv.quantidade)                    AS qtd_produtos,
        SUM(iv.quantidade * iv.preco_unitario) AS valor_venda
    FROM vendas v
    INNER JOIN itens_venda iv ON iv.id_venda = v.id_venda
    GROUP BY v.id_venda, v.id_cliente, v.data_venda
)
SELECT
    c.nome                                                AS cliente,
    c.cidade,
    c.renda,
    COUNT(vt.id_venda)                                    AS qtd_compras,
    COALESCE(SUM(vt.qtd_produtos), 0)                     AS qtd_produtos_adquiridos,
    COALESCE(ROUND(SUM(vt.valor_venda), 2), 0)            AS valor_total_gasto,
    CASE WHEN COUNT(vt.id_venda) > 0
         THEN ROUND(SUM(vt.valor_venda) / COUNT(vt.id_venda), 2)
         ELSE 0
    END                                                    AS ticket_medio,
    COALESCE(MAX(vt.data_venda), 'Nunca comprou')         AS data_ultima_compra
FROM clientes c
LEFT JOIN venda_totais vt ON vt.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome, c.cidade, c.renda
ORDER BY valor_total_gasto DESC;


-- ################################################################
-- PARTE 2 — ANÁLISE DE PRODUTOS
-- Objetivo: medir o desempenho comercial de cada produto do
-- catálogo (vendas, faturamento e alcance de clientes), incluindo
-- produtos que nunca foram vendidos.
-- ################################################################

WITH vendas_produto AS (
    SELECT
        iv.id_produto,
        iv.quantidade,
        iv.preco_unitario,
        v.id_cliente
    FROM itens_venda iv
    INNER JOIN vendas v ON v.id_venda = iv.id_venda
)
SELECT
    p.nome                                                     AS produto,
    p.categoria,
    p.preco                                                    AS preco_atual,
    p.estoque,
    COALESCE(SUM(vp.quantidade), 0)                            AS qtd_vendida,
    COALESCE(ROUND(SUM(vp.quantidade * vp.preco_unitario), 2), 0) AS faturamento,
    COUNT(DISTINCT vp.id_cliente)                              AS clientes_diferentes
FROM produtos p
LEFT JOIN vendas_produto vp ON vp.id_produto = p.id_produto
GROUP BY p.id_produto, p.nome, p.categoria, p.preco, p.estoque
ORDER BY faturamento DESC;


-- ################################################################
-- PARTE 3 — ANÁLISE DE VENDEDORES
-- Objetivo: avaliar o desempenho comercial de cada vendedor,
-- incluindo vendedores que ainda não realizaram nenhuma venda.
-- ################################################################

WITH venda_totais AS (
    SELECT
        v.id_venda,
        v.id_vendedor,
        v.id_cliente,
        SUM(iv.quantidade)                     AS qtd_produtos,
        SUM(iv.quantidade * iv.preco_unitario)  AS valor_venda
    FROM vendas v
    INNER JOIN itens_venda iv ON iv.id_venda = v.id_venda
    GROUP BY v.id_venda, v.id_vendedor, v.id_cliente
)
SELECT
    ve.nome                                              AS vendedor,
    COUNT(vt.id_venda)                                   AS qtd_vendas,
    COUNT(DISTINCT vt.id_cliente)                        AS clientes_atendidos,
    COALESCE(SUM(vt.qtd_produtos), 0)                    AS qtd_produtos_vendidos,
    COALESCE(ROUND(SUM(vt.valor_venda), 2), 0)           AS faturamento_total,
    CASE WHEN COUNT(vt.id_venda) > 0
         THEN ROUND(SUM(vt.valor_venda) / COUNT(vt.id_venda), 2)
         ELSE 0
    END                                                    AS ticket_medio
FROM vendedores ve
LEFT JOIN venda_totais vt ON vt.id_vendedor = ve.id_vendedor
GROUP BY ve.id_vendedor, ve.nome
ORDER BY faturamento_total DESC;


-- ################################################################
-- PARTE 4 — KPIs GERENCIAIS OBRIGATÓRIOS (10)
-- ################################################################

-- ==================================================
-- KPI 01 — Cliente que mais gastou na SportZone
-- Objetivo: identificar o cliente que mais gerou receita
-- para a empresa, útil para ações de fidelização/VIP.
-- ==================================================
WITH venda_totais AS (
    SELECT v.id_venda, v.id_cliente,
           SUM(iv.quantidade * iv.preco_unitario) AS valor_venda
    FROM vendas v
    INNER JOIN itens_venda iv ON iv.id_venda = v.id_venda
    GROUP BY v.id_venda, v.id_cliente
),
gasto_cliente AS (
    SELECT c.id_cliente, c.nome, ROUND(SUM(vt.valor_venda), 2) AS total_gasto
    FROM clientes c
    INNER JOIN venda_totais vt ON vt.id_cliente = c.id_cliente
    GROUP BY c.id_cliente, c.nome
)
SELECT nome AS cliente, total_gasto
FROM gasto_cliente
WHERE total_gasto = (SELECT MAX(total_gasto) FROM gasto_cliente);


-- ==================================================
-- KPI 02 — Cliente com a maior quantidade de compras
-- Objetivo: identificar o cliente mais frequente (não
-- necessariamente o de maior valor), útil para programas
-- de recorrência/fidelidade.
-- Observação: usamos comparação com o MAX() em vez de
-- LIMIT para não descartar clientes empatados na 1ª posição.
-- ==================================================
WITH compras_cliente AS (
    SELECT c.id_cliente, c.nome, COUNT(v.id_venda) AS qtd_compras
    FROM clientes c
    INNER JOIN vendas v ON v.id_cliente = c.id_cliente
    GROUP BY c.id_cliente, c.nome
)
SELECT nome AS cliente, qtd_compras
FROM compras_cliente
WHERE qtd_compras = (SELECT MAX(qtd_compras) FROM compras_cliente);


-- ==================================================
-- KPI 03 — Produto com a maior quantidade de unidades vendidas
-- Objetivo: identificar o "carro-chefe" em volume, relevante
-- para planejamento de reposição de estoque.
-- ==================================================
WITH qtd_por_produto AS (
    SELECT p.id_produto, p.nome, SUM(iv.quantidade) AS qtd_vendida
    FROM produtos p
    INNER JOIN itens_venda iv ON iv.id_produto = p.id_produto
    GROUP BY p.id_produto, p.nome
)
SELECT nome AS produto, qtd_vendida
FROM qtd_por_produto
WHERE qtd_vendida = (SELECT MAX(qtd_vendida) FROM qtd_por_produto);


-- ==================================================
-- KPI 04 — Produto que gerou o maior faturamento
-- Objetivo: identificar o produto mais importante em receita,
-- mesmo que venda poucas unidades (produto de ticket alto).
-- ==================================================
WITH fat_por_produto AS (
    SELECT p.id_produto, p.nome,
           ROUND(SUM(iv.quantidade * iv.preco_unitario), 2) AS faturamento
    FROM produtos p
    INNER JOIN itens_venda iv ON iv.id_produto = p.id_produto
    GROUP BY p.id_produto, p.nome
)
SELECT nome AS produto, faturamento
FROM fat_por_produto
WHERE faturamento = (SELECT MAX(faturamento) FROM fat_por_produto);


-- ==================================================
-- KPI 05 — Produtos que nunca foram vendidos
-- Objetivo: apontar itens parados no catálogo, candidatos a
-- promoção, descontinuação ou revisão de compras.
-- Recurso: RIGHT JOIN (produtos como tabela "âncora") + IS NULL,
-- uma forma alternativa ao NOT EXISTS de encontrar "anti-join".
-- ==================================================
SELECT p.nome AS produto, p.categoria, p.estoque
FROM itens_venda iv
RIGHT JOIN produtos p ON p.id_produto = iv.id_produto
WHERE iv.id_item IS NULL;


-- ==================================================
-- KPI 06 — Vendedor com a maior quantidade de vendas
-- Objetivo: medir produtividade comercial (nº de vendas
-- fechadas), independente do valor de cada uma.
-- ==================================================
WITH vendas_por_vendedor AS (
    SELECT ve.id_vendedor, ve.nome, COUNT(v.id_venda) AS qtd_vendas
    FROM vendedores ve
    INNER JOIN vendas v ON v.id_vendedor = ve.id_vendedor
    GROUP BY ve.id_vendedor, ve.nome
)
SELECT nome AS vendedor, qtd_vendas
FROM vendas_por_vendedor
WHERE qtd_vendas = (SELECT MAX(qtd_vendas) FROM vendas_por_vendedor);


-- ==================================================
-- KPI 07 — Vendedor que gerou o maior faturamento
-- Objetivo: medir o resultado financeiro trazido por cada
-- vendedor, base para bonificação/comissionamento.
-- ==================================================
WITH fat_por_vendedor AS (
    SELECT ve.id_vendedor, ve.nome,
           ROUND(SUM(iv.quantidade * iv.preco_unitario), 2) AS faturamento
    FROM vendedores ve
    INNER JOIN vendas v ON v.id_vendedor = ve.id_vendedor
    INNER JOIN itens_venda iv ON iv.id_venda = v.id_venda
    GROUP BY ve.id_vendedor, ve.nome
)
SELECT nome AS vendedor, faturamento
FROM fat_por_vendedor
WHERE faturamento = (SELECT MAX(faturamento) FROM fat_por_vendedor);


-- ==================================================
-- KPI 08 — Quantidade de clientes que nunca compraram
-- Objetivo: dimensionar a base "inativa" da carteira, alvo de
-- campanhas de ativação/primeira compra.
-- Recurso: NOT EXISTS (subconsulta correlacionada).
-- ==================================================
SELECT COUNT(*) AS clientes_sem_compra
FROM clientes c
WHERE NOT EXISTS (
    SELECT 1 FROM vendas v WHERE v.id_cliente = c.id_cliente
);


-- ==================================================
-- KPI 09 — Faturamento total da empresa
-- Objetivo: consolidar a receita total gerada no período,
-- indicador-síntese de desempenho do negócio.
-- ==================================================
SELECT ROUND(SUM(iv.quantidade * iv.preco_unitario), 2) AS faturamento_total
FROM itens_venda iv;


-- ==================================================
-- KPI 10 — Ticket médio geral das vendas
-- Objetivo: medir o valor médio gerado por venda (pedido),
-- referência para metas comerciais e políticas de descontos.
-- ==================================================
WITH venda_totais AS (
    SELECT v.id_venda,
           SUM(iv.quantidade * iv.preco_unitario) AS valor_venda
    FROM vendas v
    INNER JOIN itens_venda iv ON iv.id_venda = v.id_venda
    GROUP BY v.id_venda
)
SELECT ROUND(AVG(valor_venda), 2) AS ticket_medio_geral
FROM venda_totais;


-- ################################################################
-- PARTE 5 — KPIs CRIADOS PELA DUPLA (5)
-- ################################################################

-- ==================================================
-- KPI EXTRA 01 — Concentração de faturamento (top 3 clientes)
-- Pergunta de negócio: qual parcela da receita da SportZone
-- depende de um pequeno grupo de clientes (efeito 80/20)?
-- Área interessada: Diretoria / Financeiro.
-- ==================================================
WITH gasto_cliente AS (
    SELECT c.id_cliente, c.nome,
           SUM(iv.quantidade * iv.preco_unitario) AS total_gasto
    FROM clientes c
    INNER JOIN vendas v ON v.id_cliente = c.id_cliente
    INNER JOIN itens_venda iv ON iv.id_venda = v.id_venda
    GROUP BY c.id_cliente, c.nome
),
top_clientes AS (
    SELECT total_gasto FROM gasto_cliente ORDER BY total_gasto DESC LIMIT 3
)
SELECT
    (SELECT ROUND(SUM(total_gasto), 2) FROM top_clientes)  AS receita_top3,
    (SELECT ROUND(SUM(total_gasto), 2) FROM gasto_cliente) AS receita_total,
    ROUND(100.0 * (SELECT SUM(total_gasto) FROM top_clientes)
                 / (SELECT SUM(total_gasto) FROM gasto_cliente), 2) AS pct_receita_top3;


-- ==================================================
-- KPI EXTRA 02 — Taxa de recorrência de clientes
-- Pergunta de negócio: entre os clientes que já compraram,
-- que percentual voltou a comprar mais de uma vez?
-- Área interessada: Marketing / Comercial.
-- ==================================================
WITH compras_cliente AS (
    SELECT c.id_cliente, COUNT(v.id_venda) AS qtd_compras
    FROM clientes c
    LEFT JOIN vendas v ON v.id_cliente = c.id_cliente
    GROUP BY c.id_cliente
)
SELECT
    COUNT(*)                                                           AS total_clientes,
    SUM(CASE WHEN qtd_compras >= 1 THEN 1 ELSE 0 END)                  AS clientes_compradores,
    SUM(CASE WHEN qtd_compras >= 2 THEN 1 ELSE 0 END)                  AS clientes_recorrentes,
    ROUND(100.0 * SUM(CASE WHEN qtd_compras >= 2 THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN qtd_compras >= 1 THEN 1 ELSE 0 END), 0), 2)
                                                                        AS pct_recorrencia
FROM compras_cliente;


-- ==================================================
-- KPI EXTRA 03 — Produtos com estoque elevado e baixo giro
-- Pergunta de negócio: quais produtos (diferente dos que nunca
-- venderam) têm estoque alto e vendas pouco expressivas,
-- representando capital parado?
-- Área interessada: Estoque / Produtos.
-- Recurso: GROUP BY + HAVING (filtro pós-agregação).
-- ==================================================
SELECT
    p.nome AS produto,
    p.categoria,
    p.estoque,
    COALESCE(SUM(iv.quantidade), 0) AS qtd_vendida
FROM produtos p
LEFT JOIN itens_venda iv ON iv.id_produto = p.id_produto
GROUP BY p.id_produto, p.nome, p.categoria, p.estoque
HAVING p.estoque >= 20 AND COALESCE(SUM(iv.quantidade), 0) <= 5
ORDER BY p.estoque DESC;


-- ==================================================
-- KPI EXTRA 04 — Evolução mensal do faturamento
-- Pergunta de negócio: como o faturamento e o número de vendas
-- evoluíram mês a mês ao longo do período analisado?
-- Área interessada: Diretoria / Financeiro.
-- ==================================================
SELECT
    DATE_FORMAT(v.data_venda, '%Y-%m')                      AS mes,
    COUNT(DISTINCT v.id_venda)                               AS qtd_vendas,
    ROUND(SUM(iv.quantidade * iv.preco_unitario), 2)         AS faturamento
FROM vendas v
INNER JOIN itens_venda iv ON iv.id_venda = v.id_venda
GROUP BY mes
ORDER BY mes;


-- ==================================================
-- KPI EXTRA 05 — Clientes e faturamento por cidade
-- Pergunta de negócio: em quais cidades a SportZone tem mais
-- clientes, e qual é o faturamento médio por cliente em cada uma?
-- Área interessada: Marketing / Logística.
-- ==================================================
WITH gasto_cliente AS (
    SELECT c.id_cliente, c.cidade,
           COALESCE(SUM(iv.quantidade * iv.preco_unitario), 0) AS total_gasto
    FROM clientes c
    LEFT JOIN vendas v ON v.id_cliente = c.id_cliente
    LEFT JOIN itens_venda iv ON iv.id_venda = v.id_venda
    GROUP BY c.id_cliente, c.cidade
)
SELECT
    cidade,
    COUNT(*)                          AS qtd_clientes,
    ROUND(SUM(total_gasto), 2)        AS faturamento_cidade,
    ROUND(AVG(total_gasto), 2)        AS faturamento_medio_cliente
FROM gasto_cliente
GROUP BY cidade
ORDER BY qtd_clientes DESC, faturamento_cidade DESC;


-- ################################################################
-- ANEXO TÉCNICO — CONSULTAS COMPLEMENTARES
-- Pequenas consultas exploratórias que demonstram, de forma
-- aplicada a perguntas reais de negócio, recursos adicionais
-- exigidos pelo desafio (IN, LIKE, BETWEEN, UNION, FULL OUTER JOIN
-- simulado, EXISTS e CROSS JOIN). Não fazem parte da contagem
-- oficial de 3 relatórios + 15 KPIs, mas complementam a análise.
-- ################################################################

-- Anexo A — Busca no catálogo (IN + LIKE)
-- Uso: time de Produtos filtrando a linha "Dry Fit" nas categorias
-- de moda esportiva para uma campanha específica.
SELECT nome, categoria, preco
FROM produtos
WHERE categoria IN ('Calçados', 'Vestuário')
  AND nome LIKE '%Dry Fit%';

-- Anexo B — Vendas do 1º trimestre de 2026 (BETWEEN)
-- Uso: Financeiro fechando o resultado trimestral.
SELECT id_venda, data_venda, forma_pagamento
FROM vendas
WHERE data_venda BETWEEN '2026-01-01' AND '2026-03-31'
ORDER BY data_venda;

-- Anexo C — Lista consolidada de contatos em Curitiba (UNION)
-- Uso: organizar um evento local reunindo clientes e vendedores
-- da mesma cidade em uma única lista.
SELECT nome, 'Cliente' AS tipo FROM clientes WHERE cidade = 'Curitiba'
UNION
SELECT nome, 'Vendedor' AS tipo FROM vendedores WHERE cidade = 'Curitiba'
ORDER BY tipo, nome;

-- Anexo D — Cidades com presença de clientes e/ou vendedores
-- (FULL OUTER JOIN simulado no MySQL via LEFT JOIN + UNION + RIGHT JOIN)
-- Uso: Logística identificando cidades com clientes mas sem
-- vendedor alocado (oportunidade de expansão da equipe).
WITH cidades_clientes AS (SELECT DISTINCT cidade FROM clientes),
     cidades_vendedores AS (SELECT DISTINCT cidade FROM vendedores)
SELECT cc.cidade AS cidade_com_clientes, cv.cidade AS cidade_com_vendedores
FROM cidades_clientes cc
LEFT JOIN cidades_vendedores cv ON cv.cidade = cc.cidade
UNION
SELECT cc.cidade, cv.cidade
FROM cidades_clientes cc
RIGHT JOIN cidades_vendedores cv ON cv.cidade = cc.cidade
ORDER BY 1;

-- Anexo E — Vendedores que já atenderam clientes de alta renda
-- (EXISTS)
-- Uso: Comercial mapeando quem já tem experiência com o público
-- de renda >= R$ 10.000, para uma futura linha de produtos premium.
SELECT ve.nome AS vendedor
FROM vendedores ve
WHERE EXISTS (
    SELECT 1 FROM vendas v
    INNER JOIN clientes c ON c.id_cliente = v.id_cliente
    WHERE v.id_vendedor = ve.id_vendedor AND c.renda >= 10000
);

-- Anexo F — Grade categoria x forma de pagamento (CROSS JOIN)
-- Uso: Comercial gerando todas as combinações possíveis entre
-- categoria de produto e forma de pagamento, como base para depois
-- checar (via LEFT JOIN) quais combinações nunca ocorreram.
WITH categorias AS (SELECT DISTINCT categoria FROM produtos),
     formas AS (SELECT DISTINCT forma_pagamento FROM vendas)
SELECT cat.categoria, f.forma_pagamento
FROM categorias cat
CROSS JOIN formas f
ORDER BY cat.categoria, f.forma_pagamento;
