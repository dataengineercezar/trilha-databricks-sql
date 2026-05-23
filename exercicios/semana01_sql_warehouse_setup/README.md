# Semana 01 - SQL Warehouse, workspace e dataset seed

## Objetivo

Configurar a base da trilha no Databricks SQL, carregar o dataset seed e criar
os primeiros artefatos de auditoria.

Ao final, voce deve ter:

- schema `databricks_sql_track`
- tabelas Bronze carregadas
- view de contagem de linhas
- comentarios basicos nos objetos
- checklist de acesso ao SQL Warehouse

---

## Antes de comecar

1. Abra o Databricks SQL Editor.
2. Selecione um SQL Warehouse.
3. Execute `datasets/seed_ecommerce.sql`.
4. Execute `labs/01_workspace_sql.sql`.

Se o catalogo `workspace` nao existir, altere os scripts para um catalogo onde
voce tenha permissao.

---

## Conceitos

- SQL Warehouse e o compute para consultas, dashboards e conexoes BI.
- Bronze guarda dados proximos da origem.
- Auditoria minima inclui contagem de linhas, schema, comentario e data de carga.

---

## Desafio

Crie uma query que responda:

1. Quantos pedidos existem por status?
2. Quantos eventos web existem por tipo?
3. Qual tabela Bronze tem mais linhas?
4. Quais campos parecem conter PII?

Registre as respostas no seu proprio README de anotacoes.
