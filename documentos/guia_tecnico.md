# Guia Tecnico - Databricks SQL & AI/BI

Este guia e a referencia viva da trilha. Ele explica os conceitos que aparecem
nos labs e registra as decisoes tecnicas que transformam SQL em produto de
dados.

---

## 1. O papel do Databricks SQL

Databricks SQL e a camada de data warehousing do Lakehouse. Ele permite consultar
dados em Delta Lake, criar views, materializar metricas, publicar dashboards,
conectar ferramentas BI e operar workloads SQL em Jobs.

Na pratica, ele atende tres perfis:

- engenharia de dados: cria camadas confiaveis e operacionais
- analytics engineering: modela metricas e semantic layer
- negocio/BI: consome dashboards e perguntas em linguagem natural

O ponto central e que Databricks SQL nao substitui PySpark em todos os cenarios.
Ele e melhor quando o problema e expressavel como transformacao relacional,
agregacao, consumo analitico, metricas ou BI.

---

## 2. SQL Warehouse

SQL Warehouse e o compute otimizado para queries SQL, dashboards e conexoes BI.
Ele aparece nos menus do SQL Editor, Catalog Explorer e AI/BI Dashboards.

Boas praticas:

- use Serverless SQL Warehouse quando disponivel
- separe warehouses por carga: exploracao, dashboard critico, jobs
- monitore tempo de start, filas, concorrencia e custo
- prefira dashboards em warehouse dedicado quando o consumo for recorrente
- revise permissoes `CAN USE` e ownership do warehouse

Sinais de sizing ruim:

- dashboard demora para abrir mesmo com dados pequenos
- usuarios concorrentes ficam em fila
- queries simples gastam muito tempo em scan
- jobs SQL competem com exploracao ad hoc

---

## 3. Unity Catalog

Unity Catalog organiza dados em tres niveis:

```text
catalog.schema.object
```

Objetos comuns:

- table
- view
- materialized view
- metric view
- function
- volume

Padrao da trilha:

```text
workspace.databricks_sql_track.bronze_*
workspace.databricks_sql_track.silver_*
workspace.databricks_sql_track.gold_*
workspace.databricks_sql_track.dim_*
workspace.databricks_sql_track.fct_*
```

Boas praticas:

- defina ownership por dominio
- documente colunas criticas com `COMMENT`
- use views para exposicao controlada
- use masks para PII quando aplicavel
- use row filters para segmentacao por regiao, unidade ou time
- evite dar acesso direto a Bronze para consumidores de negocio

---

## 4. Delta SQL

Delta Lake traz transacoes ACID, schema enforcement, time travel e comandos de
manutencao para tabelas analiticas.

Comandos importantes:

```sql
DESCRIBE DETAIL tabela;
DESCRIBE HISTORY tabela;
OPTIMIZE tabela;
VACUUM tabela;
MERGE INTO destino USING origem ON condicao;
```

Use Delta SQL para:

- criar tabelas gerenciadas
- limpar e padronizar dados
- construir Silver e Gold
- manter historico de operacoes
- aplicar merges incrementais

Evite:

- sobrescrever tabelas sem criterio de recuperacao
- misturar graos diferentes na mesma tabela
- criar Gold com regra de negocio escondida
- usar nomes tecnicos demais para objetos consumidos por negocio

---

## 5. Modelagem para analytics

Antes de escrever a query final, responda:

- Qual e o grao da tabela?
- Cada linha representa o que?
- Quais dimensoes explicam a metrica?
- A metrica e aditiva, semi-aditiva ou nao aditiva?
- Quais filtros de qualidade foram aplicados?
- Quem e o dono da definicao?

Exemplo:

```text
Tabela: gold_daily_revenue
Grao: um dia, um canal, uma categoria
Metrica: net_revenue = gross_revenue - discount_amount - refund_amount
Fonte: silver_orders + silver_order_items
Audiencia: time comercial e lideranca
Atualizacao: diaria
```

---

## 6. Window functions e QUALIFY

Window functions calculam valores sobre uma janela sem colapsar linhas.

Casos comuns:

- ranking por categoria
- media movel
- comparacao contra periodo anterior
- deduplicacao
- cohort e retencao

`QUALIFY` permite filtrar resultado de window function sem criar CTE extra.

```sql
SELECT
  customer_id,
  order_id,
  order_ts,
  ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY order_ts DESC
  ) AS rn
FROM silver_orders
QUALIFY rn = 1;
```

Use com cuidado: `QUALIFY` melhora legibilidade, mas ainda precisa de nomes
claros para a janela e criterio de ordenacao deterministico.

