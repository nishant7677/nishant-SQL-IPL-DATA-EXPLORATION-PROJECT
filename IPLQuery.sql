select * from tutorial..ipl;
select * from tutorial..iplmatches;

-- Q-1 Number of matches per season
select yr, count(distinct id) no_of_matches_per_season from
(select year(date) yr, id from tutorial..iplmatches)a
group by yr;


-- Q-2 Highest man of the match won by players
select player_of_match, count(player_of_match) mom
from tutorial..iplmatches 
group by player_of_match
order by mom desc;


-- Q-3 most player of the match per season
select * from
(select player_of_match, yr, mom, rank() over(partition by yr order by mom desc) rnk from
(
select player_of_match, year(date) yr, count(player_of_match) mom
from tutorial..iplmatches
group by player_of_match, year(date))a)b
where rnk = 1;


-- Q-4 no of matches won by teams
select winner, count(winner) no_of_matches_won
from tutorial..iplmatches
group by winner;


-- Q-5 top 5 venues where match is played
select top 5 venue,count(venue) no_of_matches
from tutorial..iplmatches
group by venue
order by count(venue) desc;


-- Q-6 Most runs by batsman in ipl
select top 1 batsman, count(total_runs) total_runs
from tutorial..ipl
group by batsman
order by count(total_runs) desc;

-- Q-7 Percentage of total runs scored by each batsman
select *,
total_runs / sum(total_runs)  over (order by total_runs rows between unbounded preceding and unbounded following) runs from
(select batsman, sum(total_runs) total_runs from tutorial..ipl
group by batsman)a;

-- Q-8 Most number of sixes scored by a batsman
select top 1 batsman, count(batsman) most_no_of_sixes from
(select * from ipl where batsman_runs = 6)a
group by batsman
order by count(batsman) desc;

-- Q-9 Most number of fours scored by a batsman
select top 1 batsman, count(batsman) most_no_of_fours from
(select * from ipl where batsman_runs = 4)a
group by batsman
order by count(batsman) desc;

-- Q-10 3000 runs club and highest strike rate
select top 1 batsman, batsman_runs, strike_rate from
(select batsman,batsman_runs, ((batsman_runs*1.0)/total_balls)*100 strike_rate from
(select batsman, sum(batsman_runs) batsman_runs, count(batsman) total_balls from ipl group by batsman)a)b
where batsman_runs >= 3000
order by strike_rate desc

-- Q-11 lowest economy rate for the bowler who has bowled at least 50 overs
select top 1 bowler, (total_runs_conceded/(total_balls*1.0)) economy_rate from
(select bowler, count(bowler) total_balls, sum(total_runs) total_runs_conceded
from ipl
group by bowler)a
where total_balls > 300
order by economy_rate asc