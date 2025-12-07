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

Como executar (SQLite) - Projetos separados
- E-commerce (banco: ecommerce.db)
  1. Criar o arquivo de banco e aplicar o schema do e-commerce:
     - sqlite3 ecommerce.db ".read schema/schema.sql"
  2. Popular dados do e-commerce:
     - sqlite3 ecommerce.db ".read seed/seed.sql"
  3. Testar consultas do e-commerce:
     - sqlite3 ecommerce.db ".read queries/queries.sql"

- Oficina (banco: oficina.db)
  1. Criar o arquivo de banco e aplicar o schema da oficina:
     - sqlite3 oficina.db ".read schema/oficina_schema.sql"
  2. Popular dados da oficina:
     - sqlite3 oficina.db ".read seed/oficina_seed.sql"
  3. Testar consultas da oficina:
     - sqlite3 oficina.db ".read queries/oficina_queries.sql"

**Limpeza e re-execução**
- Se houver erros de UNIQUE constraint, remova o arquivo .db e recrie:
  - rm oficina.db (ou del oficina.db no Windows)
  - sqlite3 oficina.db ".read schema/oficina_schema.sql"
  - sqlite3 oficina.db ".read seed/oficina_seed.sql"
- Alternativamente, os scripts agora contêm DROP TABLE IF EXISTS e DELETE para permitir re-execução segura.

Observações
- Cada conjunto de arquivos (schema/seed/queries) é autocontido para seu respectivo DB.
- Os schemas começam com: PRAGMA foreign_keys = ON;
- Não é possível trocar de database dentro de um arquivo SQL no SQLite; por isso os arquivos foram duplicados e adaptados para cada DB.

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

Oficina (Workshop) — novo escopo
- O projeto foi expandido para contemplar um modelo de oficina mecânica.
- Foram adicionadas tabelas para: veículos, mecânicos, serviços, peças, estoque de peças, ordens de serviço e itens de ordem.
- Regras importantes:
  - Uma ordem_de_servico referencia cliente e veículo; pode ter itens de tipo 'servico' ou 'peca'.
  - Ordem_item garante que ou servico_id OU peca_id esteja preenchido (XOR).
  - Peças podem ter fornecedores (reaproveita tabela fornecedor).

Como executar (notas rápidas)
- Use os mesmos comandos SQLite já descritos; o schema agora contém as tabelas da oficina.
- Para recarregar do zero: remova/rename ecommerce.db e rode:
  1. sqlite3 ecommerce.db ".read schema/schema.sql"
  2. sqlite3 ecommerce.db ".read seed/seed.sql"
  3. sqlite3 ecommerce.db ".read queries/queries.sql"

