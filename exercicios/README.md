# Exercicios

Execute os labs em ordem. Cada semana depende dos objetos criados nas semanas
anteriores.

| Semana | Pasta | Lab principal |
| --- | --- | --- |
| 01 | `semana01_sql_warehouse_setup` | `labs/01_workspace_sql.sql` |
| 02 | `semana02_delta_sql_modelagem` | `labs/02_delta_modelagem.sql` |
| 03 | `semana03_windows_qualify` | `labs/03_windows_qualify.sql` |
| 04 | `semana04_gold_layer_metricas` | `labs/04_gold_metricas.sql` |
| 05 | `semana05_dashboards_aibi` | `labs/05_dashboard_datasets.sql` |
| 06 | `semana06_genie_metric_views` | `labs/06_semantic_context.sql` |
| 07 | `semana07_performance_sql` | `labs/07_performance_sql.sql` |
| 08 | `semana08_governanca_uc` | `labs/08_governanca_uc.sql` |
| 09 | `semana09_jobs_alertas` | `labs/09_jobs_alertas.sql` |
| 10 | `semana10_projeto_final` | `labs/10_final_query_pack.sql` |

Antes da Semana 01, execute:

```sql
datasets/seed_ecommerce.sql
```

Se algum comando depender de recurso nao habilitado no seu workspace, mantenha o
bloco como referencia e registre a limitacao nas anotacoes da semana.

---

## Notebooks

As semanas podem ter uma pasta `notebooks/` com Databricks source notebooks.
Eles sao arquivos `.sql` com marcadores de notebook, por exemplo:

```text
-- Databricks notebook source
-- COMMAND ----------
-- MAGIC %md
```

Use assim:

- SQL Editor: execute os arquivos em `labs/`.
- Databricks Workspace/VS Code: importe ou execute os arquivos em `notebooks/`.

Os arquivos em `labs/` continuam sendo a fonte de verdade.
