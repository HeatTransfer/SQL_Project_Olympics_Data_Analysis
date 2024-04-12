-- Query 6: sports which were played in all the summer games
with cte1 as
(
	select count(distinct games) as total_summer_games 
    from olympic_db.athlete_events
	where season = 'summer'
),
cte2 as
(
	select distinct games, sport
    from olympic_db.athlete_events
    where season = 'summer'
    order by games
),
cte3 as
(
	select sport, count(games) as no_of_games
    from cte2
    group by sport
)
select * from cte3
join cte1
on cte1.total_summer_games = cte3.no_of_games;

-- Query:7 Which Sports were just played only once in the olympics?
with cte1 as
(
	select distinct games, sport
	from olympic_db.athlete_events
),
cte2 as
(
	select sport, count(1) as no_of_games
	from cte1
	group by sport
)
select cte2.*, cte1.games
from cte2
join cte1 on cte1.sport = cte2.sport
where cte2.no_of_games = 1
order by cte1.sport;

-- Query 8: Fetch the total no of sports played in each olympic games.
select distinct games, count(distinct sport) as total_sports_played
from olympic_db.athlete_events
group by games;

-- Query 9: Fetch oldest athletes to win a gold medal.
with cte as
(select * from olympic_db.athlete_events
where medal = 'gold' and age <> 'na')
select * from cte
where age in (select max(age) from cte);

-- Query 10: Find the Ratio of male and female athletes participated in all olympic games.
with cte as
(
	select sex, count(1) as cnt
	from olympic_db.athlete_events
	group by sex
),
f_count as (select cnt from cte where sex='F'),
m_count as (select cnt from cte where sex='M')
select concat('1', '/', round((m_count.cnt/f_count.cnt),2)) as sex_ratio 
from f_count, m_count;
