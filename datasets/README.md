# Dataset da Trilha

O dataset seed simula um ecommerce pequeno, mas suficiente para praticar os
conceitos centrais da trilha:

- clientes
- produtos
- pedidos
- itens de pedido
- eventos web
- regioes comerciais

O objetivo nao e volume. O objetivo e qualidade de modelagem, clareza de
metricas e construcao de produto de dados.

---

## Como carregar

No Databricks SQL Editor, execute:

```sql
-- datasets/seed_ecommerce.sql
```

O script cria as tabelas Bronze:

- `bronze_customers_raw`
- `bronze_products_raw`
- `bronze_orders_raw`
- `bronze_order_items_raw`
- `bronze_web_events_raw`

Por padrao, ele usa:

```sql
USE CATALOG workspace;
CREATE SCHEMA IF NOT EXISTS databricks_sql_track;
USE SCHEMA databricks_sql_track;
```

Se necessario, altere o catalogo no inicio do arquivo.

---

## Por que ecommerce

Ecommerce permite discutir problemas comuns de engenharia de dados:

- pedidos cancelados
- receita bruta, desconto, reembolso e receita liquida
- clientes recorrentes
- funil de conversao
- produtos e categorias
- canal de aquisicao
- regioes com regras de acesso
- dashboards para negocio

Esses conceitos transferem bem para varejo, marketplace, SaaS, fintech e
operacoes digitais.

---

## Notebook opcional

Para quem preferir uma experiencia guiada no Databricks Workspace, use:

```text
datasets/notebooks/00_seed_ecommerce_notebook.sql
```

Esse arquivo e um Databricks source notebook em SQL. Ele pode ser importado como
notebook e executado celula por celula.
