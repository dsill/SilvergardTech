drop table #tmp_ImportQueue
drop table #tmp_Case
drop table #tmp_Claim
drop table #tmp_ClaimContact
drop table #tmp_ClaimContactMapping
drop table #tmp_ClaimTransaction

update [ImportQueue] set ImportStatusID = 30 where ImportStatusID = 20

select  cast(a.[ImportQueueID] as int)                                                      as [ImportQueueID]
,       cast(a.[ImportLogID] as int)                                                        as [ImportLogID]
,       cast(a.[ImportStatusID] as int)                                                     as [ImportStatusID]
,       cast(-1 as int)                                                                     as [CaseID]
,       cast(a.[CaseName] as nvarchar(255))                                                 as [CaseName]
,       cast('' as nvarchar(4))                                                             as [CaseCode]
,       cast(a.[BeneficialOwnerName] as nvarchar(max))                                      as [BeneficialOwnerName]
,       cast(a.[CoOwnerName] as nvarchar(max))                                              as [CoOwnerName]
,       cast(a.[Representative] as nvarchar(max))                                           as [Representative]
,       cast(a.[Address1] as nvarchar(max))                                                 as [Address1]
,       cast(a.[Address2] as nvarchar(max))                                                 as [Address2]
,       cast(a.[City] as nvarchar(max))                                                     as [City]
,       cast(a.[State] as nvarchar(255))                                                    as [State]
,       cast(a.[Zip] as nvarchar(255))                                                      as [Zip]
,       cast(a.[Country] as nvarchar(max))                                                  as [Country]
,       cast(a.[ForeignAddressFlag] as tinyint)                                             as [ForeignAddressFlag]
,       cast(a.[MasterClaimNumber] as int)                                                  as [MasterClaimNumber]
,       cast(a.[AccountNumber] as nvarchar(255))                                            as [AccountNumber]
,       cast(a.[ClaimNumber] as nvarchar(255))                                              as [ClaimNumber]
,       cast(a.[TaxID] as int)                                                              as [TaxID]
,       cast((case when a.[InvalidSignature] is NULL then 0 else 1 end) as tinyint)         as [InvalidSignature]
,       cast((case when a.[NoAuthorityToFile] is NULL then 0 else 1 end) as tinyint)        as [NoAuthorityToFile]
,       cast((case when a.[DataSourceUknown] is NULL then 0 else 1 end) as tinyint)         as [DataSourceUknown]
,       cast((case when a.[SpecialPaymentCode] is NULL then 0 else 1 end) as tinyint)       as [SpecialPaymentCode]
,       cast(a.[PostmarkDate] as datetime)                                                  as [PostmarkDate]
,       cast(a.[ClaimMessageCodes] as nvarchar(255))                                        as [ClaimMessageCodes]
,       cast(a.[TransactionID] as nvarchar(255))                                            as [TransactionID]
,       cast(a.[TypeOfSecurity] as nvarchar(255))                                           as [TypeOfSecurity]
,       cast(a.[SecurityID] as nvarchar(255))                                               as [SecurityID]
,       cast(a.[TransactionType] as nvarchar(255))                                          as [TransactionType]
,       cast(a.[TradeDate] as datetime)                                                     as [TradeDate]
,       cast(a.[Quantity] as decimal(19,4))                                                 as [Quantity]
,       cast(a.[Price] as decimal(19,4))                                                    as [Price]
,       cast(a.[TotalAmountPaidOrRecieved] as decimal(19,4))                                as [TotalAmountPaidOrRecieved]
,       cast(a.[DivReimbPurchase] as decimal(19,4))                                         as [DivReimbPurchase]
,       cast(a.[Options] as nvarchar(255))                                                  as [Options]
,       cast(a.[Short] as nvarchar(255))                                                    as [Short]
,       cast(a.[TransactionMsgCodes] as nvarchar(255))                                      as [TransactionMsgCodes]
,       cast(a.[CreatedDate] as datetime)                                                   as [CreatedDate]
,       cast(a.[ModifiedDate] as datetime)                                                  as [ModifiedDate]
,       cast((case when b.[TransactionID] is NULL then 0 else 1 end) as tinyint)            as [isUpdate]
into    #tmp_ImportQueue
from    [dbo].[ImportQueue] a
        left join [dbo].[ImportQueue] b on a.[MasterClaimNumber] = b.[MasterClaimNumber] and a.[TransactionID] = b.[TransactionID] and b.[ImportStatusID] = 40
