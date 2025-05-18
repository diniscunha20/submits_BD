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
CREATE FUNCTION company.Vencimento_superior_média (@Dno INT)
RETURNS TABLE
AS
RETURN (
    WITH Media_Salarial AS (
        SELECT AVG(Salary) AS average
        FROM company.employee
        WHERE Dno = @Dno
    )
    SELECT 
        e.Fname, e.Minit, e.Lname, e.Salary, e.Dno
    FROM company.employee e
    JOIN Media_Salarial m
        ON e.Salary > m.average
    WHERE e.Dno = @Dno
);

DROP FUNCTION company.Vencimento_superior_média

SELECT * FROM company.Vencimento_superior_média(3);

Select * From company.employee
```

### *g)* 

```
CREATE FUNCTION company.deptRecordSet (@Dno INT)
RETURNS @ProjectInfo TABLE (
    Pname        VARCHAR(32),
    Pnum         INT,
    Plocation    VARCHAR(32),
    Dnum         INT,
    Budget       DECIMAL(10,2),
    TotalBudget  DECIMAL(10,2)
)
AS
BEGIN
    DECLARE 
        @Pname         VARCHAR(32),
        @Pnum          INT,
        @Plocation     VARCHAR(32),
        @Budget        DECIMAL(10,2),
        @TotalBudget   DECIMAL(10,2) = 0;

    -- Cursor para iterar pelos projetos do departamento
    DECLARE project_cursor CURSOR FOR
        SELECT DISTINCT p.Pname, p.Pnumber, p.Plocation
        FROM company.Project p
        WHERE p.Dnum = @Dno;

    OPEN project_cursor;
    FETCH NEXT FROM project_cursor INTO @Pname, @Pnum, @Plocation;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calcula o orçamento do projeto com base no salário dos funcionários alocados
        SELECT 
            @Budget = ISNULL(SUM((e.Salary / 160.0) * w.Hours_ * 4), 0)
        FROM 
            company.Works_on w
            JOIN company.Employee e ON w.Essn = e.Ssn
        WHERE 
            w.Pno = @Pnum;

        -- Atualiza o total acumulado
        SET @TotalBudget += @Budget;

        -- Insere resultado na tabela de retorno
        INSERT INTO @ProjectInfo (
            Pname, Pnum, Plocation, Dnum, Budget, TotalBudget
        )
        VALUES (
            @Pname, @Pnum, @Plocation, @Dno, @Budget, @TotalBudget
        );

        FETCH NEXT FROM project_cursor INTO @Pname, @Pnum, @Plocation;
    END

    CLOSE project_cursor;
    DEALLOCATE project_cursor;

    RETURN;
END;
GO

DROP FUNCTION IF EXISTS company.deptRecordSet;
SELECT * FROM company.deptRecordSet(3);

```

### *h)* 

```
CREATE TRIGGER company.DeleteDepartment
ON company.Department
AFTER DELETE
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'company' AND TABLE_NAME = 'Department_Deleted'
    )
    BEGIN
        CREATE TABLE company.Department_Deleted (
            Dnumber         INT PRIMARY KEY,
            Dname           VARCHAR(64),
            Mgr_ssn         CHAR(9),
            Mgr_start_date  DATE,
            DeletedAt       DATETIME DEFAULT GETDATE()
        );
    END;

    INSERT INTO company.Department_Deleted (Dnumber, Dname, Mgr_ssn, Mgr_start_sate)
    SELECT Dnumber, Dname, Mgr_ssn, Mgr_start_sate
    FROM deleted;
END;
GO

Drop Trigger company.DeleteDepartment

Vantagens:
- Apenas criada se necessário
- Não interfere no comportamento de exclusão.
- Mais simples

Desvantagens:
- A tabela só é criada na primeira exclusão, o que pode não ser o ideal.

CREATE TRIGGER company.DeleteDepartment
ON company.Department
INSTEAD OF DELETE
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'company' AND TABLE_NAME = 'Department_Deleted'
    )
    BEGIN
        CREATE TABLE company.Department_Deleted (
            Dnumber         INT PRIMARY KEY,
            Dname           VARCHAR(64),
            Mgr_ssn         CHAR(9),
            Mgr_start_date  DATE,
            DeletedAt       DATETIME DEFAULT GETDATE()
        );
    END;

    INSERT INTO company.Department_Deleted (Dnumber, Dname, Mgr_ssn, Mgr_start_date)
    SELECT Dnumber, Dname, Mgr_ssn, Mgr_start_date
    FROM deleted;

    PRINT 'Delete bloqueado: dados movidos para tabela de auditoria.';
END;
GO

Vantagens:
- Soft delete

Desvantagens:
- Mais complexo e confuso já que os dados não são realmente removidos


```

### *i)* 

```
UDF:
Vantagens:
- Flexível, podendo ser incorporada diretamente dentro de expressões SQL
- Facilmente reutilizável, encapsulando toda a lógica
Desvantagens:
- Limitado em transações e estruturas de fluxo complexas

Stored Procedures:
Vantagens:
- Melhor performance, com pré compolação
- Podem controlar o acesso aos dados, ao conceder permissões de execução sem necessariamente dar acesso direto às tabelas
Desvantagens:
- Não podem ser usadas diretamente dentro de expressões SQL como as UDFs
```
