# Trilha Databricks SQL & AI/BI

Guia pratico para construir produtos de dados no Databricks usando SQL Warehouse,
Delta SQL, Unity Catalog, AI/BI Dashboards, Genie, metric views, performance e
governanca.

Esta trilha foi desenhada para engenheiros de dados, analytics engineers,
analistas tecnicos e profissionais de BI que querem sair do "sei consultar
tabelas" para "sei entregar um produto de dados confiavel no Lakehouse".

---

## Proposta do produto

Ao final da trilha, o aluno tera construido um produto de dados completo:

- camada Bronze, Silver e Gold usando Delta SQL
- modelo dimensional simples para analytics
- metricas de negocio documentadas e testadas
- dashboard AI/BI com filtros, KPIs e drill-down
- espaco Genie/semantic layer preparado para perguntas em linguagem natural
- checklist de performance, custo e governanca
- job SQL com alertas e criterio de operacao
- projeto final pronto para portfolio e LinkedIn

O diferencial nao e ensinar apenas sintaxe. A trilha ensina como pensar,
modelar, publicar e operar dados como produto.

---

## Publico alvo

- Engenheiros de dados que ja usam Spark/Python e querem dominar Databricks SQL.
- Analistas de dados e BI developers migrando para Lakehouse.
- Analytics engineers que querem juntar SQL, governanca e entrega para negocio.
- Pessoas estudando Databricks para entrevistas, certificacao e portfolio.

Pre-requisitos recomendados:

- SQL intermediario.
- Nocoes de tabelas fato/dimensao.
- Conhecimento basico de Databricks Workspace.
- Vontade de documentar decisoes tecnicas, nao apenas rodar query.

---

## Mapa da trilha

| Semana | Tema | Entregavel |
| --- | --- | --- |
| 01 | SQL Warehouse, workspace e dataset seed | schema base e tabelas Bronze |
| 02 | Delta SQL e modelagem Silver | tabelas limpas, constraints logicas e views |
| 03 | Window functions, QUALIFY e analise temporal | queries analiticas reutilizaveis |
| 04 | Gold layer e metricas de negocio | camada Gold com KPIs oficiais |
| 05 | AI/BI Dashboards | especificacao e datasets do dashboard |
| 06 | Genie, metric views e camada semantica | contrato de metricas e perguntas guiadas |
| 07 | Performance em Databricks SQL | plano de otimizacao e queries comparativas |
| 08 | Unity Catalog e governanca | permissoes, masks, row filters e lineage |
| 09 | Jobs, alertas e operacao | rotina SQL operacionalizada |
| 10 | Projeto final | produto de dados completo e publicavel |

Versao aberta:

- Semanas 01 e 02: abertas no GitHub para estudo e avaliacao tecnica.
- Semanas 03 a 10: disponiveis na versao premium com labs completos e projeto final.

---

## Estrutura

```text
TRILHA_DATABRICKS_SQL/
|-- README.md
|-- PLANO_DE_ESTUDOS.md
|-- datasets/
|   |-- README.md
|   |-- seed_ecommerce.sql
|   `-- notebooks/
|-- exercicios/
|   |-- semana01_sql_warehouse_setup/
|   |-- semana02_delta_sql_modelagem/
|   |-- semana03_windows_qualify/
|   |-- semana04_gold_layer_metricas/
|   |-- semana05_dashboards_aibi/
|   |-- semana06_genie_metric_views/
|   |-- semana07_performance_sql/
|   |-- semana08_governanca_uc/
|   |-- semana09_jobs_alertas/
|   `-- semana10_projeto_final/
|-- projeto_final/
`-- templates/
```

---

## Como executar

1. Abra um workspace Databricks com Unity Catalog habilitado.
2. Use um SQL Warehouse, de preferencia Serverless quando disponivel.
3. Abra o SQL Editor.
4. Execute primeiro `datasets/seed_ecommerce.sql`.
5. Siga os labs por semana, na ordem.

Por padrao, os scripts usam:

```sql
USE CATALOG workspace;
CREATE SCHEMA IF NOT EXISTS databricks_sql_track;
USE SCHEMA databricks_sql_track;
```

Se o catalogo `workspace` nao existir no seu ambiente, troque por um catalogo
ao qual voce tenha `USE CATALOG`, `USE SCHEMA` e `CREATE TABLE`.

Scripts operacionais:

- Validacao gratuita: `scripts/run_free_validation_databricks.ps1`
- Executor SQL: `scripts/run_sql_file_databricks.ps1`
- Acesso premium: [ACESSO_PREMIUM.md](ACESSO_PREMIUM.md)

---

## SQL files e notebooks

A trilha usa os dois formatos:

- `.sql` como fonte de verdade para versionamento, revisao, SQL Editor e Jobs.
- notebooks Databricks source para experiencia guiada de aprendizado.

As semanas 01 e 02 ja incluem notebooks iniciais:

```text
datasets/notebooks/00_seed_ecommerce_notebook.sql
exercicios/semana01_sql_warehouse_setup/notebooks/01_workspace_sql_notebook.sql
exercicios/semana02_delta_sql_modelagem/notebooks/02_delta_modelagem_notebook.sql
```

---

## O que torna a trilha vendavel

- Ela resolve uma dor de mercado: transformar dados governados em consumo real.
- Ela produz artefatos de portfolio, nao apenas anotacoes.
- Ela conecta engenharia de dados com BI, sem abandonar boas praticas.
- Ela cobre temas atuais da plataforma: AI/BI, Genie, metric views, SQL Warehouse,
  Unity Catalog e performance.
- Ela permite posts tecnicos fortes no LinkedIn a cada semana.

---

## Referencias oficiais

- Databricks SQL: https://docs.databricks.com/aws/en/sql/get-started/
- SQL Warehouses: https://docs.databricks.com/aws/en/compute/sql-warehouse
- AI/BI: https://docs.databricks.com/aws/en/ai-bi/
- Dashboards: https://docs.databricks.com/aws/en/dashboards/tutorials/create-dashboard
- Metric views: https://docs.databricks.com/aws/en/metric-views
- Databricks Asset Bundles: https://docs.databricks.com/aws/en/dev-tools/cli/bundle-commands
