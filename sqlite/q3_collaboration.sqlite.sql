-- Find the ten latest collaborative releases. Only consider the releases with valid release date. Order the results by release date from newest to oldest, and then by release name alphabetically.

-- filter(release_info) x filter(release, id, name, artist_credit) x filter(artist_credit, artist_count>1)

select release_info.y || '-' || release_info.m || '-' || release_info.d as RELEASE_DATE, release.name as RELEASE_NAME, artist_credit.artist_count as ARTIST_COUNT 
from (
    select release, date_year as y, date_month as m, date_day as d from release_info 
    where date_year is not null and date_month is not null and date_day is not null
) release_info join (
    select release.id, release.name, release.artist_credit from release
) release
on release.id = release_info.release join (
    select id, artist_count from artist_credit where artist_count > 1
) artist_credit
on release.artist_credit = artist_credit.id
order by release_info.y desc, release_info.m desc, release_info.d desc, release.name asc limit 10;
