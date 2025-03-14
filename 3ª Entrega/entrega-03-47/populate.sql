DROP TABLE IF EXISTS evento_reposicao;
DROP TABLE IF EXISTS responsavel_por;
DROP TABLE IF EXISTS retalhista;
DROP TABLE IF EXISTS planograma;
DROP TABLE IF EXISTS prateleira;
DROP TABLE IF EXISTS instalada_em;
DROP TABLE IF EXISTS ponto_de_retalho;
DROP TABLE IF EXISTS IVM;
DROP TABLE IF EXISTS tem_categoria;
DROP TABLE IF EXISTS produto;
DROP TABLE IF EXISTS tem_outra;
DROP TABLE IF EXISTS super_categoria;
DROP TABLE IF EXISTS categoria_simples;
DROP TABLE IF EXISTS categoria;

CREATE TABLE categoria (
  nome VARCHAR(20),
  PRIMARY KEY(nome)
);

CREATE TABLE categoria_simples (
  nome VARCHAR(20),
  PRIMARY KEY(nome),
  FOREIGN KEY(nome) REFERENCES categoria(nome)
);

CREATE TABLE super_categoria (
  nome VARCHAR(20),
  PRIMARY KEY(nome),
  FOREIGN KEY(nome) REFERENCES categoria(nome) 
);

CREATE TABLE tem_outra (
  categoria VARCHAR(20),
  super_categoria VARCHAR(20) NOT NULL,
  PRIMARY KEY(categoria),
  FOREIGN KEY(super_categoria) REFERENCES super_categoria(nome),
  FOREIGN KEY(categoria) REFERENCES categoria(nome),
  CHECK(super_categoria != categoria)
);

CREATE TABLE produto (
  ean NUMERIC(13, 0),
  cat VARCHAR(20) NOT NULL,
  descr VARCHAR(50),
  PRIMARY KEY(ean),
  FOREIGN KEY(cat) REFERENCES categoria(nome)
);

CREATE TABLE tem_categoria (
    ean NUMERIC(13, 0),
    nome VARCHAR(20),
    PRIMARY KEY(ean, nome),
    FOREIGN KEY(ean) REFERENCES produto(ean),
    FOREIGN KEY(nome) REFERENCES categoria(nome)
);

CREATE TABLE ivm (
    num_serie INT,
    fabricante VARCHAR(20),
    PRIMARY KEY(num_serie, fabricante)
);

CREATE TABLE ponto_de_retalho (
    nome VARCHAR(20),
    distrito VARCHAR(30),
    concelho VARCHAR(30),
    PRIMARY KEY(nome)
);

CREATE TABLE instalada_em (
    num_serie INT,
    fabricante VARCHAR(20),
    "local"  VARCHAR(30) NOT NULL, 
    PRIMARY KEY(num_serie, fabricante),
    FOREIGN KEY(num_serie, fabricante) REFERENCES ivm(num_serie, fabricante),
    FOREIGN KEY( "local" ) REFERENCES ponto_de_retalho(nome)
);

CREATE TABLE prateleira (
    nro INT,
    num_serie INT,
    fabricante VARCHAR(20),
    altura INT,
    nome VARCHAR(20) NOT NULL,
    PRIMARY KEY(nro, num_serie, fabricante),
    FOREIGN KEY(num_serie, fabricante) REFERENCES ivm(num_serie, fabricante),
    FOREIGN KEY(nome) REFERENCES categoria(nome)
);

CREATE TABLE planograma (
    ean NUMERIC(13, 0),
    nro INT,
    num_serie INT,
    fabricante VARCHAR(20),
    faces INT,
    unidades INT NOT NULL,
    loc INT,
    PRIMARY KEY(ean, nro , num_serie, fabricante),
    FOREIGN KEY(ean) REFERENCES produto(ean),
    FOREIGN KEY(nro, num_serie, fabricante) REFERENCES prateleira(nro, num_serie, fabricante)
);

CREATE TABLE retalhista (
    tin INT,
    "name" VARCHAR(20) NOT NULL UNIQUE,
    PRIMARY KEY(tin)
);

