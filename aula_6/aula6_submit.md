# BD: Guião 6

## Problema 6.1

### *a)* Todos os tuplos da tabela autores (authors);

```
SELECT * FROM AUTHORS
```

### *b)* O primeiro nome, o último nome e o telefone dos autores;

```
SELECT au_fname,au_lname,phone FROM authors;
```

### *c)* Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o último nome (ascendente); 

```
SELECT au_fname,au_lname,phone FROM authors
ORDER by au_fname,au_lname;
```

### *d)* Consulta definida em c) mas renomeando os atributos para (first_name, last_name, telephone); 

```
SELECT au_fname as first_name ,au_lname as last_name, phone as telephone FROM authors
ORDER by first_name, last_name;
```

### *e)* Consulta definida em d) mas só os autores da Califórnia (CA) cujo último nome é diferente de ‘Ringer’; 

```
SELECT au_fname as first_name ,au_lname as last_name, phone as telephone FROM authors
WHERE state = 'CA' and au_lname != 'Ringer' 
ORDER by first_name, last_name
```

### *f)* Todas as editoras (publishers) que tenham ‘Bo’ em qualquer parte do nome; 

```
SELECT * FROM publishers
WHERE pub_name like '%Bo%'
```

### *g)* Nome das editoras que têm pelo menos uma publicação do tipo ‘Business’; 

```
SELECT distinct publishers.pub_name, publishers.pub_id
FROM publishers inner join titles on publishers.pub_id = titles.pub_id
WHERE type = 'Business'
```

### *h)* Número total de vendas de cada editora; 

```
SELECT publishers.pub_name as Editora, publishers.pub_id, COUNT(sales.qty) as Vendas
FROM (publishers inner join titles on publishers.pub_id = titles.pub_id) inner join sales on titles.title_id = sales.title_id 
Group by publishers.pub_name, publishers.pub_id
```

### *i)* Número total de vendas de cada editora agrupado por título; 

```
SELECT publishers.pub_name, titles.title as Título, COUNT(sales.qty) as Vendas
FROM (publishers inner join titles on publishers.pub_id = titles.pub_id) inner join sales on titles.title_id = sales.title_id 
Group by publishers.pub_name, titles.title```

### *j)* Nome dos títulos vendidos pela loja ‘Bookbeat’; 

```
SELECT stores.stor_name as Loja, titles.title as Título
FROM (stores inner join sales on stores.stor_id = sales.stor_id) inner join titles on titles.title_id = sales.title_id 
Where stores.stor_name = 'Bookbeat'
```

### *k)* Nome de autores que tenham publicações de tipos diferentes; 

```
SELECT authors.au_fname as Nome, authors.au_lname as Apelido, COUNT(titles.type) as num_tipos
FROM (titleauthor inner join titles on  titleauthor.title_id = titles.title_id) inner join authors on authors.au_id = titleauthor.au_id 
GROUP by authors.au_fname, authors.au_lname
HAVING COUNT (titles.type) > 1
```

### *l)* Para os títulos, obter o preço médio e o número total de vendas agrupado por tipo (type) e editora (pub_id);

```
SELECT titles.title, titles.type, titles.pub_id, avg(titles.price) as média, sum(sales.qty) as vendas
FROM titles join sales on titles.title_id = sales.title_id
GROUP BY titles.type, titles.pub_id, titles.title
```

### *m)* Obter o(s) tipo(s) de título(s) para o(s) qual(is) o máximo de dinheiro “à cabeça” (advance) é uma vez e meia superior à média do grupo (tipo);

```
SELECT titles.type 
FROM titles GROUP BY titles.type
HAVING max(titles.advance) > 1.5 * avg(titles.price)
```

### *n)* Obter, para cada título, nome dos autores e valor arrecadado por estes com a sua venda;

```
SELECT titles.title, authors.au_fname, authors.au_lname,  (titles.price * (titles.royalty * titleauthor.royaltyper / 100) / 100) as gains
FROM (titles JOIN titleauthor on titles.title_id = titleauthor.title_id) join authors on titleauthor.au_id = authors.au_id 
GROUP by  titles.title, authors.au_fname, authors.au_lname,  (titles.price * (titles.royalty * titleauthor.royaltyper / 100) / 100)
```

### *o)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, a faturação total, o valor da faturação relativa aos autores e o valor da faturação relativa à editora;

```
SELECT titles.ytd_sales AS 'Vendas', titles.title AS 'Titulo', titles.price*titles.ytd_sales AS 'Faturação total',  price*ytd_sales*royalty/100 as 'Faturacao relativa aos autores', price*ytd_sales-price*ytd_sales*royalty/100 as 'Faturacao relativa ás editoras'
FROM titles```

### *p)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, o nome de cada autor, o valor da faturação de cada autor e o valor da faturação relativa à editora;

