-- 1. zrobilam dla kwot rekompensat z tabeli 'wnioski' i z tabeli 'szczegoly rekompensat', bo roznia sie i nie wiedzialam ktora wybrac
-- 2. aby wyliczyc czas realizacji wniosku zrobilam roznice miedzy najwczesniejsza data z bazy (w.data_utworzenia -> data utworzenia wniosku) i najpozniejsza (sr.data_utworzenia -> w moim odczuciu data utworzenia potwierdzenia wyplacenia rekompensaty)

select w.id as id_wniosku, w.partner,
      round((date_part('year',sr.data_utworzenia)-date_part('year',w.data_utworzenia))*12 +
         (date_part('month',sr.data_utworzenia)-date_part('month',w.data_utworzenia)) ) as czas_realizacji_w_miesiacach,
       (w.kwota_rekompensaty*w.oplata_za_usluge_procent/100 + w.kwota_rekompensaty*w.oplata_za_usluge_prawnicza_procent/100) as laczny_zysk_wg_wnioskow,
       (sr.kwota*w.oplata_za_usluge_procent/100 + sr.kwota*w.oplata_za_usluge_prawnicza_procent/100) as laczny_zysk_wg_sp,
      round((w.kwota_rekompensaty*w.oplata_za_usluge_procent/100 + w.kwota_rekompensaty*w.oplata_za_usluge_prawnicza_procent/100)/
          ((date_part('year',sr.data_utworzenia)-date_part('year',w.data_utworzenia))*12 +
         (date_part('month',sr.data_utworzenia)-date_part('month',w.data_utworzenia))) ) as sredni_miesieczny_zysk_wg_wnioskow,
      round((sr.kwota*w.oplata_za_usluge_procent/100 + sr.kwota*w.oplata_za_usluge_prawnicza_procent/100)/
        ((date_part('year',sr.data_utworzenia)-date_part('year',w.data_utworzenia))*12 +
         (date_part('month',sr.data_utworzenia)-date_part('month',w.data_utworzenia))) ) as sredni_miesieczny_zysk_wg_sp
from wnioski w
inner join szczegoly_rekompensat sr on w.id = sr.id_rekompensaty
where ((date_part('year',sr.data_utworzenia)-date_part('year',w.data_utworzenia))*12 +
         (date_part('month',sr.data_utworzenia)-date_part('month',w.data_utworzenia)) ) is not null
and partner is not null
order by w.id
