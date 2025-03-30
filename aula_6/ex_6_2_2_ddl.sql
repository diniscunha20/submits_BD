CREATE SCHEMA Stock;
GO

CREATE TABLE Stock.produto(
Codigo INT NOT NULL,
Preço DECIMAL(4,2) NOT NULL,
Nome VARCHAR(40),
Iva INT,
N_Encomenda INT NOT NULL,

PRIMARY KEY (Codigo),
);

CREATE TABLE Stock.ecomenda(
N_Encomenda INT NOT NULL,
Data_ DATE,
NIF_Fornecedor INT NOT NULL,

PRIMARY KEY (N_Encomenda),
FOREIGN KEY (NIF_Fornecedor) REFERENCES Stock.fornecedor(NIF),
);

CREATE TABLE Stock.fornecedor(
Nome VARCHAR(30),
NIF INT NOT NULL,
Endereco VARCHAR(40),
Fax INT,
Codigo INT NOT NULL,
Tipo INT,


PRIMARY KEY (NIF),
FOREIGN KEY (Tipo) REFERENCES Stock.tipoFornecedor(Codigo),
);

CREATE TABLE Stock.tipoFornecedor(
Codigo INT NOT NULL,
Designacao VARCHAR(30) NOT NULL,

PRIMARY KEY(Codigo)
);

CREATE TABLE Stock.item(
N_Encomenda INT NOT NULL,
Codigo INT NOT NULL,
Unidades INT,
PRIMARY KEY (N_Encomenda,Unidades),
FOREIGN KEY (N_Encomenda) REFERENCES Stock.ecomenda(N_Encomenda),
FOREIGN KEY (Codigo) REFERENCES Stock.produto(Codigo),
);
