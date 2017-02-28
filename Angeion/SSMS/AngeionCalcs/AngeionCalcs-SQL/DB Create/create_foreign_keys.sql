USE [AngeionCalcs]
GO

PRINT N'Adding foreign keys to [active].[CaseAttributeValue]'
GO
ALTER TABLE [dbo].[CaseAttributeValue]  WITH NOCHECK ADD  CONSTRAINT [FK__dbo_CaseAttributeValue__CaseID] FOREIGN KEY([CaseID])
REFERENCES [dbo].[Case] ([CaseID])
GO

ALTER TABLE [dbo].[CaseAttributeValue] CHECK CONSTRAINT [FK__dbo_CaseAttributeValue__CaseID]
GO


ALTER TABLE [dbo].[CaseAttributeValue]  WITH NOCHECK ADD  CONSTRAINT [FK__dbo_CaseAttributeValue__CaseAttributeID] FOREIGN KEY([CaseAttributeID])
REFERENCES [dbo].[CaseAttribute] ([CaseAttributeID])
GO

ALTER TABLE [dbo].[CaseAttributeValue] CHECK CONSTRAINT [FK__dbo_CaseAttributeValue__CaseAttributeID]
GO


PRINT N'Adding foreign keys to [active].[CaseAttribute]'
GO
ALTER TABLE [dbo].[CaseAttribute]  WITH NOCHECK ADD  CONSTRAINT [FK__dbo_CaseAttribute__CaseAttributeTypeID] FOREIGN KEY([CaseAttributeTypeID])
REFERENCES [dbo].[lk_CaseAttributeType] ([CaseAttributeTypeID])
GO

ALTER TABLE [dbo].[CaseAttribute] CHECK CONSTRAINT [FK__dbo_CaseAttribute__CaseAttributeTypeID]
GO


PRINT N'Adding foreign keys to [active].[ImportBatchQueue]'
GO
ALTER TABLE [dbo].[ImportBatchQueue]  WITH NOCHECK ADD  CONSTRAINT [FK__dbo_ImportBatchQueue__ImportQueueID] FOREIGN KEY([ImportQueueID])
REFERENCES [dbo].[ImportQueue] ([ImportQueueID])
GO

ALTER TABLE [dbo].[ImportBatchQueue] CHECK CONSTRAINT [FK__dbo_ImportBatchQueue__ImportQueueID]
GO


PRINT N'Adding foreign keys to [active].[Claim]'
GO
ALTER TABLE [dbo].[Claim]  WITH NOCHECK ADD  CONSTRAINT [FK__dbo_Claim__ClaimContactID] FOREIGN KEY([ClaimContactID])
REFERENCES [dbo].[ClaimContact] ([ClaimContactID])
GO

ALTER TABLE [dbo].[Claim] CHECK CONSTRAINT [FK__dbo_Claim__ClaimContactID]
GO


PRINT N'Adding foreign keys to [active].[ClaimContact]'
GO
ALTER TABLE [dbo].[ClaimContact]  WITH NOCHECK ADD  CONSTRAINT [FK__dbo_ClaimContact__CaseID] FOREIGN KEY([CaseID])
REFERENCES [dbo].[Case] ([CaseID])
GO

ALTER TABLE [dbo].[ClaimContact] CHECK CONSTRAINT [FK__dbo_ClaimContact__CaseID]
GO


PRINT N'Adding foreign keys to [active].[ClaimTransaction]'
GO
ALTER TABLE [dbo].[ClaimTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK__dbo_ClaimTransaction__ClaimID] FOREIGN KEY([ClaimID])
REFERENCES [dbo].[Claim] ([ClaimID])
GO

ALTER TABLE [dbo].[ClaimTransaction] CHECK CONSTRAINT [FK__dbo_ClaimTransaction__ClaimID]
GO

ALTER TABLE [dbo].[ClaimTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK__dbo_ClaimTransaction__SecurityTypeID] FOREIGN KEY([SecurityTypeID])
REFERENCES [dbo].[lk_SecurityType] ([SecurityTypeID])
GO

ALTER TABLE [dbo].[ClaimTransaction] CHECK CONSTRAINT [FK__dbo_ClaimTransaction__SecurityTypeID]
GO

ALTER TABLE [dbo].[ClaimTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK__dbo_ClaimTransaction__TransactionTypeID] FOREIGN KEY([TransactionTypeID])
REFERENCES [dbo].[lk_TransactionType] ([TransactionTypeID])
GO

ALTER TABLE [dbo].[ClaimTransaction] CHECK CONSTRAINT [FK__dbo_ClaimTransaction__TransactionTypeID]
GO




PRINT N'Adding foreign keys to [active].[ImportLog]'
GO
ALTER TABLE [dbo].[ImportLog]  WITH NOCHECK ADD  CONSTRAINT [FK__dbo_ImportLog__ImportStatusID] FOREIGN KEY([ImportStatusID])
REFERENCES [dbo].[lk_ImportStatus] ([ImportStatusID])
GO

ALTER TABLE [dbo].[ImportLog] CHECK CONSTRAINT [FK__dbo_ImportLog__ImportStatusID]
GO



