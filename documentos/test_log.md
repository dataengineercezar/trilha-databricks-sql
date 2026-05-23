# Test Log

Use este arquivo para registrar validacoes no Databricks Free Trial.

## Execucao

Data: 2026-05-23

Workspace: Databricks Free Trial

SQL Warehouse: Serverless Starter Warehouse

Perfil VS Code/CLI: cezar_databricks

Catalog: workspace

Schema: databricks_sql_track

---

## Checklist

| Etapa | Status | Evidencia | Observacao |
| --- | --- | --- | --- |
| Seed executado | OK | CLI Statements API |  |
| Semana 01 | OK | CLI Statements API |  |
| Semana 02 | OK | CLI Statements API |  |
| Semana 03 | OK | CLI Statements API |  |
| Semana 04 | OK | CLI Statements API |  |
| Semana 05 | OK | CLI Statements API |  |
| Semana 06 semantic view | OK | CLI Statements API |  |
| Semana 06 metric view opcional | OK | CLI Statements API | Recurso suportado no workspace testado |
| Semana 07 performance | OK | CLI Statements API |  |
| Semana 08 governanca | OK | CLI Statements API | Corrigida view segura para buscar email em `dim_customer` |
| Semana 09 alertas | OK | CLI Statements API |  |
| Semana 10 query pack final | OK | CLI Statements API |  |

---

## Erros encontrados

| Arquivo | Erro | Causa provavel | Correcao |
| --- | --- | --- | --- |
| `semana08_governanca_uc/labs/08_governanca_uc.sql` | `email` nao existia em `gold_customer_value` | view segura usava tabela agregada sem PII | join com `dim_customer` para mascarar email |
| `scripts/run_sql_file_databricks.ps1` | blocos apenas de comentario eram enviados para API | splitter nao ignorava comentario-only statement | adicionado filtro de conteudo executavel |

---

## Resultado final

Resumo: Validacao completa da trilha aprovada no Databricks Free Trial via Databricks CLI v0.299.1 e SQL Statements API.

Decisao:

- [x] Aprovado para repo publico.
- [x] Aprovado para premium.
- [ ] Precisa correcao antes do lancamento.
