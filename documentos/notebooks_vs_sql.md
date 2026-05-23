# Estrategia: SQL files e Notebooks

## Decisao

Sim, podemos e devemos usar os dois.

Mas cada formato deve ter uma funcao clara:

| Formato | Funcao |
| --- | --- |
| `.sql` | fonte de verdade, automacao, jobs, versionamento e copy/paste no SQL Editor |
| notebooks | experiencia guiada de aprendizado, narrativa, outputs e portfolio visual |

Minha recomendacao para esta trilha:

```text
.sql = produto tecnico e reprodutivel
notebook = aula/lab guiado para o aluno
```

---

## Por que manter `.sql`

Arquivos `.sql` sao melhores para:

- Git diff limpo
- revisao tecnica
- execucao no SQL Editor
- SQL Jobs
- empacotamento premium
- automacao futura
- uso por pessoas que nao gostam de notebooks

Eles tambem deixam o produto mais profissional para engenharia de dados.

---

## Por que adicionar notebooks

Notebooks sao melhores para:

- explicar passo a passo
- misturar texto, query e resultado
- reduzir friccao para iniciantes
- gerar prints para LinkedIn
- criar sensacao de curso premium
- mostrar outputs esperados

No Databricks, o aluno naturalmente espera notebooks em uma trilha pratica.

---

## Modelo recomendado

Para cada semana:

```text
README.md
labs/
  04_gold_metricas.sql
notebooks/
  04_gold_metricas_notebook.sql
```

O notebook deve ser um Databricks source notebook em SQL:

```sql
-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Semana 04 - Gold layer e metricas

-- COMMAND ----------

USE CATALOG workspace;
USE SCHEMA databricks_sql_track;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Criar dimensoes

-- COMMAND ----------

CREATE OR REPLACE TABLE dim_customer AS ...
```

Esse formato e versionavel como texto e pode ser importado como notebook no
Databricks.

---

## O que entra no free e no premium

Free:

- `.sql` das semanas 01 e 02
- notebooks das semanas 01 e 02
- README explicando como executar pelos dois caminhos

Premium:

- `.sql` das semanas 03 a 10
- notebooks guiados das semanas 03 a 10
- outputs esperados
- projeto final

Isso aumenta a percepcao de valor sem sacrificar qualidade tecnica.

---

## Padrao editorial dos notebooks

Cada notebook deve ter:

1. titulo da semana
2. objetivo
3. contexto de negocio
4. celula de setup
5. blocos pequenos de SQL
6. checkpoints de validacao
7. desafio
8. criterios de aceite

Evitar:

- notebooks gigantes
- query sem explicacao
- prints hardcoded
- misturar comandos de semanas diferentes
- depender de estado invisivel

---

## Regra de manutencao

O `.sql` continua sendo a fonte de verdade.

Quando alterar um lab:

1. atualize primeiro o `.sql`
2. atualize o notebook correspondente
3. rode a validacao no Free Trial
4. registre no changelog

---

## Roadmap para adicionar notebooks

Fase 1:

- criar notebooks das semanas 01 e 02
- publicar no repo free

Fase 2:

- criar notebooks das semanas 03 a 10
- colocar no premium

Fase 3:

- gravar video curto ou GIF para o README
- adicionar prints do dashboard final