---

## 7. Gold layer e metricas

Gold e a camada onde dados viram decisao. Ela nao deve ser apenas "mais uma
tabela agregada"; deve representar um contrato de negocio.

Uma boa Gold layer tem:

- grao explicito
- definicoes de metricas
- dimensoes amigaveis
- filtros de qualidade documentados
- reconciliacao contra a camada anterior
- comentarios de tabela e coluna

Exemplo de teste de reconciliacao:

```sql
SELECT
  (SELECT ROUND(SUM(net_revenue), 2) FROM silver_orders) AS silver_revenue,
  (SELECT ROUND(SUM(net_revenue), 2) FROM gold_daily_revenue) AS gold_revenue;
```

---

## 8. AI/BI Dashboards

Dashboards AI/BI sao a interface de consumo para usuarios de negocio. Eles
devem responder perguntas, nao apenas mostrar graficos.

Checklist de um bom dashboard:

- primeira dobra mostra KPIs principais
- filtros refletem o jeito que o negocio decide
- cada grafico tem pergunta associada
- existe drill-down para investigacao
- metricas tem fonte e definicao
- usuarios sabem quando o dado foi atualizado
- permissao de acesso esta alinhada com a audiencia

Artefatos que devem existir antes do dashboard:

- tabela Gold ou view confiavel
- metric contract
- lista de perguntas de negocio
- regra de atualizacao
- criterio de qualidade

---

## 9. Genie e metric views

Genie permite explorar dados com linguagem natural. Para funcionar bem, ele
precisa de contexto semantico: nomes bons, comentarios, exemplos de perguntas,
metricas consistentes e objetos bem modelados.

Metric views sao a implementacao de semantica de negocio no Unity Catalog. Elas
separam medidas e dimensoes, permitindo que uma metrica seja definida uma vez e
consumida em diferentes agrupamentos.

Padrao mental:

```text
tabela/view = dados estruturados
metric view = definicao governada de medidas e dimensoes
Genie = interface conversacional sobre contexto confiavel
```

Boas praticas:

- use nomes de negocio, nao nomes de sistema
- inclua sinonimos e descricoes quando a UI permitir
- documente exemplos de perguntas esperadas
- teste perguntas ambiguas
- revise respostas com usuarios reais

---

## 10. Performance

Performance em Databricks SQL depende de tres camadas:

- compute: tipo e tamanho do SQL Warehouse
- layout: tamanho de arquivos, particionamento, clustering, estatisticas
- query: filtros, joins, agregacoes, window functions e colunas lidas

Ferramentas:

```sql
EXPLAIN FORMATTED
DESCRIBE DETAIL
DESCRIBE HISTORY
OPTIMIZE
ANALYZE TABLE
```

Checklist rapido:

- a query filtra cedo?
- le apenas colunas necessarias?
- evita `SELECT *`?
- joins usam chaves com cardinalidade esperada?
- tabelas grandes tem layout adequado?
- a Gold layer reduz custo de dashboards recorrentes?

---

## 11. Governanca

Governanca nao e burocracia; e o que permite escalar o uso dos dados sem criar
risco.

Pontos minimos:

- catalogo e schema organizados por dominio
- grupos de acesso por funcao
- views para consumo
- mascaras para PII
- row filters para escopo regional ou comercial
- comentarios e tags para descoberta
- lineage revisado antes de mudancas criticas

Exemplo:

```sql
GRANT SELECT ON TABLE gold_daily_revenue TO `account users`;
```

Em ambientes reais, prefira grupos especificos em vez de permissoes amplas.

---

## 12. Produto de dados

Um produto de dados tem consumidor, contrato, SLA e ownership.

Template minimo:

```text
Nome:
Dono:
Consumidores:
Perguntas atendidas:
Tabelas/views:
Metricas oficiais:
Frequencia de atualizacao:
SLA:
Permissoes:
Known limitations:
```

Se ninguem sabe qual decisao o artefato suporta, ele ainda e apenas uma tabela.

---

## Referencias oficiais

- Databricks SQL: https://docs.databricks.com/aws/en/sql/get-started/
- SQL Warehouses: https://docs.databricks.com/aws/en/compute/sql-warehouse
- AI/BI: https://docs.databricks.com/aws/en/ai-bi/
- Dashboards: https://docs.databricks.com/aws/en/dashboards/tutorials/create-dashboard
- Metric views: https://docs.databricks.com/aws/en/metric-views
- CREATE VIEW / METRICS: https://docs.databricks.com/gcp/en/sql/language-manual/sql-ref-syntax-ddl-create-view
