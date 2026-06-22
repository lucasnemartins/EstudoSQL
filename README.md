# 📊 Orçamento da Despesa — 2026

> Estudo de **SQL (Oracle)** sobre a base pública de Orçamento da Despesa de 2026, do Portal da Transparência do Governo Federal. Faz parte do repositório de estudos de SQL, onde cada base analisada tem sua própria pasta.

![SQL](https://img.shields.io/badge/SQL-Oracle-red)
![Status](https://img.shields.io/badge/status-conclu%C3%ADdo-success)
![Dados](https://img.shields.io/badge/fonte-Portal%20da%20Transpar%C3%AAncia-green)

---

## 📑 Sumário

- [Sobre este estudo](#-sobre-este-estudo)
- [Arquivos desta pasta](#-arquivos-desta-pasta)
- [Sobre os dados](#-sobre-os-dados)
- [Como executar](#-como-executar)
- [Consultas disponíveis](#-consultas-disponíveis)
- [Desafios e aprendizados](#-desafios-e-aprendizados)
- [Fonte dos dados](#-fonte-dos-dados)

---

## 🎯 Sobre este estudo

Esta pasta documenta o ciclo completo de trabalho com a base orçamentária da União de 2026:

1. **Extração e limpeza** do CSV original do Portal da Transparência
2. **Modelagem** de uma tabela relacional no Oracle
3. **Carga** dos dados (assistente do SQL Developer ou SQL\*Loader)
4. **Análise** por meio de consultas SQL com agregações, ranqueamentos e formatação de valores

> 💡 Cada base estudada no repositório fica em uma pasta separada. Esta é a pasta **Orçamento da Despesa**.

---

## 📁 Arquivos desta pasta

```
Orçamento da Despesa/
├── orcamento_despesa_2026.csv      # Dados tratados (UTF-8, separador vírgula)
├── 01_create_table.sql             # DDL da tabela DESPESAS
├── 02_sqlldr_orcamento.ctl         # Control file do SQL*Loader
├── EstudoSQL-Despesas     # Consultas analíticas formatadas
└── README.md                       # Este arquivo
```

---

## 🗂 Sobre os dados

A tabela `DESPESAS` contém **22.933 registros** com a execução orçamentária da União em 2026, detalhada por órgão, função, programa, ação e elemento de despesa.

| Coluna | Descrição |
|---|---|
| `EXERCICIO` | Ano do exercício orçamentário |
| `COD_ORGAO_SUPERIOR` / `NOME_ORGAO_SUPERIOR` | Órgão superior |
| `COD_ORGAO_SUBORDINADO` / `NOME_ORGAO_SUBORDINADO` | Órgão subordinado |
| `COD_UNIDADE_ORCAMENTARIA` / `NOME_UNIDADE_ORCAMENTARIA` | Unidade orçamentária |
| `COD_FUNCAO` / `NOME_FUNCAO` | Função de governo |
| `COD_SUBFUNCAO` / `NOME_SUBFUNCAO` | Subfunção |
| `COD_PROGRAMA_ORCAMENTARIO` / `NOME_PROGRAMA_ORCAMENTARIO` | Programa orçamentário |
| `COD_ACAO` / `NOME_ACAO` | Ação orçamentária |
| `COD_CATEGORIA_ECONOMICA` / `NOME_CATEGORIA_ECONOMICA` | Categoria econômica |
| `COD_GRUPO_DESPESA` / `NOME_GRUPO_DESPESA` | Grupo de despesa |
| `COD_ELEMENTO_DESPESA` / `NOME_ELEMENTO_DESPESA` | Elemento de despesa |
| `ORCAMENTO_INICIAL` | Orçamento inicial (R$) |
| `ORCAMENTO_ATUALIZADO` | Orçamento atualizado (R$) |
| `ORCAMENTO_EMPENHADO` | Orçamento empenhado (R$) |
| `ORCAMENTO_REALIZADO` | Orçamento realizado (R$) |
| `PERC_REALIZADO` | % realizado sobre o atualizado |

---

## ▶️ Como executar

1. **Crie a tabela**
   ```sql
   @01_create_table.sql
   ```

2. **Importe os dados** — duas opções:

   **a) SQL Developer (assistente)**
   - Botão direito em *Tables* → **Import Data...**
   - Selecione `orcamento_despesa_2026.csv`
   - Encoding: **UTF-8** · Delimitador: **`,`** · Enclosure: **`"`** · Header marcado
   - Tabela de destino: `DESPESAS`

   **b) SQL\*Loader (linha de comando)**
   ```bash
   sqlldr usuario/senha@conexao control=02_sqlldr_orcamento.ctl log=carga.log
   ```

3. **Valide a carga**
   ```sql
   SELECT COUNT(*) FROM DESPESAS;   -- esperado: 22933
   ```

4. **Rode as análises**
   ```sql
   @04_consultas_formatadas.sql
   ```

---

## 🔎 Consultas disponíveis

O arquivo `04_consultas_formatadas.sql` traz, entre outras:

- **Top 15 unidades orçamentárias** por percentual de execução
- **Execução por grupo de despesa** (atualizado vs. realizado)
- **Execução por função de governo**
- **Categoria econômica × grupo de despesa**
- **Top 15 ações** e **Top 15 elementos de despesa** por execução
- Consultas exploratórias por unidade orçamentária específica

Todos os valores são exibidos no padrão brasileiro (`1.234.567,89`) e o percentual é protegido contra divisão por zero.

---

## 💡 Desafios e aprendizados

Registro dos principais obstáculos enfrentados nesta base e como foram resolvidos.

### 1. Encoding e separadores do CSV original
O arquivo vinha em **ISO-8859-1**, com separador `;` e decimais no padrão brasileiro (`1234,56`), o que quebrava acentos e impedia a leitura numérica. **Solução:** conversão para UTF-8, separador `,`, decimal com ponto e colunas renomeadas sem acentos (máx. 30 caracteres, limite do Oracle).

### 2. Formatação de valores no padrão brasileiro
Para exibir os totais legíveis, usei `TO_CHAR` com máscara:
```sql
TO_CHAR(SUM(ORCAMENTO_ATUALIZADO),
        'FM999G999G999G999G990D00',
        'NLS_NUMERIC_CHARACTERS='',.''')
```
Onde `9` = dígito que some se for zero à esquerda, `0` = dígito forçado, `G` = separador de milhar, `D` = separador decimal e `FM` = remove espaços à esquerda. Resultado: `12.345.678.901,23`.

### 3. Divisão por zero no cálculo do percentual
Linhas com orçamento atualizado igual a zero disparavam `ORA-01476`. **Solução:** `NULLIF` no divisor (zero vira `NULL`, e divisão por `NULL` não dá erro) e `NVL` para exibir zero:
```sql
ROUND(NVL(SUM(ORCAMENTO_REALIZADO) / NULLIF(SUM(ORCAMENTO_ATUALIZADO), 0) * 100, 0), 2)
```

### 4. O símbolo `#` na coluna formatada
O `#####` indica que o número **não cabe na máscara** (mais dígitos que `9` disponíveis). **Solução:** ampliar a máscara com mais grupos `G999`. Como o `FM` faz os dígitos não usados desaparecerem, sobrar `9` não atrapalha números menores.

### 5. Ordenação por coluna formatada
Ordenar pelo resultado de um `TO_CHAR` bagunça o ranking, pois o valor virou texto (`"9,50%"` vem depois de `"100,00%"`). **Regra aprendida:** *calcule e ordene em número, formate por último* — sempre usar a expressão numérica original no `ORDER BY`.

---

## 📚 Fonte dos dados

Dados públicos do **[Portal da Transparência do Governo Federal](https://portaldatransparencia.gov.br/dicionario-de-dados/orcamento-da-despesa)** — Despesas / Orçamento da Despesa, exercício 2026.
