USE [AngeionCalcs]
GO

/*

drop table [dbo].[ImportBatchQueue]
drop table [dbo].[ImportQueue]
drop table [dbo].[CaseAttributeValue]
drop table [dbo].[CaseAttribute]
drop table [dbo].[Case]
drop table [dbo].[ClaimTransaction]
drop table [dbo].[Claim]
drop table [dbo].[ClaimContact]

drop table [dbo].[ImportLog]

drop table [dbo].[lk_TransactionType]
drop table [dbo].[lk_SecurityType]
drop table [dbo].[lk_ImportStatus]
drop table [dbo].[lk_ErrorMsg]
drop table [dbo].[lk_CaseAttributeType]

drop table [dbo].[SSIS Configurations]

*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lk_TransactionType](
	[TransactionTypeID] [int] NOT NULL,
	[TransactionTypeCode] [nvarchar](255) NOT NULL,
	[TransactionTypeName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK__lk_TransactionType] PRIMARY KEY CLUSTERED 
(
	[TransactionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO


CREATE TABLE [dbo].[lk_SecurityType](
	[SecurityTypeID] [int] NOT NULL,
	[SecurityTypeCode] [nvarchar](255) NOT NULL,
	[SecurityTypeName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK__lk_SecurityType] PRIMARY KEY CLUSTERED 
(
	[SecurityTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO


CREATE TABLE [dbo].[lk_CaseAttributeType](
	[CaseAttributeTypeID] [int] NOT NULL,
	[CaseAttributeTypeName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK__lk_CaseAttributeType] PRIMARY KEY CLUSTERED 
(
	[CaseAttributeTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO


CREATE TABLE [dbo].[ImportQueue](
    [ImportQueueID] int identity(1,1), --PK
    [ImportLogID] int NULL,
    [ImportStatusID] int NOT NULL CONSTRAINT [DF__dbo_ImportQueue__ImportStatusID__10] DEFAULT ((10)), --default queued
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
    [DataSourceUnknown] nvarchar(255) NULL,
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
    [CreatedDate] datetime NOT NULL CONSTRAINT [DF__dbo_ImportQueue__CreatedDate] DEFAULT (getutcdate()), 
    [ModifiedDate] datetime NULL
    ) ON [PRIMARY]
    WITH
    (
    DATA_COMPRESSION = ROW
    )
GO

PRINT N'Creating primary key [pk__dbo_ImportQueue] on [dbo].[ImportQueue]'
GO
ALTER TABLE [dbo].[ImportQueue] ADD CONSTRAINT [PK__dbo_ImportQueue] PRIMARY KEY CLUSTERED  ([ImportQueueID]) ON [PRIMARY]
GO


PRINT N'Creating index [ix__dbo_ImportQueue__ImportStatusID__inc__MasterClaimNumber__TransactionID] on [dbo].[ImportQueue]'
GO
CREATE NONCLUSTERED INDEX [IX__dbo_ImportQueue__ImportStatusID] ON [dbo].[ImportQueue] ([ImportStatusID]) INCLUDE ([MasterClaimNumber],[TransactionID])
GO


CREATE TABLE [dbo].[ImportBatchQueue](
    [ImportBatchQueueID] int identity(1,1), --PK
    [BatchID] int NOT NULL,
    [ImportQueueID] int NOT NULL
    ) ON [PRIMARY]
    WITH
    (
    DATA_COMPRESSION = ROW
    )
GO

PRINT N'Creating primary key [PK__dbo_ImportBatchQueue] on [dbo].[ImportBatchQueue]'
GO
ALTER TABLE [dbo].[ImportBatchQueue] ADD CONSTRAINT [PK__dbo_ImportBatchQueue] PRIMARY KEY CLUSTERED  ([ImportBatchQueueID]) ON [PRIMARY]
GO

PRINT N'Creating primary key [IX__dbo_ImportBatchQueue__ImportQueueID] on [dbo].[ImportBatchQueue]'
GO
CREATE NONCLUSTERED INDEX [IX__dbo_ImportBatchQueue__ImportQueueID] ON [dbo].[ImportBatchQueue] ([ImportQueueID]) WITH (DATA_COMPRESSION = ROW) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Case](
    [CaseID] int identity(1,1), --PK
    [CaseCode] nvarchar(4) NOT NULL,
    [CaseName] nvarchar(255) NULL,
    [CreatedDate] datetime NOT NULL CONSTRAINT [DF__dbo_Case__CreatedDate] DEFAULT (getutcdate()), 
    [ModifiedDate] datetime NULL,
    [isDeleted] tinyint NOT NULL CONSTRAINT [DF__dbo_Case__isDeleted] DEFAULT ((0)),
    ) ON [PRIMARY]
    WITH
    (
    DATA_COMPRESSION = ROW
    )
GO


PRINT N'Creating primary key [PK__dbo_Case] on [dbo].[Case]'
GO
ALTER TABLE [dbo].[Case] ADD CONSTRAINT [PK__dbo_Case] PRIMARY KEY CLUSTERED  ([CaseID]) ON [PRIMARY]
GO



CREATE TABLE [dbo].[CaseAttribute](
    [CaseAttributeID] int identity(1,1), --PK
    [CaseAttributePrompt] nvarchar(1000) NULL,
    [CaseAttributeTypeID] int NOT NULL,
    [CreatedDate] datetime NOT NULL CONSTRAINT [DF__dbo_CaseAttribute__CreatedDate] DEFAULT (getutcdate()),  
    [ModifiedDate] datetime NULL, 
    ) ON [PRIMARY]
    WITH
    (
    DATA_COMPRESSION = ROW
    )
GO


PRINT N'Creating primary key [PK__dbo_CaseAttribute] on [dbo].[CaseAttribute]'
GO
ALTER TABLE [dbo].[CaseAttribute] ADD CONSTRAINT [PK__dbo_CaseAttribute] PRIMARY KEY CLUSTERED  ([CaseAttributeID]) ON [PRIMARY]
GO



CREATE TABLE [dbo].[CaseAttributeValue](
    [CaseAttributeValueID] int identity(1,1), --PK
    [CaseID] int NOT NULL, --FK
    [CaseAttributeID] int NOT NULL, --FK
    [CaseAttributeValue_String] nvarchar(255) NULL,
    [CaseAttributeValue_Integer] int NULL,
    [CaseAttributeValue_Decimal] decimal(19,4) NULL,
    [CaseAttributeValue_Date] datetime NULL,
    [isRequired] tinyint NOT NULL,
    [CreatedDate] datetime NOT NULL CONSTRAINT [DF__dbo_CaseAttributeValue__CreatedDate] DEFAULT (getutcdate()),  
    [ModifiedDate] datetime NULL, 
    ) ON [PRIMARY]
    WITH
    (
    DATA_COMPRESSION = ROW
    )
GO

PRINT N'Creating primary key [PK__dbo_CaseAttributeValue] on [dbo].[CaseAttributeValue]'
GO
ALTER TABLE [dbo].[CaseAttributeValue] ADD CONSTRAINT [PK__dbo_CaseAttributeValue] PRIMARY KEY CLUSTERED  ([CaseAttributeValueID]) ON [PRIMARY]
GO



CREATE TABLE [dbo].[ClaimContact](
    [ClaimContactID] int identity(1,1), --PK
    [CaseID] int NOT NULL, --FK
    [MasterClaimNumber] int NOT NULL,
    [Address1] nvarchar(max) NOT NULL,
    [Address2] nvarchar(max) NULL, 
    [City] nvarchar(max) NOT NULL,
    [State] nvarchar(255) NOT NULL,
    [Zip] nvarchar(255) NOT NULL,
    [Country] nvarchar(max) NULL,
    [isForeignAddress] tinyint NOT NULL CONSTRAINT [DF__dbo_ClaimContact__isForeignAddress__0] DEFAULT ((0)),
    [CreatedDate] datetime NOT NULL CONSTRAINT [DF__dbo_ClaimContact__CreatedDate] DEFAULT (getutcdate()), 
    [ModifiedDate] datetime NULL
    ) ON [PRIMARY]
    WITH
    (
    DATA_COMPRESSION = ROW
    )
    GO
    
PRINT N'Creating primary key [PK__dbo_ClaimContact] on [dbo].[ClaimContact]'
GO
ALTER TABLE [dbo].[ClaimContact] ADD CONSTRAINT [PK__dbo_ClaimContact] PRIMARY KEY CLUSTERED  ([ClaimContactID]) ON [PRIMARY]
GO

PRINT N'Creating index [ix__dbo_ClaimContact__MasterClaimNumber] on [dbo].[ClaimContact]'
GO
CREATE NONCLUSTERED INDEX [IX__dbo_ClaimContact__MasterClaimNumber] ON [dbo].[ClaimContact] ([MasterClaimNumber]) WITH (DATA_COMPRESSION = ROW) ON [PRIMARY]
GO



CREATE TABLE [dbo].[Claim](
    [ClaimID] int identity(1,1), --PK
    --[CaseID] int NOT NULL, --FK
    [ClaimContactID] int NOT NULL, --FK
    [MasterClaimNumber] int NOT NULL,
    [ClaimNumber] nvarchar(255) NOT NULL,
    [AccountNumber] nvarchar(255) NULL,
    [BeneficialOwnerName] nvarchar(max) NOT NULL,
    [CoOwnerName] nvarchar(max) NULL,
    [Representative] nvarchar(max) NOT NULL,
    [TaxID] int NULL,
    [InvalidSignature] tinyint NULL CONSTRAINT [DF__dbo_Claim__InvalidSignature__0] DEFAULT ((0)),
    [NoAuthorityToFile] tinyint NULL CONSTRAINT [DF__dbo_Claim__NoAuthorityToFile__0] DEFAULT ((0)),
    [DataSourceUnknown] tinyint NULL CONSTRAINT [DF__dbo_Claim__DataSourceUnknown__0] DEFAULT ((0)),
    [SpecialPaymentCode] tinyint NULL CONSTRAINT [DF__dbo_Claim__SpecialPaymentCode__0] DEFAULT ((0)),
    [ClaimMessageCodes] nvarchar(255) NULL,
    [PostmarkDate] datetime NULL,
    [CreatedDate] datetime NOT NULL CONSTRAINT [DF__dbo_Claim__CreatedDate] DEFAULT (getutcdate()), 
    [ModifiedDate] datetime NULL
    ) ON [PRIMARY]
    WITH
    (
    DATA_COMPRESSION = ROW
    )
GO


PRINT N'Creating primary key [pk__dbo_Claim] on [dbo].[Claim]'
GO
ALTER TABLE [dbo].[Claim] ADD CONSTRAINT [PK__dbo_Claim] PRIMARY KEY CLUSTERED  ([ClaimID]) ON [PRIMARY]
GO

PRINT N'Creating index [ix__dbo_Claim__MasterClaimNumber] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX__dbo_Claim__MasterClaimNumber] ON [dbo].[Claim] ([MasterClaimNumber]) WITH (DATA_COMPRESSION = ROW) ON [PRIMARY]
GO

PRINT N'Creating index [ix__dbo_Claim__AccountNumber] on [dbo].[Claim]'
GO
CREATE INDEX [IX__dbo_Claim__AccountNumber] ON [dbo].[Claim] ([AccountNumber]) WITH (DATA_COMPRESSION = ROW) ON [PRIMARY]
GO




CREATE TABLE [dbo].[ClaimTransaction](
    [ClaimTransactionID] int identity(1,1),
    [ClaimID] int NOT NULL, --FK
    [TransactionID] nvarchar(255) NOT NULL,
    [SecurityTypeID] int NOT NULL, --FK
    [SecurityID] nvarchar(255) NOT NULL,
    [TransactionTypeID] int NOT NULL, --FK
    [TradeDate] datetime NOT NULL,
    [Quantity] decimal(19,4) NOT NULL,
    [Price] decimal(19,4) NULL,
    [TotalAmountPaidOrRecieved] decimal(19,4) NULL,
    [DivReimbPurchase] decimal(19,4) NULL,
    [Options] nvarchar(255) NULL,
    [Short] nvarchar(255) NULL,
    [TransactionMsgCodes] nvarchar(255) NULL,
    [isDeleted] tinyint NOT NULL CONSTRAINT [DF__dbo_ClaimTransaction__isDeleted__0] DEFAULT (0), 
    [CreatedDate] datetime NOT NULL CONSTRAINT [DF__dbo_ClaimTransaction__CreatedDate] DEFAULT (getutcdate()), 
    [ModifiedDate] datetime NULL
    ) ON [PRIMARY]
    WITH
    (
    DATA_COMPRESSION = ROW
    )
    GO
    
PRINT N'Creating primary key [pk__dbo_ClaimTransaction] on [dbo].[ClaimTransaction]'
GO
ALTER TABLE [dbo].[ClaimTransaction] ADD CONSTRAINT [PK__dbo_ClaimTransaction] PRIMARY KEY NONCLUSTERED  ([ClaimTransactionID]) ON [PRIMARY]
GO




CREATE TABLE [dbo].[lk_ImportStatus](
	[ImportStatusID] int NOT NULL,
	[ImportStatusName] nvarchar(255) NOT NULL,
    [ImportStatusDescription] nvarchar(255) NULL,
 CONSTRAINT [PK__lk_ImportStatus] PRIMARY KEY CLUSTERED 
(
	[ImportStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO



CREATE TABLE [dbo].[ImportLog](
    [ImportLogID] int identity(1,1), --PK
    [BatchID] int NULL,  --IXC
    [DateFileImportStarted] datetime NOT NULL CONSTRAINT [DF__dbo_ImportLog__DateFileImportStarted] DEFAULT (getutcdate()), 
    [DateFileImportFinished] datetime NULL, 
    [FileImportTimeInMS] int NULL,
    [QtyRowsInFile] int NULL,
    [QtyRowsImported] int NULL,
    [QtyRowsFail] int NULL,
    [DateDequeueStarted] datetime NULL,
    [DateDequeueFinished] datetime NULL, 
    [DequeueTimeInMS] int NULL,
    [QtyClaims] int NULL,
    [QtyTransactions] int NULL,
    [isUpdate] bit NULL,
    [ImportStatusID] int NOT NULL, --FK
    [ImportFileName] nvarchar(255) NULL,
    [ImportMsg] nvarchar(max) NULL,
    ) ON [PRIMARY]
    WITH
    (
    DATA_COMPRESSION = ROW
    )
    GO
    
PRINT N'Creating primary key [pk__dbo_ImportLog] on [dbo].[ImportLog]'
GO
ALTER TABLE [dbo].[ImportLog] ADD CONSTRAINT [PK__dbo_ImportLog] PRIMARY KEY NONCLUSTERED  ([ImportLogID]) ON [PRIMARY]
GO

PRINT N'Creating index [ixc__dbo_ImportLog__ClaimID] on [dbo].[ImportLog]'
GO
CREATE UNIQUE CLUSTERED INDEX [IXC__dbo_ImportLog__ImportLogID__ClaimID] ON [dbo].[ImportLog] ([ImportLogID], [BatchID]) WITH (DATA_COMPRESSION = ROW) ON [PRIMARY]
GO



CREATE TABLE [dbo].[lk_ErrorMsg]
(
[ErrorMsgID] int NOT NULL,
[ErrorParam] nvarchar (255) NOT NULL,
[ErrorMsg] nvarchar (1000) NOT NULL
) ON [PRIMARY]
GO

PRINT N'Creating primary key [PK__dbo__lk_ErrorMsg] on [dbo].[lk_ErrorMsg]'
GO
ALTER TABLE [dbo].[lk_ErrorMsg] ADD CONSTRAINT [PK__dbo__lk_ErrorMsg] PRIMARY KEY CLUSTERED  ([ErrorMsgID]) ON [PRIMARY]
GO

PRINT N'Creating index [IX__dbo__lk_ErrorMsg__ErrorParam] on [dbo].[lk_ErrorMsg]'
GO
CREATE NONCLUSTERED INDEX [IX__dbo__lk_ErrorMsg__ErrorParam] ON [dbo].[lk_ErrorMsg] ([ErrorParam]) ON [PRIMARY]
GO



CREATE TABLE [dbo].[SSIS Configurations]
(
	ConfigurationFilter NVARCHAR(255) NOT NULL,
	ConfiguredValue NVARCHAR(255) NULL,
	PackagePath NVARCHAR(255) NOT NULL,
	ConfiguredValueType NVARCHAR(20) NOT NULL
)