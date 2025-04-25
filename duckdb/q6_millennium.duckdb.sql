-- Find the artists in the United States whose last release and second last release were both in 1999. Order the result by artist name, last release name, and second last release name alphabetically.

with artist_release_rank as (
    select *, rank() over (
        partition by artist_id order by release_y desc, release_m desc, release_d desc, release_name desc
    ) as rank from (
        select distinct artist.id as artist_id, artist.id as artist_id, artist.name as artist_name, release.name as release_name, release.y as release_y, release.m as release_m, release.d as release_d from (
            select * from artist where area in (
               select id from area where name = 'United States'
            )
        ) artist join artist_credit_name on artist.id = artist_credit_name.artist 
        join (
            select release.name as name, release.artist_credit as artist_credit, release_info.date_year as y, release_info.date_month as m, release_info.date_day as d 
            from release join release_info on release.id = release_info.release where release_info.date_year >= 1999 and release_info.date_month is not null and release_info.date_day is not null
        ) release 
        on artist_credit_name.artist_credit = release.artist_credit
    )
)

select a.artist_name as ARTIST_NAME, a.release_name as LAST_RELEASE_NAME, b.release_name as SECOND_LAST_RELEASE_NAME from (
    select artist_id, artist_name, release_name from artist_release_rank where rank = 1 and release_y = 1999
) a join (
    select artist_id, release_name from artist_release_rank where rank = 2 and release_y = 1999
) b on a.artist_id = b.artist_id
order by a.artist_name asc, a.release_name asc, b.release_name asc;