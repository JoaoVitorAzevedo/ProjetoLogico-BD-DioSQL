-- Dados de exemplo (SQLite)

-- Clientes
INSERT INTO cliente (nome, email, cpf, cnpj, telefone) VALUES
('João Silva', 'joao@example.com', '123.456.789-00', NULL, '11999990000'),
('Empresa ABC Ltda', 'contato@abc.com', NULL, '12.345.678/0001-99', '1133333000');

-- Pessoas (para fornecedores/vendedores)
INSERT INTO pessoa (nome, documento) VALUES
('Mariana Souza', '987.654.321-00'),
('Fornecedor X LTDA', '55.555.555/0001-00');

-- Fornecedor e Vendedor (mesma pessoa -> será ambos)
INSERT INTO fornecedor (pessoa_id, nome_fantasia) VALUES (1, 'Mariana Fornecimentos');
INSERT INTO vendedor (pessoa_id, codigo_vendedor) VALUES (1, 'VEND-001');

-- Outro fornecedor
INSERT INTO fornecedor (pessoa_id, nome_fantasia) VALUES (2, 'Fornecedor X');

-- Produtos
INSERT INTO produto (nome, descricao, preco) VALUES
('Teclado Mecânico', 'Teclado mecânico RGB', 299.90),
('Mouse Gamer', 'Mouse com DPI ajustável', 149.50),
('Monitor 24"', 'Monitor Full HD 24 polegadas', 799.00);

-- Associação produto <-> fornecedor
INSERT INTO produto_fornecedor (produto_id, fornecedor_id, preco_fornecedor) VALUES
(1, 1, 200.00),
(2, 1, 100.00),
(3, 2, 600.00);

-- Estoque
INSERT INTO estoque (produto_id, quantidade, localizacao) VALUES
(1, 10, 'CD-SP'),
(2, 25, 'CD-SP'),
(3, 5, 'CD-RJ');

-- Pagamentos (múltiplas formas por cliente)
INSERT INTO pagamento (cliente_id, tipo, detalhes) VALUES
(1, 'cartao', 'Visa **** 4242'),
(1, 'pix', 'joao.pix@pag'),
(2, 'boleto', 'Conta 001');

-- Pedidos e itens (datas usando datetime do SQLite)
INSERT INTO pedido (cliente_id, vendedor_id, data_pedido, status) VALUES
(1, 1, datetime('now','-10 days'), 'concluido'),
(1, 1, datetime('now','-2 days'), 'processando'),
(2, NULL, datetime('now','-1 days'), 'novo');

INSERT INTO pedido_item (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1, 1, 1, 299.90),
(1, 2, 1, 149.50),
(2, 2, 2, 140.00),
(3, 3, 1, 799.00);

-- Associação pagamentos a pedidos
INSERT INTO pedido_pagamento (pedido_id, pagamento_id, valor) VALUES
(1, 1, 449.40),
(2, 2, 280.00),
(3, 3, 799.00);

-- Entregas
INSERT INTO entrega (pedido_id, status, codigo_rastreamento) VALUES
(1, 'entregue', 'BR1234567890'),
(2, 'em_transito', 'BR0987654321');