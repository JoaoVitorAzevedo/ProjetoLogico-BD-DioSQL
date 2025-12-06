## Descrição do Desafio - Construindo seu Primeiro Projeto Lógico de Banco de Dados

Replique a modelagem do projeto lógico de banco de dados para o cenário de e-commerce. Fique atento as definições de chave primária e estrangeira, assim como as constraints presentes no cenário modelado. Perceba que dentro desta modelagem haverá relacionamentos presentes no modelo EER. Sendo assim, consulte como proceder para estes casos. Além disso, aplique o mapeamento de modelos aos refinamentos propostos no módulo de modelagem conceitual.

Objetivo
Refine o modelo apresentado acrescentando os seguintes pontos:
- Cliente PJ e PF – Uma conta pode ser PJ ou PF, mas não pode ter as duas informações;
- Pagamento – Pode ter cadastrado mais de uma forma de pagamento;
- Entrega – Possui status e código de rastreio;
- Relacionamentos EER mapeados para o esquema relacional.

Estrutura do projeto
- schema/schema.sql  -> Script DDL (criação das tabelas e constraints)
- seed/seed.sql      -> Inserção de dados de exemplo
- queries/queries.sql -> Consultas que demonstram requisitos (SELECT, WHERE, derived, ORDER BY, HAVING, JOINs)
- docs/diagrama.md   -> Notas sobre decisões de modelagem
- .gitignore

Como executar (SQLite)
1. Criar o arquivo de banco e aplicar o schema:
   - Usando o CLI: sqlite3 ecommerce.db ".read schema/schema.sql"
   - Ou: sqlite3 ecommerce.db < schema/schema.sql
2. Habilitar foreign keys (caso necessário):
   - No CLI: sqlite3 ecommerce.db "PRAGMA foreign_keys = ON;"
   - O schema já define PRAGMA foreign_keys = ON no topo para execução via .read.
3. Popular dados:
   - sqlite3 ecommerce.db ".read seed/seed.sql"
   - Ou: sqlite3 ecommerce.db < seed/seed.sql
4. Testar consultas:
   - sqlite3 ecommerce.db ".read queries/queries.sql"
   - Ou abrir no DB Browser for SQLite e executar os arquivos SQL.

Observações
- SQLite usa tipos mais permissivos; alguns defaults e funções de data foram adaptados (datetime('now')).
- Verifique se o cliente/GUI usado respeita PRAGMA foreign_keys (o CLI e DB Browser normalmente respeitam).

Perguntas exemplo respondidas nas queries
- Quantos pedidos foram feitos por cada cliente?
- Algum vendedor também é fornecedor?
- Relação de produtos, fornecedores e estoques
- Relação de nomes dos fornecedores e nomes dos produtos

Decisões de modelagem
- Cliente tem colunas cpf e cnpj com CHECK para garantir PF XOR PJ.
- Fornecedores e vendedores apontam para uma tabela geral pessoa para permitir sobreposição (um mesmo indivíduo pode ser fornecedor e vendedor).
- Pagamentos permitem múltiplas formas por cliente; pedido pode associar-se a múltiplos pagamentos.
- Entrega possui status e código de rastreio.

