with przychod as (
    select distinct id, partner, round(((oplata_za_usluge_procent * kwota_rekompensaty )/ 100) + ((oplata_za_usluge_prawnicza_procent * kwota_rekompensaty )/ 100),2) as przychod_id
    from wnioski
    where partner is null and date_part('year', data_utworzenia)<2019 and
      stan_wniosku ilike '%wyplacony%'
),
     przychod_bezpartnera as(
    select distinct id, partner, round(((oplata_za_usluge_procent * kwota_rekompensaty )/ 100) + ((oplata_za_usluge_prawnicza_procent * kwota_rekompensaty )/ 100),2) as przychod_id
    from wnioski
    where partner is not null and date_part('year', data_utworzenia)<2019 and
      stan_wniosku ilike '%wyplacony%'
     )
select partner,
       round(min(przychod_id),2) as minimalna_kwota,
       round(percentile_disc(0.25) within group ( order by przychod_id ),2) as pierwszy_kwartyl,
       round(avg(przychod_id),2) as srednia,
       round(percentile_disc(0.5) within group ( order by przychod_id ),2) as mediana,
       round(percentile_disc(0.75) within group ( order by przychod_id ),2) as trzeci_kwartyl,
       round(percentile_disc(0.99) within group ( order by przychod_id ) ,2) as "99 percentyl",
       round(max(przychod_id),2) as maksymalna_kwota,
       round(stddev(przychod_id),2) as std,
       count(id) as liczba_wnioskow
       from przychod
group by partner
union
select partner,
       round(min(przychod_id),2) as minimalna_kwota,
       round(percentile_disc(0.25) within group ( order by przychod_id ),2) as pierwszy_kwartyl,
       round(avg(przychod_id),2) as srednia,
       round(percentile_disc(0.5) within group ( order by przychod_id ),2) as mediana,
       round(percentile_disc(0.75) within group ( order by przychod_id ),2) as trzeci_kwartyl,
       round(percentile_disc(0.99) within group ( order by przychod_id ) ,2) as "99 percentyl",
       round(max(przychod_id),2) as maksymalna_kwota,
       round(stddev(przychod_id),2) as std,
       count(id) as liczba_wnioskow
       from przychod_bezpartnera
group by partner
order by partner;