where   a.[ImportStatusID] in (30, 99)

/*
select * from #tmp_ImportQueue
select sum(qtyTransactions) as qtyTransactions from [dbo].[ImportLog]
*/


-- generate CaseCode from ClaimNumber and insert into #tmp_Case
update  #tmp_ImportQueue
set     [CaseCode] = case   when charindex('-', [ClaimNumber]) = 3 then (left([ClaimNumber], charindex('-', [ClaimNumber])-1)) + 'XX' 
                            when charindex('-', [ClaimNumber]) = 5 then (left([ClaimNumber], charindex('-', [ClaimNumber])-1)) 
                            else 'ERR'
                     end


--#tmp_Case
        select  a.[ClaimNumber]
        ,       a.[CaseCode]
        ,       a.[CaseName]
        ,       getutcdate() as [CreatedDate]
        into    #tmp_Case
        from    #tmp_ImportQueue a
        group by a.[ClaimNumber]
        ,       a.[CaseCode]
        ,       a.[CaseName]

        --#tmp_ClaimContact
        select  a.[MasterClaimNumber]
        ,       b.[CaseCode]
        ,       a.[Address1]
        ,       a.[Address2]
        ,       a.[City]
        ,       a.[State]
        ,       a.[Zip]
        ,       a.[Country]
        ,       isnull(a.[ForeignAddressFlag], 0) as isForeignAddress
        ,       a.[isUpdate]
        into    #tmp_ClaimContact
        from    #tmp_ImportQueue a
                inner join #tmp_Case b on a.[ClaimNumber] = b.[ClaimNumber]
        group by a.[MasterClaimNumber]
        ,       b.[CaseCode]
        ,       a.[Address1]
        ,       a.[Address2]
        ,       a.[City]
        ,       a.[State]
        ,       a.[Zip]
        ,       a.[Country]
        ,       isnull(a.[ForeignAddressFlag], 0)
        ,       a.[isUpdate]

        --#tmp_Claim
        select  a.[CaseCode]
        ,       a.[MasterClaimNumber]
        ,       a.[ClaimNumber]
        ,       a.[AccountNumber]
        ,       a.[BeneficialOwnerName]
        ,       a.[CoOwnerName]
        ,       a.[Representative]
        ,       a.[TaxID]
        ,       a.[InvalidSignature]
        ,       a.[NoAuthorityToFile]
        ,       a.[DataSourceUknown]
        ,       a.[SpecialPaymentCode]
        ,       a.[ClaimMessageCodes]
        ,       a.[PostmarkDate]
        ,       a.[isUpdate]
        into    #tmp_Claim
        from    #tmp_ImportQueue a
                inner join #tmp_Case b on a.[ClaimNumber] = b.[ClaimNumber]
        group by a.[CaseCode]
        ,       a.[MasterClaimNumber]
        ,       a.[ClaimNumber]
        ,       a.[AccountNumber]
        ,       a.[BeneficialOwnerName]
        ,       a.[CoOwnerName]
        ,       a.[Representative]
        ,       a.[TaxID]
        ,       a.[InvalidSignature]
        ,       a.[NoAuthorityToFile]
        ,       a.[DataSourceUknown]
        ,       a.[SpecialPaymentCode]
        ,       a.[ClaimMessageCodes]
        ,       a.[PostmarkDate]
        ,       a.[isUpdate]

        --#tmp_ClaimTransaction
        select  b.[CaseCode]
        ,       a.[MasterClaimNumber]
        ,       a.[ClaimNumber]
        ,       a.[TransactionID]  
        ,       c.[SecurityTypeID]
        ,       a.[SecurityID]
        ,       d.[TransactionTypeID]
        ,       a.[TradeDate]
        ,       a.[Quantity]
        ,       a.[Price]
        ,       a.[TotalAmountPaidOrRecieved]
        ,       a.[DivReimbPurchase]
        ,       a.[Options]
        ,       a.[Short]
        ,       a.[TransactionMsgCodes]
        ,       a.[isUpdate]
        into    #tmp_ClaimTransaction
        from    #tmp_ImportQueue a
                inner join #tmp_Case b on a.[ClaimNumber] = b.[ClaimNumber]
                inner join [dbo].[lk_SecurityType] c on a.[TypeOfSecurity] = c.[SecurityTypeCode]
                inner join [dbo].[lk_TransactionType] d on a.[TransactionType] = d.[TransactionTypeCode]
        group by b.[CaseCode] 
        ,       a.[MasterClaimNumber]
        ,       a.[ClaimNumber]
        ,       a.[TransactionID]  
        ,       c.[SecurityTypeID]
        ,       a.[SecurityID]
        ,       d.[TransactionTypeID]
        ,       a.[TradeDate]
        ,       a.[Quantity]
        ,       a.[Price]
        ,       a.[TotalAmountPaidOrRecieved]
        ,       a.[DivReimbPurchase]
        ,       a.[Options]
        ,       a.[Short]
        ,       a.[TransactionMsgCodes]
        ,       a.[isUpdate]



