-- Query 1: How many olympic games have been held?
select count(distinct games) as total_olympics from olympic_db.athlete_events;
-- Query 2: List down all Olympics games held so far.
select distinct year, season, city
from olympic_db.athlete_events
order by year;
-- Query 3: Mention the total no of nations who participated in each olympics game?
select games, count(distinct nr.region) as total_countries
from olympic_db.athlete_events ae
join olympic_db.noc_regions nr using(noc)
group by games 
order by games;
-- Query 4: Which year saw the highest and lowest no of countries participating in olympics?
with cte as
(
	select games, count(distinct nr.region) as total_countries
	from olympic_db.athlete_events ae
	join olympic_db.noc_regions nr using(noc)
	group by games 
	order by total_countries
)
select distinct concat(first_value(games) over(),
	   "-",
       first_value(total_countries) over()) as lowest_countries,
       concat(last_value(games) over(),
	   "-",
       last_value(total_countries) over()) as highest_countries
from cte;

-- Query 5: Which nations have participated in all of the olympic games?
select nr.region as country, 
	   count(distinct games) as total_participated_games
from olympic_db.athlete_events ae 
join olympic_db.noc_regions nr using(noc)
group by country
having total_participated_games in (select count(distinct games) from athlete_events);