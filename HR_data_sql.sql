create table hrdata
(  
	emp_no int8 PRIMARY KEY,
	gender varchar(50) NOT NULL,
	marital_satus varchar(50),
	age_band varchar(50),
	age int8,
	department varchar(50),
	education varchar(50),
	education_field varchar(50),
	job_role varchar(50),
	business_travel varchar(50),
	employee_count int8,
	attrition varchar(50),
	attrition_label varchar(50),
	job_satisfaction int8,
	active_employee int8
)

select*from hrdata

/* import data in table using query(optinal)*/

COPY hrdata FROM 'C:\Users\sachi\OneDrive\Desktop\SQL projects\hrdata.csv' DELIMITER ',' 
CSV HEARDER;

/* employee count*/

select sum(employee_count) from hrdata

select sum(employee_count) as employee_count from hrdata
--where education = 'High School'
--where department= 'Sales'
where education_field ='Medical'

/* attrition count */

select count(attrition) from hrdata
where attrition = 'Yes' 

/* attrition count using multiply filters*/

select count(attrition) from hrdata
--where attrition = 'Yes' and education = 'Doctoral Degree'
where attrition = 'Yes' and department = 'R&D' and education_field = 'Medical'

/* attrition rate */

select round(((select count(attrition) from hrdata where attrition = 'Yes')
/sum(employee_count))*100,2)  from hrdata

/* attrition rate using filters*/

select round(((select count(attrition) from hrdata where attrition = 'Yes' and department = 'Sales')
/sum(employee_count))*100,2)  from hrdata
where department = 'Sales'

/* active employee*/
select sum(employee_count)-(select count(attrition) from hrdata where attrition ='Yes')
from hrdata

/* male active employee  */

select sum(employee_count)-(select count(attrition) from hrdata where attrition = 'Yes' and gender = 'Male')
from hrdata 
where gender = 'Male'

/* average age */
select round(avg(age),0) as age from hrdata

/*attrition by gender*/

select gender , count(attrition) from hrdata
where attrition = 'Yes'
group by gender
order by count(attrition) DESC

/* department wise attrition*/

select department , count(attrition),
round((cast(count(attrition) as Numeric)/(select count(attrition) from hrdata where attrition = 'Yes'))*100,2)
from hrdata 
where attrition = 'Yes'
group by department
order by count(attrition) DESC

/* no of employee by age group */

select age , sum(employee_count) from hrdata
group by age 
order by age

select age , sum(employee_count) from hrdata
where department = 'R&D'
group by age 
order by age

/* education field wise attrition*/

select education_field , count(attrition) from hrdata
where attrition = 'Yes'
group by education_field
order by count(attrition) desc


select education_field , count(attrition) from hrdata
where attrition = 'Yes' and department = 'Sales'
group by education_field
order by count(attrition) desc

/* attrition rate by gender for different age group*/

select age_band , gender , count(attrition),
round((cast(count(attrition) as numeric )/
(select count(attrition) from hrdata where attrition = 'Yes'))*100,2) as pct
from hrdata
where attrition = 'Yes'
group by age_band , gender
order by age_band , gender

/* job satisfaction rate */

create extension if not exists tablefunc;

select *
from crosstab(
'select job_role , job_satisfaction , sum(employee_count)
	from hrdata
	group by job_role , job_satisfaction
	order by job_role , job_satisfaction'
) as ct(job_role varchar(50), one numeric , two numeric , three numeric , four numeric)
order by job_role;

select age_band , gender , sum(employee_count) from hrdata
group by age_band , gender
order by age_band , gender desc


























