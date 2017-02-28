USE [AngeionCalcs]
GO

if exists (select * from sysobjects where name = 'ImportDequeue' and type = 'P')
begin
    drop procedure [dbo].[ImportDequeue]
end
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
------------------------------------------------------------------------
-- ABOUT
------------------------------------------------------------------------

    Author:		    Daniel Sill
    Create date:    Sep 2, 2016
    Description:	Dequeue records from ImportQueue

------------------------------------------------------------------------
-- USAGE
------------------------------------------------------------------------
    
    exec [dbo].[ImportDequeue] @QtyDequeue = 0, @isDebug = 1

------------------------------------------------------------------------
-- DEBUG
------------------------------------------------------------------------

    select * from [dbo].[ImportQueue]
    select * from [dbo].[Claim]
    select * from [dbo].[ClaimContact]
    select * from [dbo].[ClaimTransaction]

------------------------------------------------------------------------
------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[ImportDequeue]
(
	@QtyDequeue int = 0, --Qty 0 = All
    @isDebug int = 0
)
AS
BEGIN

	SET NOCOUNT ON
    BEGIN TRY

        --declare variables
        declare @ImportStatusID int
        declare @ImportMsg nvarchar(max)
        declare @maxBatchID int
        declare @MasterClaimNumber int
        declare @ErrorMsgID int 
        declare @ErrorMsg nvarchar(1000)
        declare @ErrorImportQueueID int
        declare @ErrorTransactionID nvarchar(255)
        declare @ErrorValue nvarchar(10)
        declare @QtyClaims int
        declare @QtyTransactions int
        declare @DateDequeueStarted datetime

        set @ImportStatusID = case when @isDebug = 0 then 30 else 99 end --99 is debug status

        --set all queued records to processing in ImportQueue
        update  [dbo].[ImportQueue]
        set     [ImportStatusID] = @ImportStatusID
        where   [ImportStatusID] = 20

        --create list of import log records
        select  distinct a.[ImportLogID]
        ,       a.[ImportStatusID]
        ,       b.[ImportStatusDescription] as [ImportMsg]
        into    #tmp_ImportLogList
        from    [dbo].[ImportQueue] a
                inner join [dbo].[lk_ImportStatus] b on a.[ImportStatusID] = b.[ImportStatusID]
        where   a.[ImportStatusID] = @ImportStatusID

        -- update import log records in this process
        -- insert input params into table variable of TVP type to be passed to [dbo].[ImportLog_Update] which accepts TVP as input.
        -- this was done to allow log updates to be performed in bulk or individually with one set of logic.
        declare  @table_ImportLogList dbo.ImportLogList 

        insert into @table_ImportLogList 
        select  a.[ImportLogID]
        ,       NULL --BatchID
        ,       NULL --QtyRowsInFile
        ,       NULL --QtyRowsImported
        ,       NULL --QtyRowsFail
        ,       NULL --QtyClaims
        ,       NULL --QtyTransactions
        ,       NULL --isUpdate
        ,       a.[ImportStatusID]
        ,       a.[ImportMsg]
        from    #tmp_ImportLogList a

        exec [dbo].[ImportLog_Update] @table_ImportLogList


        --create and populate tmp tables, use cast to ensure datatypes
        select  cast(a.[ImportQueueID] as int)                                                      as [ImportQueueID]
        ,       cast(a.[ImportLogID] as int)                                                        as [ImportLogID]
        ,       cast(a.[ImportStatusID] as int)                                                     as [ImportStatusID]
        ,       cast(a.[CaseName] as nvarchar(255))                                                 as [CaseName]
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
        where   a.[ImportStatusID] in (30, 99) --Processing, Debug


		--set isUpdate for updates included in same batch as original record
		update	a
		set		a.[isUpdate] = 1
		from	#tmp_ImportQueue a
				left join #tmp_ImportQueue b on a.[MasterClaimNumber] = b.[MasterClaimNumber] and a.[TransactionID] = b.[TransactionID] and a.[ImportLogID] > b.[ImportLogID]
		where	b.[ImportStatusID] in (30, 99)


        --select records to be set as deleted
        select  distinct [MasterClaimNumber]
        into    #tmp_MasterClaim
        from    #tmp_ImportQueue

        --declare table variable @tbl_ImportQueueDelete
        declare @tbl_ImportQueueDelete table (
                [ImportQueueID] int
        ,       [MasterClaimNumber] int
        ,       [TransactionID] nvarchar(255)
        )

        --loop through each MasterClaimNumber individually
        while exists (select * from #tmp_MasterClaim)
        begin

            -- set MasterClaimNumber to max(MasterClaimNumber)
            select  @MasterClaimNumber = max([MasterClaimNumber])
            from    #tmp_MasterClaim

            -- insert records from ImportQueue that have completed and have same MasterClaimNumber but no matching transaction
            -- these records will be marked as deleted as they do not exist in the file being imported
            insert into @tbl_ImportQueueDelete
            select  b.[ImportQueueID]
            ,       b.[MasterClaimNumber]
            ,       b.[TransactionID]
            from    #tmp_ImportQueue a
                    right join [dbo].[ImportQueue] b on a.[TransactionID] = b.[TransactionID] and a.[MasterClaimNumber] = b.[MasterClaimNumber]
            where   b.[MasterClaimNumber] = @MasterClaimNumber
            and     b.[ImportStatusID] = 40
            and     a.[TransactionID] is NULL

            delete from #tmp_MasterClaim where MasterClaimNumber = @MasterClaimNumber

        end

        -- generate unique CaseID from ClaimNumber and insert into #tmp_Case
        select  case when charindex('-', a.[ClaimNumber]) = 3 then (left(a.[ClaimNumber], charindex('-', a.[ClaimNumber])-1)) + 'XX' 
                     when charindex('-', a.[ClaimNumber]) = 5 then (left(a.[ClaimNumber], charindex('-', a.[ClaimNumber])-1)) 
                     else 'ERR'
                end as [CaseCode]
        ,       a.[CaseName]
        ,       getutcdate() as [CreatedDate]
        into    #tmp_Case
        from    [dbo].[ImportQueue] a
        group by case when charindex('-', a.[ClaimNumber]) = 3 then (left(a.[ClaimNumber], charindex('-', a.[ClaimNumber])-1)) + 'XX' 
                      when charindex('-', a.[ClaimNumber]) = 5 then (left(a.[ClaimNumber], charindex('-', a.[ClaimNumber])-1)) 
                      else 'ERR'
                 end
        ,        a.CaseName

        --#tmp_ClaimContact
        select  a.[MasterClaimNumber]
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
        group by a.[MasterClaimNumber]
        ,       a.[Address1]
        ,       a.[Address2]
        ,       a.[City]
        ,       a.[State]
        ,       a.[Zip]
        ,       a.[Country]
        ,       isnull(a.[ForeignAddressFlag], 0)
        ,       a.[isUpdate]

        --#tmp_Claim
        select  a.[MasterClaimNumber]
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
        group by a.[MasterClaimNumber]
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
        select  a.[MasterClaimNumber]
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
                inner join [dbo].[lk_SecurityType] c on a.[TypeOfSecurity] = c.[SecurityTypeCode]
                inner join [dbo].[lk_TransactionType] d on a.[TransactionType] = d.[TransactionTypeCode]
        group by a.[MasterClaimNumber]
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


        -----------------------------------------------------------------------------------------
        -- ERROR CHECKS
        -----------------------------------------------------------------------------------------
        --check for invalid CaseCode
        --TODO

        --check for unknown Type_of_Security
        select  top 1 a.[ImportQueueID]
        ,       a.[TransactionID]
        ,       a.[TypeOfSecurity]
        into    #tmp_SecurityTypeError
        from    #tmp_ImportQueue a
                left join [dbo].[lk_SecurityType] b on a.[TypeOfSecurity] = b.[SecurityTypeCode]
        where   b.[SecurityTypeCode] is NULL

        --check for unknown Transaction_Type
        select  top 1 a.[ImportQueueID]
        ,       a.[TransactionID]
        ,       a.[TransactionType]
        into    #tmp_TransactionTypeError
        from    #tmp_ImportQueue a
                left join [dbo].[lk_TransactionType] b on a.[TransactionType] = b.[TransactionTypeCode]
        where   b.[TransactionTypeCode] is NULL


        --throw error if an ImportLog shows queued records but #tmp_ImportQueue has 0 rows and not a debug execution
        if not exists(select [ImportQueueID] from #tmp_ImportQueue) and exists(select * from #tmp_ImportLogList) and (@isDebug = 0)
        begin 
             
            select  @ErrorMsgID = ErrorMsgID  
            ,       @ErrorMsg = ErrorMsg 
            from    [dbo].[lk_ErrorMsg] 
            where   [ErrorParam] = '#tmp_ImportQueue' 

 
            ;THROW @ErrorMsgID, @ErrorMsg, 1
        end

        --throw error if #tmp_ImportQueue has unknown SecurityType and not a debug execution
        if exists(select * from #tmp_SecurityTypeError) and (@isDebug = 0)
        begin 

            select  @ErrorImportQueueID = [ImportQueueID]
            ,       @ErrorTransactionID = [TransactionID] 
            ,       @ErrorValue = [TypeOfSecurity]
            from    #tmp_SecurityTypeError

            select  @ErrorMsgID = ErrorMsgID  
            ,       @ErrorMsg = ErrorMsg 
            from    [dbo].[lk_ErrorMsg] 
            where   [ErrorParam] = 'lk_SecurityType' 

            set     @ErrorMsg = replace(@ErrorMsg, '##tkn_TypeOfSecurity##', @ErrorValue)
            set     @ErrorMsg = replace(@ErrorMsg, '##tkn_ImportQueueID##', @ErrorImportQueueID)
            set     @ErrorMsg = replace(@ErrorMsg, '##tkn_TransactionID##', @ErrorTransactionID)
 
            ;THROW @ErrorMsgID, @ErrorMsg, 1
        end

        --throw error if #tmp_ImportQueue has unknown TransactionType and not a debug execution
        if exists(select * from #tmp_TransactionTypeError) and (@isDebug = 0)
        begin 
            
            select  @ErrorImportQueueID = [ImportQueueID]
            ,       @ErrorTransactionID = [TransactionID] 
            ,       @ErrorValue = [TypeOfSecurity]
            from    #tmp_TransactionTypeError

            select  @ErrorMsgID = ErrorMsgID  
            ,       @ErrorMsg = ErrorMsg 
            from    [dbo].[lk_ErrorMsg] 
            where   [ErrorParam] = 'lk_TransactionType' 

            set     @ErrorMsg = replace(@ErrorMsg, '##tkn_TransactionType##', @ErrorValue)
            set     @ErrorMsg = replace(@ErrorMsg, '##tkn_ImportQueueID##', @ErrorImportQueueID)
            set     @ErrorMsg = replace(@ErrorMsg, '##tkn_TransactionID##', @ErrorTransactionID)
 
            ;THROW @ErrorMsgID, @ErrorMsg, 1
        end

        --------------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------------


        if (@isDebug = 0)
        begin

            --create BatchQueue records in [dbo].[ImportBatchQueue]
            select  @maxBatchID = isnull(max([BatchID]), 0) + 1
            from    [dbo].[ImportBatchQueue]

            insert  into [dbo].[ImportBatchQueue]
            select  @maxBatchID
            ,       [ImportQueueID]
            from    #tmp_ImportQueue


            --update log with batch info
            select  a.ImportLogID
            ,       max(a.isUpdate) as isUpdate
            into    #tmp_ImportLog
            from    #tmp_ImportQueue a
            group by a.ImportLogID

            update  a  
            set     a.[BatchID] = @maxBatchID
            ,       a.[isUpdate] = b.[isUpdate]
            from    @table_ImportLogList a
                    inner join #tmp_ImportLog b on a.ImportLogID = b.ImportLogID

            exec [dbo].[ImportLog_Update] @table_ImportLogList

            ----------------------------
            -- [dbo].[Case] 
            ----------------------------
            -- Insert Case record if it does not already exist
            insert  into [dbo].[Case]
            select  a.CaseCode
            ,       a.CaseName
            ,       a.CreatedDate
            from    #tmp_Case a
                    left join [dbo].[Case] b on a.CaseCode = b.CaseCode
                                            and a.CaseName = b.CaseName
            where   b.CaseCode is NULL


            ----------------------------
            -- [dbo].[ClaimContact] 
            ----------------------------
            -- Update existing ClaimContact record
            update  b
            set     b.[Address1] = a.[Address1]
            ,       b.[Address2] = a.[Address2]
            ,       b.[City] = a.[City]
            ,       b.[State] = a.[State]
            ,       b.[Zip] = a.[Zip]
            ,       b.[Country] = a.[Country]
            ,       b.[isForeignAddress] = isnull(a.[isForeignAddress], 0)
            ,       b.[ModifiedDate] = getutcdate()
            from    #tmp_ClaimContact a
                    inner join [dbo].[ClaimContact] b on a.[MasterClaimNumber] = b.[MasterClaimNumber]
                                                    and a.[Address1] = b.[Address1]
                                                    and isnull(a.[Address2], '') = isnull(b.[Address2], '')
                                                    and a.[City] = b.[City]
                                                    and a.[State] = b.[State]
                                                    and a.[Zip] = b.[Zip]
                                                    and isnull(a.[Country], '') = isnull(b.[Country], '')
                                                    and isnull(a.[isForeignAddress], 0) = isnull(b.[isForeignAddress], 0) 
            where   a.[isUpdate] = 1


            -- Insert ClaimContact record if it does not already exist
            insert into [dbo].[ClaimContact]
            select  a.[MasterClaimNumber]
            ,       a.[Address1]
            ,       a.[Address2]
            ,       a.[City]
            ,       a.[State]
            ,       a.[Zip]
            ,       a.[Country]
            ,       isnull(a.[isForeignAddress], 0) 
            ,       getutcdate()    --CreatedDate
            ,       NULL            --ModifiedDate
            from    #tmp_ClaimContact a
                    left join [dbo].[ClaimContact] b on a.[MasterClaimNumber] = b.[MasterClaimNumber]
                                                    and a.[Address1] = b.[Address1]
                                                    and isnull(a.[Address2], '') = isnull(b.[Address2], '')
                                                    and a.[City] = b.[City]
                                                    and a.[State] = b.[State]
                                                    and a.[Zip] = b.[Zip]
                                                    and isnull(a.[Country], '') = isnull(b.[Country], '')
                                                    and isnull(a.[isForeignAddress], 0) = isnull(b.[isForeignAddress], 0) 
            where   b.[MasterClaimNumber] is NULL


            -- Create temporary contact mapping
            select  distinct a.[ClaimContactID]
            ,       b.[MasterClaimNumber]
            ,       b.[ClaimNumber]
            into    #tmp_ClaimContactMapping
            from    [dbo].[ClaimContact] a
                    inner join #tmp_ImportQueue b on a.[MasterClaimNumber] = b.[MasterClaimNumber]
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
            set     b.[MasterClaimNumber] = a.[MasterClaimNumber]
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
                    inner join [dbo].[Claim] b on a.[ClaimNumber] = b.[ClaimNumber] and b.[MasterClaimNumber] = a.[MasterClaimNumber] and a.[isUpdate] = 1
            where   b.[AccountNumber] != a.[AccountNumber]
            or      b.[BeneficialOwnerName] != a.[BeneficialOwnerName]
            or      b.[CoOwnerName] != a.[CoOwnerName]
            or      b.[Representative] != a.[Representative]
            or      b.[TaxID] != a.[TaxID]
            or      b.[InvalidSignature] != a.[InvalidSignature]
            or      b.[NoAuthorityToFile] != a.[NoAuthorityToFile]
            or      b.[DataSourceUknown] != a.[DataSourceUknown]
            or      b.[SpecialPaymentCode] != a.[SpecialPaymentCode]
            or      b.[ClaimMessageCodes] != a.[ClaimMessageCodes]
            or      b.[PostmarkDate] != a.[PostmarkDate]




            -- Insert Claim record if it does not already exist (existence based on [MasterClaimNumber])
            insert into [dbo].[Claim]
            select  c.[ClaimContactID]
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
            ,       getutcdate()    --CreatedDate
            ,       NULL            --ModifiedDate
            from    #tmp_Claim a
                    left join [dbo].[Claim] b on a.[ClaimNumber] = b.[ClaimNumber] and b.[MasterClaimNumber] = a.[MasterClaimNumber]
                    inner join #tmp_ClaimContactMapping c on a.[ClaimNumber] = c.[ClaimNumber] and a.[MasterClaimNumber] = c.[MasterClaimNumber] 
            where   b.[ClaimNumber] is NULL


            -- Delete Claim record if it once existed and has been removed from the import file
        

            ----------------------------
            -- [dbo].[ClaimTransaction]
            ----------------------------
            -- Update existing ClaimTransaction record (existence based on [TransactionID])
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
                    inner join [dbo].[ClaimTransaction] b on a.[TransactionID] = b.[TransactionID] and a.[isUpdate] = 1
                    inner join [dbo].[Claim] c on a.[ClaimNumber] = c.[ClaimNumber] and a.[MasterClaimNumber] = c.[MasterClaimNumber]
            where   b.[ClaimID] != c.[ClaimID]
            or      b.[TransactionID] != a.[TransactionID]  
            or      b.[SecurityTypeID] != a.[SecurityTypeID]
            or      b.[SecurityID] != a.[SecurityID]
            or      b.[TransactionTypeID] != a.[TransactionTypeID]
            or      b.[TradeDate] != a.[TradeDate]
            or      b.[Quantity] != a.[Quantity]
            or      b.[Price] != a.[Price]
            or      b.[TotalAmountPaidOrRecieved] != a.[TotalAmountPaidOrRecieved]
            or      b.[DivReimbPurchase] != a.[DivReimbPurchase]
            or      b.[Options] != a.[Options]
            or      b.[Short] != a.[Short]
            or      b.[TransactionMsgCodes] != a.[TransactionMsgCodes]


            -- Set isDeleted flag if file has already imported and updated file is missing rows
            update  b
            set     b.[isDeleted] = 1
            from    @tbl_ImportQueueDelete a
                    inner join [dbo].[ClaimTransaction] b on a.[TransactionID] = b.[TransactionID]

            -- Insert ClaimTransaction record if it does not already exist (existence based on [TransactionID])
            insert into [dbo].[ClaimTransaction]
            select  c.[ClaimID]
            ,       a.[TransactionID]  
            ,       a.[SecurityTypeID]
            ,       a.[SecurityID]
            ,       a.[TransactionTypeID]
            ,       a.[TradeDate]
            ,       a.[Quantity]
            ,       a.[Price]
            ,       a.[TotalAmountPaidOrRecieved]
            ,       a.[DivReimbPurchase]
            ,       a.[Options]
            ,       a.[Short]
            ,       a.[TransactionMsgCodes]
            ,       0               --isDeleted
            ,       getutcdate()    --CreatedDate
            ,       NULL            --ModifiedDate
            from    #tmp_ClaimTransaction a
                    left join [dbo].[ClaimTransaction] b on a.[TransactionID] = b.[TransactionID]
                    inner join [dbo].[Claim] c on a.[ClaimNumber] = c.[ClaimNumber] and a.[MasterClaimNumber] = c.[MasterClaimNumber]
            where   b.[TransactionID] is NULL


            --set all processed records to completed in ImportQueue
            select  @ImportStatusID = a.[ImportStatusID]
            ,       @ImportMsg = a.[ImportStatusDescription]
            from    [dbo].[lk_ImportStatus] a
            where   a.[ImportStatusID] = 40 --Completed

            update  a
            set     [ImportStatusID] = @ImportStatusID
            from    [dbo].[ImportQueue] a
                    inner join [dbo].[ImportBatchQueue] b on a.[ImportQueueID] = b.[ImportQueueID] and b.[BatchID] = @maxBatchID


            --update counts after completed batch for updating log values
            select  b.[ImportLogID]
            ,       count(a.[MasterClaimNumber]) as [QtyClaims]
            into    #tmp_QtyClaim
            from    #tmp_Claim a
                    inner join (select distinct [ImportLogID], [MasterClaimNumber] from #tmp_ImportQueue) b on a.[MasterClaimNumber] = b.[MasterClaimNumber]
            group by b.[ImportLogID]

            select  a.[ImportLogID]
            ,       count(a.[TransactionID]) as [QtyTransactions]
            into    #tmp_QtyTransaction
            from    #tmp_ImportQueue a
            group by a.ImportLogID

            
            --update ImportLog table var to be passed to ImportLog_Update procedure
            update  a  
            set     a.ImportStatusID = @ImportStatusID
            ,       a.[QtyClaims] = b.[QtyClaims]
            ,       a.[QtyTransactions] = c.[QtyTransactions]
            ,       a.ImportMsg = @ImportMsg
            from    @table_ImportLogList a
                    inner join #tmp_QtyClaim b on a.[ImportLogID] = b.[ImportLogID]
                    inner join #tmp_QtyTransaction c on a.[ImportLogID] = c.[ImportLogID]
            
            --exec log update
            exec [dbo].[ImportLog_Update] @table_ImportLogList

        
            
        end
        else
        begin
            --Enter debug block

            select '@table_ImportLogList' as [table], * from @table_ImportLogList
            select '#tmp_ImportQueue' as [table], * from #tmp_ImportQueue
            select '@tbl_ImportQueueDelete' as [table], * from @tbl_ImportQueueDelete
            select '#tmp_Case' as [table], * from #tmp_Case
            select '#tmp_Claim' as [table], * from #tmp_Claim
            select '#tmp_ClaimContact' as [table], * from #tmp_ClaimContact
            select '#tmp_ClaimTransaction' as [table], * from #tmp_ClaimTransaction

            --set status back to queued
            update  a
            set     [ImportStatusID] = 20
            from    [dbo].[ImportQueue] a
            where   [ImportStatusID] = 99

            update  a
            set     [ImportStatusID] = 20
            from    [dbo].[ImportLog] a
                    inner join @table_ImportLogList b on a.[ImportLogID] = b.[ImportLogID]
            where   a.[ImportStatusID] = 99

        end

    END TRY
    BEGIN CATCH

        set @ImportStatusID = 50 --Error

        --update ImportLog table var to be passed to ImportLog_Update procedure
        update  a  
        set     a.ImportStatusID = @ImportStatusID
        ,       a.ImportMsg = @ErrorMsg
        from    @table_ImportLogList a
            
        --exec log update
        exec [dbo].[ImportLog_Update] @table_ImportLogList
        ;THROW

    END CATCH

    --TODO: catch invalid case code

END

