-- Dados de exemplo (SQLite) - OFICINA

-- Limpar dados antigos antes de inserir (permite re-execução)
DELETE FROM ordem_pagamento;
DELETE FROM ordem_item;
DELETE FROM ordem_servico;
DELETE FROM estoque_peca;
DELETE FROM peca;
DELETE FROM servico;
DELETE FROM mecanico;
DELETE FROM veiculo;
DELETE FROM pagamento;
DELETE FROM fornecedor;
DELETE FROM pessoa;
DELETE FROM cliente;

-- Reset auto-increment (SQLite)
DELETE FROM sqlite_sequence WHERE name='cliente';
DELETE FROM sqlite_sequence WHERE name='pessoa';
DELETE FROM sqlite_sequence WHERE name='fornecedor';
DELETE FROM sqlite_sequence WHERE name='veiculo';
DELETE FROM sqlite_sequence WHERE name='mecanico';
DELETE FROM sqlite_sequence WHERE name='servico';
DELETE FROM sqlite_sequence WHERE name='peca';
DELETE FROM sqlite_sequence WHERE name='estoque_peca';
DELETE FROM sqlite_sequence WHERE name='ordem_servico';
DELETE FROM sqlite_sequence WHERE name='ordem_item';
DELETE FROM sqlite_sequence WHERE name='pagamento';
DELETE FROM sqlite_sequence WHERE name='ordem_pagamento';

-- Clientes
INSERT INTO cliente (nome, email, cpf, cnpj, telefone) VALUES
('João Silva', 'joao.silva@oficina.com', '123.456.789-00', NULL, '11999990000'),
('Maria Oliveira', 'maria.oliveira@oficina.com', '222.333.444-55', NULL, '11988887777');

-- Pessoas / Fornecedores
INSERT INTO pessoa (nome, documento) VALUES
('Carlos Mecânico', '111.222.333-44'),
('Fornecedor Pecas LTDA', '66.666.666/0001-00');

INSERT INTO fornecedor (pessoa_id, nome_fantasia) VALUES
(2, 'Fornecedor Pecas');

-- Pagamentos (para ordens)
INSERT INTO pagamento (cliente_id, tipo, detalhes, ativo) VALUES
(1, 'dinheiro', 'Pagamento presencial', 1),
(2, 'cartao', 'Master **** 1111', 1);

-- Veículos
INSERT INTO veiculo (cliente_id, placa, modelo, ano) VALUES
(1, 'ABC1D23', 'Gol 1.0', 2010),
(2, 'XYZ9Z99', 'Corolla', 2018);

-- Mecânicos
INSERT INTO mecanico (pessoa_id, especialidade) VALUES
(1, 'eletrica');

-- Serviços oferecidos
INSERT INTO servico (descricao, preco_base) VALUES
('Troca de óleo', 120.00),
('Alinhamento e balanceamento', 80.00),
('Troca de pastilhas de freio', 200.00);

-- Peças e estoque
INSERT INTO peca (nome, codigo, preco, fornecedor_id) VALUES
('Filtro de óleo', 'FILT-001', 25.00, 1),
('Pastilha de freio - eixo dianteiro', 'PAST-100', 75.00, 1);

INSERT INTO estoque_peca (peca_id, quantidade, localizacao) VALUES
(1, 50, 'almoxarifado'),
(2, 15, 'almoxarifado');

-- Ordens de serviço
INSERT INTO ordem_servico (cliente_id, veiculo_id, mecanico_id, data_abertura, status, observacoes) VALUES
(1, 1, 1, datetime('now','-5 days'), 'finalizado', 'Troca de óleo e filtro'),
(1, 1, 1, datetime('now','-2 days'), 'em_andamento', 'Barulho no motor'),
(2, 2, NULL, datetime('now','-1 days'), 'aberto', 'Agendamento para alinhamento');

-- Itens das ordens
INSERT INTO ordem_item (ordem_id, tipo, servico_id, peca_id, quantidade, preco_unitario) VALUES
(1, 'servico', 1, NULL, 1, 120.00),
(1, 'peca', NULL, 1, 1, 25.00),
(2, 'servico', 3, NULL, 1, 200.00),
(3, 'servico', 2, NULL, 1, 80.00);

-- Associação pagamento <-> ordem
INSERT INTO ordem_pagamento (ordem_id, pagamento_id, valor) VALUES
(1, 1, 145.00),
(3, 2, 80.00);
