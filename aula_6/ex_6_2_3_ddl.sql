CREATE SCHEMA DDL_Prescricoes;
GO

CREATE TABLE DDL_Prescricoes.Farmacia(
    nome VARCHAR(32) NOT NULL PRIMARY KEY,
    telefone INT NOT NULL,
    endereco VARCHAR(64) NOT NULL
);

CREATE TABLE DDL_Prescricoes.Medico(
    numSNS INT NOT NULL PRIMARY KEY,
    nome VARCHAR(64) NOT NULL UNIQUE,
    especialidade VARCHAR(32) NOT NULL
);

CREATE TABLE DDL_Prescricoes.Paciente(
    numUtente INT NOT NULL PRIMARY KEY,
    nome VARCHAR(64) NOT NULL UNIQUE,
    dataNasc DATE NOT NULL,
    endereco VARCHAR(64) NOT NULL
);

CREATE TABLE DDL_Prescricoes.Prescricao(
    numPresc INT NOT NULL PRIMARY KEY,
    numUtente INT NOT NULL,
    numMedico INT NOT NULL,
    farmacia VARCHAR(32),
    data DATE,
    FOREIGN KEY (numUtente) REFERENCES DDL_Prescricoes.Paciente(numUtente),
    FOREIGN KEY (numMedico) REFERENCES DDL_Prescricoes.Medico(numSNS),
    FOREIGN KEY (farmacia) REFERENCES DDL_Prescricoes.Farmacia(nome)
);

CREATE TABLE DDL_Prescricoes.Farmaceutica(
    numReg INT NOT NULL PRIMARY KEY,
    nome VARCHAR(32) NOT NULL UNIQUE,
    endereco VARCHAR(64) NOT NULL
);

CREATE TABLE DDL_Prescricoes.Farmaco(
    numRegFarm INT NOT NULL,
    nome VARCHAR(64) NOT NULL,
    formula VARCHAR(32) NOT NULL,
    PRIMARY KEY (numRegFarm, nome),
    FOREIGN KEY (numRegFarm) REFERENCES DDL_Prescricoes.Farmaceutica(numReg)
);

CREATE TABLE DDL_Prescricoes.Presc_farmaco(
    numPresc INT NOT NULL,
    numRegFarm INT NOT NULL,
    nomeFarmaco VARCHAR(64) NOT NULL,
    PRIMARY KEY (numPresc, numRegFarm, nomeFarmaco),
    FOREIGN KEY (numPresc) REFERENCES DDL_Prescricoes.Prescricao(numPresc),
    FOREIGN KEY (numRegFarm, nomeFarmaco) REFERENCES DDL_Prescricoes.Farmaco(numRegFarm, nome)
);
