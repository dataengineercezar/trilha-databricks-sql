# Teste no Databricks Free Trial

Este guia descreve como validar a trilha em um workspace Databricks Free Trial e
como um aluno deve reproduzir os labs usando SQL Editor, VS Code ou CLI.

O caminho recomendado para consumidores e:

```text
Databricks SQL Editor -> executar arquivos .sql em ordem -> validar objetos no Catalog
```

O caminho para autores/manutencao e:

```text
VS Code + Databricks extension -> editar arquivos localmente -> executar/sincronizar -> validar no workspace
```

---

## 1. Pre-requisitos

Conta:

- Databricks Free Trial ativo.
- Workspace aberto no navegador.
- Unity Catalog habilitado.
- SQL Warehouse disponivel.

Ambiente local opcional:

- VS Code.
- Extensao oficial Databricks.
- Perfil autenticado, por exemplo `cezar_databricks`.
- Pasta local da trilha aberta no VS Code.

No screenshot atual, o ambiente ja mostra:

- workspace Databricks acessivel no browser
- VS Code com Databricks extension aberta
- auth profile configurado
- target `dev`
- modo Serverless selecionado

---

## 2. Ordem oficial de teste

Execute nesta ordem:

| Ordem | Arquivo |
| ---: | --- |
| 1 | `datasets/seed_ecommerce.sql` |
| 2 | `exercicios/semana01_sql_warehouse_setup/labs/01_workspace_sql.sql` |
| 3 | `exercicios/semana02_delta_sql_modelagem/labs/02_delta_modelagem.sql` |
| 4 | `exercicios/semana03_windows_qualify/labs/03_windows_qualify.sql` |
| 5 | `exercicios/semana04_gold_layer_metricas/labs/04_gold_metricas.sql` |
| 6 | `exercicios/semana05_dashboards_aibi/labs/05_dashboard_datasets.sql` |
| 7 | `exercicios/semana06_genie_metric_views/labs/06_semantic_context.sql` |
| 8 | `exercicios/semana06_genie_metric_views/labs/06_metric_view_optional.sql` |
| 9 | `exercicios/semana07_performance_sql/labs/07_performance_sql.sql` |
| 10 | `exercicios/semana08_governanca_uc/labs/08_governanca_uc.sql` |
| 11 | `exercicios/semana09_jobs_alertas/labs/09_jobs_alertas.sql` |
| 12 | `exercicios/semana10_projeto_final/labs/10_final_query_pack.sql` |

O arquivo `06_metric_view_optional.sql` e opcional. Se o workspace ainda nao
suportar metric views, pule esse arquivo e siga com `semantic_revenue_base`.

---

## 3. Caminho A - Teste pelo SQL Editor

Este e o caminho mais facil para consumidores.

### 3.1 Abrir SQL Editor

1. Acesse o workspace Databricks.
2. Clique em `SQL Editor` no menu lateral.
3. Selecione um SQL Warehouse no topo da tela.
4. Se nao existir warehouse ativo, abra `SQL Warehouses` e inicie/crie um.

### 3.2 Executar seed

1. Abra localmente `datasets/seed_ecommerce.sql`.
2. Copie o conteudo.
3. Cole em uma nova query no SQL Editor.
4. Execute.

Resultado esperado:

```text
status      catalog_name  schema_name             loaded_at
seed_loaded workspace     databricks_sql_track    ...
```

Depois confira no Catalog:

```text
workspace.databricks_sql_track.bronze_customers_raw
workspace.databricks_sql_track.bronze_products_raw
workspace.databricks_sql_track.bronze_orders_raw
workspace.databricks_sql_track.bronze_order_items_raw
workspace.databricks_sql_track.bronze_web_events_raw
```

### 3.3 Executar Semana 01

Execute:

```text
exercicios/semana01_sql_warehouse_setup/labs/01_workspace_sql.sql
```

Resultado esperado:

- view `vw_bronze_row_counts` criada
- contagens de Bronze retornadas
- `DESCRIBE DETAIL bronze_orders_raw` executado com sucesso

Query de validacao:

```sql
SELECT *
FROM workspace.databricks_sql_track.vw_bronze_row_counts
ORDER BY table_name;
```

### 3.4 Executar Semana 02

Execute:

```text
exercicios/semana02_delta_sql_modelagem/labs/02_delta_modelagem.sql
```

Resultado esperado:

```text
silver_customers
silver_products
silver_orders
silver_order_items
```

Query de validacao:

```sql
SELECT
  order_status,
  COUNT(*) AS orders,
  ROUND(SUM(net_revenue), 2) AS net_revenue
FROM workspace.databricks_sql_track.silver_orders
GROUP BY order_status
ORDER BY orders DESC;
```

### 3.5 Executar Semanas 03 a 10

Siga a tabela da secao `Ordem oficial de teste`.

Depois de cada arquivo:

1. Verifique se a ultima query retorna resultado.
2. Abra `Catalog`.
3. Confirme se os objetos esperados foram criados.
4. Registre qualquer erro em `documentos/test_log.md`.

---

## 4. Caminho B - Teste pelo VS Code

Use este caminho se quiser editar localmente e executar no workspace.

### 4.1 Conferir extensao

