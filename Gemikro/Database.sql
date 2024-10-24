CREATE DATABASE MyDatabase;
GO

USE MyDatabase;
GO

CREATE TABLE Savetnici (
    Id_svet INT PRIMARY KEY,
    Savetnik NVARCHAR(100),
    Novauser BIT,
    [e-mail] NVARCHAR(100)
);

CREATE TABLE Partner (
    PartnerId INT PRIMARY KEY,
    Name NVARCHAR(100),
    Adress NVARCHAR(255),
    StatusSaradnje NVARCHAR(50),
    Id_svet INT,
    FOREIGN KEY (Id_svet) REFERENCES Savetnici(Id_svet)
);

CREATE TABLE Contract (
    ContractId INT PRIMARY KEY,
    PartnerId INT,
    Description NVARCHAR(255),
    Value DECIMAL(18, 2),
    Status_akt NVARCHAR(50),
    dat_akt DATE,
    FOREIGN KEY (PartnerId) REFERENCES Partner(PartnerId)
);

CREATE TABLE PlanOtp (
    PlanpId INT PRIMARY KEY,
    ContractId INT,
    Claim NVARCHAR(255),
    Claim_Value DECIMAL(18, 2),
    Debt DECIMAL(18, 2),
    FOREIGN KEY (ContractId) REFERENCES Contract(ContractId)
);

CREATE TABLE Invoice (
    InvoiceId INT PRIMARY KEY,
    PartnerId INT,
    InvoiceDate DATE,
    Amount DECIMAL(18, 2),
    ContractId INT,
    FOREIGN KEY (PartnerId) REFERENCES Partner(PartnerId),
    FOREIGN KEY (ContractId) REFERENCES Contract(ContractId)
);
