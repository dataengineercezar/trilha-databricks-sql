# Plano de Estudos

Esta trilha tem uma premissa simples: cada semana precisa gerar um artefato que
poderia existir dentro de uma empresa.

O aluno nao deve apenas "terminar uma aula". Ele deve sair de cada modulo com
uma pequena entrega tecnica: tabela, view, contrato de metrica, dashboard,
checklist de performance, politica de acesso ou job operacional.

---

## Metodologia

Cada semana segue o ciclo:

1. Contexto de negocio
2. Conceito tecnico
3. Lab guiado
4. Desafio sem resposta imediata
5. Checklist de qualidade
6. Artefato publicavel

O repositorio deve funcionar como:

- guia de estudo individual
- base para mentoria
- produto digital
- portfolio tecnico
- material de revisao para entrevista

Formato dos labs:

- `.sql`: fonte de verdade e execucao direta no SQL Editor.
- notebooks: versao guiada para aprendizado e demonstracao.

---

## Ritmo recomendado

Plano de 10 semanas:

| Semana | Horas | Foco |
| --- | ---: | --- |
| 01 | 3-4h | ambiente, SQL Warehouse, seed data |
| 02 | 4-5h | Delta SQL, limpeza, modelagem |
| 03 | 4-5h | windows, QUALIFY, analise temporal |
| 04 | 5-6h | Gold layer, KPIs e testes de metricas |
| 05 | 4-5h | datasets para dashboards e UX analitica |
| 06 | 5-6h | semantic layer, metric views e Genie |
| 07 | 4-5h | EXPLAIN, OPTIMIZE, Photon e custo |
| 08 | 4-5h | Unity Catalog, grants, masks, row filters |
| 09 | 3-4h | jobs SQL, alertas, operacao |
| 10 | 6-8h | projeto final e publicacao |

Plano intensivo de 4 semanas:

- Semana A: modulos 01, 02 e 03
- Semana B: modulos 04 e 05
- Semana C: modulos 06, 07 e 08
- Semana D: modulos 09 e 10

---

## Criterios de qualidade

Uma entrega so esta pronta quando:

- as tabelas tem nomes claros e namespace organizado
- as metricas possuem definicao de negocio
- queries complexas usam CTEs nomeadas por intencao
- nao ha `SELECT *` em artefatos finais
- filtros de qualidade estao documentados
- existe pelo menos um teste de reconciliacao
- o dashboard responde perguntas reais de negocio
- permissoes e audiencia estao definidas
- custo e performance foram avaliados

---

## Projeto final

Tema base: produto de dados de ecommerce.

Perguntas que o produto deve responder:

- Qual a receita liquida por dia, canal e categoria?
- Onde a conversao esta piorando?
- Quais clientes geram maior valor recorrente?
- Quais regioes ou canais precisam de acao?
- Que metricas devem ser monitoradas diariamente?

Entregaveis:

- modelo Bronze/Silver/Gold
- dashboard executivo
- metric contract
- checklist de governanca
- query de auditoria de qualidade
- plano de performance
- README do projeto final
- post tecnico para LinkedIn

---

## Validacao no Free Trial

Antes de publicar uma versao, execute o runbook:

```text
documentos/teste_free_trial_databricks.md
```

Registre evidencias em:

```text
documentos/test_log.md
```

---

## Como avaliar o aluno

Use esta rubrica:

| Dimensao | Peso | Excelente |
| --- | ---: | --- |
| SQL correto | 25% | queries legiveis, sem ambiguidade e com bons filtros |
| Modelagem | 20% | fatos/dimensoes coerentes e grao bem definido |
| Produto | 20% | dashboard responde decisoes reais |
| Governanca | 15% | permissoes, mascaras e ownership claros |
| Performance | 10% | sabe explicar plano, layout e custo |
| Comunicacao | 10% | documenta trade-offs e proximos passos |
