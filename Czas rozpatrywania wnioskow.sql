--Czesc wynikow wychodzi ujemnych - dodac komentarz w prezentacji, ze dane sa z bledem :)

select w.id as id_wniosku, w.partner,
      round((date_part('year',aw.data_zakonczenia)-date_part('year',aw.data_utworzenia))*12 +
         (date_part('month',aw.data_zakonczenia)-date_part('month',aw.data_utworzenia)) ) as czas_realizacji_w_miesiacach
from wnioski w
inner join analizy_wnioskow aw on w.id = aw.id_wniosku
order by czas_realizacji_w_miesiacach asc
