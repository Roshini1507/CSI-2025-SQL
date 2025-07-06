CREATE TABLE SubjectAllotments (
    StudentID VARCHAR(50),
    SubjectID VARCHAR(50),
    Is_Valid BIT
);

CREATE TABLE SubjectRequest (
    StudentID VARCHAR(50),
    SubjectID VARCHAR(50)
);

INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid) VALUES
('159103036', 'PO1491', 1),
('159103036', 'PO1492', 0),
('159103036', 'PO1493', 0),
('159103036', 'PO1494', 0),
('159103036', 'PO1495', 0);

INSERT INTO SubjectRequest (StudentID, SubjectID) VALUES
('159103036', 'PO1496');

CREATE PROCEDURE ProcessSubjectRequest
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @StudentID VARCHAR(50);
        DECLARE @RequestedSubjectID VARCHAR(50);
        DECLARE @CurrentSubjectID VARCHAR(50);

        DECLARE request_cursor CURSOR FOR
        SELECT StudentID, SubjectID FROM SubjectRequest;

        OPEN request_cursor;
        FETCH NEXT FROM request_cursor INTO @StudentID, @RequestedSubjectID;

        WHILE @@FETCH_STATUS = 0
        BEGIN

            SELECT @CurrentSubjectID = SubjectID
            FROM SubjectAllotments
            WHERE StudentID = @StudentID AND Is_Valid = 1;

            IF @CurrentSubjectID IS NOT NULL
            BEGIN
                IF @CurrentSubjectID <> @RequestedSubjectID
                BEGIN

                    UPDATE SubjectAllotments
                    SET Is_Valid = 0
                    WHERE StudentID = @StudentID AND Is_Valid = 1;

                    INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
                    VALUES (@StudentID, @RequestedSubjectID, 1);
                END
            END
            ELSE
            BEGIN
                INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
                VALUES (@StudentID, @RequestedSubjectID, 1);
            END

            FETCH NEXT FROM request_cursor INTO @StudentID, @RequestedSubjectID;
        END

        CLOSE request_cursor;
        DEALLOCATE request_cursor;

        TRUNCATE TABLE SubjectRequest;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

EXEC ProcessSubjectRequest;

SELECT * FROM SubjectAllotments;