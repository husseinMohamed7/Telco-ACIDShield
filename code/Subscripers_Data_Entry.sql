
INSERT INTO core.Subscribers (subscriber_id, fullname, phone)
VALUES 
    (1, 'Ahmed Hassan', '01001234567'),
    (2, 'Hussein Mohamed', '01554954628'); 


INSERT INTO core.Accounts (account_id, subscriber_id, balance)
VALUES 
    (101, 1, 150.00),
    (102, 2, 200.00);


INSERT INTO billing.Bundles (bundle_id, bundle_name, price)
VALUES 
    (201, 'Basic Bundle', 30.00),
    (202, 'Premium Bundle', 90.00);


INSERT INTO billing.Transactions (transaction_id, account_id, bundle_id, trans_type, amount, trans_status, trans_timestamp)
VALUES 
    (1001, 101, 201, 'purchase', 30.00, 'success', GETDATE());

INSERT INTO logs.AuditLog (ACTION, transaction_id, trans_status)
VALUES 
    ('Bundle purchased: Basic Bundle', 1001, 'Success');

INSERT INTO billing.CurrentBundle (account_id, bundle_id, activated_on)
VALUES 
    (101, 201, GETDATE()); 
