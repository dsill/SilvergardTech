USE [AngeionCalcs]
GO

----------------------------------------------------------------------------------------------------------
---------------------------------!!!!!!!! UPDATE PER ENVIRONMENT !!!!!!!!---------------------------------
----------------------------------------------------------------------------------------------------------
/*
truncate table [dbo].[SSIS Configurations]
select * from [SSIS Configurations]
*/


--DS-DESKTOP
--insert into [dbo].[SSIS Configurations]
--values  ('AngeionCalcs', '\\Ds-desktop\ftp\', '\Package.Variables[User::varFtpPath].Properties[Value]', 'String')
--,       ('AngeionCalcs', '\\Ds-desktop\ftp\Load', '\Package.Variables[User::varFtpPath_Load].Properties[Value]', 'String')
--GO

--DS-LAPTOP
insert into [dbo].[SSIS Configurations]
values  ('AngeionCalcs', '\\Ds-laptop\ftp\', '\Package.Variables[User::varFtpPath].Properties[Value]', 'String')
,       ('AngeionCalcs', '\\Ds-laptop\ftp\Load', '\Package.Variables[User::varFtpPath_Load].Properties[Value]', 'String')
GO

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------


insert into [dbo].[lk_TransactionType]
values  (10, 'U', 'Unsold')
,       (20, 'B', 'Beginning')
,       (30, 'I', 'Transfer In')
,       (40, 'O', 'Transfer Out')
,       (50, 'P', 'Purchase')
,       (60, 'S', 'Sale')
,       (70, 'STKSPLIT', 'Stock Split')

GO


insert into [dbo].[lk_SecurityType]
values  (10, 'CS', '')
GO


insert into [dbo].[lk_ImportStatus]
values  (10, 'Importing', 'File import in progress')
,       (20, 'Queued', 'Imported records queued for processing')
,       (30, 'Processing', 'Imported records dequeued and processing')
,       (40, 'Completed', 'Imported records completed processing')
,       (50, 'Error', 'Import resulted in error')
,       (99, 'Debug', 'Debugging status - testing only')
GO

--truncate table [dbo].[lk_ErrorMsg]
insert into [dbo].[lk_ErrorMsg]
values  (50000, N'#tmp_ImportQueue', N'50000: #tmp_ImportQueue has 0 rows.')
,       (51000, N'lk_SecurityType', N'51000: Type_of_Security ''##tkn_TypeOfSecurity##'' in spreadsheet does not exist in lk_SecurityType. ImportQueueID: [##tkn_ImportQueueID##]  TransactionID: [##tkn_TransactionID##]')
,       (51100, N'lk_TransactionType', N'51100: Transaction_Type ''##tkn_TransactionType##'' in spreadsheet does not exist in lk_TransactionType. ImportQueueID: [##tkn_ImportQueueID##]  TransactionID: [##tkn_TransactionID##]')
GO

--delete from [dbo].[lk_CaseAttributeType]
insert into [dbo].[lk_CaseAttributeType]
values  (10, 'int')
,       (20, 'decimal')
,       (30, 'nvarchar')
,       (40, 'varchar')
,       (50, 'datetime')

GO


insert into [dbo].[CaseAttribute]
values  ('CUSIP', 30, 0, 1, 0, getutcdate(), NULL)
,       ('Call Options', 10, 1, 1, 0, getutcdate(), NULL)
,       ('Put Options', 10, 1, 1, 0, getutcdate(), NULL)
,       ('Notes/Debentures', 10, 1, 1, 0, getutcdate(), NULL)
,       ('Preferred Stock', 10, 1, 1, 0, getutcdate(), NULL)
,       ('Warrants', 10, 1, 1, 0, getutcdate(), NULL)
,       ('Anything other than B, P, S, I, O, U?', 10, 1, 1, 0, getutcdate(), NULL) --enter new id's?
,       ('Start Date', 50, 0, 1, 0, getutcdate(), NULL)
,       ('End Date', 50, 0, 1, 0, getutcdate(), NULL)
,       ('Value', 20, 0, 1, 0, getutcdate(), NULL)
,       ('FIFO/LIFO/Other?', 30, 0, 1, 0, getutcdate(), NULL)
,       ('Create UA if unbalanced with more P''s?', 10, 1, 1, 0, getutcdate(), NULL)  
,       ('Should UA result in RL?', 10, 1, 1, 0, getutcdate(), NULL)
,       ('Should UA result in ML?', 10, 1, 1, 0, getutcdate(), NULL)
,       ('Create PA as last purchase if unbalanced with more S''s?', 10, 1, 1, 0, getutcdate(), NULL) 
,       ('Should PA result in RL?', 10, 1, 1, 0, getutcdate(), NULL)
,       ('Should PA result in ML?', 10, 1, 1, 0, getutcdate(), NULL)
,       ('Was there a stock split?', 10, 1, 1, 0, getutcdate(), NULL)
,       ('Split Date', 50, 0, 0, 18, getutcdate(), NULL)
,       ('Split Ratio', 20, 0, 0, 18, getutcdate(), NULL)  