-- Consulta de Análise - DESPESAS (Orçamento da União 2026)
-- Percentual da divisão protegido contra divisão por zero

-- Visão geral da tabela
SELECT * FROM DESPESAS;

-- Total do valor atualizado
SELECT SUM(ORCAMENTO_ATUALIZADO) FROM DESPESAS;

-- Detalhe de unidades orcamentarias especificas
SELECT * FROM DESPESAS
 WHERE NOME_UNIDADE_ORCAMENTARIA = 'RECURSOS SOB SUPERVISAO DO MIN. DA FAZENDA';
 
SELECT * FROM DESPESAS
 WHERE NOME_UNIDADE_ORCAMENTARIA = 'RESERVA DE CONTINGENCIA';
 
SELECT * FROM DESPESAS
 WHERE NOME_UNIDADE_ORCAMENTARIA = 'FUNDO DO REGIME GERAL DA PREVIDENCIA SOCIAL';
 
-- Total realizado de um grupo de despesa
SELECT SUM(ORCAMENTO_REALIZADO) FROM DESPESAS
 WHERE NOME_GRUPO_DESPESA = 'Outras Despesas Correntes';

-- ----------------------------------------------------------
-- TOP 15 Uidade Orçamentária por % (realizado / autalizado)
-- ----------------------------------------------------------
SELECT
    nome_unidade_orcamentaria,
    to_char(
        sum(orcamento_atualizado),
        'FM999G999G999G999G990D00',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS orcamento_atualizado,
    to_char(
        sum(orcamento_realizado),
        'FM999G999G999G990D00',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS orcamento_realizado,
    round(
        nvl(sum(orcamento_realizado) / nullif(
            sum(orcamento_atualizado),
            0
        ) * 100,
            0),
        2
    ) AS percentual_relizado
FROM
    despesas
GROUP BY
    nome_unidade_orcamentaria, to_char( sum(orcamento_atualizado), 'FM999G999G999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.''' ), to_char( sum(orcamento_realizado), 'FM999G999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.''' ), round( nvl(sum(orcamento_realizado) / nullif( sum(orcamento_atualizado), 0 ) * 100, 0), 2 )
ORDER BY
    percentual_relizado DESC
FETCH FIRST 15 ROWS ONLY;

-- ------------------------------------------------------------------
-- Execução pro grupo de despesas
-- ------------------------------------------------------------------
SELECT
    nome_grupo_despesa,
    to_char(
        sum(orcamento_atualizado),
        'FM999G999G999G999G990D00',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS orcamento_atualizado,
    to_char(
        sum(orcamento_realizado),
        'FM999G999G999G999G990D00',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS orcamento_realizado,
    round(
        nvl(sum(orcamento_realizado) / nullif(
            sum(orcamento_atualizado),
            0
        ) * 100,
            0),
        2
    ) AS percentual_relizado
FROM
    despesas
GROUP BY
    nome_grupo_despesa, to_char( sum(orcamento_atualizado), 'FM999G999G999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.''' ), to_char( sum(orcamento_realizado), 'FM999G999G999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.''' ), round( nvl(sum(orcamento_realizado) / nullif( sum(orcamento_atualizado), 0 ) * 100, 0), 2 )
ORDER BY
    percentual_relizado DESC;
    
-- ------------------------------------------------
-- Execução por Governo
-- ------------------------------------------------
SELECT
    nome_funcao,
    to_char(
        sum(orcamento_atualizado),
        'FM999G999G999G999G990D00',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS orcamento_atualizado,
    to_char(
        sum(orcamento_realizado),
        'FM999G999G999G999G990D00',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS orcamento_realizado,
    round(
        nvl(sum(orcamento_realizado) / nullif(
            sum(orcamento_atualizado),
            0
        ) * 100,
            0),
        2
    ) AS percentual_relizado
FROM
    despesas
GROUP BY
    nome_funcao, to_char( sum(orcamento_atualizado), 'FM999G999G999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.''' ), to_char( sum(orcamento_realizado), 'FM999G999G999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.''' ), round( nvl(sum(orcamento_realizado) / nullif( sum(orcamento_atualizado), 0 ) * 100, 0), 2 )
ORDER BY
    percentual_relizado DESC;
    
-- ------------------------------------------------
-- Categoria econômica x grupo de despesas
-- ------------------------------------------------
SELECT
    nome_categoria_economica,
    nome_grupo_despesa,
    to_char(
        sum(orcamento_atualizado),
        'FM999G999G999G999G990D00',
        'NLS_NUMERIC_CHARACTERS='',.'''
    ) AS orcamento_atualizado
FROM
    despesas
GROUP BY
    nome_categoria_economica, nome_grupo_despesa, to_char( sum(orcamento_atualizado), 'FM999G999G999G999G990D00', 'NLS_NUMERIC_CHARACTERS='',.''' )
ORDER BY
    nome_categoria_economica,
    SUM(orcamento_atualizado) DESC;

-- 1.1) Quantas linhas existem por categoria econômica?
SELECT
    nome_categoria_economica,
    COUNT(nome_categoria_economica) AS qt_nome_categoria_economica
FROM
    despesas
GROUP BY
    nome_categoria_economica
ORDER BY
    qt_nome_categoria_economica DESC;

-- 1.2) Quais funções de governo têm orçamento atualizado somado acima de 1 bilhão? (dica: use HAVING)

SELECT
    nome_funcao,
    SUM(orcamento_atualizado) AS orcamento_atualizado
FROM
    despesas group by nome_funcao
HAVING
    SUM(orcamento_atualizado) > 1000000000
ORDER BY
    orcamento_atualizado;
    
-- 1.3) Qual o orçamento médio, mínimo e máximo realizado por grupo de despesa?
SELECT
    nome_grupo_despesa,
    ROUND(AVG(orcamento_atualizado),2) AS media_orcamento,
    MIN(orcamento_atualizado) AS mínimo_orcamento,
    MAX(orcamento_atualizado) AS máximo_orcamento
FROM
    despesas
GROUP BY
    nome_grupo_despesa;
-- 2.1) Crie uma tabela-dimensão DIM_FUNCAO com os códigos e nomes
--      únicos de função a partir da DESPESAS. Em seguida, some o
--      orçamento atualizado por função fazendo INNER JOIN entre
--      DESPESAS e DIM_FUNCAO pelo código.
SELECT
    f.cod_funcao,
    f.nome_funcao,
    d.cod_funcao              AS cd_funcao_despesas,
    d.nome_funcao             AS nome_funcao_despesas,
    SUM(orcamento_atualizado) AS orcamento_atualizado
FROM
         despesas d
    INNER JOIN dim_funcao f ON f.cod_funcao = d.cod_funcao
GROUP BY
    f.cod_funcao,
    f.nome_funcao,
    f.cod_funcao,
    d.cod_funcao,
    d.nome_funcao
ORDER BY
    orcamento_atualizado DESC;
    
-- 2.2) Insira na DIM_FUNCAO uma função fictícia que NÃO existe na
--      DESPESAS. Depois use LEFT JOIN para listar todas as funções da
--      dimensão, inclusive a sem despesas (o total dela deve vir nulo).
--      Compare o resultado com o que sairia usando INNER JOIN.

-- inserindo o valor que não existe na tabela despesas
INSERT INTO dim_funcao (
    cod_funcao,
    nome_funcao
) VALUES ( 100,
           'Outros' );

SELECT
    f.cod_funcao,
    f.nome_funcao,
    d.cod_funcao  AS cod_funcao_despesas,
    d.nome_funcao AS nome_funcao_despesas
FROM
    dim_funcao f
    LEFT JOIN despesas   d ON f.cod_funcao = d.cod_funcao
GROUP BY
    f.cod_funcao,
    f.nome_funcao,
    d.cod_funcao,
    d.nome_funcao;
    
-- 3.1) Calcule o total geral de orçamento atualizado e, para cada
--      órgão superior, mostre quanto ele representa desse total (em %).
--      Use uma CTE para calcular o total geral.

WITH orcamento_atualizado_total AS (
    SELECT
        SUM(orcamento_atualizado) AS total_orcamento_atualizado FROM DESPESAS
)
SELECT d.nome_orgao_superior,
        sum(d.orcamento_atualizado) total_orgao,
        round(
            nvl(sum(d.orcamento_atualizado) / nullif(
                total_orcamento_atualizado,
                0
            ) * 100,
                0),
            2
        )                         AS percentual
    FROM
        despesas d
    CROSS JOIN orcamento_atualizado_total t
    GROUP BY
        d.nome_orgao_superior, t.total_orcamento_atualizado
    ORDER BY percentual DESC;

