-- Schema DDL (SQLite) - E-COMMERCE

PRAGMA foreign_keys = ON;

CREATE TABLE cliente (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome TEXT NOT NULL,
	email TEXT UNIQUE,
	cpf TEXT,
	cnpj TEXT,
	telefone TEXT,
	CHECK (
		( (cpf IS NULL AND cnpj IS NOT NULL) OR (cpf IS NOT NULL AND cnpj IS NULL) )
	)
);

CREATE TABLE pessoa (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome TEXT NOT NULL,
	documento TEXT
);

CREATE TABLE fornecedor (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	pessoa_id INTEGER NOT NULL,
	nome_fantasia TEXT,
	FOREIGN KEY (pessoa_id) REFERENCES pessoa(id) ON DELETE CASCADE
);

CREATE TABLE vendedor (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	pessoa_id INTEGER NOT NULL,
	codigo_vendedor TEXT,
	FOREIGN KEY (pessoa_id) REFERENCES pessoa(id) ON DELETE CASCADE
);

CREATE TABLE produto (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome TEXT NOT NULL,
	descricao TEXT,
	preco REAL NOT NULL DEFAULT 0
);

CREATE TABLE produto_fornecedor (
	produto_id INTEGER NOT NULL,
	fornecedor_id INTEGER NOT NULL,
	preco_fornecedor REAL,
	PRIMARY KEY (produto_id, fornecedor_id),
	FOREIGN KEY (produto_id) REFERENCES produto(id) ON DELETE CASCADE,
	FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id) ON DELETE CASCADE
);

CREATE TABLE estoque (
	produto_id INTEGER PRIMARY KEY,
	quantidade INTEGER NOT NULL DEFAULT 0,
	localizacao TEXT,
	FOREIGN KEY (produto_id) REFERENCES produto(id) ON DELETE CASCADE
);

CREATE TABLE pedido (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	cliente_id INTEGER NOT NULL,
	vendedor_id INTEGER,
	data_pedido DATETIME NOT NULL DEFAULT (datetime('now')),
	status TEXT DEFAULT 'novo',
	FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE RESTRICT,
	FOREIGN KEY (vendedor_id) REFERENCES vendedor(id)
);

CREATE TABLE pedido_item (
	pedido_id INTEGER NOT NULL,
	produto_id INTEGER NOT NULL,
	quantidade INTEGER NOT NULL CHECK (quantidade > 0),
	preco_unitario REAL NOT NULL,
	PRIMARY KEY (pedido_id, produto_id),
	FOREIGN KEY (pedido_id) REFERENCES pedido(id) ON DELETE CASCADE,
	FOREIGN KEY (produto_id) REFERENCES produto(id)
);

CREATE TABLE pagamento (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	cliente_id INTEGER NOT NULL,
	tipo TEXT NOT NULL,
	detalhes TEXT,
	ativo INTEGER DEFAULT 1,
	FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE CASCADE
);

CREATE TABLE pedido_pagamento (
	pedido_id INTEGER NOT NULL,
	pagamento_id INTEGER NOT NULL,
	valor REAL NOT NULL,
	PRIMARY KEY (pedido_id, pagamento_id),
	FOREIGN KEY (pedido_id) REFERENCES pedido(id) ON DELETE CASCADE,
	FOREIGN KEY (pagamento_id) REFERENCES pagamento(id) ON DELETE CASCADE
);

CREATE TABLE entrega (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	pedido_id INTEGER NOT NULL UNIQUE,
	status TEXT NOT NULL DEFAULT 'pendente',
	codigo_rastreamento TEXT,
	FOREIGN KEY (pedido_id) REFERENCES pedido(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_produto_nome ON produto(nome);
CREATE INDEX IF NOT EXISTS idx_cliente_email ON cliente(email);