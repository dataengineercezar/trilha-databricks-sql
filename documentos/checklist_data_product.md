# Checklist de Produto de Dados

Use este checklist no projeto final e em qualquer entrega real.

---

## 1. Consumidor

- [ ] Quem usa este produto?
- [ ] Qual decisao ele suporta?
- [ ] Qual e a frequencia de uso?
- [ ] O consumidor entende as metricas?
- [ ] Existe canal de feedback?

---

## 2. Contrato

- [ ] Nome do produto definido
- [ ] Owner tecnico definido
- [ ] Owner de negocio definido
- [ ] SLA ou expectativa de atualizacao definida
- [ ] Fonte dos dados documentada
- [ ] Limitacoes conhecidas documentadas

---

## 3. Dados

- [ ] Grao de cada tabela explicado
- [ ] Chaves primarias logicas definidas
- [ ] Duplicidades tratadas
- [ ] Nulos relevantes tratados
- [ ] Datas e timezones documentados
- [ ] PII identificada

---

## 4. Metricas

- [ ] Cada metrica tem formula
- [ ] Cada metrica tem dono
- [ ] Filtros de negocio estao explicitos
- [ ] Existe reconciliacao Silver x Gold
- [ ] Existe query de auditoria
- [ ] Alteracoes de definicao sao versionadas

---

## 5. Consumo

- [ ] Dashboard tem publico alvo claro
- [ ] Primeira tela responde as perguntas principais
- [ ] Filtros sao uteis e nao excessivos
- [ ] Visualizacoes tem titulo orientado a decisao
- [ ] Ultima atualizacao esta visivel ou documentada
- [ ] Permissoes foram testadas com usuario nao-admin

---

## 6. Operacao

- [ ] Job ou rotina de atualizacao definido
- [ ] Alertas de falha configurados
- [ ] Query de qualidade executavel
- [ ] Plano de rollback ou recuperacao conhecido
- [ ] Custo do warehouse revisado
- [ ] Owner sabe investigar falhas

---

## 7. Governanca

- [ ] Objetos estao em catalog/schema corretos
- [ ] Grants usam grupos, nao usuarios soltos
- [ ] Views protegem detalhes sensiveis
- [ ] Masks ou row filters foram considerados
- [ ] Lineage foi revisado
- [ ] Documentacao esta acessivel ao consumidor
