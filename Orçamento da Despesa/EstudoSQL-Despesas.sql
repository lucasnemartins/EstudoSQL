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


