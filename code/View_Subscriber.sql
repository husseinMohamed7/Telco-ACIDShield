SELECT 
    s.fullname AS 'Subscriber Name',
    s.phone AS 'Phone Number',
    b.bundle_name AS 'Current Bundle',
    a.balance AS Balance
FROM core.Subscribers s
JOIN core.Accounts a ON s.subscriber_id = a.subscriber_id
LEFT JOIN billing.CurrentBundle cb ON a.account_id = cb.account_id
LEFT JOIN billing.Bundles b ON cb.bundle_id = b.bundle_id
WHERE s.subscriber_id = 1