``` 
SELECT titles.ytd_sales as 'Vendas', titles.title as 'Titulo', titles.price*titles.ytd_sales as 'Faturação total',  price*ytd_sales*royalty/100 as 'Faturacao relativa aos autores', price*ytd_sales-price*ytd_sales*royalty/100 as 'Faturacao relativa ás editoras'
FROM titles
```

### *q)* Lista de lojas que venderam pelo menos um exemplar de todos os livros;

```
SELECT stor_name as 'Loja'
FROM ((stores join sales on stores.stor_id = sales.stor_id) join titles on sales.title_id = titles.title_id)
GROUP BY stor_name
HAVING count(title) = (select count(title_id) from titles);
```

### *r)* Lista de lojas que venderam mais livros do que a média de todas as lojas;

```
SELECT stores.stor_name as 'Loja', SUM(sales.qty) as 'Vendas'
FROM stores join sales on stores.stor_id=sales.stor_id 
GROUP BY stores.stor_id , stores.stor_name
HAVING sum(sales.qty) > (SELECT avg(total)
	FROM(SELECT sum(sales.qty) as total
		FROM sales
		GROUP BY sales.stor_id) as subquery)
```

### *s)* Nome dos títulos que nunca foram vendidos na loja “Bookbeat”;

```
SELECT titles.title as 'Título', titles.title_id as 'ID'
FROM titles left join (
SELECT sales.title_id 
FROM sales inner join stores on sales.stor_id = stores.stor_id 
WHERE stores.stor_name = 'Bookbeat') as Bookbeat on titles.title_id = Bookbeat.title_id
WHERE Bookbeat.title_id is null
```

### *t)* Para cada editora, a lista de todas as lojas que nunca venderam títulos dessa editora; 

```
-- Livrarias que ainda NÃO venderam livros de uma editora
SELECT publishers.pub_id AS 'ID', publishers.pub_name AS 'Editora', stores.stor_name AS 'Loja'
FROM publishers, stores
EXCEPT
SELECT publishers.pub_id AS 'ID', publishers.pub_name AS 'Editora', stores.stor_name AS 'Loja'
FROM sales inner JOIN titles ON sales.title_id = titles.title_id inner JOIN publishers ON titles.pub_id = publishers.pub_id inner JOIN stores ON sales.stor_id = stores.stor_id;
```

## Problema 6.2

### ​5.1

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_1_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_1_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT employee.Ssn, employee.Fname, employee.Minit, employee.Lname, project.Pname
FROM 
	Company.employee JOIN Company.works_on ON employee.Ssn=works_on.Essn
		  			JOIN Company.project ON works_on.Pno=project.Pnumber
```

##### *b)* 

```
SELECT employee.Fname, employee.Minit, employee.Lname
FROM 
	Company.employee JOIN 
				(SELECT employee.Ssn AS Carlos
					FROM Company.employee
					WHERE employee.Fname='Carlos' AND employee.Minit='D' AND Lname='Gomes') AS C
    ON employee.Super_ssn=C.Carlos
```

##### *c)* 

```
SELECT Projeto.Pname, Tempo.Total
FROM Company.project AS Projeto JOIN (SELECT works_on.Pno , SUM(Hours_) as Total
												FROM Company.works_on
												GROUP BY works_on.Pno) AS Tempo
			ON Projeto.Pnumber = Tempo.Pno
```

##### *d)* 

```
SELECT employee.Fname, employee.Minit, employee.Lname
FROM 
	Company.employee JOIN Company.works_on 
	ON employee.Ssn=works_on.Essn
WHERE employee.Dno=3 AND works_on.Hours_>20
```

##### *e)* 

```
SELECT employee.Fname,	employee.Minit, employee.Lname
FROM 
	Company.employee LEFT JOIN Company.works_on
	ON employee.Ssn=works_on.Essn
WHERE works_on.Essn IS NULL
```

##### *f)* 

```
SELECT Dname, avg(Salary) AS salario  
FROM 
	Company.employee JOIN Company.department
	ON employee.Dno = department.Dnumber
WHERE employee.Sex='F'
GROUP BY Dname
```

##### *g)* 

```
SELECT employee.Ssn, employee.Fname, employee.Minit, employee.Lname, COUNT(employee.Ssn) AS total
FROM 
	Company.employee JOIN Company.dependent_
	ON employee.Ssn=dependent_.Essn
GROUP BY employee.Ssn, employee.Fname, employee.Minit, employee.Lname
HAVING count(employee.Ssn) > 2
```

##### *h)* 

```
SELECT Ssn, Fname, Minit, Lname
FROM Company.dependent_ RIGHT JOIN (SELECT Ssn, Fname, Minit, Lname
	FROM Company.employee JOIN Company.department ON Ssn = Mgr_ssn) AS F
	ON Ssn = Essn
