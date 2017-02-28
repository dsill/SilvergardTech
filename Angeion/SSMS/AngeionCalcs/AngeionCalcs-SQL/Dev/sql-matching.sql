with s as ( select  *
            ,       SoldUpToNow = ( select  sum(OrderQty) 
                                    from    SalesOrder
                                    where   ProductId = s.ProductId 
                                    and     OrderDate <= s.OrderDate)
            from    SalesOrder s)

,    p as ( select ProductId
            ,      sum(OrderQty) as TotalProduced
            from   ProductionOrder
            group by ProductId)


select  *
from    (   select  s.*
            ,       p.TotalProduced
            ,       case    when s.SoldUpToNow - isnull(p.TotalProduced,0) < 0 then 0
                            when (s.SoldUpToNow - isnull(p.TotalProduced,0) ) > s.OrderQty then s.OrderQty
                            else s.SoldUpToNow - isnull(p.TotalProduced,0)
                    end as LeftQty
            from s
            left join p on s.ProductId = p.ProductId) fifo
where   LeftQty > 0

select  a.[TransactionID]
,       b.[TransactionTypeName]
from    [dbo].[ClaimTransaction] a
        inner join [dbo].[lk_TransactionType] b on a.[TransactionTypeID] = b.[TransactionTypeID]



select * from [dbo].[lk_TransactionType]