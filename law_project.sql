SELECT * FROM law.law;

--

 -- 1 Which lawyers have the highest total billable hours?
 
 select LawyerAssigned , sum(BillableHours) as high_bill 
 from law.law
 group by LawyerAssigned
 order by high_bill desc;
 
 
 -- 2 what is the average invoice amount per case type?
 
 select casetype, avg(InvoiceAmount) as normal_amount
 from law.law
 group by casetype
 order by normal_amount ;



-- 3 Which clients have generated the highest total billing?

select ClientName , sum(InvoiceAmount) as high_total
from law.law
group by ClientName
order by high_total 
limit 15;

-- 4  how do case statuses translate into simplified categories, and how are they 
-- distributed across different case types and assigned lawyers?
select casetype, LawyerAssigned,
case
  when CaseStatus = 'pending' then  'TBA'
  when CaseStatus = 'open' then 'in progress'
  when  CaseStatus = 'applealed' then 'reviewed'
  else 'close'
  end as status_update
  from law.law;
  
  
  
  -- 5 for each lawyer, how often does the actual invoice amount deviate from the expected value
-- (BillableHours × HourlyRate), and what is the average deviation?



select * from law.law;

select LawyerAssigned,
avg(HourlyRate) as avg_hour,
sum(BillableHours) as high_bill,
avg(InvoiceAmount - (BillableHours * HourlyRate)) as deviation
from law.law
where lawyerAssigned is not null 
and Billablehours is not null 
group by LawyerAssigned
order by deviation desc;




-- 6 How many cases are in each status, and are there inconsistencies?
update law.law
set CaseStatus = case
when  CaseStatus =  'opel' then 'open'
when CaseStatus = 'pendinl' then 'pending'
when CaseStatus = 'pendind' then 'pending'
when CaseStatus = 'apppeale' then 'appealed'
end
where CaseStatus in( 'opel','pendinl','pendind','apppeale');


select count(*) as total_case
from law.law
group by CaseStatus
order by total_case desc;