CREATE TABLE responsavel_por (
    num_serie INT,
    fabricante VARCHAR(20),
    nome_cat VARCHAR(20) NOT NULL,
    tin INT NOT NULL,
    PRIMARY KEY(num_serie, fabricante),
    FOREIGN KEY(num_serie, fabricante) REFERENCES ivm(num_serie, fabricante),
    FOREIGN KEY(tin) REFERENCES retalhista(tin),
    FOREIGN KEY(nome_cat) REFERENCES categoria(nome)
);

CREATE TABLE evento_reposicao (
    ean NUMERIC(13, 0),
    nro INT,
    num_serie INT,
    fabricante VARCHAR(20),
    instante TIMESTAMP,
    unidades INT NOT NULL,
    tin INT NOT NULL,
    PRIMARY KEY(ean, nro, num_serie, fabricante, instante),
    FOREIGN KEY(ean, nro, num_serie, fabricante) REFERENCES planograma(ean, nro, num_serie, fabricante),
    FOREIGN KEY(tin) REFERENCES retalhista(tin)
);

INSERT INTO categoria(
    nome
) 
VALUES
    ('snacks'),
    ('batatas fritas'),
    ('frescos'),
    ('bolachas'),
    ('chocolates'),
    ('vegetais'),
    ('leites magros'),
    ('laticínios'),
    ('enlatados'),
    ('bebidas'),
    ('refrigerantes'),
    ('leguminosas'),
    ('bebidas alcoólicas'),
    ('carnes'),
    ('carnes de aves'),
    ('carnes vermelhas'),
    ('carne de vaca');

INSERT INTO categoria_simples(
    nome
) 
VALUES
    ('batatas fritas'),
    ('leites magros'),
    ('leguminosas'),
    ('bebidas alcoólicas'),
    ('refrigerantes'),
    ('carnes de aves'),
    ('carne de vaca'),
    ('vegetais'),
    ('bolachas'),
    ('chocolates');

INSERT INTO super_categoria(
    nome
) 
VALUES 
    ('snacks'),
    ('frescos'),
    ('laticínios'),
    ('bebidas'),
    ('enlatados'),
    ('carnes'),
    ('carnes vermelhas');

INSERT INTO tem_outra(
    super_categoria,
    categoria 
)
VALUES 
    ('frescos', 'laticínios'),
    ('laticínios', 'leites magros'),
    ('bebidas', 'bebidas alcoólicas'),
    ('bebidas', 'refrigerantes'),
    ('enlatados', 'leguminosas'),
    ('carnes', 'carnes de aves'),
    ('carnes', 'carnes vermelhas'),
    ('carnes vermelhas', 'carne de vaca'),
    ('frescos', 'vegetais'),
    ('snacks', 'bolachas'),
    ('snacks', 'batatas fritas');

INSERT INTO produto(
    ean,
    cat,
    descr
)
VALUES 
    (3455123456631, 'carnes de aves', 'bife de frango'),
    (1773452432342, 'bolachas', 'bolachas milka'),
    (1432223498912, 'vegetais', 'alface'),
    (1023543609803, 'laticínios', 'queijo'),
    (1423543609803, 'leguminosas', 'feijão'),
    (1323543609803, 'bebidas alcoólicas', 'cerveja'),
    (1566232121332, 'refrigerantes', 'coca-cola'),
    (1023543609804, 'leites magros', 'leite magro'),
    (2321344557825, 'batatas fritas', 'batatas lays');

INSERT INTO tem_categoria(
    ean,
    nome 
)
VALUES
    (3455123456631, 'carnes de aves'),
    (1023543609803, 'laticínios'),
    (1773452432342, 'bolachas'),
    (1773452432342, 'chocolates'),
    (1323543609803, 'bebidas alcoólicas'),
    (1423543609803, 'leguminosas'),
    (1023543609804, 'leites magros'),
    (1566232121332, 'refrigerantes'),
    (1432223498912, 'vegetais'),
    (2321344557825, 'batatas fritas');

INSERT INTO ivm(
    num_serie,
    fabricante
)
VALUES 
    (223756, 'IVMS_LDA'),
    (542789, 'IVMS_LDA'),
    (879643, 'JOAQUIM_E_REMENDOS'),
    (483773, 'ALBERTO_CT'),
    (438274, 'FATIREPAIRS_LDA'),
    (123424, 'FATIREPAIRS_LDA'),
    (432455, 'FATIREPAIRS_LDA'),
    (438279, 'FATIREPAIRS_LDA'),
    (213127, 'LEIRAO_E_LOBSTERS'),
    (212344, 'LEIRAO_E_LOBSTERS'),
    (124127, 'LEIRAO_E_LOBSTERS'),
    (234327, 'LEIRAO_E_LOBSTERS'),
    (231347, 'GANG_DO_GANG');

