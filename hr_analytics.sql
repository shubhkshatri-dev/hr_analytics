create database hr_analytics;
use  hr_analytics;

-- Creating the table
create table raw_employees(
	employee_id int primary key,
    department varchar(50),
    region varchar(50),
    education varchar(50),
    gender varchar(10),
    recruitment_channel varchar(50),
    no_of_trainings int,
    age int,
    previous_year_rating float,
    length_of_service int,
    KPIs_met_more_than_80 int,
    awards_won int,
    avg_training_score int
);

-- Handling missing values
create table cleaned_employees as
select
	employee_id,
    department,
    region,
    coalesce(nullif(education,''), 'Unknown') as education,
    gender,
    recruitment_channel,
    no_of_trainings,
    age,
    case
		when age < 30 then'Under 30'
        when age between 30 and 45 then '30-45'
        else '45+'
        end as age_group,
	coalesce(previous_year_rating, 3.0) as previous_year_rating,
    length_of_service,
    case 
		when length_of_service <= 2 then 'New Hire(0-2 yrs)'
        when length_of_service between 3 and 7 then 'Mid Tenured(3-7 yrs)'
        else 'Senior(8+ yrs)'
	end as tenure_band,
	KPIs_met_more_than_80,
    awards_won,
    avg_training_score,
    case
		when KPIs_met_more_than_80 = 1 AND avg_training_score >= 70 THEN 1
        else 0
	end as high_performer_flag
from raw_employees;

-- General summary stats 
select
	count(employee_id) as total_employees,
    round(avg(age), 1) as avg_age,
    round(avg(length_of_service), 1) as avg_tenure_years,
    round(avg(avg_training_score), 2) as avg_training_score,
    round(avg(previous_year_rating), 2) as avg_prev_rating,
    round(sum(KPIs_met_more_than_80) * 100.0/ count(*), 2) as pct_met_kpis,
    round(sum(awards_won) * 100.0 / count(*), 2) as pct_awards_won
from cleaned_employees; 

-- Department and gender breakdown
select 
	department, 
    gender,
    count(employee_id) as total_count,
    round(avg(avg_training_score), 2) as avg_score,
    round(avg(length_of_service), 2) as avg_tenure
from cleaned_employees
group by department, gender
order by department, gender;

-- Performance and retention analysis
select
	tenure_band,
    count(employee_id) as total_employees,
    round(avg(previous_year_rating), 2) as avg_rating,
    round(avg(avg_training_score), 2) as avg_score,
    round(sum(high_performer_flag) *100.0/count(*), 2) as pct_high_performers
from cleaned_employees
group by tenure_band
order by avg_score desc;

-- Impact of training frequency on employee performance
select 
	no_of_trainings,
    count(employee_id) as employee_count,
    round(avg(avg_training_score), 2) as avg_training_score,
    round(sum(KPIs_met_more_than_80)*100.0/count(*), 2) as pct_kpi_met
from cleaned_employees
group by no_of_trainings
order by no_of_trainings;

-- High performance concentration by education and age group
select
	education,
    age_group,
    count(employee_id) as employee_count,
    round(sum(high_performer_flag)*100.0/count(*), 2) as high_performer_rate,
    sum(high_performer_flag) as high_performer_count
from cleaned_employees
group by education, age_group
order by high_performer_rate desc;

-- Identifying at risk demographics
select 
	department,
    education,
    count(employee_id) as low_performer_count,
    round(count(employee_id)*100.0/(select count(*)from cleaned_employees), 2) as total_pct_share
from cleaned_employees
where kpis_met_more_than_80 = 0
and previous_year_rating<= 2.0
and avg_training_score < 60
group by department, education
order by low_performer_count desc;

-- Benchmarking top talents
with deptmetrics as(
	select 
		department,
        count(employee_id) as total_emp,
        round(sum(kpis_met_more_than_80)*100.0/ count(*), 2) as kpi_success_rate,
        round(avg(avg_training_score), 2) as avg_dept_score
	from cleaned_employees
    group by department
    )
select
	department,
    total_emp,
    kpi_success_rate,
    avg_dept_score,
    dense_rank() over (order by kpi_success_rate desc) as performance_rank
from deptmetrics;
