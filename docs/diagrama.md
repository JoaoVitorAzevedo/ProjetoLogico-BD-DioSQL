Notas do diagrama / decisões de modelagem

- Cliente: mantido em tabela única com cpf ou cnpj; CHECK garante PF XOR PJ.
- Pessoa: tabela base para fornecedores e vendedores para permitir sobreposição (mesma pessoa pode atuar em ambos).
- Produtos e Fornecedores: relação N:N via produto_fornecedor.
- Estoque: relação 1:1 por produto (simplificação).
- Pedido, PedidoItem: modelo clássico com pedido_item como N:N com atributos.
- Pagamento: permite múltiplas formas por cliente; pedido_pagamento associa pagamentos a pedidos (1 pedido pode ter vários pagamentos).
- Entrega: tabela separada com status e código de rastreio; existe uma entrega por pedido (UNIQUE pedido_id).

Notas sobre SQLite
- O projeto foi adaptado para SQLite: tipos e defaults foram ajustados (AUTOINCREMENT, REAL/INTEGER/TEXT).
- Foreign keys precisam estar habilitadas (PRAGMA foreign_keys = ON). O schema já define este PRAGMA no topo para execução direta via .read.
- Funções de data usam datetime('now') e modificadores (ex: datetime('now','-10 days')).
