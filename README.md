<div align="center">

<h1>Telco-ACIDShield</h1>

</div>


# Telecom Billing System (SQL-based)

This project demonstrates a simplified telecom billing system using SQL Server.  
It highlights how to implement **ACID-compliant transactions** in stored procedures, particularly focusing on a **Subscribe to Bundle** scenario.

---

📄 [View the full ACID Demo PDF](./Telco_ACIDSheild.pdf)

---
## Features

- ACID properties implemented and enforced (Atomicity, Consistency, Isolation, Durability)
- Modular schema with clear separation of:
  - `core` (Accounts, Subscribers)
  - `billing` (Bundles, Transactions, CurrentBundle)
  - `logs` (AuditLog)
- Safe stored procedure: `SubscribeToBundle`
- Handles business rules:
  - Valid accounts and bundles
  - Sufficient balance
  - Replacing old subscriptions
  - Error handling with rollback

---

## Tech Stack

- Microsoft SQL Server
- T-SQL (Stored Procedures, Transactions)
- Schema-first design


## Entity Relationship Diagram (ERD)

```mermaid
erDiagram

  core_Subscribers {
    int subscriber_id
    varchar fullname
    varchar phone
  }

  core_Accounts {
    int account_id
    int subscriber_id
    decimal balance
  }

  billing_Bundles {
    int bundle_id
    varchar bundle_name
    decimal price
  }

  billing_Transactions {
    int transaction_id
    int account_id
    int bundle_id
    varchar trans_type
    decimal amount
    varchar trans_status
    datetime trans_timestamp
  }

  logs_AuditLog {
    int LogID
    nvarchar ACTION
    int transaction_id
    datetime Timestamp
    nvarchar trans_status
  }

  billing_CurrentBundle {
    int account_id
    int bundle_id
    datetime activated_on
  }

  core_Subscribers ||--o{ core_Accounts : has
  core_Accounts ||--o{ billing_Transactions : has
  billing_Bundles ||--o{ billing_Transactions : has
  billing_Transactions ||--o{ logs_AuditLog : logs
  core_Accounts ||--o{ billing_CurrentBundle : uses
  billing_Bundles ||--o{ billing_CurrentBundle : assigned

```
<p align="center">
  <img src="https://visitor-badge.laobi.icu/badge?page_id=husseinMohamed7.Telco-ACIDShield" alt="Visitors Badge"/>
</p>
