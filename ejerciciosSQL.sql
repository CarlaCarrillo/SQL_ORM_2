use classicmodels;
SELECT lastname, firstname, jobtitle FROM employees;

SELECT lastname FROM employees ORDER BY lastname;

SELECT DISTINCT lastname FROM employees ORDER BY lastname;

SELECT state, city FROM customers;

SELECT DISTINCT state, city FROM customers;

/*para ubicar solo los estados*/
SELECT DISTINCT state FROM customers;

/*para ubicar solo la ciudad*/
SELECT DISTINCT city FROM customers;

/*Buscar registros que cumplan las condiciones  especificas*/
SELECT  * FROM employees where jobTitle='Sales Rep' AND officecode=1;
Select lastname, firstname, jobtitle from employees where jobtitle <> 'SalesRep';
Select lastname, firstname, officeCode from employees where officecode BETWEEN 2 AND 5;
/*que contenga esta cadena de texto*/
Select lastname, firstname, officeCode from employees where firstName LIKE 'An%';
/*valor este dentro del siguiente conjunto de datos*/
Select * from customers WHERE country IN ('USA', 'FRANCE');
/*Donde su valor sea NULL*/
Select * from customers WHERE salesRepEmployeeNumber IS NULL;

/*FILTERING DATA*/
/*Operador AND*/
SELECT customername, country, state, creditlimit FROM customers WHERE country ='USA' AND state= 'CA' AND creditLimit > 100000;
/*Operador OR*/
SELECT customername, country FROM customers WHERE country = 'USA' OR country = 'FRANCE';
/*Habrá que tener cuidado con los operadores, como con el OR, que hay que ponerlo en paréntesis para que primero
lo haga y después aplique el AND*/
SELECT customername, country, creditLimit FROM customers WHERE (country = 'USA' OR country = 'FRANCE')  AND creditLimit > 100000;
/*Alias */
SELECT CONCAT_WS(',',lastName, firstname) AS 'FULL name' FROM employees;
SELECT CONCAT_WS(' 'lastName, firstname) AS 'FULL name' FROM employees;
/*INNER JOIN busca en las dos tablas y usa alias (C.)*/
SELECT t1.id, t2.id FROM t1 INNER JOIN t2 ON t1.pattern = t2.pattern;
SELECT C.customername, E.lastname, E.firstname, E.officecode FROM customers C Inner JOIN employees E ON C.salesrepemployeenumber=E.employeenumber WHERE E.officeCode =2;
/*get customers from NY*/
SELECT customerName, contactLastName, Phone, country, city FROM customers WHERE city ='NYC';
SELECT customerName, contactLastName, Phone, country, city FROM customers WHERE country ='Australia';
/*Get customer with high credit */
SELECT * FROM customers ORDER BY creditLimit DESC;
/*Get customers from Australia with high credit*/
SELECT * FROM customers WHERE country='Australia' ORDER BY creditLimit DESC;
/*Get customers from NY with more credit*/
SELECT *, MAX(creditLimit) FROM customers WHERE city='NYC' OR country='Australia';
/*Get customers from Australia and NY with high credit*/
SELECT *, MAX(creditLimit) FROM customers WHERE city='NYC'
UNION
SELECT *, MAX(creditLimit) FROM customers WHERE country='Australia';
/*Get numero de Customers by country*/
SELECT country, count(*) FROM customers group by country;
/*Get country with more customers*/
SELECT country, count(*) AS num FROM customers group by country;
#Count all employees
SELECT count(*) FROM employees;
#Count employees by job title
SELECT jobtitle, count(*) FROM employees GROUP BY jobTitle;
#Order employees by Number
SELECT jobtitle, count(*) AS num FROM employees GROUP BY jobTitle ORDER BY num DESC;
#Get employees by office

SELECT E.employeeNumber, O.city FROM offices O Inner JOIN employees E ON E.officeCode=O.officeCode;
#Get employees reporter
SELECT e.firstname, e.lastname, e.reportsto  FROM employees AS e INNER JOIN employees f ON f.firstName=e.reportsto;
#Subqueries---consultas anidadas con otra consulta
SELECT * FROM orders WHERE customerNumber IN (SELECT customerNumber FROM customers WHERE country = 'USA');
#Exists no exists
SELECT customerNumber, customerName FROM customers WHERE exists(SELECT 1 FROM orders WHERE orders.customernumber = customers.customernumber);
SELECT customerNumber, customerName FROM customers WHERE NOT exists(SELECT 1 FROM orders WHERE orders.customernumber = customers.customernumber);
/*SET OPERATORS*/
#union ----- combina las dos tablas y la convierte en una
#minus ---- dice cual es el que existe de la t1 en la t2
#intersect ------ regresa los que tienen en común en la dos tablas
/*MODIFICANDO DATA*/
#INSERT ---regresa uno o mas registros a una tabla
SELECT * FROM productlines;
INSERT INTO productlines(productLine,textDescription) 
VALUES('plantas','plantas exóticas únicas en su especie');
#UPDATE
SELECT employeeNumber,lastName,email FROM employees where employeeNumber=1056;
UPDATE employees SET lastName = 'Hill', email='mary.hill@classicmodelcars.com' WHERE employeeNumber = 1056;
#DELETE
DELETE FROM productlines WHERE productLine = 'plantas'; 
/*Agregar funciones*/
SELECT AVG(buyPrice) average_buy_price FROM products;
#COUNT--numero de renglones que cumplen con la consulta
SELECT COUNT(*) AS Total FROM products;
#SUM -- regresa la suma de un conunto  de valores
SELECT SUM(buyPrice) average_buy_price FROM products;
SELECT productCode,sum(priceEach*quantityOrdered) total
FROM orderdetails GROUP BY productCode;
#MAX o MIN---valor máximo o mínimo en la columna
SELECT MAX(buyPrice) highest_price FROM products;
SELECT MIN(buyPrice) lowest_price FROM products;
SELECT productName,buyPrice FROM products WHERE buyPrice = (SELECT MAX(buyPrice) highest_price FROM products);

