# Semana 02 - Delta SQL e modelagem Silver

## Objetivo

Transformar tabelas Bronze em uma camada Silver confiavel, com tipos corretos,
campos derivados e regras de qualidade explicitas.

Ao final, voce deve ter:

- `silver_customers`
- `silver_products`
- `silver_orders`
- `silver_order_items`
- queries de reconciliacao Bronze x Silver

---

## Conceitos

Silver e a camada de dados limpos e padronizados. Ela ainda nao e necessariamente
otimizada para dashboard, mas precisa ser confiavel para servir de base para
varias Gold layers.

Decisoes tecnicas desta semana:

- converter timestamps raw para `TIMESTAMP`
- derivar `DATE`
- normalizar status e canais
- calcular receita bruta e receita liquida no nivel do pedido
- separar pedidos que contam como receita dos pedidos cancelados

---

## Desafio

Adicione uma regra de qualidade:

- pedidos com `gross_revenue <= 0` devem ser investigados
- pedidos cancelados nao devem contar como receita
- pedidos reembolsados devem manter historico, mas reduzir receita liquida

Explique em texto por que cada regra existe.
