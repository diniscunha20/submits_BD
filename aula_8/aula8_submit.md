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
... Write here your answer ...
```

### *c)* 

```
... Write here your answer ...
```

### *d)* 

```
... Write here your answer ...
```

### *e)* 

```
... Write here your answer ...
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