INSERT INTO ponto_de_retalho(
    nome,
    distrito,
    concelho
)
VALUES 
    ('BP Paço de Arcos', 'Lisboa', 'Oeiras'),
    ('Super Cascais', 'Lisboa', 'Cascais'),
    ('IST', 'Lisboa', 'Lisboa'),
    ('Fitness Hut', 'Lisboa', 'Oeiras'),
    ('Super Gaia', 'Porto', 'Vila Nova de Gaia'),
    ('Grande Queijas', 'Lisboa', 'Oeiras');

INSERT INTO instalada_em(
    num_serie,
    fabricante,
    "local"   
)
VALUES
    (223756, 'IVMS_LDA', 'BP Paço de Arcos'),
    (542789, 'IVMS_LDA', 'IST'),
    (879643, 'JOAQUIM_E_REMENDOS', 'Super Cascais'),
    (483773, 'ALBERTO_CT', 'Super Gaia'),
    (438274, 'FATIREPAIRS_LDA', 'Grande Queijas');

INSERT INTO prateleira(
    nro, 
    num_serie,
    fabricante,
    altura,
    nome
)
VALUES 
    (1, 223756, 'IVMS_LDA', 20, 'laticínios'),
    (2, 223756, 'IVMS_LDA', 20, 'leguminosas'),
    (3, 223756, 'IVMS_LDA', 20, 'bolachas'),
    (4, 223756, 'IVMS_LDA', 20, 'bebidas alcoólicas'),
    (5, 223756, 'IVMS_LDA', 20, 'refrigerantes'),
    (1, 542789, 'IVMS_LDA', 20, 'laticínios'),
    (2, 542789, 'IVMS_LDA', 20, 'leguminosas'),
    (3, 542789, 'IVMS_LDA', 20, 'bolachas'),
    (4, 542789, 'IVMS_LDA', 20, 'bebidas alcoólicas'),
    (5, 542789, 'IVMS_LDA', 20, 'refrigerantes'),
    (1, 879643, 'JOAQUIM_E_REMENDOS', 30, 'leguminosas'),
    (2, 879643, 'JOAQUIM_E_REMENDOS', 30, 'vegetais'),
    (3, 879643, 'JOAQUIM_E_REMENDOS', 25, 'bolachas'),
    (1, 483773, 'ALBERTO_CT', 15, 'refrigerantes'),
    (2, 483773, 'ALBERTO_CT', 20, 'bebidas alcoólicas'),
    (3, 483773, 'ALBERTO_CT', 20, 'bolachas'),
    (4, 483773, 'ALBERTO_CT', 20, 'batatas fritas');

INSERT INTO planograma(
    ean, 
    nro, 
    num_serie,
    fabricante,
    faces,
    unidades,
    loc
)
VALUES 
    (1023543609803, 1, 223756, 'IVMS_LDA', 10, 30, 123456),
    (1423543609803, 2, 223756, 'IVMS_LDA', 10, 30, 123456),
    (1773452432342, 3, 223756, 'IVMS_LDA', 10, 30, 123456),
    (1323543609803, 4, 223756, 'IVMS_LDA', 10, 30, 123456),
    (1566232121332, 5, 223756, 'IVMS_LDA', 10, 30, 123456),
    (1023543609803, 1, 542789, 'IVMS_LDA', 10, 30, 123456),
    (1423543609803, 2, 542789, 'IVMS_LDA', 10, 30, 123456),
    (1773452432342, 3, 542789, 'IVMS_LDA', 10, 30, 123456),
    (1323543609803, 4, 542789, 'IVMS_LDA', 10, 30, 123456),
    (1566232121332, 5, 542789, 'IVMS_LDA', 10, 30, 123456),
    (1423543609803, 1, 879643, 'JOAQUIM_E_REMENDOS', 5, 20, 7654321),
    (1432223498912, 2, 879643, 'JOAQUIM_E_REMENDOS', 5, 20, 7654321),
    (1773452432342, 3, 879643, 'JOAQUIM_E_REMENDOS', 5, 20, 7654321),
    (1566232121332, 1, 483773, 'ALBERTO_CT', 8, 32, 192837),
    (1323543609803, 2, 483773, 'ALBERTO_CT', 8, 32, 192837),
    (1773452432342, 3, 483773, 'ALBERTO_CT', 8, 32, 192837),
    (2321344557825, 4, 483773, 'ALBERTO_CT', 8, 32, 192837);

