use forensics;


-- 1. Cumulative number of catastrophes in each country sorted alphabetically.
select E.country, count(event_id) as num_events
from CountryRef
         join Events E on CountryRef.country = E.country
group by E.country
order by E.country;


-- 2. Partial sums of victims in all natural catastrophes taken together in last 100 years.
-- resources: https://www.sqlindia.com/calculate-cumulative-sum-of-previous-rows-sql-server/
with T1 as (
    select E.name, E.date, count(PM.post_mortem_id) as num_victims
    from Events E
             join PostMortems PM on E.event_id = PM.event_id
    where E.date > dateadd(year, -100, getdate())
    group by E.name, E.date
)
select T2.name, (select sum(T1.num_victims) from T1 where T1.date <= T2.date) as total
from T1 as T2
order by T2.date;


-- 3. List of anthropologists who work on identifying above-average number of victims
select A.first_name, A.last_name, count(post_mortem_id) as post_moretem_count
from Anthropologists A
         join PostMortems PM on A.anthropologist_id = PM.created_by_id
group by A.first_name, A.last_name
having count(post_mortem_id) > (
    select avg(reports_per_anthro) as avg_reporst_per_anthro
    from (select count(Pm.created_by_id) as reports_per_anthro
          from PostMortems PM
          group by PM.created_by_id) _
);


-- 4. List of institutions which anthropologist worked on at least two catastrophes
select I.name, count(distinct E.event_id) as event_count
from Institutions I
         join Anthropologists A on I.institution_id = A.affiliation_id
         join PostMortems PM on A.anthropologist_id = PM.created_by_id
         join Events E on PM.event_id = E.event_id
group by I.name
having count(distinct E.event_id) > 1;


-- 5. List of victims found with no items
select *
from PostMortems pm
where not exists(select * from PostMortems_Items pmi where pm.post_mortem_id = pmi.post_mortem_id);