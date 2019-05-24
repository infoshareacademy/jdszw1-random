--Czesc wynikow wychodzi ujemnych - dodac komentarz w prezentacji, ze dane sa z bledem :)

select id_wniosku, czas_realizacji_w_dniach, partner,
      (case when czas_realizacji_w_dniach < 0 then 'Error - ujemny wynik'
        when czas_realizacji_w_dniach >= 0 and czas_realizacji_w_dniach < 7 then 'Mniej niz tydzien'
        else 'Ponad_tydzien' end) as czas_realizacji,
      laczny_zysk,
round((laczny_zysk/czas_realizacji_w_dniach)::numeric,2) as sredni_dzienny_zysk
from
(select w.id as id_wniosku, w.partner,
      ((date_part('year',aw.data_zakonczenia)-date_part('year',aw.data_utworzenia))*360 +
       (date_part('month',aw.data_zakonczenia)-date_part('month',aw.data_utworzenia))*30 +
       (date_part('day',aw.data_zakonczenia)-date_part('day',aw.data_utworzenia)) ) as czas_realizacji_w_dniach,
       (w.kwota_rekompensaty*w.oplata_za_usluge_procent/100 + w.kwota_rekompensaty*w.oplata_za_usluge_prawnicza_procent/100) as laczny_zysk from wnioski w
        inner join analizy_wnioskow aw on w.id = aw.id_wniosku
         where partner is not null) a
where czas_realizacji_w_dniach <> 0
order by czas_realizacji_w_dniach asc
