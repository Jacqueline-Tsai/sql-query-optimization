-- For each decade from 1950s to 2010s (inclusive), count the number of non-US artists who has a US release in the same decade with their retirement. Order the result by decade, from oldest to newest.

-- artist x artist_credit_name x release x release_info

select artist_retire_decade, count(*) from (
    select distinct artist.retire_decade as artist_retire_decade, artist.id as artist_id from (
        select artist.id as id, (artist.end_date_year - (artist.end_date_year % 10))::VARCHAR || 's' as retire_decade 
        from artist join area on artist.area = area.id where area.name != 'United States' and artist.end_date_year >= 1950 and artist.end_date_year < 2020
    ) artist
    join artist_credit_name on artist.id = artist_credit_name.artist
    join (
        select release.id as id, release.artist_credit as artist_credit, (release_info.date_year - (release_info.date_year % 10))::VARCHAR || 's' as decade
        from release join release_info on release.id = release_info.release join area on release_info.area = area.id
        where area.name = 'United States' and release_info.date_year >= 1950 and release_info.date_year < 2020
    ) release on artist_credit_name.artist_credit = release.artist_credit
    where artist.retire_decade = release.decade
) group by artist_retire_decade order by artist_retire_decade;