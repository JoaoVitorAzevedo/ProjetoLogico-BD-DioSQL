Notas do diagrama / decisões de modelagem

- Cliente: mantido em tabela única com cpf ou cnpj; CHECK garante PF XOR PJ.
- Pessoa: tabela base para fornecedores e vendedores para permitir sobreposição (mesma pessoa pode atuar em ambos).
- Produtos e Fornecedores: relação N:N via produto_fornecedor.
- Estoque: relação 1:1 por produto (simplificação).
- Pedido, PedidoItem: modelo clássico com pedido_item como N:N com atributos.
- Pagamento: permite múltiplas formas por cliente; pedido_pagamento associa pagamentos a pedidos (1 pedido pode ter vários pagamentos).
- Entrega: tabela separada com status e código de rastreio; existe uma entrega por pedido (UNIQUE pedido_id).

Oficina — notas de modelagem
- Veículo ligado a um cliente (1 cliente pode ter N veículos).
- Mecânico referencia pessoa para reuso (mesma pessoa pode ser vendedor/fornecedor).
- Serviços (atividades) em tabela separada com preço base; ordens de serviço agregam serviços e peças.
- Ordem_item modela itens heterogêneos (serviço ou peça). CHECK garante XOR entre servico_id e peca_id.
- Estoque de peças mantido em estoque_peca; peca referencia fornecedor.
- Ordem_pagamento associa pagamentos já modelados no esquema e permite múltiplos pagamentos por ordem.

Notas sobre SQLite
- O projeto foi adaptado para SQLite: tipos e defaults foram ajustados (AUTOINCREMENT, REAL/INTEGER/TEXT).
- Foreign keys precisam estar habilitadas (PRAGMA foreign_keys = ON). O schema já define este PRAGMA no topo para execução direta via .read.
- Funções de data usam datetime('now') e modificadores (ex: datetime('now','-10 days')).

Separação de bancos
- O projeto foi separado em dois bancos SQLite distintos:
  - ecommerce.db (arquivos: schema/schema.sql, seed/seed.sql, queries/queries.sql)
  - oficina.db  (arquivos: schema/oficina_schema.sql, seed/oficina_seed.sql, queries/oficina_queries.sql)
- Cada schema é autocontido: inclui as tabelas base necessárias (cliente, pessoa, fornecedor, pagamento) quando aplicável.
- Justificativa: o SQLite não permite trocar de database dentro de um arquivo .sql; duplicação garante execução independente.
