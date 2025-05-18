# BD: Guião 8


## ​8.1
 
### *a)*

```
CREATE PROC remove_employee @ssn int
AS
BEGIN
DELETE FROM works_on WHERE works_on.Essn = @ssn
DELETE FROM dependent_ WHERE dependent_.Essn = @ssn
UPDATE employee SET Mgr_ssn = NULL WHERE department.Mgr_ssn = @ssn
UPDATE department SET Super_ssn = NULL WHERE Employee.Super_ssn = @ssn
DELETE FROM employee WHERE employee.Ssn = @ssn
END
GO
```

### *b)* 

```
CREATE PROCEDURE OldestManager
AS
BEGIN
    SELECT 
        e.Fname AS FirstName, 
        e.Minit AS MiddleInitial, 
        e.Lname AS LastName, 
        e.Ssn AS SSN, 
        e.Sex AS Gender, 
        e.Salary, 
        e.Dno AS DeptNumber,
        DATEDIFF(YEAR, d.Mgr_start_date, GETDATE()) AS TotalYearsAsManager
    FROM 
        employee e
    INNER JOIN 
        department d ON e.Ssn = d.Mgr_ssn;

    SELECT TOP 1 
        e.Fname AS FirstName, 
        e.Minit AS MiddleInitial, 
        e.Lname AS LastName, 
        e.Ssn AS SSN,
        e.Sex AS Gender, 
        e.Salary, 
        e.Dno AS DeptNumber,
        DATEDIFF(YEAR, d.Mgr_start_date, GETDATE()) AS TotalYearsAsManager
    FROM 
        employee e
    INNER JOIN 
        department d ON e.Ssn = d.Mgr_ssn
    ORDER BY 
        d.Mgr_start_date ASC;
END;
GO

```

### *c)* 

```
CREATE TRIGGER CheckManager
ON department
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN department d ON i.Mgr_ssn = d.Mgr_ssn
        GROUP BY i.Mgr_ssn
        HAVING COUNT(d.Dnumber) > 1
    )
    BEGIN
        RAISERROR ('An employee cannot be the manager of more than one department.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

```

### *d)* 

```
CREATE TRIGGER AdjustSalary
ON employee
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE e
    SET e.Salary = m.Salary - 1
    FROM employee e
    JOIN inserted i ON e.Ssn = i.Ssn
    JOIN department d ON e.Dno = d.Dnumber
    JOIN employee m ON d.Mgr_ssn = m.Ssn
    WHERE i.Salary >= m.Salary;
END;
```

### *e)* 

```
CREATE FUNCTION dbo.GetEmployeeProjects (@Ssn INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        p.Pname AS ProjectName, 
        p.Plocation AS ProjectLocation
    FROM 
        works_on w
    INNER JOIN 
        project p ON w.Pno = p.Pnumber
    WHERE 
        w.Essn = @Ssn
);
GO
```

### *f)* 

```
... Write here your answer ...
```

### *g)* 

```
... Write here your answer ...
```

### *h)* 

```
... Write here your answer ...
```

### *i)* 

```
... Write here your answer ...
```
