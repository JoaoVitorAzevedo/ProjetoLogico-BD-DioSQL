-- Consultas de exemplo (SQLite) - E-COMMERCE

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

-- 4) Atributo derivado: total de cada pedido (somando itens)
SELECT p.id AS pedido_id, p.data_pedido,
       SUM(pi.quantidade * pi.preco_unitario) AS total_calculado
FROM pedido p
JOIN pedido_item pi ON pi.pedido_id = p.id
GROUP BY p.id, p.data_pedido
ORDER BY total_calculado DESC;

-- 5) Clientes com mais de 1 pedido (HAVING)
SELECT c.id, c.nome, COUNT(p.id) AS num_pedidos
FROM cliente c
JOIN pedido p ON p.cliente_id = c.id
GROUP BY c.id, c.nome
HAVING COUNT(p.id) > 1
ORDER BY num_pedidos DESC;
