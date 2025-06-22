-- Step 1: Creating the SourceTable and DestinationTable
CREATE TABLE StartTable (
    ID INT PRIMARY KEY,
    Data VARCHAR(100)
);

CREATE TABLE DestTable (
    ID INT PRIMARY KEY,
    Data VARCHAR(100)
);


-- Step 2: Inserting sample data 
INSERT INTO StartTable (ID, Data) VALUES
(1, 'One'),
(2, 'Two'),
(3, 'Three'),
(4, 'Four'),
(5, 'Five');

INSERT INTO DestTable (ID, Data) VALUES
(1, 'One'),
(2, 'Two');


-- Step 3: Checking the Contents Before Copying
SELECT * FROM StartTable;
SELECT * FROM DestTable;


-- Step 4: Inserting new data from SourceTable to DestinationTable
INSERT INTO DestTable (ID, Data)
SELECT ID, Data
FROM StartTable
EXCEPT
SELECT ID, Data
FROM DestTable;

-- Step 5: Checking the Contents after Copying
SELECT * FROM StartTable;
SELECT * FROM DestTable;