/*
select * from #tmp_ImportQueue
select * from #tmp_Case
select * from #tmp_ClaimContact
select * from #tmp_mClai
select * from #tmp_ClaimTransaction
*/


-- Insert Case record if it does not already exist
--insert  into [dbo].[Case]
--select  a.[CaseCode]
--,       a.[CaseName] 
--,       a.[CreatedDate]
--from    #tmp_Case a
--        left join [dbo].[Case] b on a.CaseCode = b.CaseCode
--                                and a.CaseName = b.CaseName
--group by a.[CaseCode]
--,        a.[CaseName] 
--,        a.[CreatedDate]


update  a
set     a.[CaseID] = b.[CaseID]
from    #tmp_ImportQueue a
        inner join [dbo].[Case] b on a.[CaseCode] = b.[CaseCode]



----------------------------
-- [dbo].[ClaimContact] 
----------------------------
-- Update existing ClaimContact record
update  b
set     b.[CaseID] = c.[CaseID]
,       b.[MasterClaimNumber] = a.[MasterClaimNumber]
,       b.[Address1] = a.[Address1]
,       b.[Address2] = a.[Address2]
,       b.[City] = a.[City]
,       b.[State] = a.[State]
,       b.[Zip] = a.[Zip]
,       b.[Country] = a.[Country]
,       b.[isForeignAddress] = isnull(a.[isForeignAddress], 0)
,       b.[ModifiedDate] = getutcdate()
--select *
from    #tmp_ClaimContact a
        inner join [dbo].[ClaimContact] b on a.[MasterClaimNumber] = b.[MasterClaimNumber]
                                        and a.[Address1] = b.[Address1]
                                        and isnull(a.[Address2], '') = isnull(b.[Address2], '')
                                        and a.[City] = b.[City]
                                        and a.[State] = b.[State]
                                        and a.[Zip] = b.[Zip]
                                        and isnull(a.[Country], '') = isnull(b.[Country], '')
                                        and isnull(a.[isForeignAddress], 0) = isnull(b.[isForeignAddress], 0) 
        inner join [dbo].[Case] c on a.[CaseCode] = c.[CaseCode]
where   a.[isUpdate] = 1


-- Create temporary contact mapping
select  distinct a.[ClaimContactID]
,       a.[CaseID]
,       b.[MasterClaimNumber]
,       b.[ClaimNumber]
into    #tmp_ClaimContactMapping
from    [dbo].[ClaimContact] a
        inner join #tmp_ImportQueue b on a.[CaseID] = b.[CaseID]     
                                        and a.[MasterClaimNumber] = b.[MasterClaimNumber]
                                        and a.[Address1] = b.[Address1]
                                        and isnull(a.[Address2], '') = isnull(b.[Address2], '')
                                        and a.[City] = b.[City]
                                        and a.[State] = b.[State]
                                        and a.[Zip] = b.[Zip]
                                        and isnull(a.[Country], '') = isnull(b.[Country], '')
                                        and isnull(a.[isForeignAddress], 0) = isnull(b.[ForeignAddressFlag], 0) 
        



