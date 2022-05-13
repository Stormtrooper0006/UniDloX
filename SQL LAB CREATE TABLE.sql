CREATE DATABASE UniDloX

USE UniDloX

CREATE TABLE Staff(
	Staff_ID CHAR(5) CHECK(Staff_ID LIKE 'SF[0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	Staff_Name VARCHAR(255) NOT NULL,
	Staff_Phone_Number VARCHAR(255) NOT NULL,
	Staff_Address VARCHAR(255) CHECK(LEN(Staff_Address) BETWEEN 10 AND 15) NOT NULL,
	Staff_Age INT NOT NULL,
	Staff_Gender VARCHAR(20) CHECK(Staff_Gender IN ('Male', 'Female')) NOT NULL,
	Staff_Salary INT NOT NULL
)

CREATE TABLE Supplier(
		Supplier_ID CHAR(5) CHECK(Supplier_ID LIKE 'SU[0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
		Supplier_Name VARCHAR(255) CHECK(LEN(Supplier_Name) > 6) NOT NULL,
		Supplier_Phone_Number VARCHAR(20) NOT NULL,
		Supplier_Adress VARCHAR(255) NOT NULL
)

CREATE TABLE Customer(
	Customer_ID CHAR(5) CHECK(Customer_ID LIKE 'CU[0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	Customer_Name VARCHAR(255) NOT NULL,
	Customer_Phone_Number VARCHAR(20) NOT NULL,
	Customer_Address VARCHAR(255) NOT NULL,
	Customer_Gender VARCHAR(10) CHECK(Customer_Gender IN ('Male', 'Female')) NOT NULL,
	Customer_Email VARCHAR(255) CHECK(Customer_Email LIKE '%@gmail.com' OR Customer_Email LIKE '%@yahoo.com') NOT NULL,
	Customer_DOB DATE NOT NULL
)

CREATE TABLE Cloth(
	Cloth_ID CHAR(5) CHECK(Cloth_ID LIKE 'CL[0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	Cloth_Name VARCHAR(255) NOT NULL,
	Stock INT CHECK(Stock BETWEEN 0 AND 250) NOT NULL,
	Price INT NOT NULL
)

CREATE TABLE Payment_Type(
	Payment_Type_ID CHAR(5) CHECK(Payment_Type_ID LIKE 'PA[0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	Payment_Name VARCHAR(255) NOT NULL
)

CREATE TABLE Material(
	Material_ID CHAR(5) CHECK(Material_ID LIKE 'MA[0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	Supplier_ID CHAR(5) FOREIGN KEY REFERENCES Supplier(Supplier_ID),
	Material_Name VARCHAR(255) NOT NULL,
	Material_Price INT CHECK(Material_Price > 0) NOT NULL
)

CREATE TABLE Purchase_Transaction(
	Purchase_Transaction_ID CHAR(5) CHECK(Purchase_Transaction_ID LIKE 'PU[0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	Staff_ID CHAR(5) FOREIGN KEY REFERENCES Staff(Staff_ID),
	Payment_Type_ID CHAR(5) FOREIGN KEY REFERENCES Payment_Type(Payment_Type_ID),
	Transaction_Date DATE NOT NULL
)

CREATE TABLE Purchase_Detail(
	Purchase_Transaction_ID CHAR(5) FOREIGN KEY REFERENCES Purchase_Transaction(Purchase_Transaction_ID) NOT NULL,
	Material_ID CHAR(5) FOREIGN KEY REFERENCES Material(Material_ID),
	Quantity INT NOT NULL
)

CREATE TABLE Sales_Transaction(
	Sales_Transaction_ID CHAR(5) CHECK(Sales_Transaction_ID LIKE 'SA[0-9][0-9][0-9]') PRIMARY KEY NOT NULL,
	Staff_ID CHAR(5) FOREIGN KEY REFERENCES Staff(Staff_ID),
	Customer_ID CHAR(5) FOREIGN KEY REFERENCES Customer(Customer_ID),
	Transaction_Date DATE NOT NULL,
	Payment_Type_ID CHAR(5) FOREIGN KEY REFERENCES Payment_Type(Payment_Type_ID),
)

CREATE TABLE Sales_Detail(
	Sales_Transaction_ID CHAR(5) FOREIGN KEY REFERENCES Sales_Transaction(Sales_Transaction_ID),
	Cloth_ID CHAR(5) FOREIGN KEY REFERENCES Cloth(Cloth_ID),
	Quantity INT NOT NULL
)