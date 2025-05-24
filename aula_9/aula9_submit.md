# BD: Guião 9


## ​9.1. Complete a seguinte tabela.
Complete the following table.

| #    | Query                                                                                                      | Rows  | Cost  | Pag. Reads | Time (ms) | Index used | Index Op.            | Discussion |
| :--- | :--------------------------------------------------------------------------------------------------------- | :---- | :---- | :--------- | :-------- | :--------- | :------------------- | :--------- |
| 1    | SELECT * from Production.WorkOrder                                                                         | 72591 | 0.473 | 742        | 1209      | PK_WorkOrder_WorkOrderID         | Clustered Index Scan |            |
| 2    | SELECT * from Production.WorkOrder where WorkOrderID=1234                                                  |   1    |   0.003    | 216           |      67     |     PK_WorkOrder_WorkOrderID       |        Clustered Index Seek              |            |
| 3.1  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 10000 and 10010                               |    11   |   0.003    |     26       |      91     |     PK_WorkOrder_WorkOrderID       |          Clustered Index Seek            |            |
| 3.2  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 1 and 72591                                   |    72591   |   0.473    |      744      |     1206      |    PK_WorkOrder_WorkOrderID        |         Clustered Index Seek               |            |
| 4    | SELECT * FROM Production.WorkOrder WHERE StartDate = '2007-06-25'                                          |    55   |   0.473    |      554      |     144      |      PK_WorkOrder_WorkOrderID       |           Clustered Index Scan            |            |
| 5    | SELECT * FROM Production.WorkOrder WHERE ProductID = 757                                                   |    9   |    0.03   |     44       |     109      |     ProductID	       |        Index Seek (NonClustered)              |            |
| 6.1  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 757                              |     9  |   0.003    |     238       |    73       |     ProductID covered       |          Index Seek (NonClustered)              |            |
| 6.2  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945                              |   1105    |   0.005    |     232       |      93     |       ProductId covered    |             Index Seek (NonClustered)            |            |
| 6.3  | SELECT WorkOrderID FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04'            |     1  |   0.003    |     30       |     47      |      ProductId covered     |          Index Seek (NonClustered)              |            
| 7    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04' |    1   |   0.003    |     30       |     58      |      ProductID and StartDate      |            Index Seek (NonClustered)            |            |
| 8    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04' |     1  |   0.003    |      30      |     58      |     Composite (ProductID, StartDate)       |        Index Seek (NonClustered)              |            |

## ​9.2.

### a)

```
... Write here your answer ...
```

### b)

```
... Write here your answer ...
```

### c)

```
... Write here your answer ...
```

### d)

```
... Write here your answer ...
```

### e)

```
... Write here your answer ...
```

## ​9.3.

```
... Write here your answer ...
```
