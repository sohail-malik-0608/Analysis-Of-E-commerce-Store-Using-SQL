-- What is the total revenue generated over the entire period?

Select Sum(OD.quantity * p.price) AS Total_Revenue
From orderdetails OD
Join Products P on p.productid=od.productid;

-- Revenue Excluding Returned Orders

Select Sum(OD.quantity * p.price) AS Revenue_excluding_return
from orders O
Join Orderdetails OD ON OD.OrderId=O.orderId
Join Products P ON P.productId=OD.productId
Where Isreturned= False;

-- Total Revenue per Year / Month

	Select year(orderdate)AS `Year`,Month(orderdate)As `Month`, Sum(OD.quantity * p.price) AS Total_Revenue
	From Orders O
	Join Orderdetails OD ON OD.OrderId=O.orderId
	Join Products P ON P.productId=OD.productId
	Group By `Year`,`Month`
	Order By `Year`,`Month`;

-- Revenue by Product / Category

Select Productname, Category, Sum(OD.quantity * p.price) AS Product_Revenue
From Orderdetails OD
Join Products P On P.ProductId=OD.ProductId
Group By Productname, Category
Order By Productname, Category Desc;

-- What is the average order value (AOV) across all orders?	
Select Avg(totalordervalue) AS AverageOrderValue
From ( Select o.orderid,Sum(OD.quantity * p.price) AS totalorderValue
       from Orders O
       Join Orderdetails OD ON OD.OrderId=O.orderId
	   Join Products P ON P.productId=OD.productId
       Group By orderid) T;
       
       -- AOV per Year / Month

       
        Select Year(orderdate) AS `Year`,Month(orderdate) As `Month`,Avg(totalordervalue) AS AverageOrderValue
From ( Select o.orderid,orderdate,Sum(OD.quantity * p.price) AS totalorderValue
       from Orders O
       Join Orderdetails OD ON OD.OrderId=O.orderId
	   Join Products P ON P.productId=OD.productId
       Group By orderid) T
       Group By `year`,`month`
       Order By `year`,`month`;
       
   --    What is the average order size by region?
   
   Select RegionName,Avg(total_order_size) AS Average_order_size
   From ( Select O.OrderId,C.regionid, Sum(OD.Quantity) AS total_order_size
          From Orders O
          Join Customers C ON C.CustomerId=O.CustomerID
          Join Orderdetails OD ON OD.Orderid=O.OrderId
          Group By OrderId,C.RegionID) AS OrderSizes
	Join Regions R On R.RegionID=Ordersizes.RegionID
    Group By Regionname
    Order By Average_order_size Desc;
    
    -- Customer Insights
    
   -- Who are the top 10 customers by total revenue spent?
   
   Select C.CustomerId,CustomerName, Sum(OD.Quantity * P.Price) AS Total_Revenue
   From Customers C
   Join Orders O On O.CustomerId=C.CustomerId
   Join orderdetails OD ON OD.orderid=O.orderID
   Join Products P ON P.productID=OD.productID
   Group By C.CustomerId, CustomerName
   Order BY Total_Revenue Desc
   Limit 10;
   
  -- What is the repeat customer rate?
  
  Select Round(Count(Distinct Case When OrderCount > 1 Then CustomerID END)/ Count(distinct CustomerID),2) AS Repeat_Customer_Rate
  From ( Select CustomerID, Count(orderID) AS Ordercount
        From Orders
        Group By CustomerID) AS T;
        
-- What is the average time between two consecutive orders for the same customer Region-wise?

With CustomerOrders AS (
            Select C.CustomerID,R.RegionName,O.orderdate,
            Lag(O.orderdate) Over (partition By C.CustomerID Order By Orderdate) AS PreviousOrderDate
            From Customers C
            Join Orders O On O.customerId=C.customerId
            Join Regions R on R.regionId=C.regionid)
            
		Select RegionName, Avg(datediff(OrderDate,PreviousOrderdate))AS Average_Days_Between_Orders
        From CustomerOrders
        Where PreviousOrderdate is NOT NULL
        Group By RegionName
        Order By Average_Days_Between_Orders ASC;
        
--  Customer Segment (based on total spend)

Select C.CustomerId,CustomerName, Sum(OD.Quantity*P.Price)AS TotalSpend,
Case
    When Sum(OD.Quantity*P.Price) > 1500 Then 'Platinium'
    When Sum(OD.Quantity*P.Price) Between 1000 and 1500 Then 'Gold'
    When Sum(OD.Quantity*P.Price) Between 500 and 999 Then 'Silver'
    Else 'Bronze'
    END AS Customer_segment
    From Customers C
    Join Orders O ON O.customerid=c.customerid
    Join Orderdetails OD ON Od.orderid=o.orderid
    Join Products P On P.productid=od.productid
    Group BY CustomerId, Customername;
    
    -- What is the customer lifetime value (CLV)
    
    Select C.CustomerId, C.CustomerName, Sum(OD.Quantity*P.price)AS CLV
    From Customers C
    Join Orders O On O.customerid=c.customerid
    Join Orderdetails OD ON OD.orderid=o.orderid
    Join Products P ON P.productid=od.productid
    Group By C.CustomerId,C.CustomerName
    Order By ClV Desc;
    
    --      Product & Order Insights
    
    -- What are the top 10 most sold products (by quantity)?

