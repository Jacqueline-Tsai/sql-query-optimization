-- Find the 11 artists who released most christmas songs. For each artist, list their oldest five releases in November with valid release date. Organize the results by the number of each artist's christmas songs, highest to lowest. If two artists released the same number of christmas songs, order them alphabetically. After that, organize the release name alphabetically, and finally by the release date, oldest to newest.

select artist_name as ARTIST_NAME, release_name as RELEASE_NAME, (release_y || '-' || release_m || '-' || release_d) as RELEASE_DATE from (
    select top11_artist.id as artist_id, top11_artist.name as artist_name, top11_artist.christmas_count as artist_christmas_count, 
    release.y as release_y, release.m as release_m, release.d as release_d, release.name as release_name,
    rank() over (
        partition by top11_artist.id, top11_artist.name ORDER BY release.y asc, release.m asc, release.d asc
    ) as rank from (
        select artist.id, artist.name, count(release.id) as christmas_count from (
            select id, name, from artist where type in (
                select id from artist_type where name = 'Person'
            )
        ) artist join artist_credit_name on artist.id = artist_credit_name.artist join release on artist_credit_name.artist_credit = release.artist_credit 
        where lower(release.name) like '%christmas%' group by artist.id, artist.name order by count(release.id) desc, artist.name asc limit 11
    ) top11_artist join artist_credit_name on top11_artist.id = artist_credit_name.artist join (
        select distinct release.name as name, release.artist_credit as artist_credit, release_info.date_year as y, release_info.date_month as m, release_info.date_day as d from release join release_info on release.id = release_info.release where release_info.date_year is not null and release_info.date_month = 11 and release_info.date_day is not null
    ) release on artist_credit_name.artist_credit = release.artist_credit
) where rank <= 5 order by artist_christmas_count desc, artist_name asc, release_name asc, release_y asc, release_m asc, release_d asc;