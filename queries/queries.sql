-- Consultas de exemplo (SQLite)

-- 1) Quantos pedidos foram feitos por cada cliente?
SELECT c.id, c.nome, COUNT(p.id) AS total_pedidos
FROM cliente c
LEFT JOIN pedido p ON p.cliente_id = c.id
GROUP BY c.id, c.nome
ORDER BY total_pedidos DESC;

-- 2) Algum vendedor também é fornecedor? (nomes)
SELECT p.id, p.nome
FROM pessoa p
JOIN vendedor v ON v.pessoa_id = p.id
JOIN fornecedor f ON f.pessoa_id = p.id;

-- 3) Relação de produtos, fornecedores e estoques
SELECT pr.nome AS produto, f.nome_fantasia AS fornecedor, COALESCE(e.quantidade,0) AS estoque
FROM produto pr
JOIN produto_fornecedor pf ON pf.produto_id = pr.id
JOIN fornecedor f ON f.id = pf.fornecedor_id
LEFT JOIN estoque e ON e.produto_id = pr.id
ORDER BY pr.nome;

-- 4) Nomes dos fornecedores e nomes dos produtos
SELECT f.nome_fantasia, pr.nome
FROM fornecedor f
JOIN produto_fornecedor pf ON pf.fornecedor_id = f.id
JOIN produto pr ON pr.id = pf.produto_id
ORDER BY f.nome_fantasia, pr.nome;

-- 5) Atributo derivado: total de cada pedido (somando itens)
SELECT p.id AS pedido_id, p.data_pedido,
       SUM(pi.quantidade * pi.preco_unitario) AS total_calculado
FROM pedido p
JOIN pedido_item pi ON pi.pedido_id = p.id
GROUP BY p.id, p.data_pedido
ORDER BY total_calculado DESC;

-- 6) Clientes com mais de 1 pedido (HAVING)
SELECT c.id, c.nome, COUNT(p.id) AS num_pedidos
FROM cliente c
JOIN pedido p ON p.cliente_id = c.id
GROUP BY c.id, c.nome
HAVING COUNT(p.id) > 1
ORDER BY num_pedidos DESC;

-- 7) Filtros com WHERE: pedidos em um intervalo de datas e ordenados
SELECT p.id, c.nome AS cliente, p.data_pedido, p.status
FROM pedido p
JOIN cliente c ON c.id = p.cliente_id
WHERE p.data_pedido >= datetime('now','-30 days')
ORDER BY p.data_pedido DESC;

-- 8) Junção complexa: pedidos, itens, fornecedores dos produtos
SELECT p.id AS pedido, c.nome AS cliente, pr.nome AS produto, f.nome_fantasia AS fornecedor, pi.quantidade
FROM pedido p
JOIN cliente c ON c.id = p.cliente_id
JOIN pedido_item pi ON pi.pedido_id = p.id
JOIN produto pr ON pr.id = pi.produto_id
JOIN produto_fornecedor pf ON pf.produto_id = pr.id
JOIN fornecedor f ON f.id = pf.fornecedor_id
ORDER BY p.id, pr.nome;