----------------------------
-- [dbo].[Claim]
---------------------------- 
-- Update existing Claim record (existence based on [MasterClaimNumber] and [ClaimNumber] where [isUpdate] = 1)
update  b
set     b.[ClaimContactID] = d.[ClaimContactID]
,       b.[MasterClaimNumber] = a.[MasterClaimNumber]
,       b.[ClaimNumber] = a.[ClaimNumber]
,       b.[AccountNumber] = a.[AccountNumber]
,       b.[BeneficialOwnerName] = a.[BeneficialOwnerName]
,       b.[CoOwnerName] = a.[CoOwnerName]
,       b.[Representative] = a.[Representative]
,       b.[TaxID] = a.[TaxID]
,       b.[InvalidSignature] = a.[InvalidSignature]
,       b.[NoAuthorityToFile] = a.[NoAuthorityToFile]
,       b.[DataSourceUknown] = a.[DataSourceUknown]
,       b.[SpecialPaymentCode] = a.[SpecialPaymentCode]
,       b.[ClaimMessageCodes] = a.[ClaimMessageCodes]
,       b.[PostmarkDate] = a.[PostmarkDate]
,       b.[ModifiedDate] = getutcdate()
--select a.*
from    #tmp_Claim a
        inner join [dbo].[Claim] b on a.[ClaimNumber] = b.[ClaimNumber] and b.[MasterClaimNumber] = a.[MasterClaimNumber] --and a.[isUpdate] = 1
        inner join [dbo].[Case] c on a.[CaseCode] = c.[CaseCode]
        inner join #tmp_ClaimContactMapping d on a.[ClaimNumber] = d.[ClaimNumber] and a.[MasterClaimNumber] = d.[MasterClaimNumber] and c.[CaseID] = d.[CaseID] 
where   a.[isUpdate] = 1
--where   b.[ClaimContactID] != d.[ClaimContactID]
--or      b.[AccountNumber] != a.[AccountNumber]
--or      b.[BeneficialOwnerName] != a.[BeneficialOwnerName]
--or      b.[CoOwnerName] != a.[CoOwnerName]
--or      b.[Representative] != a.[Representative]
--or      b.[TaxID] != a.[TaxID]
--or      b.[InvalidSignature] != a.[InvalidSignature]
--or      b.[NoAuthorityToFile] != a.[NoAuthorityToFile]
--or      b.[DataSourceUknown] != a.[DataSourceUknown]
--or      b.[SpecialPaymentCode] != a.[SpecialPaymentCode]
--or      b.[ClaimMessageCodes] != a.[ClaimMessageCodes]
--or      b.[PostmarkDate] != a.[PostmarkDate]  



select * from #tmp_Claim
select * from [dbo].[Claim]
select * from #tmp_ClaimContactMapping


update  b
set     b.[ClaimID] = c.[ClaimID]
,       b.[TransactionID] = a.[TransactionID]  
,       b.[SecurityTypeID] = a.[SecurityTypeID]
,       b.[SecurityID] = a.[SecurityID]
,       b.[TransactionTypeID] = a.[TransactionTypeID]
,       b.[TradeDate] = a.[TradeDate]
,       b.[Quantity] = a.[Quantity]
,       b.[Price] = a.[Price]
,       b.[TotalAmountPaidOrRecieved] = a.[TotalAmountPaidOrRecieved]
,       b.[DivReimbPurchase] = a.[DivReimbPurchase]
,       b.[Options] = a.[Options]
,       b.[Short] = a.[Short]
,       b.[TransactionMsgCodes] = a.[TransactionMsgCodes]
,       b.[ModifiedDate] = getutcdate()
--select a.*
from    #tmp_ClaimTransaction a
        inner join [dbo].[ClaimTransaction] b on a.[TransactionID] = b.[TransactionID]
        inner join [dbo].[Claim] c on a.[ClaimNumber] = c.[ClaimNumber] and a.[MasterClaimNumber] = c.[MasterClaimNumber]
where   a.[isUpdate] = 1