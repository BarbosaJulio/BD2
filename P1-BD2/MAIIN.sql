DROP DATABASE IF EXISTS employees;
CREATE DATABASE IF NOT EXISTS employees;
USE employees;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

DROP TABLE IF EXISTS dept_emp,
                     dept_manager,
                     titles,
                     salaries, 
                     employees, 
                     departments;



CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);

CREATE TABLE dept_manager (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
) 
; 

CREATE TABLE salaries (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
) 
; 

#Soma todos sálários da empresa
SELECT    SUM(salary) Total_Salary
FROM    salaries;

#Soma a quantidade de funcionários empresa
SELECT    COUNT(emp_no) Total_Employes
FROM    employees;

#Soma a quantidade de funcionários Agrupados separadamente por genero
SELECT emp_no, gender,    COUNT(emp_no) Total_Employes
FROM    employees
GROUP BY gender;


#Ordena os Funcionários por idade 
 SELECT*
 FROM employees
 order by birth_date;

#Ordena os funcionários em ordem alfabética
 SELECT*
 FROM employees
 order by first_name;
 
 #Ordena os funcionários de acordo com a data de contratação
 SELECT*
 FROM employees
 order by hire_date;

 #Agrupa os funcionários pelo genêro
 SELECT*
 FROM employees
 order by gender;
 
 #Ordena os Funcionários pelo número dos funcionarios
 SELECT*
 FROM dept_emp
 order by emp_no;
 
 
 #Ordena os funcionários por departamento
 SELECT*
 FROM dept_emp
 order by dept_no;
 
 #Ordena os funcionários por departamento
 SELECT*
 FROM dept_emp
 order by dept_no;
 
#Filtra o número dos empregados pelo  departameno d001
 SELECT emp_no, dept_no
 FROM dept_emp
 where dept_no= 'd001';
 
 #Filtra o número dos empregados pelo  departameno d002
 
 SELECT emp_no, dept_no
 FROM dept_emp
 where dept_no= 'd002';
 
  #Filtra o número dos empregados pelo  departameno d003
 SELECT emp_no, dept_no       
 FROM dept_emp
 where dept_no= 'd003';
 
 #Filtra o número dos empregados pelo  departameno d004
 SELECT emp_no, dept_no
 FROM dept_emp
 where dept_no= 'd004';
 
 
 
 
#Filtra o número dos empregados pelo  departameno d001 e d002
 SELECT emp_no, dept_no
 FROM dept_emp
 WHERE dept_no='d001' OR dept_no='d002';
 
 #União de tabelas do departamento de funcionarios e departamentos de gestores que compartilham a mesma area
 SELECT emp_no, dept_no
 FROM dept_emp
 where dept_no= 'd001'
 union
SELECT emp_no,dept_no
 FROM dept_manager
 where dept_no= 'd001';
 
 #Altera tabela salários adicionando uma coluna para bônus
ALTER TABLE salaries
ADD Bônus SMALLINT NOT NULL;
SELECT* 
FROM salaries;

#Filtra por salários diferentes
SELECT DISTINCT salary FROM salaries;

#Filtra o número dos empregados utilizando dois critérios dpt_no e emp_No
SELECT emp_no,dept_no
 FROM dept_manager
 where dept_no= 'd001' AND emp_no >= '11111';

#Filtra Selecionando especificamente pelo numero do funcionário inserido na busca
SELECT *
FROM dept_manager        
WHERE emp_no IN (110039, 110022, 110085);




#Seleciona os empregados que tem o sobrenome Simmel
Select *
FROM employees WHERE last_name 
LIKE 'Simmel%';

#Filtra Selecionando o número dos colaboradores entre 110022 e 110560	
SELECT *
FROM dept_manager          
WHERE emp_no BETWEEN '110022' AND '110560';

#Selciona toda a tabela departamentos e traz os dois primeiros da lista
SELECT * FROM departments LIMIT 0, 2;



#Filtra Selecionando os funcionários que não tenham sobrenome Simmel
SELECT *
FROM employees
WHERE NOT last_name = 'Simmel%';

#Seleciona a tabela empregados e retorna as datas de aniversario em ordem descrecente pelo numero do empregado
SELECT * FROM employees WHERE birth_date IS NOT NULL ORDER BY emp_no DESC;

#Filtro para obter salários menores que 70000
SELECT *
FROM salaries
GROUP BY salary
HAVING salary < 70000;


#SOma salarios individualmente
SELECT*,
SUM(salary)
FROM salaries
GROUP BY  salary, emp_no WITH ROLLUP;

#Uni o registro das tabelas dept_emp e dept_manager
SELECT emp_no, dept_no FROM dept_emp
UNION ALL
SELECT emp_no, dept_no FROM dept_manager;

#Aumenta os caracteres do sobrenome na tabela empregados
alter table employees modify last_name varchar(30);

#Inner Join entre tabelas com Número do funcionário, nome e número do departamento
SELECT dept_emp.emp_no, employees.first_name, dept_emp.dept_no
FROM dept_emp
INNER JOIN employees ON dept_emp.emp_no=employees.emp_no;


CREATE OR REPLACE VIEW dept_emp_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp
    GROUP BY emp_no;

# shows only the current department for each employee
CREATE OR REPLACE VIEW current_dept_emp AS
    SELECT l.emp_no, dept_no, l.from_date, l.to_date
    FROM dept_emp d
        INNER JOIN dept_emp_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;
        
