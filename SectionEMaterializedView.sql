DECLARE @columns AS NVARCHAR(MAX)
DECLARE @query AS NVARCHAR(MAX)

select @columns = STUFF(
			(SELECT distinct ',' + QUOTENAME(c.CalendarYear)
				from (select [ProductDescription], [CalendarYear], sum([SalesAmount]) as sales_amount from [dbo].[FactSalesOrders] fa
						inner join [dbo].[DimProduct] p on fa.[ProductKey] = p.[ProductKey] 
						inner join [dbo].[DimDate] d on fa.[OrderDateKey] = d.[DateKey]
						group by [CalendarYear], [ProductDescription]
						) as c
			FOR XML PATH(''), TYPE
			).value('.', 'NVARCHAR(MAX)'),1,1,'')

set @query = 'CREATE VIEW mv_view1 
			WITH SCHEMABINDING
			AS 
				SELECT [ProductDescription] as Product,' + @columns + ' from 
             (	select [ProductDescription], [CalendarYear], sum([SalesAmount]) as sales_amount from [dbo].[FactSalesOrders] fa
				inner join [dbo].[DimProduct] p on fa.[ProductKey] = p.[ProductKey] 
				inner join [dbo].[DimDate] d on fa.[OrderDateKey] = d.[DateKey]
				group by [CalendarYear], [ProductDescription]  
            ) x
            pivot 
            (
                min(sales_amount)
                for CalendarYear in (' + @columns + ')
            ) p'

execute(@query)

CREATE UNIQUE CLUSTERED INDEX IDX_V1 ON mv_view1(Product); 





 