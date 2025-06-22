-- Step 1: Creating the Tables
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10, 2)
);


-- Step 2: Inserting Sample Data
INSERT INTO Employee (EmployeeID, EmployeeName, Salary) VALUES
(1, 'Roshini', 83000.00),
(2, 'Eleven', 78000.00),
(3, 'Ayan', 70000.00),
(4, 'Joey', 92000.00),
(5, 'Smith', 66000.00),
(6, 'Patrik', 68000.00),
(7, 'Klassen', 75000.00),
(8, 'Alia', 93000.00),
(9, 'Sofia', 80000.00),
(10, 'Alen', 64000.00);


-- Step 3: Writing the Query
WITH RankedEmployees AS (
    SELECT 
        EmployeeID,
        EmployeeName,
        Salary,
        DENSE_RANK() OVER (ORDER BY Salary DESC) AS Rank
    FROM Employee
)
SELECT 
    EmployeeID,
    EmployeeName,
    Salary
FROM RankedEmployees
WHERE Rank <= 5;
