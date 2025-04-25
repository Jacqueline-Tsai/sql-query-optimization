-- Find the ten youngest collaborators of the Pittsburgh Symphony Orchestra. Exclude the Pittsburgh Symphony Orchestra itself from the final result. Organize the result by the collaborator's begin date, youngest to oldest, and then alphabetical order on their names. Only consider the artists with valid begin_date.

select name as COLLABORATOR_NAME, begin_date_year || '-' || begin_date_month || '-' || begin_date_day as BEGIN_DATE from artist where id in (
    select distinct artist from artist_credit_name where artist_credit in (
        select artist_credit from artist_credit_name where artist in (
            select id from artist where name = 'Pittsburgh Symphony Orchestra'
        )
    )
) and name != 'Pittsburgh Symphony Orchestra' and begin_date_year is not null and begin_date_month is not null and begin_date_day is not null
order by begin_date_year desc, begin_date_month desc, begin_date_day desc, name asc limit 10;
