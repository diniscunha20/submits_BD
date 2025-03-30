Create Schema Company;

GO

CREATE TABLE Company.employee (
Fname VARCHAR(15),
Minit VARCHAR(15),
Lname VARCHAR(15),
Ssn INT NOT NULL,
Bdate DATE,
Address_ VARCHAR(20),
Sex VARCHAR(10),
Salary INT,
Super_ssn INT,
Dno INT,

PRIMARY KEY (Ssn),
FOREIGN KEY(Super_ssn) REFERENCES Company.employee(Ssn),
);

CREATE TABLE Company.department (
Dname VARCHAR(17),
Dnumber INT NOT NULL,
Mgr_ssn INT,
Mgr_start_sate DATE,

PRIMARY KEY(Dnumber)
);

CREATE TABLE Company.dept_locations(
Dnumber INT NOT NULL,
Dlocation VARCHAR(16) NOT NULL,

PRIMARY KEY (Dnumber, Dlocation),
FOREIGN KEY (Dnumber) REFERENCES Company.department(Dnumber),
);

CREATE TABLE Company.project(
Pname VARCHAR(15),
Pnumber INT NOT NULL,
Plocation VARCHAR(15),
Dnum INT NOT NULL,

PRIMARY KEY (Pnumber),
FOREIGN KEY (Dnum) REFERENCES Company.department(Dnumber),
);

CREATE TABLE Company.works_on(
Essn INT NOT NULL,
Pno INT NOT NULL,
Hours_ INT,

PRIMARY KEY (Essn,Pno),
FOREIGN KEY (Essn) REFERENCES Company.employee(Ssn),
FOREIGN KEY (Pno) REFERENCES Company.project(Pnumber),
);

CREATE TABLE Company.dependent_(
Essn INT NOT NULL,
Dependent_name VARCHAR(15) NOT NULL,
Sex VARCHAR(10),
Bdate DATE,
Relationship VARCHAR(8),

PRIMARY KEY (Essn, Dependent_name),
FOREIGN KEY (Essn) REFERENCES Company.employee(Ssn),
);

ALTER TABLE Company.employee
           ADD CONSTRAINT EMPDEPTFK FOREIGN KEY (Dno) REFERENCES Company.department(Dnumber);

ALTER TABLE Company.department
			ADD CONSTRAINT DEPTMGRFK FOREIGN KEY (Mgr_ssn) REFERENCES Company.employee(Ssn);
