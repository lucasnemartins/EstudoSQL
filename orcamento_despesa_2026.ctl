load data 
infile 'orcamento_despesa_2026.csv' "str '\n'"
append
into table DespesasNovo
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( EXERCICIO,
             COD_ORGAO_SUPERIOR CHAR(4000),
             NOME_ORGAO_SUPERIOR CHAR(4000),
             COD_ORGAO_SUBORDINADO CHAR(4000),
             NOME_ORGAO_SUBORDINADO CHAR(4000),
             COD_UNIDADE_ORCAMENTARIA CHAR(4000),
             NOME_UNIDADE_ORCAMENTARIA CHAR(4000),
             COD_FUNCAO,
             NOME_FUNCAO CHAR(4000),
             COD_SUBFUNCAO CHAR(4000),
             NOME_SUBFUNCAO CHAR(4000),
             COD_PROGRAMA_ORCAMENTARIO CHAR(4000),
             NOME_PROGRAMA_ORCAMENTARIO CHAR(4000),
             COD_ACAO CHAR(4000),
             NOME_ACAO CHAR(4000),
             COD_CATEGORIA_ECONOMICA,
             NOME_CATEGORIA_ECONOMICA CHAR(4000),
             COD_GRUPO_DESPESA,
             NOME_GRUPO_DESPESA CHAR(4000),
             COD_ELEMENTO_DESPESA,
             NOME_ELEMENTO_DESPESA CHAR(4000),
             ORCAMENTO_INICIAL CHAR(4000),
             ORCAMENTO_ATUALIZADO CHAR(4000),
             ORCAMENTO_EMPENHADO CHAR(4000),
             ORCAMENTO_REALIZADO CHAR(4000),
             PERC_REALIZADO CHAR(4000)
           )
