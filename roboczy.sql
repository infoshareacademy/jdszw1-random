-- liczba wniosków wypłaconych--
select count (stan_wniosku) from wnioski where stan_wniosku similar to  '%(wyplacony)%'

-- liczba rekompensat--
select count (id_agenta) from rekompensaty where id_agenta is not null

-- liczba szczegółów rekompensat--
select count(id) from szczegoly_rekompensat where id_rekompensaty is not null

-- typy stanów wniosków--
select distinct (stan_wniosku) from wnioski

select * from wnioski where stan_wniosku similar to '%(wyplacony)%'

-- podzial na partnerów, liczbę wniosków i stan wniosków--
select distinct partner, count(stan_wniosku), stan_wniosku from wnioski where partner is not null group by partner, stan_wniosku

-- liczba wniosków dla poszczególnych partnerów--
select distinct partner, count(stan_wniosku) from wnioski where partner is not null group by partner

-- stawki opłat za usługi--
select distinct oplata_za_usluge_procent from wnioski

select a.*, b.cnt_paid from
  (select partner, count(*) as total_cnt from wnioski  where partner is not null group by partner) a
left join (select partner, count(*) as cnt_paid from wnioski
          where partner is not null and stan_wniosku ilike '%wyplacon%' group by partner) b
  on a.partner = b.partner