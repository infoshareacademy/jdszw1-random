select a.*, b.cnt_paid, ((b.cnt_paid*100)/a.total_cnt) as procent_paid from
  (select partner, count(*) as total_cnt from wnioski  where partner is not null group by partner) a
left join (select partner, count(*) as cnt_paid from wnioski
          where partner is not null and stan_wniosku ilike '%wyplacon%' group by partner) b
  on a.partner = b.partner
