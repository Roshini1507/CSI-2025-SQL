-- Step 1: Creating the Table
CREATE TABLE SampleTable (
    ID INT PRIMARY KEY,
    ColumnA INT,
    ColumnB INT
);

-- Step 2: Inserting Sample Data
INSERT INTO SampleTable (ID, ColumnA, ColumnB) VALUES
(1, 100, 200),
(2, 300, 400),
(3, 500, 600);

-- Step 3: Writing the Query to Swap Values
UPDATE SampleTable
SET ColumnA = ColumnA + ColumnB;
UPDATE SampleTable
SET ColumnB = ColumnA - ColumnB;
UPDATE SampleTable
SET ColumnA = ColumnA - ColumnB;

-- Step 4: Verifying the Swap
SELECT * FROM SampleTable;

