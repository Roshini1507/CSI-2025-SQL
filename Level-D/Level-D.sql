CREATE PROCEDURE PopulateDateDimension
    @InputDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StartDate DATE;
    DECLARE @EndDate DATE;
    
    SET @StartDate = DATEFROMPARTS(YEAR(@InputDate), 1, 1);
    SET @EndDate = DATEFROMPARTS(YEAR(@InputDate), 12, 31);
    
    DELETE FROM DateDimension 
    WHERE CalendarYear = YEAR(@InputDate);
    
    WITH DateSequence AS (
        SELECT @StartDate AS DateValue
        UNION ALL
        SELECT DATEADD(DAY, 1, DateValue)
        FROM DateSequence
        WHERE DateValue < @EndDate
    ),
    DateAttributes AS (
        SELECT 
            DateValue,
            CAST(FORMAT(DateValue, 'yyyyMMdd') AS INT) AS SKDate,
            
            FORMAT(DateValue, 'M/d/yyyy') AS KeyDate,
            
            DAY(DateValue) AS CalendarDay,
            MONTH(DateValue) AS CalendarMonth,
            DATEPART(QUARTER, DateValue) AS CalendarQuarter,
            YEAR(DateValue) AS CalendarYear,
            
            DATENAME(WEEKDAY, DateValue) AS DayNameLong,
            LEFT(DATENAME(WEEKDAY, DateValue), 3) AS DayNameShort,
            
            DATEPART(WEEKDAY, DateValue) AS DayNumberOfWeek,
            
            DATEPART(DAYOFYEAR, DateValue) AS DayNumberOfYear,
            
            CASE 
                WHEN DAY(DateValue) IN (1, 21, 31) THEN CAST(DAY(DateValue) AS VARCHAR) + 'st'
                WHEN DAY(DateValue) IN (2, 22) THEN CAST(DAY(DateValue) AS VARCHAR) + 'nd'
                WHEN DAY(DateValue) IN (3, 23) THEN CAST(DAY(DateValue) AS VARCHAR) + 'rd'
                ELSE CAST(DAY(DateValue) AS VARCHAR) + 'th'
            END AS DaySuffix,
            
            DATEPART(WEEK, DateValue) AS FiscalWeek,
            
            MONTH(DateValue) AS FiscalPeriod,
            
            NULL AS FiscalQuarter,
            
            YEAR(DateValue) AS FiscalYear,
            
            CAST(YEAR(DateValue) AS VARCHAR) + RIGHT('0' + CAST(MONTH(DateValue) AS VARCHAR), 2) AS FiscalYearPeriod
            
        FROM DateSequence
    )
    INSERT INTO DateDimension (
        SKDate, KeyDate, [Date], CalendarDay, CalendarMonth, CalendarQuarter, 
        CalendarYear, DayNameLong, DayNameShort, DayNumberOfWeek, DayNumberOfYear, 
        DaySuffix, FiscalWeek, FiscalPeriod, FiscalQuarter, FiscalYear, FiscalYearPeriod
    )
    SELECT 
        SKDate, KeyDate, DateValue, CalendarDay, CalendarMonth, CalendarQuarter,
        CalendarYear, DayNameLong, DayNameShort, DayNumberOfWeek, DayNumberOfYear,
        DaySuffix, FiscalWeek, FiscalPeriod, FiscalQuarter, FiscalYear, FiscalYearPeriod
    FROM DateAttributes
    OPTION (MAXRECURSION 366); 
    
    PRINT 'Date dimension populated for year ' + CAST(YEAR(@InputDate) AS VARCHAR);
END;
