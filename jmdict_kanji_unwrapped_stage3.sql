---------
---------
--------- problem
--------- the sandhi list.. didn't consider that same reading might have sandhi on both ends!
--------- 
---------
---------

--select * from jmdict_kanji_unwrapped_stage3_rev2
;with cte as (select *,dense_rank()over (order by m_kanji_index,vocab_ent_n,m_std_reading)dn,
row_number()over (partition by m_kanji_index,vocab_ent_n,m_std_reading order by len(m_hiragana) desc)rn from jmdict_kanji_unwrapped_stage3_rev2
)
,cte2 as(
select * from cte a where rn=1--dn in (select dn from cte b where b.rn>1)
)
select * from cte2
order by m_kanji_index,vocab_ent_n,m_std_reading,rn

--select 
--'select ent_seq,entry_n,c'+convert(varchar(2),b10)+' c,ct'+convert(varchar(2),b10)+' ct,cr'+convert(varchar(2),b10)+' cr from jmdict_separated_charas where cr'+convert(varchar(2),b10)+' is not null and ct'+convert(varchar(2),b10)+' !=''h''
--union '
--from miscellaneous..numbers_64k where b10 between 1 and 27
--order by b10
;with cte as(
select ent_seq,entry_n,c1 c,ct1 ct,cr1 cr from jmdict_separated_charas where cr1 is not null and ct1 !='h'
union 
select ent_seq,entry_n,c2 c,ct2 ct,cr2 cr from jmdict_separated_charas where cr2 is not null and ct2 !='h'
union 
select ent_seq,entry_n,c3 c,ct3 ct,cr3 cr from jmdict_separated_charas where cr3 is not null and ct3 !='h'
union 
select ent_seq,entry_n,c4 c,ct4 ct,cr4 cr from jmdict_separated_charas where cr4 is not null and ct4 !='h'
union 
select ent_seq,entry_n,c5 c,ct5 ct,cr5 cr from jmdict_separated_charas where cr5 is not null and ct5 !='h'
union 
select ent_seq,entry_n,c6 c,ct6 ct,cr6 cr from jmdict_separated_charas where cr6 is not null and ct6 !='h'
union 
select ent_seq,entry_n,c7 c,ct7 ct,cr7 cr from jmdict_separated_charas where cr7 is not null and ct7 !='h'
union 
select ent_seq,entry_n,c8 c,ct8 ct,cr8 cr from jmdict_separated_charas where cr8 is not null and ct8 !='h'
union 
select ent_seq,entry_n,c9 c,ct9 ct,cr9 cr from jmdict_separated_charas where cr9 is not null and ct9 !='h'
union 
select ent_seq,entry_n,c10 c,ct10 ct,cr10 cr from jmdict_separated_charas where cr10 is not null and ct10 !='h'
union 
select ent_seq,entry_n,c11 c,ct11 ct,cr11 cr from jmdict_separated_charas where cr11 is not null and ct11 !='h'
union 
select ent_seq,entry_n,c12 c,ct12 ct,cr12 cr from jmdict_separated_charas where cr12 is not null and ct12 !='h'
union 
select ent_seq,entry_n,c13 c,ct13 ct,cr13 cr from jmdict_separated_charas where cr13 is not null and ct13 !='h'
union 
select ent_seq,entry_n,c14 c,ct14 ct,cr14 cr from jmdict_separated_charas where cr14 is not null and ct14 !='h'
union 
select ent_seq,entry_n,c15 c,ct15 ct,cr15 cr from jmdict_separated_charas where cr15 is not null and ct15 !='h'
union 
select ent_seq,entry_n,c16 c,ct16 ct,cr16 cr from jmdict_separated_charas where cr16 is not null and ct16 !='h'
union 
select ent_seq,entry_n,c17 c,ct17 ct,cr17 cr from jmdict_separated_charas where cr17 is not null and ct17 !='h'
union 
select ent_seq,entry_n,c18 c,ct18 ct,cr18 cr from jmdict_separated_charas where cr18 is not null and ct18 !='h'
union 
select ent_seq,entry_n,c19 c,ct19 ct,cr19 cr from jmdict_separated_charas where cr19 is not null and ct19 !='h'
union 
select ent_seq,entry_n,c20 c,ct20 ct,cr20 cr from jmdict_separated_charas where cr20 is not null and ct20 !='h'
union 
select ent_seq,entry_n,c21 c,ct21 ct,cr21 cr from jmdict_separated_charas where cr21 is not null and ct21 !='h'
union 
select ent_seq,entry_n,c22 c,ct22 ct,cr22 cr from jmdict_separated_charas where cr22 is not null and ct22 !='h'
union 
select ent_seq,entry_n,c23 c,ct23 ct,cr23 cr from jmdict_separated_charas where cr23 is not null and ct23 !='h'
union 
select ent_seq,entry_n,c24 c,ct24 ct,cr24 cr from jmdict_separated_charas where cr24 is not null and ct24 !='h'
union 
select ent_seq,entry_n,c25 c,ct25 ct,cr25 cr from jmdict_separated_charas where cr25 is not null and ct25 !='h'
union 
select ent_seq,entry_n,c26 c,ct26 ct,cr26 cr from jmdict_separated_charas where cr26 is not null and ct26 !='h'
union 
select ent_seq,entry_n,c27 c,ct27 ct,cr27 cr from jmdict_separated_charas where cr27 is not null and ct27 !='h'
)
select cte.*,p.score,p.ke_pri_avg,p.re_pri_avg from cte join jmdict_entseq_priority p on cte.ent_seq=p.ent_seq
order by c,p.score,entry_n,cr