--Query 14 Olympics Dataset
--Unpivot
--List down total gold, silver and bronze medals won by each country
-----First make data into appropriate coloumns like main table then apply pivot

with main
as
(
    select nr.region as country,medal,count(medal) as total_medals
    from olympics_history oh
    join olympics_history_noc_regions nr
    on nr.noc= oh.noc
    where medal<>'NA'
    group by nr.region,medal
    order by nr.region,medal
),
piv
as
  (
     select *
     from main
           pivot
               ( 
                    sum(total_medals)
                    for medal
                    in ('Gold' gold,'Silver' silver,'Bronze' bronze)
              )
  ),
pivot_data
as
(
  select * from piv 
)
select country,nvl(gold,0) gold,nvl(silver,0) silver,nvl(bronze,0) bronze
from pivot_data 
order by gold desc;





--15.List down total gold, silver and bronze medals won by each country corresponding to each olympic games.

with main
as
(
    select nr.region as country,games,medal,count(medal) as total_medals
    from olympics_history oh
    join olympics_history_noc_regions nr
    on nr.noc= oh.noc
    where medal<>'NA'
    group by nr.region,medal,games
    order by nr.region,medal
),
piv
as
  (
     select *
     from main
           pivot
               ( 
                    sum(total_medals)
                    for medal
                    in ('Gold' gold,'Silver' silver,'Bronze' bronze)
              )
  ),
pivot_data
as
(
  select * from piv 
)
select games,country,nvl(gold,0) gold,nvl(silver,0) silver,nvl(bronze,0) bronze
from pivot_data 
order by games,country,gold desc;


--16.Identify which country won the most gold, most silver and most bronze medals in each olympic games.
-- main use of First_Value over max function is max will give you max number but First value will give you corresponding value of max data see
-- last line we wanted country corresponding to max gold, So we used First value here.
with main
as
(
    select nr.region as country,games,medal,count(medal) as total_medals
    from olympics_history oh
    join olympics_history_noc_regions nr
    on nr.noc= oh.noc
    where medal<>'NA'
    group by nr.region,medal,games
    order by nr.region,medal
),
piv
as
  (
     select *
     from main
           pivot
               ( 
                    sum(total_medals)
                    for medal
                    in ('Gold' gold,'Silver' silver,'Bronze' bronze)
              )
  ),
pivot_data
as
(
  select games,country,nvl(gold,0) gold,nvl(silver,0) silver,nvl(bronze,0) bronze from piv 
)
select distinct games,
FIRST_VALUE(gold) over(partition by games order by gold desc) as gold,
FIRST_VALUE(country) over(partition by games order by gold desc) as gold_country,
FIRST_VALUE(silver) over(partition by games order by silver desc) as silver,
FIRST_VALUE(country) over(partition by games order by silver desc) as silver_country,
FIRST_VALUE(bronze) over(partition by games order by bronze desc) as bronze,
FIRST_VALUE(country) over(partition by games order by bronze desc) as bronze_country
from pivot_data 
order by games,gold desc;

--17.Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.

with main
as
(
    select nr.region as country,games,medal,count(medal) as total_medals
    from olympics_history oh
    join olympics_history_noc_regions nr
    on nr.noc= oh.noc
    where medal<>'NA'
    group by nr.region,medal,games
    order by nr.region,medal
),
piv
as
  (
     select *
     from main
           pivot
               ( 
                    sum(total_medals)
                    for medal
                    in ('Gold' gold,'Silver' silver,'Bronze' bronze)
              )
  ),
pivot_data
as
(
  select games,country,nvl(gold,0) gold,nvl(silver,0) silver,nvl(bronze,0) bronze from piv 
)
select distinct games,
FIRST_VALUE(gold) over(partition by games order by gold desc) as gold,
FIRST_VALUE(country) over(partition by games order by gold desc) as gold_country,
FIRST_VALUE(silver) over(partition by games order by silver desc) as silver,
FIRST_VALUE(country) over(partition by games order by silver desc) as silver_country,
FIRST_VALUE(bronze) over(partition by games order by bronze desc) as bronze,
FIRST_VALUE(country) over(partition by games order by bronze desc) as bronze_country,
FIRST_VALUE(gold+silver+bronze) over(partition by games  order by gold+silver+bronze desc )as max_medal,
FIRST_VALUE(country) over(partition by games  order by gold+silver+bronze desc )as max_medal_country
from pivot_data 
order by games,gold desc;



--18.Which countries have never won gold medal but have won silver/bronze medals?

with main
as
(
    select nr.region as country,medal,count(medal) as total_medals
    from olympics_history oh
    join olympics_history_noc_regions nr
    on nr.noc= oh.noc
    where medal<>'NA'
    group by nr.region,medal
    order by nr.region,medal
),
piv
as
  (
     select *
     from main
           pivot
               ( 
                    sum(total_medals)
                    for medal
                    in ('Gold' gold,'Silver' silver,'Bronze' bronze)
              )
  ),
pivot_data
as
(
  select country,nvl(gold,0) gold,nvl(silver,0) silver,nvl(bronze,0) bronze from piv 
)
select * from pivot_data
where gold=0 and (silver!=0 or bronze!=0)
order by gold,silver desc,bronze desc;

--19.In which Sport/event, India has won highest medals

select nr.region as country,sport,count(medal) as total_medals
from olympics_history oh
join olympics_history_noc_regions nr
on nr.noc= oh.noc
where nr.region='India' and medal<>'NA'
group by nr.region,sport
order by nr.region ;


--20.Break down all olympic games where India won medal for Hockey and how many medals in each olympic games
select nr.region as country,sport,games,count(medal) as total_medals
from olympics_history oh
join olympics_history_noc_regions nr
on nr.noc= oh.noc
where nr.region='India' and medal<>'NA'
group by nr.region,sport,games
order by count(medal) desc ;