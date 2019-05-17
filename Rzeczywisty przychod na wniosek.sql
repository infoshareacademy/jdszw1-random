select distinct w. partner, round(sum((((w.oplata_za_usluge_procent * w.kwota_rekompensaty)+(oplata_za_usluge_prawnicza_procent * w.kwota_rekompensaty))/100)),2)
    as laczny_przychod, sum(w.kwota_rekompensaty) as kwotarekompensaty,
                round(sum(((w.oplata_za_usluge_procent * w.kwota_rekompensaty )/ 100))*100/(select round(sum(((w.oplata_za_usluge_procent * w.kwota_rekompensaty )/ 100)),2)
                    from wnioski w
                    where  partner is not null and date_part('year', w.data_utworzenia)<2019 and w.stan_wniosku ilike '%wyplacony%'),1) as procentzpartnera,
                count(*) as "liczbawnioskow", round((sum((((w.oplata_za_usluge_procent * w.kwota_rekompensaty)+(oplata_za_usluge_prawnicza_procent * w.kwota_rekompensaty))/100)) / count(*)),2) as "przychod_na_wniosek"
from wnioski w
where w.partner is not null and date_part('year', w.data_utworzenia)<2019 and
      w.stan_wniosku ilike '%wyplacony%'
group by w. partner
order by laczny_przychod desc;
