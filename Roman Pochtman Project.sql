--------------------- Course :  DA041021	----------------------------
--------------------- Student name : Roman Pochtman 	----------------------------
--------------------- Phone : 0545912272		----------------------------


use adventureworks2014;
go


-- Exercise 1:

select pp.BusinessEntityID, pp.FirstName, pp.MiddleName, pp.LastName, hre.StartDate, hre.DepartmentID, hre.EndDate, hre.ModifiedDate
from Person.Person pp inner join HumanResources.EmployeeDepartmentHistory hre on pp.BusinessEntityID = hre.BusinessEntityID
where hre.EndDate is not null

go


-- Exercise 2:
select pp.BusinessEntityID, pp.FirstName, pp.MiddleName, pp.LastName, hre.StartDate, hre.DepartmentID, hre.EndDate, hre.ModifiedDate, hrd.GroupName, hrd.[Name]
from Person.Person pp inner join HumanResources.EmployeeDepartmentHistory hre on pp.BusinessEntityID = hre.BusinessEntityID
inner join HumanResources.Department hrd on hre.DepartmentID = hrd.DepartmentID

where hre.EndDate is not null
go

-- Exercise 3:
select top 1 pp.[Name], ppo.OrderQty
from Production.Product pp inner join Purchasing.PurchaseOrderDetail ppo on pp.ProductID = ppo.ProductID
order by ppo.OrderQty desc
go

-- Exercise 4:

select top 1 pp.[Name], sod.OrderQty
from Production.Product pp inner join Sales.SalesOrderDetail sod on pp.ProductID = sod.ProductID
order by sod.OrderQty desc

go

-- Exercise 5:


 SELECT  count(SalesOrderID) as ordernum, s.CustomerID , p.FirstName, p.LastName
       
 FROM Sales.Customer s
 left join  Person.Person p on s.CustomerID = p.BusinessEntityID
 left join Sales.SalesOrderHeader so on s.CustomerID = so.CustomerID 
 where SalesOrderID is null
 GROUP BY s.CustomerID ,p.FirstName, p.LastName
 order by s.CustomerID


-- Exercise 6:

 SELECT count(soh.SalesOrderID) as totalsales, p.ProductID, p.[Name]
       
 FROM Production.Product p left join Sales.SalesOrderDetail sod on p.ProductID = sod.ProductID
 left join Sales.SalesOrderHeader soh on sod.SalesOrderID = soh.SalesOrderID
 where soh.SalesOrderID is null
 group by  p.ProductID, p.[Name]

go

-- Exercise 7:

--stage 1


select sum(orderqty * unitprice) as totalsales, SalesOrderID
into #totalsalesamount
from Sales.SalesOrderDetail
group by SalesOrderID

--
-- stage 2


select  totalsales, sh.SalesOrderID, year(sh.orderdate) *100 + month(sh.orderdate) as ordermonth_year
into #totalsalesamountwithorderdate2
from (select * from #totalsalesamount ) as t inner join Sales.SalesOrderHeader sh on t.SalesOrderID = sh.SalesOrderID 
order by totalsales desc 

--
-- stage 3


select *
from (select ROW_NUMBER() over (partition by ordermonth_year order by totalsales desc) as sales_rank, 
             ordermonth_year, SalesOrderID, totalsales
from #totalsalesamountwithorderdate2
 ) ranks
 where sales_rank <=3
 


-- Exercise 8:


select soh.SalesPersonID, t.SalesOrderID, t.totalsales, year(soh.orderdate) *100 + month(soh.orderdate) as ordermonth_year
into #salesperperson2
from Sales.SalesPerson sp left join Sales.SalesOrderHeader soh on soh.SalesPersonID = sp.BusinessEntityID
left join #totalsalesamount t on t.SalesOrderID = soh.SalesOrderID

order by soh.SalesPersonID, totalsales desc

--step 2

select count(salesorderid) as countsales, ordermonth_year, SalesPersonID
from #salesperperson2
group by ordermonth_year, SalesPersonID
order by SalesPersonID, ordermonth_year





-- Exercise 9: 


select count(sp.totalsales) as totalsales,
       sum(sp.totalsales) as sumofsales,
	 
	   sp.SalesPersonID, sp.ordermonth_year, pp.FirstName, pp.LastName
from #salesperperson2 sp left join Person.Person pp on sp.SalesPersonID = pp.BusinessEntityID
group by sp.SalesPersonID, sp.ordermonth_year , pp.FirstName, pp.LastName
order by sp.SalesPersonID, sp.ordermonth_year 

-- Exercise 10:

 

go

-- Exercise 11:

go

-- Example of a working call to the procedure with a valid Sales Person ID:

go

-- Example of a working call to the procedure with no Sales Person ID:

go

-- Example of a failed call to the function using invalid input:

go