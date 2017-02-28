USE [AngeionCalcs]
GO

CREATE TYPE [dbo].[ImportLogList] AS TABLE
(
    [ImportLogID] int NULL,
    [BatchID] int NULL,
    [QtyRowsInFile] int NULL,
    [QtyRowsImported] int NULL,
    [QtyRowsFail] int NULL,
    [QtyClaims] int NULL,
    [QtyTransactions] int NULL,
    [isUpdate] bit NULL,
    [ImportStatusID] int NULL,
    [ImportMsg] nvarchar(max) NULL
)
GO

