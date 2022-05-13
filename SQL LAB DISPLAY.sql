USE UniDloX

SELECT * FROM Purchase_Detail

-- 1. Display StaffID, StaffName, StaffAddress, SupplierName, Total Purchases (obtained from the total number of purchase) 
-- for every purchase which occurs in November and handled by Staff whose the last character of StaffID is an even number.

SELECT 
	s.Staff_ID, 
	Staff_Name, 
	Staff_Address,
	Supplier_Name,
	COUNT(pt.Purchase_Transaction_ID) AS Total_Purchases
FROM Staff s 
	JOIN Purchase_Transaction pt 
		ON s.Staff_ID = pt.Staff_ID
	JOIN Purchase_Detail pd 
		ON pt.Purchase_Transaction_ID = pd.Purchase_Transaction_ID
	JOIN Material m 
		ON pd.Material_ID = m.Material_ID
	JOIN Supplier sp 
		ON m.Supplier_ID = sp.Supplier_ID
WHERE MONTH(Transaction_Date) = 11 AND RIGHT(s.Staff_ID, 2) % 2 = 0
GROUP BY s.Staff_ID, Staff_Name, Staff_Address, Supplier_Name


-- 2. Display SalesID, CustomerName, Total Sales Price (obtained from sum of the cloth price and quantity) 
-- for every sales transaction whose CustomerName contains “m” and the total sales price is greater than 2000000.

SELECT
	st.Sales_Transaction_ID,
	Customer_Name,
	SUM(Price * Quantity) AS Total_Sales_Price
FROM Customer c
	JOIN Sales_Transaction st
		ON c.Customer_ID = st.Customer_ID
	JOIN Sales_Detail sd
		ON st.Sales_Transaction_ID = sd.Sales_Transaction_ID
	JOIN Cloth cl
		ON sd.Cloth_ID = cl.Cloth_ID
WHERE Customer_Name LIKE '%m%' 
GROUP BY st.Sales_Transaction_ID, Customer_Name
HAVING SUM(Price * Quantity) > 2000000

-- 3. Display Month (obtained from month name), Transaction Count (obtained from the total number of purchases),
-- and Material Sold Count (obtained from the sum of quantity) 
-- for every purchase that is managed by staff whose StaffAge between 25 and 30 
-- and the material sold price is more than 150000.

SELECT
	DATENAME(MONTH, pt.Transaction_Date) AS Month_Name,
	COUNT(Purchase_Transaction_ID) AS Transaction_Count,
	SUM(Quantity) AS Material_Sold_Count
FROM Purchase_Transaction pt
	JOIN Staff s
		ON pt.Staff_ID = s.Staff_ID
	JOIN Sales_Transaction st
		ON s.Staff_ID = st.Staff_ID
	JOIN Sales_Detail sd
		ON st.Sales_Transaction_ID = sd.Sales_Transaction_ID
	JOIN Cloth cl
		ON sd.Cloth_ID = cl.Cloth_ID
WHERE s.Staff_Age BETWEEN 25 AND 30 AND Price > 150000
GROUP BY pt.Transaction_Date


-- 4. Display CustomerName (obtained from customer name in lowercase format), CustomerEmail, CustomerAddress,
-- Cloth Bought Count (Obtained from the total number of cloths bought), 
-- and Total Price (obtained by adding “IDR ” in front of the sum of quantity and cloth price) 
-- for every transaction which payment using “Cryptocurrency”, “Cash”, or “Shopee-Pay”.

SELECT * FROM Sales_Transaction
SELECT * FROM Payment_Type

SELECT
	LOWER(Customer_Name) AS Customer_Name,
	Customer_Email,
	Customer_Address,
	COUNT(Quantity) AS Cloth_Bought_Count,
	Total_Price = 'IDR ' + CONVERT(VARCHAR, SUM(Quantity * Price))
FROM Customer c
	JOIN Sales_Transaction st
		ON c.Customer_ID = st.Customer_ID
	JOIN Payment_Type pt
		ON st.Payment_Type_ID = pt.Payment_Type_ID
	JOIN Sales_Detail sd
		ON st.Sales_Transaction_ID = sd.Sales_Transaction_ID
	JOIN Cloth cl
		ON sd.Cloth_ID = cl.Cloth_ID
