-- List all the artist types ordered alphabetically.

-- filter(medium, name='CD) x medium_formar x release

with medium_release as (
    select medium_format.id as medium_format_id, medium_format.name as medium_format_name, release.name as release_name, length(release.name) as release_name_len
    from medium_format join medium on medium_format.id = medium.format 
    join release on medium.release = release.id where medium_format.name like '%CD%'
)

select distinct medium_release.medium_format_name as FORMAT_NAME, medium_release.release_name as RELEASE_NAME from medium_release join (
    select medium_format_id, medium_format_name, max(release_name_len) as max_release_name_len from medium_release group by medium_format_id, medium_format_name
) max_release_name on medium_release.medium_format_id = max_release_name.medium_format_id and medium_release.release_name_len = max_release_name.max_release_name_len
order by medium_release.medium_format_name asc, medium_release.release_name asc;