/*EJERCICIOS*/
#lista de oficinas ordenado por country, state y city
SELECT country,state,city FROM offices ORDER BY country,state,city;
#lista de productos que contienen cars
SELECT * FROM products;
Select * from products where productLine LIKE '%Cars';
#Reporta todos los pagos mayores de 100,000
SELECT * FROM payments;
SELECT * FROM payments where amount > 100000;
#Cual fue el mínimo pago recibido
SELECT MIN(amount) lowest_price FROM payments;
#Quienes son los empleados en Boston
SELECT * FROM offices;
SELECT E.lastname, E.firstname, E.officeCode FROM employees E Inner JOIN offices O ON E.officeCode=E.officeCode WHERE E.officeCode =2;
#Reporta el total de pagos para Atelier graphique
SELECT * FROM customers;
SELECT SUM(amount) sum_amount FROM payments WHERE customerNumber=103;
#Lista los empleados que se llaman LARRY o Barry
SELECT firstName FROM employees WHERE firstName=Larry;


/*EJERCICIOS TEMA VIEW*/
CREATE VIEW customerorder AS SELECT d.ordernumber, customername, SUM(quantityordered*priceEach) total 
FROM orderdetails d INNER JOIN orders o ON o.orderNumber = d.orderNumber INNER JOIN
customers c ON c.customerNumber = c.customerNumber GROUP BY d.orderNumber ORDER BY total DESC;
Select * FROM customerorder where total>100000;

#TRIGGERS
CREATE TABLE employees_audit (
id INT auto_increment PRIMARY KEY,
employeenumber INT NOT NULL,
lastname VARCHAR(50) NOT NULL,
changedat DATETIME DEFAULT NULL,
action VARCHAR(50) DEFAULT NULL
);

DELIMITER $$
CREATE TRIGGER before_employee_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
INSERT INTO employees_audit
SET action='update',
employeenumber = OLD.employeenumber,
lastname = OLD.lastname,
changedat = NOW();
END$$
DELIMITER ;

UPDATE employees
SET
lastname = 'Phan'
WHERE
employeenumber = 1056;

SELECT * FROM employees_audit;
#para regresar el valor que ya tenía
UPDATE employees
SET
lastname = 'Hill'
WHERE
employeenumber = 1056;
SELECT * FROM employees_audit;

/*STORE PROCEDURES*/
DELIMITER //
CREATE PROCEDURE GetAllProducts()
BEGIN
SELECT*FROM products;
END//
DELIMITER ;
#Y luego corremos
CALL GetAllProducts();

DELIMITER //
CREATE PROCEDURE TestVariables()
BEGIN
DECLARE total_count INT DEFAULT 0;
SELECT 
COUNT(*)into total_count
FROM products;
SELECT total_count;
END//
DELIMITER ;

CALL TestVariables();

DELIMITER //
CREATE PROCEDURE getOfficeByCountry(IN countryName VARCHAR(255))
BEGIN
SELECT * 
FROM offices
WHERE country = countryName;
END//
DELIMITER ;
#ejemplo de llamda
CALL GetOfficeByCountry('USA');
CALL GetOfficeByCountry('FRANCE');

/*STORE PROCEDURES PARAMETERS*/
DELIMITER $$
CREATE PROCEDURE CountOrderByStatus(
IN orderStatus VARCHAR(25),
OUT total INT)
BEGIN
SELECT COUNT(orderNumber)
INTO total
FROM orders
WHERE status = orderStatus;
END$$
DELIMITER ;
#ejemplo de llamda
CALL CountOrderByStatus('Shipped',@total);
SELECT @total;
SELECT @total*2;

DELIMITER $$
CREATE PROCEDURE set_counter(INOUT count INT(4),IN inc INT(4))
BEGIN
SET count=count+inc;
END$$
DELIMITER ;

SET @COUNTER = 1;
CALL set_counter(@counter,1); -- 2
CALL set_counter(@counter,1); -- 3
CALL set_counter(@counter,5); -- 8
SELECT @counter; -- 8

/*FUNCTIONS CONTROL DE FLUJO CASE*/
SELECT
SUM(CASE
WHEN status = 'Shipped' THEN 1
ELSE 0
END) AS 'Shipped',
SUM(CASE
WHEN status = 'On Hold' THEN 1
ELSE 0
END) AS 'On Hold',
COUNT(*) AS Total
FROM
orders;

/*FUNCTIONS CONTROL DE FLUJO CASE - IF*/
SELECT SUM(IF(status='Shipped',1,0)) FROM orders
WHERE orderDate BETWEEN '2003-06-01' and '2003-06-30';

/*Functions - Comparison- GREATEST and LEAST*/
CREATE TABLE IF NOT EXISTS revenues (
	company_id INT PRIMARY KEY,
    q1 DECIMAL(19, 2),
    q2 DECIMAL(19, 2),
    q3 DECIMAL(19, 2),
    q4 DECIMAL(19, 2)
);
INSERT INTO revenues(company_id,q1,q2,q3,q4)
VALUES (1,100,120,110,130),
(2,250,260,300,310);

SELECT 
	company_id,
    LEAST(q1, q2, q3, q4) low,
    GREATEST(q1, q2, q3, q4) high
FROM
	revenues;
    SELECT * FROM revenues;
