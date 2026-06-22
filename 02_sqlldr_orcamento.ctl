-- =====================================================================
-- SQL*Loader control file - ORCAMENTO_DESPESA_2026
-- Uso: sqlldr usuario/senha@conexao control=02_sqlldr_orcamento.ctl
-- =====================================================================
OPTIONS (SKIP=1, DIRECT=TRUE, ERRORS=1000)
LOAD DATA
CHARACTERSET UTF8
INFILE 'orcamento_despesa_2026.csv'
BADFILE 'orcamento_despesa_2026.bad'
DISCARDFILE 'orcamento_despesa_2026.dsc'
APPEND
INTO TABLE ORCAMENTO_DESPESA_2026
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
    EXERCICIO                   INTEGER EXTERNAL,
    COD_ORGAO_SUPERIOR          CHAR(10),
    NOME_ORGAO_SUPERIOR         CHAR(150),
    COD_ORGAO_SUBORDINADO       CHAR(10),
    NOME_ORGAO_SUBORDINADO      CHAR(200),
    COD_UNIDADE_ORCAMENTARIA    CHAR(10),
    NOME_UNIDADE_ORCAMENTARIA   CHAR(150),
    COD_FUNCAO                  CHAR(5),
    NOME_FUNCAO                 CHAR(60),
    COD_SUBFUNCAO               CHAR(5),
    NOME_SUBFUNCAO              CHAR(100),
    COD_PROGRAMA_ORCAMENTARIO   CHAR(10),
    NOME_PROGRAMA_ORCAMENTARIO  CHAR(150),
    COD_ACAO                    CHAR(10),
    NOME_ACAO                   CHAR(400),
    COD_CATEGORIA_ECONOMICA     CHAR(2),
    NOME_CATEGORIA_ECONOMICA    CHAR(60),
    COD_GRUPO_DESPESA           CHAR(2),
    NOME_GRUPO_DESPESA          CHAR(80),
    COD_ELEMENTO_DESPESA        CHAR(5),
    NOME_ELEMENTO_DESPESA       CHAR(200),
    ORCAMENTO_INICIAL           DECIMAL EXTERNAL,
    ORCAMENTO_ATUALIZADO        DECIMAL EXTERNAL,
    ORCAMENTO_EMPENHADO         DECIMAL EXTERNAL,
    ORCAMENTO_REALIZADO         DECIMAL EXTERNAL,
    PERC_REALIZADO              DECIMAL EXTERNAL
)
