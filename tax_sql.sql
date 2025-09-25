SELECT * FROM tax2024.income;

alter table tax2024.income
drop column CAAGI,
drop column CountyLatitude,
drop column CountyLongitude,
drop column GeoCounty,
drop column GeoCity,
drop column GeoZipCode,
drop column UploadedToSQL;


select *
from tax2024.income;


-- 1 Which ZIP codes file the most tax returns?

select Zipcode , count(*) as tax_returns
from tax2024.income
group by Zipcode
order by tax_returns desc ;



-- 2 On average, how much tax is owed per return across the state?

select avg(TotalTaxLiability) as tax_owed
from tax2024.income;


-- 3 Which cities are contributing the highest total tax revenue?


select 
    city, 
    SUM(TotalTaxLiability) as total_tax_revenue
from tax2024.income
group by city
order by total_tax_revenue desc;


--  4 What are the top 10 cities with the most returns filed?

select city, count(*)as return_field 
from tax2024.income
group by city
order by return_field desc
limit 10 ;


  -- 5 How are tax returns distributed across CA?

select state ,
count(*) as tax_returns
from tax2024.income
group by state
order by tax_returns desc;


-- 6 Which ZIP codes have the highest average tax liability per return?


select  ZipCode,
 round(avg(TotalTaxLiability),2) as avg_liability
from tax2024.income
group by Zipcode
order by avg_liability desc;



-- 7 How does the number of returns compare to total tax collected across counties?
select county , count(*) as tax_returns,
sum(TotalTaxLiability) as total_tax_collected
from tax2024.income
group by county 
order by tax_returns
and total_tax_collected ;


-- 8 Are there cities where taxpayers are paying significantly more (e.g., over $15k) per return on average?


select city ,
avg(TotalTaxLiability) as avg_tax_payer_return,
count(*) as tax_payer
from tax2024.income
group by city
having avg(TotalTaxLiability) > 15000
order by avg_tax_payer_return desc;


-- 9 Which counties in California rank highest in average tax per return?”


select county , 
avg_TotalTaxLiability as avg_return,
rank() over (order by avg_TotalTaxLiability desc) as rank_returns
from(
select county,
avg(TotalTaxLiability) as avg_TotalTaxLiability
from tax2024.income
group by county
) sub
order by avg_return ;



-- 10 How have the total number of returns changed year over year?
with yearly_change as (
  select
    TaxYear as yr,
    COUNT(*) as return_count
  from tax2024.income
  group by  TaxYear
)
select
  yr,
  return_count,
  coalesce(lag(return_count) over (order by  yr), 0) as past_year,
  (return_count - coalesce(lag(return_count) over (order by yr), 0)) AS yoy_change,
  ROUND(
    100.0 * (return_count - coalesce(lag(return_count) over (order by yr), 0))
    / coalesce(lag(return_count) over (order by yr), 1), 0
  ) as yoy_change_pct
from yearly_change
order by  yr;



-- 11 Which ZIP codes stand out as outliers with unusually high tax per return?


select ZipCode ,
avg(TotalTaxLiability) as outliers
from tax2024.income
group by ZipCode
order by outliers desc; 



-- 12 What is the relationship between the number of returns filed and the amount of tax collected by county?
select county ,
count(*) as count_returns,
avg(TotalTaxLiability) as avg_tax_collected
from tax2024.income
group by county 
order by  count_returns desc, avg_tax_collected ;




-- 13 Which counties contribute disproportionately high tax revenue despite having relatively few returns?
WITH each_county AS (
  select
    county,
    COUNT(*) as total_returns,
    SUM(TotalTaxLiability) as total_tax_collected,
    avg(TotalTaxLiability) as avg_tax_per_return
  from tax2024.income
  group by county
)
select
  county,
  total_returns,
  total_tax_collected,
  ROUND(avg_tax_per_return, 2) AS avg_tax_per_return,
  total_returns / SUM(total_returns) over () as share_returns,
  total_tax_collected / SUM(total_tax_collected) over () as share_tax,
  ( total_tax_collected / SUM(total_tax_collected) over ())
  / ( total_returns       / SUM(total_returns) over ()) as impact_ratio
from each_county
order by impact_ratio DESC, total_tax_collected DESC;



-- 14 How does the average tax liability compare between the top 10 and bottom 10 ZIP codes?


select 
ZipCode,
count(*) as number_of_returns,
avg(TotalTaxLiability) as tax_liability_compare
from tax2024.income
group by ZipCode
order by tax_liability_compare desc
limit 20;
