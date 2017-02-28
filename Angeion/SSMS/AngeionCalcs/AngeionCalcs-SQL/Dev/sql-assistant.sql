/*

delete from [dbo].[ImportBatchQueue]
delete from [dbo].[ImportLog]
delete from [dbo].[ImportQueue]

delete from [dbo].[Case]
delete from [dbo].[ClaimTransaction]
delete from [dbo].[Claim]
delete from [dbo].[ClaimContact]



exec [dbo].[ImportDequeue] @QtyDequeue = 0, @isDebug = 1

update [ImportQueue] set ImportStatusID = 30 where ImportStatusID = 20
update [ImportQueue] set ImportStatusID = 20 where ImportStatusID = 30/*

delete from [dbo].[ImportBatchQueue]
delete from [dbo].[ImportLog]
delete from [dbo].[ImportQueue]

delete from [dbo].[Case]
delete from [dbo].[ClaimTransaction]
delete from [dbo].[Claim]
delete from [dbo].[ClaimContact]

DBCC CHECKIDENT ('[dbo].[ImportBatchQueue]', RESEED, 0)
DBCC CHECKIDENT ('[dbo].[ImportLog]', RESEED, 0)
DBCC CHECKIDENT ('[dbo].[ImportQueue]', RESEED, 0)

DBCC CHECKIDENT ('[dbo].[Case]', RESEED, 0)
DBCC CHECKIDENT ('[dbo].[ClaimTransaction]', RESEED, 0)
DBCC CHECKIDENT ('[dbo].[Claim]', RESEED, 0)
DBCC CHECKIDENT ('[dbo].[ClaimContact]', RESEED, 0)
GO



exec [dbo].[ImportDequeue] @QtyDequeue = 0, @isDebug = 1

update [ImportQueue] set ImportStatusID = 30 where ImportStatusID = 20
update [ImportQueue] set ImportStatusID = 20 where ImportStatusID = 30

update [dbo].[ClaimTransaction] set isDeleted = 0
*/


select * from [dbo].[ImportBatchQueue]
select *  from [dbo].[ImportLog]

select  * from [dbo].[ImportQueue]
--select  * from [dbo].[ImportQueue] where ImportStatusID = 20
--select  * from [dbo].[ImportQueue] where ImportStatusID = 40
--select  * from [dbo].[ImportQueue] where TypeOfSecurity = 'XX'

select * from [dbo].[Case]
select * from [dbo].[ClaimContact]
select * from [dbo].[Claim]
select * from [dbo].[ClaimTransaction] where isDeleted = 1

select * from [dbo].[lk_ErrorMsg] --delete from [dbo].[lk_ErrorMsg] where ErrorMsgID = 51200
select * from [dbo].[lk_ImportStatus]
select * from [dbo].[lk_SecurityType]
select * from [dbo].[lk_TransactionType]


exec [dbo].[ImportLog_Update]	@ImportLogID = 1
,                               @BatchID = NULL
,                               @QtyClaims = NULL
,                               @QtyTransactions = NULL
,                               @ImportStatusID = 20
,                               @ImportMsg = 'File import completed'
,                               @isDebug = 1





select  a.[ClaimNumber]
,       case when charindex('-', a.[ClaimNumber]) = 3 then (left(a.[ClaimNumber], charindex('-', a.[ClaimNumber])-1)) + 'XX' 
                when charindex('-', a.[ClaimNumber]) = 5 then (left(a.[ClaimNumber], charindex('-', a.[ClaimNumber])-1)) 
                else 'ERR'
        end as [CaseCode]
,       a.[CaseName]
,       getutcdate() as [CreatedDate]
into    #tmp_Case
from    [dbo].[ImportQueue] a
group by a.[ClaimNumber]
,        case when charindex('-', a.[ClaimNumber]) = 3 then (left(a.[ClaimNumber], charindex('-', a.[ClaimNumber])-1)) + 'XX' 
                when charindex('-', a.[ClaimNumber]) = 5 then (left(a.[ClaimNumber], charindex('-', a.[ClaimNumber])-1)) 
                else 'ERR'
            end
,        a.CaseName


select  a.[CaseCode]
,       a.[CaseName] 
,       a.[CreatedDate]
from    #tmp_Case a
        left join [dbo].[Case] b on a.CaseCode = b.CaseCode
                                and a.CaseName = b.CaseName
group by a.[CaseCode]
,       a.[CaseName] 
,       a.[CreatedDate]

select  a.CaseCode
,       a.CaseName
,       a.CreatedDate
from    #tmp_Case a
        left join [dbo].[Case] b on a.CaseCode = b.CaseCode
                                and a.CaseName = b.CaseName
where   b.CaseCode is NULL




select  case when isnull(max(a.[BatchID]), 0) >= isnull(max(c.[BatchID]), 0) 
                                        then isnull(max(a.[BatchID]), 0) + 1 
                                        else isnull(max(c.[BatchID]), 0) + 1 
                                    end
            from    [dbo].[ImportLog] a
                    left join [dbo].[ImportQueue] b on a.[ImportLogID] = b.[ImportLogID]
                    left join [dbo].[ImportBatchQueue] c on b.[ImportQueueID] = c.[ImportQueueID]


select isnull(max([BatchID]), 0) from [dbo].[ImportLog]

