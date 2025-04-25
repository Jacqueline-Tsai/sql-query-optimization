-- Find all releases before 1950 (inclusive) created by artists from multiple areas. Exclude if at least one of its artists are from the United States. For each release, print the release name, year, the number of distinct areas where its artists are from, and the list of area names in alphabetical order, separated by commas. Order the result by the area count, highest to lowest, and then by the release year, oldest to newest, and then by the release name alphabetically.

with release_area as (
    select release.id as release_id, release.name as release_name, release.year as release_year, area.name as artist_area from (
        select release.id as id, release.name as name, release.artist_credit as artist_credit, release_info.date_year as year from release join release_info on release.id = release_info.release where date_year <= 1950
    ) release join artist_credit_name on release.artist_credit = artist_credit_name.artist_credit
    join artist on artist_credit_name.artist = artist.id
    join area on artist.area = area.id
    order by release.name asc
)

select release_name as RELEASE_NAME, release_year as RELEASE_YEAR, area_count as ARTIST_AREA_COUNT, artist_areas as ARTIST_AREA_NAMES from (
    select release_id, release_name, release_year, count(distinct artist_area) as area_count, 
    STRING_AGG(distinct artist_area, ',' order by artist_area asc) as artist_areas
    from release_area group by release_id, release_name, release_year
) where area_count > 1 and release_id not in (
    select release_id from release_area where artist_area = 'United States'
) order by area_count desc, release_year asc, release_name asc;