# 1. Top 5 Genres by Global Sales
select genre_name, sum(num_sales) as sales
from region_sales as reg
join game_platform as plt on reg.game_platform_id = plt.id 
join game_publisher as pub on plt.game_publisher_id = pub.id
join game as g on pub.game_id = g.id
join genre as gen on g.genre_id = gen.id
group by genre_id
order by sales desc
limit 5; 


# 2. Yearly Sales Trends per Region
select region_name, release_year, sum(num_sales) as sales
from region_sales as rs
join region as r on rs.region_id = r.id
join game_platform as plt on rs.game_platform_id = plt.id 
group by region_id, release_year
order by region_id, release_year, sales desc
;


# 3. Publishers with the Most Games in Each Genre
select publisher_name, genre_name, count(game_id) as game_count
from genre as gen
join game as g on gen.id = g.genre_id
join game_publisher as gp on g.id = gp.game_id
join publisher as pub on gp.publisher_id = pub.id
group by publisher_id, genre_id
order by publisher_id, genre_id desc;


# 4. Platforms with the Highest Sales in North America
with highest_sales as (
select region_name, platform_name, sum(num_sales) as sales
from region_sales as rs
join region as r on rs.region_id = r.id
join game_platform as gp on rs.game_platform_id = gp.id
join platform as plt on gp.platform_id = plt.id
group by region_id, platform_id
having region_name = 'North America'
order by sales desc
)
select platform_name, sales from highest_sales limit 10;


# 5. Average Sales per Genre in Japan
with average_sales as (
select genre_name, avg(num_sales) as sales
from region_sales as rs
join region as r on rs.region_id = r.id
join game_platform as plt on rs.game_platform_id = plt.id
join game_publisher as pub on plt.game_publisher_id = pub.id
join game as g on pub.game_id = g.id
join genre as gen on g.genre_id = gen.id
group by genre_id, r.region_name
having r.region_name = 'Japan'
)
select * from average_sales;


# 6. Top Publisher by Sales in Each Region
with top_publisher as (
select region_name, publisher_name, sum(num_sales) as sales,
rank() over(partition by region_id order by sum(num_sales) desc) as ranked
from region_sales as rs
join region as r on rs.region_id = r.id
join game_platform as plt on rs.game_platform_id = plt.id
join game_publisher as gp on plt.game_publisher_id = gp.id
join publisher as pub on gp.publisher_id = pub.id
join game as g on gp.game_id = g.id
join genre as gen on g.genre_id = gen.id
group by region_id, publisher_id
)
select * from top_publisher where ranked=1;

# 7. Year-over-Year Sales Growth by Platform
with sales_growth as (
select platform_name, release_year, sum(num_sales) as sales,
sum(num_sales)-lag(sum(num_sales)) over (partition by plt.id order by gp.release_year) as growth_over_prev_year_sales
from region_sales as r
join game_platform as gp on r.game_platform_id = gp.id
join platform as plt on gp.platform_id = plt.id
group by platform_id, release_year
order by platform_id, release_year
)
select platform_name, release_year, sales,
case
when growth_over_prev_year_sales is null then 0
else growth_over_prev_year_sales
end as growth
from sales_growth;


# 8. Genres with Consistent Sales Growth Over 3 Years
with sales_growth as (
select genre_name, release_year, sum(num_sales) as sales,
lag(sum(num_sales)) over (partition by gen.id order by plt.release_year) as prev_year_sales
from region_sales as rs
join region as r on rs.region_id = r.id
join game_platform as plt on rs.game_platform_id = plt.id
join game_publisher as pub on plt.game_publisher_id = pub.id
join game as g on pub.game_id = g.id
join genre as gen on g.genre_id = gen.id
group by gen.id, release_year
),
sales_growth2 as (
select genre_name, release_year, sales, prev_year_sales,
lag(prev_year_sales) over (partition by genre_name order by release_year) as prev_prev_year_sales
from sales_growth 
)
select genre_name, release_year, sales, prev_year_sales, prev_prev_year_sales
from sales_growth2
where sales > prev_year_sales
  and prev_year_sales > prev_prev_year_sales;

