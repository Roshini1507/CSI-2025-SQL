-- Step 1: Creating a login at the server level
CREATE LOGIN Roshini
WITH PASSWORD = 'Roshini@157';

-- Step 2: Switching to my database
USE Celebal;

-- Step 3: Creating a user in the database for the login
CREATE USER SampleUser FOR LOGIN Roshini;

-- Step 4: Adding the user to the db_owner role
ALTER ROLE db_owner ADD MEMBER SampleUser;
