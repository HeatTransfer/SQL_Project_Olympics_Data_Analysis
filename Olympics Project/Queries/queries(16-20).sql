-- Query 16: Identify countries which won most gold, silver and bronze in each olympic games
/*
------------|-----------------|-------------------|-------------------|
games       |     max_gold    |     max_silver    |     max_bronze    |
----------------------------------------------------------------------|
1896 Summer       Germany-25        Greece-18           Greece-20 
1900 Summer       UK-59             France-101          France-82
1904 Summer       USA-128           USA-141             USA-125
1906 Summer       Greece-24         Greece-48           Greece-30
...               ...               ...                 ...
*/
with cte_out as
(
	with cte as
	(
		select games, region, medal from 
		olympic_db.athlete_events ae 
		join olympic_db.noc_regions nr using(noc)
		where medal <> 'NA'
	)
	select games, region as country,
		   sum(
				case when medal = 'gold' then 1 else 0 end
		   ) as gold_medals,
		   sum(
				case when medal = 'silver' then 1 else 0 end
		   ) as silver_medals,
		   sum(
				case when medal = 'bronze' then 1 else 0 end
		   ) as bronze_medals
	from cte
	group by games, country
	order by games
)
select distinct games,
	   concat(
       first_value(country) over(partition by games order by gold_medals desc),
       "-",
	   first_value(gold_medals) over(partition by games order by gold_medals desc)
       ) as max_gold,
       concat(
       first_value(country) over(partition by games order by silver_medals desc),
       "-",
       first_value(silver_medals) over(partition by games order by silver_medals desc)
       ) as max_silver,
       concat(
       first_value(country) over(partition by games order by bronze_medals desc),
       "-",
       first_value(bronze_medals) over(partition by games order by bronze_medals desc)
       )  as max_bronze     
from cte_out;

-- Query 17: Identify which country won the most gold, most silver, most bronze medals 
--           and the most medals in each olympic games.
with cte_out as
(
	with cte as
	(
		select games, region, medal from 
		olympic_db.athlete_events ae 
		join olympic_db.noc_regions nr using(noc)
		where medal <> 'NA'
	)
	select games, region as country,
		   sum(
				case when medal = 'gold' then 1 else 0 end
		   ) as gold_medals,
		   sum(
				case when medal = 'silver' then 1 else 0 end
		   ) as silver_medals,
		   sum(
				case when medal = 'bronze' then 1 else 0 end
		   ) as bronze_medals,
           sum(
				case when medal in ('gold','silver','bronze') then 1 else 0 end
           ) as total_medals
	from cte
	group by games, country
	order by games
)
select distinct games,
	   concat(
       first_value(country) over(partition by games order by gold_medals desc),
       "-",
	   first_value(gold_medals) over(partition by games order by gold_medals desc)
       ) as max_gold,
       concat(
       first_value(country) over(partition by games order by silver_medals desc),
       "-",
       first_value(silver_medals) over(partition by games order by silver_medals desc)
       ) as max_silver,
       concat(
       first_value(country) over(partition by games order by bronze_medals desc),
       "-",
       first_value(bronze_medals) over(partition by games order by bronze_medals desc)
       )  as max_bronze,
       concat(
       first_value(country) over(partition by games order by total_medals desc),
       "-",
	   first_value(total_medals) over(partition by games order by total_medals desc)
       ) as max_medals
from cte_out;

-- Query 18: Which countries have never won gold medal but have won silver/bronze medals?
with cte_out as
(
	with cte as
	(
		select region, medal from 
		olympic_db.athlete_events ae 
		join olympic_db.noc_regions nr using(noc)
		where medal <> 'NA'
	)
	select region as country,
		   sum(
				case when medal = 'gold' then 1 else 0 end
		   ) as gold_medals,
		   sum(
				case when medal = 'silver' then 1 else 0 end
		   ) as silver_medals,
		   sum(
				case when medal = 'bronze' then 1 else 0 end
		   ) as bronze_medals
	from cte
	group by country
	order by country
)
select * from cte_out
where gold_medals = 0 and (silver_medals > 0 or bronze_medals > 0)
order by bronze_medals desc;

-- Query 19: In which Sport/event, India has won highest medals?
with cte as
(
	select noc,sport,medal
	from olympic_db.athlete_events
	where medal <> 'na'
	and
	noc in (select noc from olympic_db.noc_regions where region = 'India')
)
select sport, count(1) as total_medal
from cte 
group by sport
order by total_medal desc
limit 1;

-- Query 20: Break down all olympic games where India won medal for Hockey and 
--           how many medals in each olympic games.
select team,games,count(1) as medals_won
from olympic_db.athlete_events
where medal <> 'na' and sport = 'Hockey' and
noc in (select noc from olympic_db.noc_regions where region = 'India')
group by team, games
order by medals_won desc;