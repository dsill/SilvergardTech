USE [AngeionCalcs]
GO

/*
select * from [temp].[ImportQueue]
*/

drop table [temp].[ImportQueue]
go

CREATE TABLE [temp].[ImportQueue](
    [ImportQueueID] int NOT NULL,
    --[ImportLogID] int NULL,
    --[ImportStatusID] int NULL,
    [CaseName] nvarchar(255) NULL,
    [BeneficialOwnerName] nvarchar(max) NULL,
    [CoOwnerName] nvarchar(max) NULL,
    [Representative] nvarchar(max) NULL,
    [Address1] nvarchar(max) NULL,
    [Address2] nvarchar(max) NULL, 
    [City] nvarchar(max) NULL,
    [State] nvarchar(255) NULL,
    [Zip] nvarchar(255) NULL,
    [Country] nvarchar(max) NULL,
    [ForeignAddressFlag] tinyint NULL,
    [MasterClaimNumber] int NULL,
    [AccountNumber] nvarchar(255) NULL,
    [ClaimNumber] nvarchar(255) NULL,
    [TaxID] int NULL,
    [InvalidSignature] nvarchar(255) NULL,
    [NoAuthorityToFile] nvarchar(255) NULL,
    [DataSourceUknown] nvarchar(255) NULL,
    [SpecialPaymentCode] nvarchar(255) NULL,
    [PostmarkDate] datetime NULL,
    [ClaimMessageCodes] nvarchar(255) NULL,
    [TransactionID] nvarchar(255) NULL,
    [TypeOfSecurity] nvarchar(255) NULL, 
    [SecurityID] nvarchar(255) NULL,
    [TransactionType] nvarchar(255) NULL,
    [TradeDate] datetime NULL,
    [Quantity] decimal(19,4) NULL,
    [Price] decimal(19,4) NULL,
    [TotalAmountPaidOrRecieved] decimal(19,4) NULL,
    [DivReimbPurchase] decimal(19,4) NULL,
    [Options] nvarchar(255) NULL,
    [Short] nvarchar(255) NULL,
    [TransactionMsgCodes] nvarchar(255) NULL,
    [CreatedDate] datetime NULL, 
    [ModifiedDate] datetime NULL
    ) ON [PRIMARY]
    WITH
    (
    DATA_COMPRESSION = ROW
    )
GO

PRINT N'Creating primary key [pk__temp_ImportQueue] on [temp].[ImportQueue]'
GO
ALTER TABLE [temp].[ImportQueue] ADD CONSTRAINT [PK__temp_ImportQueue] PRIMARY KEY CLUSTERED  ([ImportQueueID]) ON [PRIMARY]
GO