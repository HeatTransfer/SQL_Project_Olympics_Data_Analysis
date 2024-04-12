-- Query 11: Fetch top 5 athletes who won most gold medals
with cte_out as
(
	with cte_in as 
	(
		select name,team,count(medal) as gold_medal_won
		from olympic_db.athlete_events 
		where medal = 'gold'
		group by name, team
		order by gold_medal_won desc
	)
	select *, dense_rank() over (order by gold_medal_won desc) as d_rank from cte_in
)
select * from cte_out where d_rank <= 5;
-- #####################################################################
with cte1 as 
(
	select name,team,count(medal) as gold_medal_won
	from olympic_db.athlete_events
	where medal = 'gold'
	group by name, team
),
cte2 as
(
	select *, dense_rank() over (order by gold_medal_won desc) as d_rank 
    from cte1
)
select name, team, gold_medal_won from cte2
where cte2.d_rank <= 5;

-- Query 12: Fetch top 5 athletes who won most medals(gold/silver/bronze)
with cte1 as 
(
	select name,team,count(medal) as medals_won
	from olympic_db.athlete_events
	where medal <> 'na'
	group by name, team
),
cte2 as
(
	select *, dense_rank() over (order by medals_won desc) as d_rank 
    from cte1
)
select name, team, medals_won from cte2
where cte2.d_rank <= 5;

-- Query 13: Fetch top 5 most successful countries in olympics.
with cte1 as 
(
	select nr.region as country,count(medal) as total_medals
	from olympic_db.athlete_events ae
    join olympic_db.noc_regions nr using(noc)
	where medal <> 'na'
	group by country
),
cte2 as
(
	select *, dense_rank() over (order by total_medals desc) as d_rank 
    from cte1
)
select country, total_medals from cte2
where cte2.d_rank <= 5;

-- Query 14: List down total gold, silver, bronze medals won by each country
with cte as
(
	select * from 
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
order by gold_medals desc;

-- Query 15: List down total gold, silver, bronze medals won by each country corresponding to 
--           each olympic games.
with cte as 
(
	select games, nr.region as country, medal
    from olympic_db.athlete_events ae 
    join olympic_db.noc_regions nr using(noc)
	where medal <> 'NA'
)
select games, country, 
	   sum(
			case when medal = 'gold' then 1 else 0 end
       ) as gold,
       sum(
			case when medal = 'silver' then 1 else 0 end
       ) as silver,
       sum(
			case when medal = 'bronze' then 1 else 0 end
       ) as bronze
from cte
group by games, country
order by games, country;