WHERE Payment_Name = 'Cash' OR Payment_Name = 'Cryptocurrency' OR Payment_Name = 'Shopee-Pay'
GROUP BY Customer_Name, Customer_Email, Customer_Address



-- 5. Display PurchaseID (obtained from the last 3 characters of the PurchaseID), PurchaseDate, StaffName, 
-- and PaymentTypeName for every transaction which served by staff whose gender is female and 
-- salary is greater than the average salary of every staff who was born before 1996. (alias subquery)

SELECT * FROM Staff

SELECT 		
	RIGHT(Purchase_Transaction_ID, 3) AS Purchase_ID,
	Transaction_Date,
	Staff_Name,
	Payment_Name
FROM Purchase_Transaction pt
	JOIN Staff s
		ON pt.Staff_ID = s.Staff_ID
	JOIN Payment_Type pay
		ON pt.Payment_Type_ID = pay.Payment_Type_ID,
		(
			SELECT 
				AVG(Staff_Salary) AS AverageSalary,
				Staff_Gender,
				Staff_Age
			FROM Staff
			WHERE Staff_Age >= 26
			GROUP BY Staff_Gender, Staff_Age
		) AS SubQuery
WHERE Staff_Salary > SubQuery.AverageSalary AND s.Staff_Gender = 'Female'


-- 6. Display SalesID, SalesDate (obtained from SalesDate with “Mon dd, yyyy” format), CustomerName, CustomerGender 
-- for every transaction which occurred in 2021 
-- and quantity is lower than the minimum quantity of all transaction that occurred on the 15th day of the month. (alias subquery)

SELECT * FROM Sales_Transaction
SELECT * FROM Purchase_Transaction

SELECT
	Sales_Transaction_ID,
	CONVERT(VARCHAR, st.Transaction_Date, 101) AS SalesDate,
	Customer_Name,
	Customer_Gender
FROM Sales_Transaction st
	JOIN Customer c
		ON st.Customer_ID = c.Customer_ID,
	(
		SELECT
			Transaction_Date,
			MIN(Quantity) AS MinimumQuantity
		FROM Sales_Transaction st
			JOIN Sales_Detail sd
				ON st.Sales_Transaction_ID = sd.Sales_Transaction_ID
		WHERE YEAR(Transaction_Date) = 2021 AND Transaction_Date LIKE '%-%-15' 
		GROUP BY Transaction_Date, Quantity
		HAVING Quantity < MIN(Quantity)
	) AS SubQuery


-- 7. Display PurchaseID, SupplierName, SupplierPhone (obtained by replacing SupplierPhone first character into ‘+62’), 
-- PurchaseDate (obtained from the weekday of the PurchaseDate), 
-- Quantity for every transaction which occurred on Friday until Sunday and quantity is 
-- greater than average of total quantity (obtained from sum of the quantity) for every purchase. (alias subquery)

SELECT * FROM SUPPLIER

SELECT 
	pt.Purchase_Transaction_ID,
	Supplier_Name,
	Supplier_Phone_Number,
	DATENAME(dw, pt.Transaction_Date) AS PurchaseDate,
	Quantity

FROM Purchase_Transaction pt

	JOIN Purchase_Detail pd
		ON pt.Purchase_Transaction_ID = pd.Purchase_Transaction_ID
	JOIN Material m
		ON pd.Material_ID = m.Material_ID
	JOIN Supplier sp
		ON m.Supplier_ID = sp.Supplier_ID,
	(	
		SELECT
			pt.Transaction_Date,
			SUM(Quantity) AS SumQuantity 

		FROM Purchase_Transaction pt

			JOIN Purchase_Detail pd
				ON pt.Purchase_Transaction_ID = pd.Purchase_Transaction_ID
		GROUP BY pt.Transaction_Date
	) AS SubQuery2

WHERE DATENAME(dw, pt.Transaction_Date) = 'Friday' OR DATENAME(dw, pt.Transaction_Date) = 'Saturday' OR DATENAME(dw, pt.Transaction_Date) = 'Sunday'
GROUP BY pt.Purchase_Transaction_ID, Supplier_Name, Supplier_Phone_Number, pt.Transaction_Date, Quantity
HAVING Quantity > AVG(SubQuery2.SumQuantity) 

 
-- 8. Display CustomerName (obtained by adding “Mr. ” in front of the CustomerName 
-- if CustomerGender is Male or “Mrs. ” if CustomerGender is female), CustomerPhone, CustomerAddress, 
-- CustomerDOB (obtained from SalesDate with “dd/mm/yyy” format), 
-- and Cloth Count (obtained from the total number of cloths bought) 
-- for every customer which has the highest total number of cloth bought and CustomerName contains “o”. (alias subquery)

