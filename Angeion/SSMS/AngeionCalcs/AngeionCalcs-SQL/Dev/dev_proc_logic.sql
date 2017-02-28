select * from [dbo].[ImportBatchQueue]
select *  from [dbo].[ImportLog]

select  * from [dbo].[ImportQueue]

select * from [dbo].[Case]
select * from [dbo].[ClaimContact]
select * from [dbo].[Claim]
select * from [dbo].[ClaimTransaction] where isDeleted = 1

select * from [dbo].[lk_ErrorMsg] --delete from [dbo].[lk_ErrorMsg] where ErrorMsgID = 51200
select * from [dbo].[lk_ImportStatus]
select * from [dbo].[lk_SecurityType]
select * from [dbo].[lk_TransactionType]


USE [AngeionCalcs]
GO

SELECT [ImportLogID]
      ,[BatchID]
      ,[DateFileImportStarted]
      ,[DateFileImportFinished]
      ,[FileImportTimeInMS]
      ,[QtyRowsInFile]
      ,[QtyRowsImported]
      ,[QtyRowsFail]
      ,[DateDequeueStarted]
      ,[DateDequeueFinished]
      ,[DequeueTimeInMS]
      ,[QtyClaims]
      ,[QtyTransactions]
      ,[isUpdate]
      ,[ImportStatusID]
      ,[ImportFileName]
      ,[ImportMsg]
  FROM [dbo].[ImportLog]
GO


select  a.[ImportLogID]
,       a.[BatchID]
,       a.[DateFileImportStarted]
,       a.[DateFileImportFinished]
,       a.[FileImportTimeInMS]
,       a.[QtyRowsInFile]
,       a.[QtyRowsImported]
,       a.[QtyRowsFail]
,       a.[DateDequeueStarted]
,       a.[DateDequeueFinished]
,       a.[DequeueTimeInMS]
,       a.[QtyClaims]
,       a.[QtyTransactions]
,       a.[ImportFileName]
,       a.[ImportStatusID]
,       b.[ImportStatusName]
,       a.[ImportMsg]
,       a.[isUpdate]
from    [dbo].[ImportLog] a
        inner join [dbo].[lk_ImportStatus] b on a.[ImportStatusID] = b.[ImportStatusID]