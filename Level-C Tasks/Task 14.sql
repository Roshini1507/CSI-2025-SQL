-- Step 1: Creating the Tables
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    SubBand VARCHAR(10)
);

-- Step 2: Inserting Sample Data
INSERT INTO Employee (EmployeeID, EmployeeName, SubBand) VALUES
(1, 'Roshini', 'A1'),
(2, 'Eleven', 'A2'),
(3, 'Ayan', 'A1'),
(4, 'Joey', 'A3'),
(5, 'Smith', 'A2'),
(6, 'Patrik', 'A1'),
(7, 'Klassen', 'A3'),
(8, 'Alia', 'A2'),
(9, 'Sofia', 'A1'),
(10, 'Alen', 'A2');


-- Step 3: Writing the Query
WITH TotalCount AS (
    SELECT COUNT(*) AS Total FROM Employee
)
SELECT 
    SubBand,
    COUNT(*) AS HeadCount,
    ROUND((COUNT(*) * 100.0 / (SELECT Total FROM TotalCount)), 2) AS Percentage
FROM Employee
GROUP BY SubBand;

