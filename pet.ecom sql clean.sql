
-- How are Revenue, Orders, AOV, GM% trending MTD/QTD/YTD vs last year?

 -- Which stores over- or under-performed this week and this month?

-- What days of the week consistently miss targets?

-- Which categories drove the most revenue and margin this month?

-- What’s our top 10 SKUs by revenue and by margin in the last 30 days?

-- Are we shifting toward higher or lower margin products vs last month?

-- Which SKUs are high units but low margin (profit leaks)?






SELECT * FROM pet.ecommerce;

update pet.ecommerce
set campaign = case
when campaign = 'clearance' then 'CLEARANCE' 
when campaign =   "VIP LAUNCH" then  'VIP LAUNCH'
when campaign = 'vip launch' then 'VIP LAUNCH'
when campaign =  'ADOPT-A-THON' then 'Adopt-A-Thon'
when campaign = "Summer Splash" then 'Summer Splash'
when campaign = "BACK TO SCHOOL"  then 'Back To School'
when campaign = "Spring Paws" then 'Spring Paws'
when campaign = 'holiday tails' then 'Hoiliday Tails'
when campaign = 'VIP LÃ¡unch' then 'Vip Launch'
when campaign = 'FALL FURBALL' then 'Fall Furball'
else campaign 
end;


SELECT campaign
FROM pet.ecommerce
WHERE campaign IN (
    'clearance', 'vip launch', 'VIP LAUNCH', 'VIP LÃ¡unch',
    'ADOPT-A-THON', 'Summer Splash', 'BACK TO SCHOOL',
    'Spring Paws', 'holiday tails', 'FALL FURBALL'
);



SELECT campaign,
  case
when campaign = 'clearance' then 'CLEARANCE' 
when campaign =   "VIP LAUNCH" then  'VIP LAUNCH'
when campaign = 'vip launch' then 'VIP LAUNCH'
when campaign =  'ADOPT-A-THON' then 'Adopt-A-Thon'
when campaign = "Summer Splash" then 'Summer Splash'
when campaign = "BACK TO SCHOOL"  then 'Back To School'
when campaign = "Spring Paws" then 'Spring Paws'
when campaign = 'holiday tails' then 'Hoiliday Tails'
when campaign = 'VIP LÃ¡unch' then 'Vip Launch'
when campaign = 'FALL FURBALL' then 'Fall Furball'
else campaign 
end as cleaned_campaign
from pet.ecommerce;



select *
from pet.ecommerce;

update pet.ecommerce
set campaign = case
when lower( channel)  like  '%display%' then 'Display'
when lower( channel)   like '%social%' then 'Social'  
when lower( channel)  like '%email%' then 'Email'
when lower( channel)  like '%influencer%'  then 'Influencer'
when lower( channel)  like '%search%' then 'Search'
when lower( channel)  like '%referr%'  then 'Referral'
when lower( channel)  like '%sms%'  then 'SMS'
when lower( channel)  like '%affiliat%' then 'Affiliate'
when lower( channel)  like '%DisplÃ¡y%' then 'Display'
when lower (channel) like  '% SeÃ¡rch%' then 'search'
when lower (channel) like  '% emÃ¡il%' then 'Email'
when lower (channel) like '%AffiliÃ¡te%' then 'Affiliate'
else channel
end;




select channel ,
 case 
 when lower( channel)  like  '%display%' then 'Display'
when lower( channel)   like '%social%' then 'Social'  
when lower( channel)  like '%email%' then 'Email'
when lower( channel)  like '%influencer%'  then 'Influencer'
when lower( channel)  like '%search%' then 'Search'
when lower( channel)  like '%referr%'  then 'Referral'
when lower( channel)  like '%sms%'  then 'SMS'
when lower( channel)  like '%affiliat%' then 'Affiliate'
when lower( channel)  like '%DisplÃ¡y%' then 'Display'
when lower (channel) like  '% SeÃ¡rch%' then 'search'
when lower (channel) like  '% emÃ¡il%' then 'Email'
when lower (channel) like '%AffiliÃ¡te%' then 'Affiliate'
end as clean_channel
from pet.ecommerce;


select * 
from  pet.ecommerce;

alter table pet.ecommerce
drop column city;


select state ,count(*) as state_count
from pet.ecommerce
group by state 
order by state_count desc , state;


update pet.ecommerce
set state = nullif(upper(trim(state)), '.');

update pet.ecommerce
set state = null
where state = '';

update pet.ecommerce set state = 'CA' where state = 'CALIFORNIA';
update pet.ecommerce set state = 'WA' where state = 'WASHINGTON';
update pet.ecommerce set state = 'TX' where state = 'TEXAS';
update pet.ecommerce set state = 'IL' where state = 'ILL';


select * 
from  pet.ecommerce;

update pet.ecommerce
set state = TRIM(state);



UPDATE pet.ecommerce
SET date = COALESCE(
  STR_TO_DATE(date, '%b %d, %Y'),  
  STR_TO_DATE(date, '%d/%m/%Y')    
);




update pet.ecommerce
set spend = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(spend ,'$', ''),',',''), 'USD', ''), 'â€“', ''));

-- How are Revenue, Orders, AOV, GM% trending MTD/QTD/YTD vs last year?

select 
sum(spend) as revenue,
sum(signups) as orders,
sum(spend) / nullif (sum(signups),0) as aov
from pet.ecommerce
where date between '2025 -09-01' and current_date;


 -- Which stores over- or under-performed this week and this month?
select 
state,
sum(spend)as revenue,
sum(spend) - lag(sum(spend)) over (partition by state order by week) as performed
from pet.ecommerce
group by  state , yearweek(date);

-- What days of the week consistently miss targets?

-- Which categories drove the most revenue 
select 
dayname(date) as weekday,
round(avg(spend),2) as avg_rev,
case 
when 
avg(spend) < 1000 then'miss'
end as performance
from pet.ecommerce
group by dayname(date)
order by avg_rev;


 -- Which categories drove the most revenue and margin this month?
select 
campaign,
sum(spend) as rev
from pet.ecommerce
where date >= date_format(curdate(), '%y-%m-01')
group by campaign
order by rev desc;
-- What’s our top 10 SKUs by revenue and by margin in the last 30 days?
select 
campaign,
sum(spend) as rev
from pet.ecommerce
where date >= curdate()- interval 30 day
group by campaign
order by rev 
limit 10;
-- Are we shifting toward higher or lower margin products vs last month?
select 
campaign ,
sum(spend) as rev,
sum(spend) / nullif(sum(signups),0) as this_month
from pet.ecommerce
where date >= date_format(curdate(), '%y-%m-01')
group by campaign
order by this_Month;

select 
campaign ,
sum(spend) as rev,
sum(signups) as orders,
sum(spend) / nullif(sum(signups),0) as last_month
from pet.ecommerce
where date between date_format(curdate() - interval 1 month ,'%y-%m-01')
     and last_day(curdate() - interval 1 month)
group by campaign
order by last_month desc;





-- Which SKUs are high units but low margin (profit leaks)?



select 
campaign as sku,
sum(signups)as units,
sum(spend) as rev,
round(sum(spend) / nullif(sum(signups),0), 2) as aov
from pet.ecommerce
group by campaign
having sum(signups) > (select avg(signups) from pet.ecommerce) 
and (sum(spend) / nullif(sum(signups),0)) <
(select avg(spend/signups) from pet.ecommerce 
where signups > 0)
order by units desc