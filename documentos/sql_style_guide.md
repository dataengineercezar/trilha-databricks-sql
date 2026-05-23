# SQL Style Guide

Este guia define o padrao de SQL da trilha. O objetivo e escrever queries que
uma equipe real consiga revisar, manter e operar.

---

## Naming

Use nomes em ingles, snake_case e com prefixo por camada:

- `bronze_orders_raw`
- `silver_orders`
- `dim_customer`
- `fct_order_item`
- `gold_daily_revenue`

Evite:

- `tabela_final`
- `query_nova`
- `teste2`
- `base_ok`
- abreviacoes que so o autor entende

---

## CTEs

Use CTEs para explicar etapas de raciocinio.

Bom:

```sql
WITH valid_orders AS (
  SELECT *
  FROM silver_orders
  WHERE order_status IN ('paid', 'shipped', 'delivered')
),
daily_revenue AS (
  SELECT
    order_date,
    SUM(net_revenue) AS net_revenue
  FROM valid_orders
  GROUP BY order_date
)
SELECT *
FROM daily_revenue;
```

Ruim:

```sql
WITH a AS (...),
b AS (...),
c AS (...)
SELECT * FROM c;
```

---

## SELECT *

Permitido:

- exploracao inicial
- exemplos pequenos
- checagem rapida de schema

Proibido:

- views finais
- tabelas Gold
- dashboards
- jobs
- contratos de dados

---

## Datas

Use nomes consistentes:

- `created_at`: timestamp bruto
- `updated_at`: timestamp bruto
- `order_ts`: timestamp do evento
- `order_date`: data derivada
- `ingestion_ts`: timestamp de ingestao

Evite misturar timezone sem documentar.

---

## Metricas

Toda metrica oficial precisa de:

- nome tecnico
- nome de negocio
- formula
- grao
- filtros aplicados
- dono
- limitacoes

Exemplo:

```text
net_revenue
Receita liquida
gross_revenue - discount_amount - refund_amount
Grao: dia, canal, categoria
Exclui pedidos cancelados
Dono: Revenue Operations
```

---

## Comentarios

Comente decisoes, nao obviedades.

Bom:

```sql
-- Cancelled orders are excluded because finance recognizes revenue only after payment.
WHERE order_status IN ('paid', 'shipped', 'delivered')
```

Ruim:

```sql
-- Select columns
SELECT customer_id
```

---

## Performance

Em artefatos finais:

- filtre antes de agregar
- projete apenas colunas necessarias
- evite funcoes sobre coluna no lado filtrado quando houver alternativa
- cuidado com `COUNT(DISTINCT ...)` em alta cardinalidade
- use Gold para consultas recorrentes de dashboard
- valide com `EXPLAIN FORMATTED`

---

## Review checklist

Antes de aprovar uma query:

- o grao esta claro?
- nomes estao legiveis?
- filtros de negocio estao documentados?
- joins tem chaves explicitas?
- duplicidade foi considerada?
- nulos foram tratados?
- custo/performance foi avaliado?
- a query pode ser reexecutada sem quebrar?
