-- Schema DDL (SQLite) - OFICINA (autocontido)

PRAGMA foreign_keys = ON;

-- Limpar dados antigos se existirem (permite re-execução)
DROP TABLE IF EXISTS ordem_pagamento;
DROP TABLE IF EXISTS ordem_item;
DROP TABLE IF EXISTS ordem_servico;
DROP TABLE IF EXISTS estoque_peca;
DROP TABLE IF EXISTS peca;
DROP TABLE IF EXISTS servico;
DROP TABLE IF EXISTS mecanico;
DROP TABLE IF EXISTS veiculo;
DROP TABLE IF EXISTS pagamento;
DROP TABLE IF EXISTS fornecedor;
DROP TABLE IF EXISTS pessoa;
DROP TABLE IF EXISTS cliente;

-- Tabelas base (cliente/pessoa/fornecedor/pagamento) necessárias para oficina
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

CREATE TABLE pagamento (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	cliente_id INTEGER NOT NULL,
	tipo TEXT NOT NULL,
	detalhes TEXT,
	ativo INTEGER DEFAULT 1,
	FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE CASCADE
);

-- Tabelas específicas da oficina
CREATE TABLE veiculo (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	cliente_id INTEGER NOT NULL,
	placa TEXT NOT NULL UNIQUE,
	modelo TEXT,
	ano INTEGER,
	FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE CASCADE
);

CREATE TABLE mecanico (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	pessoa_id INTEGER NOT NULL,
	especialidade TEXT,
	FOREIGN KEY (pessoa_id) REFERENCES pessoa(id) ON DELETE CASCADE
);

CREATE TABLE servico (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	descricao TEXT NOT NULL,
	preco_base REAL NOT NULL DEFAULT 0
);

CREATE TABLE peca (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nome TEXT NOT NULL,
	codigo TEXT UNIQUE,
	preco REAL NOT NULL DEFAULT 0,
	fornecedor_id INTEGER,
	FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id) ON DELETE SET NULL
);

CREATE TABLE estoque_peca (
	peca_id INTEGER PRIMARY KEY,
	quantidade INTEGER NOT NULL DEFAULT 0,
	localizacao TEXT,
	FOREIGN KEY (peca_id) REFERENCES peca(id) ON DELETE CASCADE
);

CREATE TABLE ordem_servico (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	cliente_id INTEGER NOT NULL,
	veiculo_id INTEGER NOT NULL,
	mecanico_id INTEGER,
	data_abertura DATETIME NOT NULL DEFAULT (datetime('now')),
	data_fechamento DATETIME,
	status TEXT NOT NULL DEFAULT 'aberto',
	observacoes TEXT,
	FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE RESTRICT,
	FOREIGN KEY (veiculo_id) REFERENCES veiculo(id) ON DELETE RESTRICT,
	FOREIGN KEY (mecanico_id) REFERENCES mecanico(id)
);

CREATE TABLE ordem_item (
	ordem_id INTEGER NOT NULL,
	tipo TEXT NOT NULL CHECK (tipo IN ('servico','peca')),
	servico_id INTEGER,
	peca_id INTEGER,
	quantidade INTEGER NOT NULL DEFAULT 1 CHECK (quantidade > 0),
	preco_unitario REAL NOT NULL,
	PRIMARY KEY (ordem_id, tipo, servico_id, peca_id),
	FOREIGN KEY (ordem_id) REFERENCES ordem_servico(id) ON DELETE CASCADE,
	FOREIGN KEY (servico_id) REFERENCES servico(id),
	FOREIGN KEY (peca_id) REFERENCES peca(id),
	CHECK ( (servico_id IS NULL AND peca_id IS NOT NULL) OR (servico_id IS NOT NULL AND peca_id IS NULL) )
);

CREATE TABLE ordem_pagamento (
	ordem_id INTEGER NOT NULL,
	pagamento_id INTEGER NOT NULL,
	valor REAL NOT NULL,
	PRIMARY KEY (ordem_id, pagamento_id),
	FOREIGN KEY (ordem_id) REFERENCES ordem_servico(id) ON DELETE CASCADE,
	FOREIGN KEY (pagamento_id) REFERENCES pagamento(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_veiculo_cliente ON veiculo(cliente_id);
CREATE INDEX IF NOT EXISTS idx_ordem_mecanico ON ordem_servico(mecanico_id);
CREATE INDEX IF NOT EXISTS idx_peca_fornecedor ON peca(fornecedor_id);
