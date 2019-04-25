--liczba wniosków o stanie_wniosku innym niż odrzucone
select count(stan_wniosku) from wnioski
where stan_wniosku not ilike ('%odrzucony%') and stan_wniosku is not null;

--liczba wniosków o stanie_wniosku - wyplacony
select count(stan_wniosku) from wnioski
where stan_wniosku ilike ('%wyplacony%') and stan_wniosku is not null ;

--liczba rekompensat/szczegolow_rekompensat
select count(id) from rekompensaty --szczegoly_rekompensat
where id is not null;

--liczba wniosków o ststusie - zaakaceptowane
select count(status) from analizy_wnioskow
where status ilike '%zaakceptowany' and status is not null;

--zestawienie partner|kwoty_rekompensaty|kwoty_rekompensaty_oryginejnej|kowoty z tabeli szczegoly_rekompensat|
--przychod obliczany z procenta opłaty za usługę dla każdego wniosku oddzielnie 
select w. partner, w.kwota_rekompensaty, w.kwota_rekompensaty_oryginalna, sr.kwota,
       ((w.oplata_za_usluge_procent * w.kwota_rekompensaty )/ 100) as przychod from wnioski w
inner join rekompensaty r on w.id = r.id_wniosku
inner join szczegoly_rekompensat sr on r.id = sr.id_rekompensaty
where w.partner is not null and date_part('year', w.data_utworzenia)<2019 and
      w.stan_wniosku ilike '%wyplacony%'
group by w. partner, w.kwota_rekompensaty, w.kwota_rekompensaty_oryginalna, sr.kwota, przychod;

--zestawnienie partner|przychód z partnera jako całościowy przychód dla danego partnera obliczony na podswteir procentu za usługę|
--kwotarekopmensaty jako suma rekompensat dla danego partnera | procentzpartnera jako procent udziału danego partnera dla zsumowanego przychodu 
--dla parnetrów | libczawnioskoww o stanie_wpiosku - wpłacony | kwotanawniosek - zsumaowana kwota_rekompensat podzielona przez liczbę wniosków wypłaconych
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

--Suma całościowego przychodu od partnerów obliczany z kwot_rekopmansat * procent opłat za usługę
select round(sum(((w.oplata_za_usluge_procent * w.kwota_rekompensaty )/ 100)),2) as przychodzpartnera
from wnioski w
where  partner is not null and date_part('year', w.data_utworzenia)<2019 and w.stan_wniosku ilike '%wyplacony%';
