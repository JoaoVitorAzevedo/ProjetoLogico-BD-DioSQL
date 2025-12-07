-- Consultas de exemplo (SQLite) - OFICINA

-- 1) Quantos serviços/ordens foram realizados por cada mecânico?
SELECT m.id AS mecanico_id, p.nome AS mecanico_nome, COUNT(o.id) AS total_ordens
FROM mecanico m
JOIN pessoa p ON p.id = m.pessoa_id
LEFT JOIN ordem_servico o ON o.mecanico_id = m.id
GROUP BY m.id, p.nome
ORDER BY total_ordens DESC;

-- 2) Veículos de um cliente (WHERE)
SELECT v.id, v.placa, v.modelo, v.ano
FROM veiculo v
WHERE v.cliente_id = 1
ORDER BY v.modelo;

-- 3) Valor total de cada ordem (atributo derivado)
SELECT o.id AS ordem_id, o.data_abertura,
       SUM(oi.quantidade * oi.preco_unitario) AS total_ordem
FROM ordem_servico o
JOIN ordem_item oi ON oi.ordem_id = o.id
GROUP BY o.id, o.data_abertura
ORDER BY total_ordem DESC;

-- 4) Peças com estoque baixo (WHERE + ORDER BY)
SELECT p.id, p.nome, COALESCE(e.quantidade,0) AS estoque
FROM peca p
LEFT JOIN estoque_peca e ON e.peca_id = p.id
WHERE COALESCE(e.quantidade,0) < 10
ORDER BY estoque ASC, p.nome;

-- 5) Mecânicos com mais de 1 ordem (HAVING)
SELECT m.id, p.nome, COUNT(o.id) AS num_ordens
FROM mecanico m
JOIN pessoa p ON p.id = m.pessoa_id
JOIN ordem_servico o ON o.mecanico_id = m.id
GROUP BY m.id, p.nome
HAVING COUNT(o.id) > 1
ORDER BY num_ordens DESC;

-- 6) Junção complexa: ordens, cliente, veículo, mecânico, itens e fornecedores das peças
SELECT o.id AS ordem_id, c.nome AS cliente, v.placa AS placa, me.especialidade AS mecanico_esp,
       oi.tipo, s.descricao AS servico, pc.nome AS peca, f.nome_fantasia AS fornecedor, oi.quantidade, oi.preco_unitario
FROM ordem_servico o
JOIN cliente c ON c.id = o.cliente_id
JOIN veiculo v ON v.id = o.veiculo_id
LEFT JOIN mecanico me ON me.id = o.mecanico_id
LEFT JOIN ordem_item oi ON oi.ordem_id = o.id
LEFT JOIN servico s ON s.id = oi.servico_id
LEFT JOIN peca pc ON pc.id = oi.peca_id
LEFT JOIN fornecedor f ON f.id = pc.fornecedor_id
ORDER BY o.id, oi.tipo;
