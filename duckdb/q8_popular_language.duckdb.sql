-- For each area, find the language with most releases from the artists in that area. Only include the areas where the most popular language has minimum of 5000 releases (inclusive). Arrange the results in descending order based on the release count (per language per area), and in alphabetical order by area name.

-- count(language) (area x aritst x release x language) group by area.name

select area_name as AREA_NAME, language_name as LANGUAGE_NAME, release_count as RELEASE_COUNT from (
    select *, rank() over (
        partition by area_name order by release_count desc, area_name asc
    ) as rank from (
        select area.name as area_name, language.name as language_name, count(distinct release.id) as release_count
        from artist 
        join area on artist.area = area.id
        join artist_credit_name on artist.id = artist_credit_name.artist
        join release on artist_credit_name.artist_credit = release.artist_credit 
        join language on release.language = language.id 
        group by area.name, language.id, language.name
    ) where release_count >= 5000 -- and area_name = 'United States' and language_name = 'English'; -- order by count(language) desc, area.name asc limit 10;
) where rank = 1 order by release_count desc, area_name asc;