SELECT * FROM Customer

SELECT 
	CASE WHEN Customer_Gender = 'Male' THEN 'Mr. ' + c.Customer_Name WHEN Customer_Gender = 'Female' THEN 'Mrs. ' + c.Customer_Name END AS CustomerName ,
	Customer_Phone_Number,
	Customer_Address,
	Customer_DOB = CONVERT(VARCHAR, Customer_DOB, 103),
	COUNT(sd.Cloth_ID) AS ClothCount

FROM Customer c

	JOIN Sales_Transaction st
		ON c.Customer_ID = st.Customer_ID
	JOIN Sales_Detail sd
		ON st.Sales_Transaction_ID = sd.Sales_Transaction_ID,
	(	
		SELECT
			c.Customer_Name,
			MAX(Quantity) AS HighestQuantity 

		FROM Customer c

			JOIN Sales_Transaction st
				ON c.Customer_ID = st.Customer_ID
			JOIN Sales_Detail sd
				ON st.Sales_Transaction_ID = sd.Sales_Transaction_ID

		GROUP BY c.Customer_Name
		
	) AS SubQuery3

WHERE c.Customer_Name LIKE '%o%'
GROUP BY c.Customer_Name, Customer_Phone_Number, Customer_Address, Customer_DOB, Customer_Gender




-- 9. Create a view named “ViewCustomerTransaction” to display CustomerID, CustomerName, CustomerEmail, CustomerDOB, 
-- Minimum Quantity (obtained from the minimum quantity purchased), 
-- Maximum Quantity (obtained from the maximum quantity purchased) 
-- for every customer whose born in 2000 and later and has an email domain “@yahoo.com”

GO
CREATE VIEW ViewCustomerTransaction
	AS
		SELECT
			c.Customer_ID,
			Customer_Name,
			Customer_Email,
			Customer_DOB,
			MIN(Quantity) AS Minimum_Quantity,
			MAX(Quantity) AS Maximum_Quantity
		FROM Customer c
			JOIN Sales_Transaction st
				ON c.Customer_ID = st.Customer_ID
			JOIN Sales_Detail sd
				ON st.Sales_Transaction_ID = sd.Sales_Transaction_ID
		WHERE YEAR(Customer_DOB) >= 2000 AND Customer_Email LIKE '%@yahoo.com'
		GROUP BY c.Customer_ID, Customer_Name, Customer_Email, Customer_DOB

SELECT * FROM ViewCustomerTransaction
DROP VIEW ViewCustomerTransaction


-- 10. Create a view named “ViewFemaleStaffTransaction” to view StaffID, StaffName (obtained by uppercasing StaffName), 
-- StaffSalary (obtained by adding “Rp. ” in front of the StaffSalary and ends with “,00”), 
-- Material Bought Count (obtained from count of the material bought and ends with “ Pc(s)”) 
-- for every staff whose gender is female and salary is greater than average of all staff salaries.

SELECT AVG(Staff_Salary) FROM Staff
SELECT * FROM Staff
GO
CREATE VIEW ViewFemaleStaffTransaction
	AS
		SELECT
			s.Staff_ID,
			UPPER(Staff_Name) AS StaffName,
			Staff_Salary = 'Rp. ' + CONVERT(VARCHAR, Staff_Salary) + ',00',
			Material_Bought_Count = COUNT(CONVERT(VARCHAR(10),(m.Material_ID) + 'Pc(s)')) 
		FROM Staff s
			JOIN Purchase_Transaction pt
				ON s.Staff_ID = pt.Staff_ID
			JOIN Purchase_Detail pd
				ON pt.Purchase_Transaction_ID = pd.Purchase_Transaction_ID
			JOIN Material m
				ON pd.Material_ID = m.Material_ID
		WHERE Staff_Gender = 'Female'
		GROUP BY s.Staff_ID, Staff_Name, Staff_Salary, m.Material_ID
		HAVING Staff_Salary > AVG(Staff_Salary)

SELECT * FROM ViewFemaleStaffTransaction
DROP VIEW ViewFemaleStaffTransaction



