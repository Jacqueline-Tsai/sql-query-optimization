-- Find all artists in the United States born on July 4th who ever released music in language other than English. List them in alphabetical order.

select distinct(name) from artist as ARTIST_NAME where type in (
    select id from artist_type where name = 'Person'
) and area in (
    select id from area where name = 'United States'
) and begin_date_month = 7 and begin_date_day = 4 and id in (
    select distinct(artist_credit_name.artist) from artist_credit_name 
    where artist_credit in (
        select distinct(artist_credit) from release where language not in (
            select id from language where name == 'English'
        )
    )
) order by name asc;