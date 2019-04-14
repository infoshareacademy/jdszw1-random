-- liczba wszystkich wnioskow
select count(*) from wnioski
-- liczba wyplaconych wnioskow
select count(*) from wnioski where stan_wniosku ilike '%wyplacony%'
-- liczba wnioskow wyplaconych z leadow
select count(*) from wnioski where stan_wniosku ilike '%wyplacony%' and partner is not null
-- liczba wszystkich leadow
select count(*) from m_lead
-- liczba wnioskow z leadow
select count(*) from wnioski where partner is not null
-- liczba wnioskow dla kazdego partnera
select partner, count(*) from wnioski group by partner having partner is not null
-- liczba wyplaconych wnioskow dla kazdego partnera
select partner, count(*) from wnioski group by partner, stan_wniosku having partner is not null and stan_wniosku ilike '%wyplacony%'