select  isnull(max(a.[BatchID]), 0) as maxImportLog
,       isnull(max(c.[BatchID]), 0) as maxBatchQueue                           
from    [dbo].[ImportLog] a
        left join [dbo].[ImportQueue] b on a.[ImportLogID] = b.[ImportLogID]
        left join [dbo].[ImportBatchQueue] c on b.[ImportQueueID] = c.[ImportQueueID]

update [dbo].[ClaimTransaction] set isDeleted = 0
*/


select * from [dbo].[ImportBatchQueue]
select *  from [dbo].[ImportLog]

select  * from [dbo].[ImportQueue]
--select  * from [dbo].[ImportQueue] where ImportStatusID = 20
--select  * from [dbo].[ImportQueue] where ImportStatusID = 40
--select  * from [dbo].[ImportQueue] where TypeOfSecurity = 'XX'

select * from [dbo].[Case]
select * from [dbo].[CaseAttribute]
select * from [dbo].[CaseAttributeValue]
select * from [dbo].[ClaimContact]
select * from [dbo].[Claim]
select * from [dbo].[ClaimTransaction] where isDeleted = 1

select * from [dbo].[lk_ErrorMsg] --delete from [dbo].[lk_ErrorMsg] where ErrorMsgID = 51200
select * from [dbo].[lk_ImportStatus]
select * from [dbo].[lk_SecurityType]
select * from [dbo].[lk_TransactionType]
select * from [dbo].[lk_CaseAttributeType]


exec [dbo].[ImportLog_Update]	@ImportLogID = 1
,                               @BatchID = NULL
,                               @QtyClaims = NULL
,                               @QtyTransactions = NULL
,                               @ImportStatusID = 20
,                               @ImportMsg = 'File import completed'
,                               @isDebug = 1





select  a.[ClaimNumber]
,       case when charindex('-', a.[ClaimNumber]) = 3 then (left(a.[ClaimNumber], charindex('-', a.[ClaimNumber])-1)) + 'XX' 
                when charindex('-', a.[ClaimNumber]) = 5 then (left(a.[ClaimNumber], charindex('-', a.[ClaimNumber])-1)) 
                else 'ERR'
        end as [CaseCode]
,       a.[CaseName]
,       getutcdate() as [CreatedDate]
into    #tmp_Case
from    [dbo].[ImportQueue] a
group by a.[ClaimNumber]
,        case when charindex('-', a.[ClaimNumber]) = 3 then (left(a.[ClaimNumber], charindex('-', a.[ClaimNumber])-1)) + 'XX' 
                when charindex('-', a.[ClaimNumber]) = 5 then (left(a.[ClaimNumber], charindex('-', a.[ClaimNumber])-1)) 
                else 'ERR'
            end
,        a.CaseName


select  a.[CaseCode]
,       a.[CaseName] 
,       a.[CreatedDate]
from    #tmp_Case a
        left join [dbo].[Case] b on a.CaseCode = b.CaseCode
                                and a.CaseName = b.CaseName
group by a.[CaseCode]
,       a.[CaseName] 
,       a.[CreatedDate]

select  a.CaseCode
,       a.CaseName
,       a.CreatedDate
from    #tmp_Case a
        left join [dbo].[Case] b on a.CaseCode = b.CaseCode
                                and a.CaseName = b.CaseName
where   b.CaseCode is NULL



insert into [dbo].[CaseAttributeValue] values
    (1, 2, NULL, 1, NULL, NULL, 0, getutcdate(), NULL)
,   (1, 8, NULL, NULL, NULL, getutcdate(), 0, getutcdate(), NULL)
,   (1, 10, NULL, NULL, 82.50, NULL, 0, getutcdate(), NULL)
,   (1, 11, 'FIFO', NULL, NULL, NULL, 0, getutcdate(), NULL)

insert into [dbo].[CaseAttributeValue] values
    (2, 2, NULL, 1, NULL, NULL, 0, getutcdate(), NULL)
,   (2, 8, NULL, NULL, NULL, getutcdate(), 0, getutcdate(), NULL)
,   (2, 10, NULL, NULL, 50.75, NULL, 0, getutcdate(), NULL)
,   (2, 11, 'FIFO', NULL, NULL, NULL, 0, getutcdate(), NULL)

insert into [dbo].[CaseAttributeValue] values
    (21, 2, NULL, 1, NULL, NULL, 0, getutcdate(), NULL)
,   (21, 8, NULL, NULL, NULL, getutcdate(), 0, getutcdate(), NULL)
,   (21, 10, NULL, NULL, 10.00, NULL, 0, getutcdate(), NULL)
,   (21, 11, 'FIFO', NULL, NULL, NULL, 0, getutcdate(), NULL)

select * from [Case]
select * from [CaseAttributeValue] where CaseID = 21 order by [CaseAttributeID]
select * from [test].[TestTable]

alter table [dbo].[Case]
add [isDeleted] tinyint

alter table [dbo].[Case]
alter column [isDeleted] tinyint NOT NULL

update [dbo].[Case]
set isDeleted = 0

delete from [CaseAttributeValue]
where CaseAttributeValueID >= 37

delete from [CaseAttributeValue]
where [CaseAttributeID] in (2,8,10,11)

update [dbo].[CaseAttributeValue]
set modifiedDate = NULL