WHERE Essn IS NULL
```

##### *i)* 

```
SELECT DISTINCT Fname, Lname, Address_
FROM 
	Company.employee JOIN Company.works_on
	ON Ssn=Essn
	JOIN Company.project
	ON Pnumber=Pno
	JOIN Company.department
	ON Dno=Dnum
	JOIN Company.dept_locations
	ON Dno=Dnum
WHERE Plocation='Aveiro' AND Dlocation!='Aveiro'
```

### 5.2

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_2_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_2_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT fornecedor.nif, fornecedor.nome
FROM Stock.ecomenda 
RIGHT OUTER JOIN Stock.fornecedor on ecomenda.NIF_Fornecedor = fornecedor.NIF
WHERE ecomenda.N_Encomenda is NULL
```

##### *b)* 

```
SELECT produto.nome, AVG(item.unidades) AS avg_units
FROM Stock.produto 
JOIN Stock.item ON produto.codigo = item.Codigo
GROUP BY produto.nome
```


##### *c)* 

```
SELECT AVG(CAST(contagem.total AS FLOAT)) AS media
FROM (
  SELECT N_Encomenda, COUNT(*) AS total
  FROM Stock.item
  GROUP BY N_Encomenda
) AS contagem;

```


##### *d)* 

```
SELECT 
    fornecedor.nome, 
    produto.nome, 
    COUNT(produto.nome) AS contagem 
FROM 
    Stock.fornecedor
		JOIN 
				Stock.ecomenda ON fornecedor.NIF = ecomenda.NIF_Fornecedor
		JOIN 
				Stock.item ON item.N_Encomenda = ecomenda.N_Encomenda
		JOIN 
				Stock.produto ON item.Codigo = produto.codigo
GROUP BY 
    fornecedor.nome, produto.nome
```

### 5.3

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_3_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_3_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT DDL_Prescricoes.paciente.nome 
FROM DDL_Prescricoes.paciente 
LEFT JOIN DDL_Prescricoes.prescricao on DDL_Prescricoes.paciente.numUtente = DDL_Prescricoes.prescricao.numUtente
WHERE DDL_Prescricoes.prescricao.numUtente IS NULL;
```

##### *b)* 

```
SELECT DDL_Prescricoes.medico.especialidade, COUNT(DDL_Prescricoes.prescricao.numPresc) AS cout_numPresc
FROM DDL_Prescricoes.medico 
JOIN DDL_Prescricoes.prescricao on DDL_Prescricoes.medico.numSNS = DDL_Prescricoes.prescricao.numMedico
GROUP BY DDL_Prescricoes.medico.especialidade;
```


##### *c)* 

```
SELECT DDL_Prescricoes.farmacia.nome, COUNT(DDL_Prescricoes.prescricao.numPresc) AS cout_numPresc
FROM DDL_Prescricoes.farmacia join DDL_Prescricoes.prescricao on DDL_Prescricoes.farmacia.nome = DDL_Prescricoes.prescricao.farmacia
GROUP BY DDL_Prescricoes.farmacia.nome;
```


##### *d)* 

```
(
  SELECT DDL_Prescricoes.farmaco.nome
  FROM DDL_Prescricoes.farmaco
  WHERE DDL_Prescricoes.farmaco.numRegFarm = 906
)
EXCEPT
(
  SELECT DDL_Prescricoes.presc_farmaco.nomeFarmaco
  FROM DDL_Prescricoes.presc_farmaco
  WHERE DDL_Prescricoes.presc_farmaco.numRegFarm = 906
);
```

##### *e)* 

```
SELECT 
  F.nome AS farmacia, FA.nome AS farmaceutica, 
  COUNT(FA.nome) AS count_farm
FROM DDL_Prescricoes.prescricao P
JOIN DDL_Prescricoes.farmacia F ON P.farmacia = F.nome
JOIN DDL_Prescricoes.presc_farmaco PF ON P.numPresc = PF.numPresc
JOIN DDL_Prescricoes.farmaceutica FA ON PF.numRegFarm = FA.numReg
GROUP BY F.nome, FA.nome;
```

##### *f)* 

```
SELECT DDL_Prescricoes.paciente.nome 
FROM DDL_Prescricoes.paciente join DDL_Prescricoes.prescricao on DDL_Prescricoes.paciente.numUtente = DDL_Prescricoes.prescricao.numUtente join DDL_Prescricoes.medico on DDL_Prescricoes.prescricao.numMedico = DDL_Prescricoes.medico.numSNS
GROUP BY DDL_Prescricoes.paciente.numUtente, DDL_Prescricoes.paciente.nome
HAVING COUNT(DDL_Prescricoes.medico.numSNS) > 1;
```
