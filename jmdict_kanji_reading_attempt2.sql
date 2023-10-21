--select'
--select ent_seq,entry_n,reading,kanji,c'+convert(varchar(2),main.b10)+' c,ct'+convert(varchar(2),main.b10)+' ct,
--isnull(right(cr'+convert(varchar(2),main.b10-1)+',1),'''')prev_char,cr'+convert(varchar(2),main.b10)+' cr,reading orig_reading,isnull(left(cr'+convert(varchar(2),main.b10+1)+',1),'''')next_char
--from jmdict_separated_charas where cr'+convert(varchar(2),main.b10)+' is not null and ct'+convert(varchar(2),main.b10)+' !=''h''
--union 
--'
--from miscellaneous..numbers_64k main
--where main.b10 between 1 and 27
--order by main.b10

;with cte as (

select ent_seq,entry_n,reading,kanji,c1 c,ct1 ct,
''prev_char,cr1 cr,reading orig_reading,isnull(left(cr2,1),'')next_char
from jmdict_separated_charas where cr1 is not null and ct1 !='h'
union 

select ent_seq,entry_n,reading,kanji,c2 c,ct2 ct,
isnull(right(cr1,1),'')prev_char,cr2 cr,reading orig_reading,isnull(left(cr3,1),'')next_char
from jmdict_separated_charas where cr2 is not null and ct2 !='h'
union 

select ent_seq,entry_n,reading,kanji,c3 c,ct3 ct,
isnull(right(cr2,1),'')prev_char,cr3 cr,reading orig_reading,isnull(left(cr4,1),'')next_char
from jmdict_separated_charas where cr3 is not null and ct3 !='h'
union 

select ent_seq,entry_n,reading,kanji,c4 c,ct4 ct,
isnull(right(cr3,1),'')prev_char,cr4 cr,reading orig_reading,isnull(left(cr5,1),'')next_char
from jmdict_separated_charas where cr4 is not null and ct4 !='h'
union 

select ent_seq,entry_n,reading,kanji,c5 c,ct5 ct,
isnull(right(cr4,1),'')prev_char,cr5 cr,reading orig_reading,isnull(left(cr6,1),'')next_char
from jmdict_separated_charas where cr5 is not null and ct5 !='h'
union 

select ent_seq,entry_n,reading,kanji,c6 c,ct6 ct,
isnull(right(cr5,1),'')prev_char,cr6 cr,reading orig_reading,isnull(left(cr7,1),'')next_char
from jmdict_separated_charas where cr6 is not null and ct6 !='h'
union 

select ent_seq,entry_n,reading,kanji,c7 c,ct7 ct,
isnull(right(cr6,1),'')prev_char,cr7 cr,reading orig_reading,isnull(left(cr8,1),'')next_char
from jmdict_separated_charas where cr7 is not null and ct7 !='h'
union 

select ent_seq,entry_n,reading,kanji,c8 c,ct8 ct,
isnull(right(cr7,1),'')prev_char,cr8 cr,reading orig_reading,isnull(left(cr9,1),'')next_char
from jmdict_separated_charas where cr8 is not null and ct8 !='h'
union 

select ent_seq,entry_n,reading,kanji,c9 c,ct9 ct,
isnull(right(cr8,1),'')prev_char,cr9 cr,reading orig_reading,isnull(left(cr10,1),'')next_char
from jmdict_separated_charas where cr9 is not null and ct9 !='h'
union 

select ent_seq,entry_n,reading,kanji,c10 c,ct10 ct,
isnull(right(cr9,1),'')prev_char,cr10 cr,reading orig_reading,isnull(left(cr11,1),'')next_char
from jmdict_separated_charas where cr10 is not null and ct10 !='h'
union 

select ent_seq,entry_n,reading,kanji,c11 c,ct11 ct,
isnull(right(cr10,1),'')prev_char,cr11 cr,reading orig_reading,isnull(left(cr12,1),'')next_char
from jmdict_separated_charas where cr11 is not null and ct11 !='h'
union 

select ent_seq,entry_n,reading,kanji,c12 c,ct12 ct,
isnull(right(cr11,1),'')prev_char,cr12 cr,reading orig_reading,isnull(left(cr13,1),'')next_char
from jmdict_separated_charas where cr12 is not null and ct12 !='h'
union 

select ent_seq,entry_n,reading,kanji,c13 c,ct13 ct,
isnull(right(cr12,1),'')prev_char,cr13 cr,reading orig_reading,isnull(left(cr14,1),'')next_char
from jmdict_separated_charas where cr13 is not null and ct13 !='h'
union 

select ent_seq,entry_n,reading,kanji,c14 c,ct14 ct,
isnull(right(cr13,1),'')prev_char,cr14 cr,reading orig_reading,isnull(left(cr15,1),'')next_char
from jmdict_separated_charas where cr14 is not null and ct14 !='h'
union 

select ent_seq,entry_n,reading,kanji,c15 c,ct15 ct,
isnull(right(cr14,1),'')prev_char,cr15 cr,reading orig_reading,isnull(left(cr16,1),'')next_char
from jmdict_separated_charas where cr15 is not null and ct15 !='h'
union 

select ent_seq,entry_n,reading,kanji,c16 c,ct16 ct,
isnull(right(cr15,1),'')prev_char,cr16 cr,reading orig_reading,isnull(left(cr17,1),'')next_char
from jmdict_separated_charas where cr16 is not null and ct16 !='h'
union 

select ent_seq,entry_n,reading,kanji,c17 c,ct17 ct,
isnull(right(cr16,1),'')prev_char,cr17 cr,reading orig_reading,isnull(left(cr18,1),'')next_char
from jmdict_separated_charas where cr17 is not null and ct17 !='h'
union 

select ent_seq,entry_n,reading,kanji,c18 c,ct18 ct,
isnull(right(cr17,1),'')prev_char,cr18 cr,reading orig_reading,isnull(left(cr19,1),'')next_char
from jmdict_separated_charas where cr18 is not null and ct18 !='h'
union 

select ent_seq,entry_n,reading,kanji,c19 c,ct19 ct,
isnull(right(cr18,1),'')prev_char,cr19 cr,reading orig_reading,isnull(left(cr20,1),'')next_char
from jmdict_separated_charas where cr19 is not null and ct19 !='h'
union 

select ent_seq,entry_n,reading,kanji,c20 c,ct20 ct,
isnull(right(cr19,1),'')prev_char,cr20 cr,reading orig_reading,isnull(left(cr21,1),'')next_char
from jmdict_separated_charas where cr20 is not null and ct20 !='h'
union 

select ent_seq,entry_n,reading,kanji,c21 c,ct21 ct,
isnull(right(cr20,1),'')prev_char,cr21 cr,reading orig_reading,isnull(left(cr22,1),'')next_char
from jmdict_separated_charas where cr21 is not null and ct21 !='h'
union 

select ent_seq,entry_n,reading,kanji,c22 c,ct22 ct,
isnull(right(cr21,1),'')prev_char,cr22 cr,reading orig_reading,isnull(left(cr23,1),'')next_char
from jmdict_separated_charas where cr22 is not null and ct22 !='h'
union 

select ent_seq,entry_n,reading,kanji,c23 c,ct23 ct,
isnull(right(cr22,1),'')prev_char,cr23 cr,reading orig_reading,isnull(left(cr24,1),'')next_char
from jmdict_separated_charas where cr23 is not null and ct23 !='h'
union 

select ent_seq,entry_n,reading,kanji,c24 c,ct24 ct,
isnull(right(cr23,1),'')prev_char,cr24 cr,reading orig_reading,isnull(left(cr25,1),'')next_char
from jmdict_separated_charas where cr24 is not null and ct24 !='h'
union 

select ent_seq,entry_n,reading,kanji,c25 c,ct25 ct,
isnull(right(cr24,1),'')prev_char,cr25 cr,reading orig_reading,isnull(left(cr26,1),'')next_char
from jmdict_separated_charas where cr25 is not null and ct25 !='h'
union 

select ent_seq,entry_n,reading,kanji,c26 c,ct26 ct,
isnull(right(cr25,1),'')prev_char,cr26 cr,reading orig_reading,isnull(left(cr27,1),'')next_char
from jmdict_separated_charas where cr26 is not null and ct26 !='h'
union 

select ent_seq,entry_n,reading,kanji,c27 c,ct27 ct,
isnull(right(cr26,1),'')prev_char,cr27 cr,reading orig_reading,''next_char
from jmdict_separated_charas where cr27 is not null and ct27 !='h'
)
select distinct 
cte.ent_seq,entry_n,reading,kanji,c,ct,prev_char,cr,orig_reading,next_char
,score,ke_pri_avg,re_pri_avg into jmdict_kanji_reading_attempt2 from cte
join jmdict_entseq_priority p on p.ent_seq = cte.ent_seq
order by c,p.score,entry_n,cr
update jmdict_kanji_reading_attempt2 set orig_reading=null
drop table if exists #kanasandhi
select distinct *,len(ender)len_ender,len(starter)len_starter,right(ender,1)e,left(starter,1)s
into #kanasandhi from kana_sandhi where starter!='' and ender!='' union
 select distinct ender,starter+kana,endersandhi,startersandhi+kana,sandhitype,len(ender)len_ender,len(starter+kana)len_starter,right(ender,1)e,left(starter+kana,1)s
from kana_unwrapped join kana_sandhi on kana_sandhi.starter='' union
 select distinct ender+kana,starter,endersandhi+kana,startersandhi,sandhitype,len(ender+kana)len_ender,len(starter)len_starter,right(ender+kana,1)e,left(starter,1)s
from kana_unwrapped join kana_sandhi on kana_sandhi.ender=''
--update t set t.orig_reading=null from jmdict_kanji_reading_attempt2 t
update t set t.orig_reading = r.reading
from jmdict_kanji_reading_attempt2 t
join kanjidic2_readings_ja_2 r on r.literal=t.c
--join #kanasandhi s on right(s.endersandhi,1)=prev_char and s.starter=left(r.reading,len(s.starter)) and s.startersandhi=left(t.cr,len(s.startersandhi))
--where stuff(r.reading,1,len(s.starter),s.startersandhi)=cr
--join #kanasandhi e on left(e.startersandhi,1)=next_char and e.ender=right(r.reading,len(e.ender)) and e.endersandhi=right(t.cr,len(e.endersandhi))
--where stuff(r.reading,len(r.reading)-len(e.ender)+1,len(e.ender),e.endersandhi)=cr
--join #kanasandhi s on right(s.endersandhi,1)=prev_char and s.starter=left(r.reading,len(s.starter)) and s.startersandhi=left(t.cr,len(s.startersandhi))
--join #kanasandhi e on left(e.startersandhi,1)=next_char and e.ender=right(r.reading,len(e.ender)) and e.endersandhi=right(t.cr,len(e.endersandhi))
--where stuff(stuff(r.reading,1,len(s.starter),s.startersandhi),len(stuff(r.reading,1,len(s.starter),s.startersandhi))-len(e.ender)+1,len(e.ender),e.endersandhi)=cr
where cr=r.reading and orig_reading is null
select * from jmdict_kanji_reading_attempt2 where ct='ks'and orig_reading is null
order by score

select c,isnull(k.orig_reading,cr)cr,count(distinct k.entry_n)dictn,avg(k.score)score,convert(numeric(7,2),count(distinct k.entry_n)*1.0/avg(k.score)) score2
,isnull(replace(r.r_type,'ja_',''),'??')yomi
into kanji_reading_map_from_jmdict
from jmdict_kanji_reading_attempt2 k
left join kanjidic2_readings_ja_2 r on r.literal=k.c and (r.reading=isnull(k.orig_reading,k.cr))
group by c,isnull(k.orig_reading,cr),r.r_type
order by c,score2 desc,score,dictn desc
--select * from kanjidic2_readings_ja_2
