CREATE SCHEMA core
GO
CREATE SCHEMA billing
GO
CREATE SCHEMA logs
GO

CREATE TABLE core.Subscribers(
    subscriber_id INT PRIMARY KEY,
    fullname VARCHAR(40) NOT NULL,
    phone VARCHAR(15) UNIQUE
)
CREATE TABLE core.Accounts(
    account_id INT PRIMARY KEY,
    subscriber_id INT NOT NULL FOREIGN KEY REFERENCES core.Subscribers,
    balance DECIMAL(10,2) NOT NULL,
    CONSTRAINT CK_balance_gt_0 CHECK (balance >= -10.00)
)
CREATE TABLE billing.Bundles(
    bundle_id int PRIMARY KEY,
    bundle_name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL
)
CREATE TABLE billing.Transactions(
    transaction_id INT PRIMARY KEY ,
    account_id INT NOT NULL FOREIGN KEY REFERENCES core.Accounts,
    bundle_id INT NOT NULL FOREIGN KEY REFERENCES billing.Bundles,
    trans_type VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    trans_status VARCHAR(20) NOT NULL,
    trans_timestamp DATETIME, 
    CONSTRAINT CK_trans_status_3_values CHECK (trans_status IN ('pending', 'success', 'failed'))

)
CREATE TABLE logs.AuditLog(
    LogID INT IDENTITY PRIMARY KEY,
    ACTION NVARCHAR(100) NOT NULL,
    transaction_id INT FOREIGN KEY REFERENCES billing.Transactions,
    Timestamp DATETIME DEFAULT GETDATE(),
    trans_status NVARCHAR(50) NOT NULL,
    CONSTRAINT CK_Log_trans_status_2_values CHECK (trans_status IN ('Success', 'Failed'))
)

CREATE TABLE billing.CurrentBundle (
    account_id INT PRIMARY KEY FOREIGN KEY REFERENCES core.Accounts,
    bundle_id INT FOREIGN KEY REFERENCES billing.Bundles,
    activated_on DATETIME
)
GO