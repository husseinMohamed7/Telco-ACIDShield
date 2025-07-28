CREATE PROCEDURE billing.SubscribeToBundle
    @account_id INT,
    @bundle_id INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Set the highest isolation level to prevent race conditions

        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
        BEGIN TRANSACTION;

        -- Check if account exists
        IF NOT EXISTS (SELECT 1 FROM core.Accounts WHERE account_id = @account_id)
        BEGIN
            RAISERROR('Account does not exist.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Check if bundle exists and get price
        DECLARE @bundle_price DECIMAL(10,2);
        SELECT TOP 1 @bundle_price = price
        FROM billing.Bundles
        WHERE bundle_id = @bundle_id;

        IF @bundle_price IS NULL
        BEGIN
            RAISERROR('Invalid bundle ID.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Check balance is enough
        DECLARE @balance DECIMAL(10,2);
        SELECT @balance = balance FROM core.Accounts WHERE account_id = @account_id;

        IF @balance < @bundle_price
        BEGIN
            RAISERROR('Insufficient balance.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Remove old subscription (if any)
        DELETE FROM billing.CurrentBundle
        WHERE account_id = @account_id;

        -- Deduct balance
        UPDATE core.Accounts
        SET balance = balance - @bundle_price
        WHERE account_id = @account_id;

        -- Subscribe to new bundle
        INSERT INTO billing.CurrentBundle (account_id, bundle_id, activated_on)
        VALUES (@account_id, @bundle_id, GETDATE());

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END
