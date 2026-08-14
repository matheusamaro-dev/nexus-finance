# Análise de mercado e direção do produto

Esta análise foi revisada em agosto de 2026 a partir de referências relevantes do Brasil e do exterior. Ela não tenta copiar todos os recursos do mercado: identifica os padrões que entregam mais valor e os adapta à proposta local-first do Nexus Finance.

## Referências analisadas

| Produto | Pontos fortes observados | Aprendizado para o Nexus |
|---|---|---|
| [Organizze](https://www.organizze.com.br/app-de-financas/) | contas e cartões, limites por categoria, alertas, relatórios, categorias próprias e conexão bancária via Open Finance | automatizar sem perder a simplicidade do lançamento manual |
| [Mobills](https://lp2.mobills.com.br/cartao-de-credito) | cartões, limites, parcelas, faturas, planejamento, metas, alertas e registro assistido por IA | tratar cartão e vencimento como parte central do fluxo brasileiro |
| [YNAB](https://www.ynab.com/features) | planejamento por objetivos, importação bancária, uso offline, relatórios e simulador de quitação de dívidas | transformar o orçamento em decisões futuras, não apenas em histórico |
| [Monarch Money](https://www.monarchmoney.com/features/recurring) | patrimônio líquido, identificação de recorrências, calendário de contas, categorização assistida, investimentos e painel configurável | destacar recorrências, patrimônio e revisão mensal em um painel flexível |

O [Banco Central do Brasil](https://www.bcb.gov.br/meubc/faqs/s/open-finance) informa que o Open Finance depende de consentimento, transmite os dados diretamente entre instituições autorizadas e nunca compartilha senha, token ou outras credenciais. Portanto, qualquer conexão bancária futura do Nexus deverá usar um parceiro autorizado e um backend revisado para segurança e LGPD.

## Situação do Nexus Finance

O aplicativo já entrega uma fundação importante:

- funcionamento local e independente de internet;
- cadastro, edição, exclusão, busca e filtros de lançamentos;
- painel mensal com navegação entre períodos;
- planejamento de limite mensal;
- persistência reativa e testes automatizados;
- identidade visual própria.

As maiores lacunas, comparadas às referências, estão em contas recorrentes, vencimentos, cartões e faturas, importação de dados, metas, relatórios e proteção dos dados locais.

## Princípios do produto

1. **Privacidade por padrão:** dados financeiros permanecem no aparelho até o usuário ativar uma sincronização ou backup.
2. **Automação conferível:** toda importação deve mostrar uma prévia, detectar duplicidades e permitir correção antes de salvar.
3. **Previsão antes de decoração:** saldo projetado, contas próximas e parcelas terminando têm prioridade sobre gráficos sem ação prática.
4. **Inteligência explicável:** regras locais de categorização vêm antes de IA; sugestões devem informar por que foram feitas e nunca alterar dados silenciosamente.
5. **Conexão bancária responsável:** nenhuma senha bancária será capturada. Open Finance será opcional e somente por integração autorizada.

## Roadmap recomendado

### Etapa 1 — rotina financeira real

- contas recorrentes com vencimento, valor esperado e situação de pagamento;
- calendário do mês e saldo projetado até o próximo salário;
- parcelas com início, fim e impacto futuro;
- importação local de CSV com prévia e deduplicação.

### Etapa 2 — contas e cartões

- contas bancárias e carteira com saldos separados;
- cartões, limite, fechamento, vencimento e faturas;
- compras parceladas distribuídas nas faturas corretas;
- transferências sem duplicar receita ou despesa.

### Etapa 3 — segurança e continuidade

- bloqueio por biometria;
- exportação e backup criptografado;
- restauração validada no próprio aplicativo;
- trilha de alterações para recuperar exclusões importantes.

### Etapa 4 — planejamento inteligente

- metas de reserva e objetivos com prazo;
- simulador de quitação de dívidas e economia de juros;
- relatórios por categoria, conta e período;
- revisão mensal com alertas e recomendações explicáveis.

### Etapa 5 — automação opcional

- leitura assistida de faturas em PDF e recibos por OCR;
- categorização local baseada no histórico do usuário;
- captura consentida de notificações de compras no Android;
- Open Finance por parceiro autorizado, com consentimento revogável.

## Próxima entrega

A próxima melhoria funcional deve iniciar a **Etapa 1**, modelando contas recorrentes e vencimentos sem misturar cartões, IA ou Open Finance na mesma branch. Em seguida, a importação em lote permitirá recuperar dados com segurança sem publicar informações financeiras pessoais no repositório.