No painel Databricks do VS Code, confira:

- `Local Folder`: pasta do projeto
- `Auth Type`: profile configurado
- `Target`: `dev`
- `Serverless`: habilitado quando disponivel
- `Python Environment`: configurado

### 4.2 Abrir arquivo SQL

1. Abra um arquivo `.sql`, por exemplo:

```text
TRILHA_DATABRICKS_SQL/datasets/seed_ecommerce.sql
```

2. Use os comandos da extensao Databricks:

```text
Run File on Databricks
Run selected SQL
Sync destination
```

Os nomes exatos podem variar por versao da extensao.

### 4.3 Validar no workspace

Mesmo executando pelo VS Code, valide no browser:

```sql
SELECT current_catalog(), current_schema(), current_user();

SELECT *
FROM workspace.databricks_sql_track.vw_bronze_row_counts;
```

---

## 5. Caminho C - CLI opcional

Use a CLI para manutencao e automacao. Para consumidor final, SQL Editor e mais
simples.

### 5.1 Verificar CLI

```powershell
databricks -v
```

Se ocorrer `Acesso negado` no Windows:

1. Feche e abra o terminal.
2. Teste no PowerShell fora do VS Code.
3. Verifique se a CLI instalada esta no PATH:

```powershell
Get-Command databricks
```

4. Se a extensao do VS Code funciona, continue pelo caminho B.
5. Reinstale a CLI somente se necessario.

### 5.2 Conferir perfil

```powershell
databricks auth profiles
```

### 5.3 Teste simples de workspace

```powershell
databricks workspace list /Users --profile cezar_databricks
```

### 5.4 Importar arquivos para workspace

Uma opcao e importar a pasta de labs:

```powershell
databricks workspace import-dir `
  "D:\3_Estudos\TRILHA_DATABRICKS_SQL\exercicios" `
  "/Users/SEU_EMAIL@databricks.com/trilha-databricks-sql/exercicios" `
  --profile cezar_databricks `
  --overwrite
```

Para arquivos `.sql`, a forma mais robusta para aluno ainda e copiar e executar
no SQL Editor. A importacao por CLI e melhor para autores e automacao.

### 5.5 Executar validacao por CLI

Depois de confirmar que `databricks -v` funciona:

Validar somente o conteudo gratuito:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_free_validation_databricks.ps1 `
  -Profile cezar_databricks
```

Validar a trilha completa:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_full_validation_databricks.ps1 `
  -Profile cezar_databricks
```

Validar tambem metric views:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_full_validation_databricks.ps1 `
  -Profile cezar_databricks `
  -IncludeMetricView
```

Rodar um arquivo especifico:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_sql_file_databricks.ps1 `
  -Profile cezar_databricks `
  -SqlFile .\datasets\seed_ecommerce.sql
```

---

## 6. Validacao final da trilha

Depois de rodar tudo, estas queries devem funcionar:

```sql
SELECT *
FROM workspace.databricks_sql_track.dash_executive_kpis;

SELECT *
FROM workspace.databricks_sql_track.ops_quality_summary
ORDER BY checked_at DESC;

SELECT *
FROM workspace.databricks_sql_track.secure_customer_value_public
ORDER BY lifetime_revenue DESC;

SELECT
  (SELECT ROUND(SUM(net_revenue), 2)
   FROM workspace.databricks_sql_track.silver_orders
   WHERE is_revenue_order) AS silver_net_revenue,
  (SELECT ROUND(SUM(line_net_revenue), 2)
   FROM workspace.databricks_sql_track.fct_order_item
   WHERE is_revenue_order) AS fact_net_revenue,
  (SELECT ROUND(SUM(net_revenue), 2)
   FROM workspace.databricks_sql_track.gold_daily_revenue) AS gold_net_revenue;
```

Resultado esperado:

- `dash_executive_kpis` retorna uma linha.
- `ops_quality_summary.failed_checks = 0`.
- a reconciliacao retorna diferenca zero ou aceitavel por arredondamento.

---

## 7. Registro de evidencias

Durante o teste, registre:

| Evidencia | Onde capturar |
| --- | --- |
| SQL Warehouse ativo | SQL Warehouses |
| seed executado | Query History |
| tabelas Bronze/Silver/Gold | Catalog |
| dashboard views | Catalog |
| quality checks | resultado de `ops_quality_summary` |
| performance | `EXPLAIN FORMATTED` da Semana 07 |
| governanca | views `secure_*` |

Sugestao de pasta local para prints:

```text
evidencias/free_trial/YYYY-MM-DD/
```

Nao versionar prints com dados sensiveis.

---

## 8. Problemas comuns

### Catalog `workspace` nao existe

Troque:

```sql
USE CATALOG workspace;
```

por um catalogo disponivel no seu ambiente.

### Sem permissao para criar schema/tabela

Peca permissao ou use um catalog/schema pessoal.

### SQL Warehouse desligado

Inicie em `SQL Warehouses` e aguarde ficar `Running`.

### Metric view falhou

Pule `06_metric_view_optional.sql`. Continue com `semantic_revenue_base`.

### CLI com acesso negado

Use SQL Editor ou VS Code Extension. Para consumidores, isso nao bloqueia a
trilha.
