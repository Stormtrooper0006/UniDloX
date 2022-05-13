USE UniDloX

INSERT INTO Payment_Type VALUES 
('PA001', 'Debit Card')

INSERT INTO Staff VALUES
('SF001', 'Clara', '+628468123484', 'Jalan Pudidi', 24, 'Female', 57921347)

INSERT INTO Supplier VALUES
('SU001', 'Tobey Maguire', '+628324184431', 'Jalan Melati')

INSERT INTO Customer VALUES
('CU001', 'Zahra', '+628115489437', 'Jalan Mawar', 'Female', 'Zahra@yahoo.com','2001-10-16')

INSERT INTO Cloth VALUES
('CL001', 'cloth_Tech', 203, 124000)

INSERT INTO Material VALUES
('MA001', 'SU001', 'Kapuk', 150000)

INSERT INTO Purchase_Transaction VALUES
('PU001', 'SF001', 'PA001', '2021-02-01')

INSERT INTO Purchase_Detail VALUES
('PU001', 'MA001', 1)

INSERT INTO Sales_Transaction VALUES
('SA001', 'SF001', 'CU001', '2021-05-01', 'PA001')

INSERT Sales_Detail VALUES
('SA001','CL001',1)


SELECT * FROM Payment_Type
SELECT * FROM Staff
SELECT * FROM Supplier
SELECT * FROM Customer
SELECT * FROM Cloth
SELECT * FROM Material
SELECT * FROM Purchase_Transaction
SELECT * FROM Purchase_Detail
SELECT * FROM Sales_Transaction
SELECT * FROM Sales_Detail


UPDATE Cloth
SET Stock = Stock - 1
WHERE Cloth_ID = 'CL001'


-- perubahan data setelah transaksi
SELECT * FROM Cloth