Select P.ProductId,P.Productname, Sum(OD.Quantity)AS TotalQuantity
From Orderdetails OD
Join Products P On P.Productid=OD.Productid
Group By ProductId,Productname
Order By TotalQuantity Desc
Limit 10;

--  What are the top 10 most sold products (by revenue)?

Select P.ProductId,P.Productname, Sum(OD.Quantity*p.price)AS TotalRevenue
From Orderdetails OD
Join Products P On P.Productid=OD.Productid
Group By ProductId,Productname
Order By TotalRevenue Desc
Limit 10;

--- Which products have the highest return rate?

With SOLD AS(
        Select ProductID,Sum(Quantity) AS total_Quantity
        From Orderdetails
        Group By ProductID
        ),
Returned AS( Select productID,Sum(Quantity) AS Total_Returned
            From Orderdetails OD
            Join Orders O On O.orderid=Od.orderid
            Where Isreturned= 1
            Group BY ProductID
            )
Select ProductName, Round((Total_Returned/Total_Quantity),2) AS ReturnRate
         From Products P 
         Join Sold S On S.productId=P.productid
         Join Returned R on R.Productid=p.productid
         Order By ReturnRate Desc
         Limit 10;

--  What is the average price of products per region?

Select RegionName, Round(Sum(OD.Quantity*P.price)/Sum(OD.Quantity),2) AS Averageprice
From Orders O 
Join Customers C ON C.customerId=O.Customerid
Join Regions R On R.regionid=C.regionid
Join Orderdetails OD on OD.orderid=O.orderid
Join Products P On P.productid=od.productID
Group By RegionName
Order By Averageprice Desc;

-- What is the sales trend for each product category?

Select Date_format(orderdate,"%Y-%m")AS Period , Category,Sum(OD.Quantity*P.price) AS Revenue
From Orders O
Join Orderdetails OD ON Od.Orderid=O.orderid
Join Products P On P.productid=Od.productid
Group BY period, Category
Order BY Period, Category , Revenue Desc;



-- Temporal Trends
-- What are the monthly sales trends over the past year?

Select Year(Orderdate)AS `Year`,Month(orderdate)AS `Month`,Sum(OD.Quantity*P.Price) AS Revenue
From Orders O
Join Orderdetails OD on OD.orderId=O.OrderId
Join Products P on P.productId=OD.productID
Where Orderdate >= current_date()- Interval 12 Month
Group By `Year`,`Month`
Order By `Year`,`Month`;

-- How does the average order value (AOV) change by month or week?

Select Date_format(Orderdate,"%Y-%m")AS Period,ROUND(Sum(OD.Quantity*P.Price)/Count(distinct O.OrderId),2) AS AOV
From Orders O
Join Orderdetails OD on OD.orderId=O.OrderId
Join Products P on P.productId=OD.productID
Group By Period 
Order By Period;

-- Regional Insights
-- Which regions have the highest order volume and which have the lowest?

Select RegionName, Count(orderId) As OrderVolume
From Orders O
Join Customers C On C.CustomerId=O.CustomerId
Join Regions R ON R.regionId=C.RegionId
Group By RegionName
Order By ordervolume Desc;

-- What is the revenue per region and how does it compare across different regions?

Select RegionName, Sum(OD.Quantity*p.price)AS TotalRevenue
From Orders O
Join Customers C On C.CustomerId=O.CustomerId
Join Regions R ON R.regionId=C.RegionId
Join Orderdetails OD ON OD.orderId=O.OrderId
Join Products P On P.productid=Od.productId
Group By RegionName
Order By TotalRevenue Desc;

-- Return & Refund Insights
-- What is the overall return rate by product category?

Select Category,
Round(Sum(Case When Isreturned=1 Then 1 Else 0 End)/count(O.orderId),2) AS ReturnRate
From Orders O
Join Orderdetails OD ON OD.orderId=O.OrderId
Join Products P On P.productid=Od.productId
group by Category
order By ReturnRate Desc;

-- What is the overall return rate by region?

Select RegionName,
Round(Sum(Case When Isreturned=1 Then 1 Else 0 End)/count(O.orderId),2) AS ReturnRate
From Orders O
Join Customers C  ON C.CustomerId=O.customerId
Join Regions R On R.RegionID=C.RegionID
group by RegionName
order By ReturnRate Desc;


-- Which customers are making frequent returns?

Select C.CustomerId, CustomerName, Count(O.OrderId) AS ReturnCount
From Orders O
Join Customers C on C.CustomerId=O.customerId
Where IsReturned=1
group By C.CustomerId, CustomerName
Order By ReturnCount Desc
Limit 10;