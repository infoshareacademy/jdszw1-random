select count(stan_wniosku) from wnioski
where stan_wniosku not ilike ('%odrzucony%') and stan_wniosku is not null;

select count(stan_wniosku) from wnioski
where stan_wniosku ilike ('%wyplacony%') and stan_wniosku is not null ;

select count(id) from rekompensaty
                      --szczegoly_rekompensat
where id is not null;

select count(status) from analizy_wnioskow
where status ilike '%zaakceptowany' and status is not null;

select w. partner, w.kwota_rekompensaty, w.kwota_rekompensaty_oryginalna, sr.kwota,
       ((w.oplata_za_usluge_procent * w.kwota_rekompensaty )/ 100) as przychod from wnioski w
inner join rekompensaty r on w.id = r.id_wniosku
inner join szczegoly_rekompensat sr on r.id = sr.id_rekompensaty
where w.partner is not null and date_part('year', w.data_utworzenia)<2019 and
      w.stan_wniosku ilike '%wyplacony%'
group by w. partner, w.kwota_rekompensaty, w.kwota_rekompensaty_oryginalna, sr.kwota, przychod;


select distinct w. partner, round(sum(((w.oplata_za_usluge_procent * w.kwota_rekompensaty )/ 100)),2)
    as przychodzpartnera, sum(w.kwota_rekompensaty) as kwotarekompensaty,
                round(sum(((w.oplata_za_usluge_procent * w.kwota_rekompensaty )/ 100))*100/(select round(sum(((w.oplata_za_usluge_procent * w.kwota_rekompensaty )/ 100)),2)
                    from wnioski w
                    where  partner is not null and date_part('year', w.data_utworzenia)<2019 and w.stan_wniosku ilike '%wyplacony%'),1) as procentzpartnera,
                count(*) as "liczbawnioskow", round((sum(kwota_rekompensaty) / count(*)),2) as "kwotanawniosek"
from wnioski w
where w.partner is not null and date_part('year', w.data_utworzenia)<2019 and
      w.stan_wniosku ilike '%wyplacony%'
group by w. partner
order by przychodzpartnera desc;


select round(sum(((w.oplata_za_usluge_procent * w.kwota_rekompensaty )/ 100)),2) as przychodzpartnera
from wnioski w
where  partner is not null and date_part('year', w.data_utworzenia)<2019 and w.stan_wniosku ilike '%wyplacony%';