INSERT INTO retalhista(
    tin, 
    "name"
)
VALUES 
    (400, 'José ALmeida'),
    (750, 'Andreia Alexandra'),
    (20, 'Alberto Joaquim'),
    (1000, 'Maria Antunes'),
    (150, 'Sandra Letras'),
    (550, 'Carla Paredes');

INSERT INTO responsavel_por(
    nome_cat,
    tin,
    num_serie,
    fabricante
)
VALUES
    ('laticínios', 400, 223756, 'IVMS_LDA'),
    ('leites magros', 150, 542789, 'IVMS_LDA'),
    ('batatas fritas', 150, 213127, 'LEIRAO_E_LOBSTERS'),
    ('leguminosas', 150, 212344, 'LEIRAO_E_LOBSTERS'),
    ('leguminosas', 20, 879643, 'JOAQUIM_E_REMENDOS'),
    ('bebidas alcoólicas', 150, 124127, 'LEIRAO_E_LOBSTERS'),
    ('refrigerantes', 150, 234327, 'LEIRAO_E_LOBSTERS'),
    ('carnes de aves', 150, 231347, 'GANG_DO_GANG'),
    ('carne de vaca', 150, 123424, 'FATIREPAIRS_LDA'),
    ('bolachas', 150, 432455, 'FATIREPAIRS_LDA'),
    ('chocolates', 150, 438279, 'FATIREPAIRS_LDA'),
    ('bebidas alcoólicas', 550, 483773, 'ALBERTO_CT'),
    ('vegetais', 150, 438274, 'FATIREPAIRS_LDA');

INSERT INTO evento_reposicao(
    ean,
    nro, 
    num_serie,
    fabricante,
    instante, 
    unidades, 
    tin
)
VALUES 
    (1023543609803, 1, 223756, 'IVMS_LDA', '2020-10-08', 10, 400),
    (1423543609803, 2, 223756, 'IVMS_LDA', '2021-01-05', 8, 400),
    (1423543609803, 2, 223756, 'IVMS_LDA', '2021-05-07', 6, 400),
    (1423543609803, 2, 223756, 'IVMS_LDA', '2021-09-06', 12, 400),
    (1773452432342, 3, 223756, 'IVMS_LDA', '2020-10-09', 3, 400),
    (1323543609803, 4, 223756, 'IVMS_LDA', '2020-12-28', 17, 400),
    (1023543609803, 1, 542789, 'IVMS_LDA', '2020-10-27', 13, 150),
    (1023543609803, 1, 542789, 'IVMS_LDA', '2020-10-14', 8, 150),
    (1773452432342, 3, 542789, 'IVMS_LDA', '2020-11-12', 6, 150),
    (1566232121332, 5, 542789, 'IVMS_LDA', '2020-11-08', 10, 150),
    (1423543609803, 1, 879643, 'JOAQUIM_E_REMENDOS', '2021-02-11', 8, 20),
    (1432223498912, 2, 879643, 'JOAQUIM_E_REMENDOS', '2021-01-29', 5, 20),
    (1566232121332, 1, 483773, 'ALBERTO_CT', '2020-10-09', 3, 550),
    (1566232121332, 1, 483773, 'ALBERTO_CT', '2021-12-08', 5, 550),
    (1323543609803, 2, 483773, 'ALBERTO_CT', '2022-01-07', 6, 550),
    (1323543609803, 2, 483773, 'ALBERTO_CT', '2021-11-19', 14, 550),
    (1323543609803, 2, 483773, 'ALBERTO_CT', '2020-12-24', 9, 550),
    (1773452432342, 3, 483773, 'ALBERTO_CT', '2020-11-30', 13, 550),
    (2321344557825, 4, 483773, 'ALBERTO_CT', '2021-01-04', 8, 550);