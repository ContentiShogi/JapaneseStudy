--insert into jmdict_kanji_readings_map(ent_seq,reading,kanji)
--select distinct r.ent_seq,r.reb reading,k.keb kanji
--from jmdict_readings r
--join jmdict_kanji k on k.ent_seq=r.ent_seq
--left join jmdict_kanji_readings_map m on m.ent_seq=r.ent_seq and m.kanji=k.keb
--where m.ent_seq is null and
--coalesce(r.re_restr1,r.re_restr2,r.re_restr3,
--r.re_restr4,r.re_restr5,r.re_restr6,
--r.re_restr7,r.re_restr8,r.re_restr9)is null
--select *
--from jmdict_readings r
--join jmdict_kanji k on k.ent_seq=r.ent_seq
--where k.ent_seq=1000580
--select * from jmdict_kanji_readings_map where ent_seq=1000580

--;with cte as
--(select distinct m.ent_seq,kanji,m.reading,0 rn from jmdict_kanji_readings_map m
--union all
--select cte.ent_seq,convert(nvarchar(30),replace(kanji,k.kana,''))kanji,cte.reading,rn+1 from cte join kana_unwrapped k on charindex(k.kana,kanji)>=1
--where rn+1<=100
--)
--select *,LAST_VALUE(kanji)over (partition by ent_seq,reading order by rn) from cte where rn>0
--order by ent_seq,kanji,reading,rn
--;with cte as
--(select distinct m.ent_seq,kanji,kanji oldkanji,m.reading,0 rn from jmdict_kanji_readings_map m join kana_unwrapped k on charindex(k.kana,kanji)>=1-- where kanji=N'溢れる'
--union all
--select cte.ent_seq,convert(nvarchar(30),replace(kanji,k.kana,''))kanji,oldkanji,cte.reading,rn+1 from cte join kana_unwrapped k on charindex(k.kana,kanji)>=1
--where len(replace(kanji,k.kana,''))<len(kanji) or rn+1<=30
--)
--,cte2 as (select distinct LAST_VALUE(cte.kanji)over (partition by cte.ent_seq,cte.reading order by cte.rn RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)kanji_without_kana,
--oldkanji,cte.ent_seq,cte.reading from cte)
--update m set m.no_kana=kanji_without_kana
--from cte2 join jmdict_kanji_readings_map m on m.ent_seq=cte2.ent_seq and m.reading=cte2.reading and m.kanji=cte2.oldkanji
--where rn0
--group by ent_seq,reading
--declare @kana nvarchar(5)= (select min(kana) from kana_unwrapped)
--update jmdict_kanji_readings_map set no_kana=kanji
--while exists (select 1 from kana_unwrapped where kana>@kana)
--begin
--update jmdict_kanji_readings_map set no_kana=replace(no_kana,@kana collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,'')
--set @kana=(select min(kana) from kana_unwrapped where kana>@kana)
--end
--drop table if exists #c
--;with c as (select char(b10+96)lc,char(b10+64)uc  from miscellaneous..numbers_64k where b10 between 1 and 26 )
--select lc c into #c from c union select uc from c
--declare @c nvarchar(5)= (select min(c) from #c)
--while exists (select 1 from #c where c>@c)
--begin
--update jmdict_kanji_readings_map set no_kana=replace(no_kana,@c,'')
--set @c=(select min(c) from #c where c>@c)
--end
--drop table if exists #n
--;with c as (select convert(nvarchar(1),b10)c from miscellaneous..numbers_64k where b10 between 0 and 9)
--select c into #n from c 
--union select distinct c collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS from (values
--(N'〇'),(N'〻'),(N'-'),(N'〜'),(N'＃'),(N'＆'),(N'、'),(N'。'),(N'．'),(N'／'),(N'＠'),(N'～'),(N'〃'),(N'＋'),(N'〆'),
--(N'α'),(N'＝'),(N'×'),(N'⌀'),(N'△'),(N'○'),(N'◎'),(N'・'),(N'･'),(N'※'),(N'〒'),(N'♀'),(N'-'),(N'％'),(N'-'),(N'？'),(N'！'),
--(N'°'),(N'β'),(N'γ'),(N'Γ'),(N'Δ'),(N'ζ'),(N'η'),(N'θ'),(N'Θ'),(N'ι'),(N'κ'),(N'〇'),(N'ｚ'),(N'Ｚ'),(N'Ρ'),(N'Ο'),(N'Ε'),
--(N'Λ'),(N'μ'),(N'ν'),(N'ξ'),(N'Ξ'),(N'Π'),(N'σ'),(N'τ'),(N'υ'),(N'φ'),(N'χ'),(N'ψ'),(N'ω'),(N'ん'),(N'々'),(N'ﾀ'),(N'ﾋ'),(N'ゞ'),(N'ー'),(N'ー'collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS )
--)c(c)
--declare @n nvarchar(5)= (select min(c) from #n)
--while exists (select 1 from #n where c>@n)
--begin
--update jmdict_kanji_readings_map set no_kana=replace(no_kana collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,@n collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,'')
--set @n=(select min(c) from #n where c>@n)
--end
--update m set no_kana=replace(no_kana collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ー' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,'' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--from jmdict_kanji_readings_map m

--;with cte as(select b10 n from miscellaneous..numbers_64k where b10 between 1 and 18)
--select SUBSTRING(no_kana,n,1)kanji_char,n,ent_seq,m.no_kana,m.reading,m.kanji
--into jmdict_kanji_unwrapped
--from jmdict_kanji_readings_map m
--join cte on cte.n <=len(no_kana) where len(no_kana)>=1
--order by ent_seq,kanji,reading,n,kanji_char
--select * from jmdict_kanji_readings_map where no_kana like N'%ー%'ent_seq=92886 order by no_kana,kanji,ent_seq,reading,_id
--gemination
--handakuten
--hito
--onbin
--onbin_guess
--rendaku
--renjou
--select * from jmdict_kanji_unwrapped jdict
--join kanjidic2_readings_corrected r on r.literal=jdict.kanji_char and r.r_type in ('ja_on','ja_kun')
--order by jdict.no_kana,jdict.kanji,jdict.ent_seq,jdict.reading,jdict.n
--select * from kanjidic2_readings_corrected
--alter table jmdict_kanji_unwrapped add entry_n bigint
--;with cte as (select dense_rank()over(order by ent_seq,no_kana,reading,kanji)entry_rn,* from jmdict_kanji_unwrapped)
--update jmdict_kanji_unwrapped set jmdict_kanji_unwrapped.entry_n=entry_rn from cte where cte.n=jmdict_kanji_unwrapped.n
--and cte.ent_seq=jmdict_kanji_unwrapped.ent_seq and cte.no_kana=jmdict_kanji_unwrapped.no_kana and cte.reading=jmdict_kanji_unwrapped.reading and cte.kanji=jmdict_kanji_unwrapped.kanji

--select * from kanjidic2_readings_corrected
drop table if exists #readings
select	r.literal collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS	literal
	,	r.r_type
	,	r.reading collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS	reading
	,	r.reading collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS	hiragana_reading
	------,	r.reading collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS	starter
	------,	r.reading collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS	ender
into #readings
from kanjidic2_readings_corrected r
where r_type in ('ja_on','ja_kun')
--select * from kanjidic2_readings_corrected where literal=N'与'
insert into #readings(literal,r_type,reading,hiragana_reading/*,ender,starter*/)
select distinct literal
	,	r_type
	,	left(replace(r.reading+N'.',N'-',N''),charindex(N'.',replace(r.reading+N'.',N'-',N''))-1)reading
	,	left(replace(r.hiragana_reading+N'.',N'-',N''),charindex(N'.',replace(r.hiragana_reading+N'.',N'-',N''))-1)hiragana_reading
/*	,	r.reading ender,	r.reading starter*/
from #readings r
update r set r.reading=replace(replace(reading,N'-',N''),N'.',N''),r.hiragana_reading=replace(replace(hiragana_reading,N'-',N''),N'.',N'') from #readings r
update r set r.hiragana_reading=replace(hiragana_reading,N'ン',N'ん') from #readings r
--declare @hiragana nvarchar(5)= (select min(kana) from kana_unwrapped where descr like'%hiragana%')collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS
--while exists (select 1 from kana_unwrapped where kana>@hiragana and descr like'%hiragana%')
--	begin
--	update jmdict_kanji_unwrapped set hiragana_reading=
--	replace(hiragana_reading collate Japanese_Bushu_Kakusu_140_CS_AS_WS_VSS,@hiragana collate Japanese_Bushu_Kakusu_140_CS_AS_WS_VSS,@hiragana collate Japanese_Bushu_Kakusu_140_CS_AS_WS_VSS)
--	,kanji_w_hiragana_only=
--	replace(kanji_w_hiragana_only collate Japanese_Bushu_Kakusu_140_CS_AS_WS_VSS,@hiragana collate Japanese_Bushu_Kakusu_140_CS_AS_WS_VSS,@hiragana collate Japanese_Bushu_Kakusu_140_CS_AS_WS_VSS)
--	set @hiragana=(select min(kana) from kana_unwrapped where descr like'%hiragana%' and kana>@hiragana)
--	end

declare @hiragana nvarchar(5)= (select min(kana) from kana_unwrapped where descr like'%hiragana%')collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS
while exists (select 1 from kana_unwrapped where kana>@hiragana and descr like'%hiragana%')
	begin
	update #readings set hiragana_reading=
	replace(hiragana_reading collate Japanese_Bushu_Kakusu_140_CS_AS_WS_VSS,@hiragana collate Japanese_Bushu_Kakusu_140_CS_AS_WS_VSS,@hiragana collate Japanese_Bushu_Kakusu_140_CS_AS_WS_VSS)
	set @hiragana=(select min(kana) from kana_unwrapped where descr like'%hiragana%' and kana>@hiragana)
	end
;with cte as (select *,row_number()over(partition by literal,r_type,reading,hiragana_reading order by hiragana_reading)rn from #readings) delete from cte where rn=2
--update m set hiragana_reading=replace(hiragana_reading collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ー' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,'' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,kanji_w_hiragana_only=replace(kanji_w_hiragana_only collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ー' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,'' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--from jmdict_kanji_unwrapped m
--update m set hiragana_reading=replace(hiragana_reading collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ー' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,'' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,kanji_w_hiragana_only=replace(kanji_w_hiragana_only collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ー' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,'' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--from jmdict_kanji_unwrapped m
--select * from jmdict_kanji_unwrapped
--select * from #readings order by literal,r_type,hiragana_reading
--select * from kana_sandhi
------update r set r.ender = null,r.starter = null from #readings r
------update r set r.ender = replace(r.hiragana_reading,ks.ender,ks.endersandhi)
------from #readings r join kana_sandhi ks on ks.ender=right(r.hiragana_reading,len(ks.ender))
------update r set r.starter = replace(r.hiragana_reading,ks.starter,ks.startersandhi)
------from #readings r join kana_sandhi ks on ks.starter=left(r.hiragana_reading,len(ks.starter))

drop table if exists #jmdict_kanji_unwrapped_processing
select distinct jdict.*,r.r_type,r.hiragana_reading char_reading
into #jmdict_kanji_unwrapped_processing
from jmdict_kanji_unwrapped jdict
left join #readings r on r.literal=jdict.kanji_char
	--and (	CHARINDEX(r.hiragana_reading,jdict.hiragana_reading)>0
	--	)--or CHARINDEX(r.starter,jdict.hiragana_reading)>0
		--or CHARINDEX(r.ender,jdict.hiragana_reading)>0)
--group by ent_seq,no_kana,jdict.reading,kanji
--order by jdict.no_kana,jdict.kanji,jdict.ent_seq,jdict.reading,jdict.n
--select * from jmdict_kanji_unwrapped jdict where kanji_char=N'宛'order by 1,2,4,5
--select * from #readings where literal=N'宛'
--select * from #jmdict_kanji_unwrapped_processing
drop table if exists #jmdict_kanji_unwrapped_processing_2
select distinct entry_n,n,ent_seq,no_kana,kanji,kanji_w_hiragana_only,reading,hiragana_reading,r_type
	,  kanji_char
	--,  lag(char_reading,1,'')over(partition by entry_n order by n)prev_kanji_char
	,  char_reading
	--,  lead(char_reading,1,'')over(partition by entry_n order by n)next_kanji_char
into #jmdict_kanji_unwrapped_processing_2
from #jmdict_kanji_unwrapped_processing order by entry_n,n

;with cte as(select row_number()over(partition by kanji_char,n,ent_seq,no_kana,reading,kanji,hiragana_reading,kanji_w_hiragana_only,r_type order by len(char_reading)desc)rn,* from #jmdict_kanji_unwrapped_processing_2 jdict)
--select kanji_char,n,ent_seq,no_kana,reading,kanji,hiragana_reading,kanji_w_hiragana_only,r_type,char_reading
delete from cte where rn!=1
--drop table if exists #jmdict_kanji_unwrapped_processing_ranked
--select * from #jmdict_kanji_unwrapped_processing_2 order by entry_n,n
--;with cte as(select dense_rank()over(order by ent_seq,no_kana,reading,kanji,hiragana_reading,kanji_w_hiragana_only)rn,* from jmdict_kanji_unwrapped_processing jdict)
--select * into #jmdict_kanji_unwrapped_processing_ranked
--from cte order by rn,n
--select * from #jmdict_kanji_unwrapped_processing_ranked_ranked order by rn,n
drop table if exists #jmdict_kanji_unwrapped_processed_ranked
;with entries as (select entry_n,ent_seq,no_kana,reading,kanji,hiragana_reading,kanji_w_hiragana_only from #jmdict_kanji_unwrapped_processing_2)
,char_reading1 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=1)
,char_reading2 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=2)
,char_reading3 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=3)
,char_reading4 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=4)
,char_reading5 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=5)
,char_reading6 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=6)
,char_reading7 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=7)
,char_reading8 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=8)
,char_reading9 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=9)
,char_reading10 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=10)
,char_reading11 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=11)
,char_reading12 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=12)
,char_reading13 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=13)
,char_reading14 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=14)
,char_reading15 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=15)
,char_reading16 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=16)
,char_reading17 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=17)
,char_reading18 as (select distinct entry_n,n,kanji_char,r_type,char_reading from #jmdict_kanji_unwrapped_processing_2 jdict where n=18)
select e.*
,c1.char_reading c1,c1.kanji_char k1
,c2.char_reading c2,c2.kanji_char k2
,c3.char_reading c3,c3.kanji_char k3
,c4.char_reading c4,c4.kanji_char k4
,c5.char_reading c5,c5.kanji_char k5
,c6.char_reading c6,c6.kanji_char k6
,c7.char_reading c7,c7.kanji_char k7
,c8.char_reading c8,c8.kanji_char k8
,c9.char_reading c9,c9.kanji_char k9
,c10.char_reading c10,c10.kanji_char k10
,c11.char_reading c11,c11.kanji_char k11
,c12.char_reading c12,c12.kanji_char k12
,c13.char_reading c13,c13.kanji_char k13
,c14.char_reading c14,c14.kanji_char k14
,c15.char_reading c15,c15.kanji_char k15
,c16.char_reading c16,c16.kanji_char k16
,c17.char_reading c17,c17.kanji_char k17
,c18.char_reading c18,c18.kanji_char k18
into #jmdict_kanji_unwrapped_processed_ranked from entries e
left join char_reading1 c1 on e.entry_n=c1.entry_n
left join char_reading2 c2 on e.entry_n=c2.entry_n
left join char_reading3 c3 on e.entry_n=c3.entry_n
left join char_reading4 c4 on e.entry_n=c4.entry_n
left join char_reading5 c5 on e.entry_n=c5.entry_n
left join char_reading6 c6 on e.entry_n=c6.entry_n
left join char_reading7 c7 on e.entry_n=c7.entry_n
left join char_reading8 c8 on e.entry_n=c8.entry_n
left join char_reading9 c9 on e.entry_n=c9.entry_n
left join char_reading10 c10 on e.entry_n=c10.entry_n
left join char_reading11 c11 on e.entry_n=c11.entry_n
left join char_reading12 c12 on e.entry_n=c12.entry_n
left join char_reading13 c13 on e.entry_n=c13.entry_n
left join char_reading14 c14 on e.entry_n=c14.entry_n
left join char_reading15 c15 on e.entry_n=c15.entry_n
left join char_reading16 c16 on e.entry_n=c16.entry_n
left join char_reading17 c17 on e.entry_n=c17.entry_n
left join char_reading18 c18 on e.entry_n=c18.entry_n
order by e.entry_n
drop table if exists jmdict_kanji_readings_map_split_into_chars_but_incomplete
;with cte as (select
replace(replace(replace(replace(replace(replace(replace(replace(replace(
replace(replace(replace(replace(replace(replace(replace(replace(replace(kanji_w_hiragana_only
,isnull(k1,'`'),isnull(c1,'-'))
,isnull(k2,'`'),isnull(c2,'-'))
,isnull(k3,'`'),isnull(c3,'-'))
,isnull(k4,'`'),isnull(c4,'-'))
,isnull(k5,'`'),isnull(c5,'-'))
,isnull(k6,'`'),isnull(c6,'-'))
,isnull(k7,'`'),isnull(c7,'-'))
,isnull(k8,'`'),isnull(c8,'-'))
,isnull(k9,'`'),isnull(c9,'-'))
,isnull(k10,'`'),isnull(c10,'-'))
,isnull(k11,'`'),isnull(c11,'-'))
,isnull(k12,'`'),isnull(c12,'-'))
,isnull(k13,'`'),isnull(c13,'-'))
,isnull(k14,'`'),isnull(c14,'-'))
,isnull(k15,'`'),isnull(c15,'-'))
,isnull(k16,'`'),isnull(c16,'-'))
,isnull(k17,'`'),isnull(c17,'-'))
,isnull(k18,'`'),isnull(c18,'-'))piecedtogetherhiragana
,* from #jmdict_kanji_unwrapped_processed_ranked)
select distinct * into jmdict_kanji_readings_map_split_into_chars_but_incomplete
from cte --where piecedtogetherhiragana=hiragana_reading
--select count(*) from jmdict_kanji_readings_map

--Why has 月極 (げっきょく) failed to match; clearly my logic to include rendaku gemination etc has failed
select * from jmdict_kanji_readings_map a
left join jmdict_kanji_readings_map_split_into_chars_but_incomplete b
on a.ent_seq=b.ent_seq and a.reading=b.reading and a.kanji=b.kanji where _id in
(select _id from jmdict_kanji_readings_map a
left join jmdict_kanji_readings_map_split_into_chars_but_incomplete b
on a.ent_seq=b.ent_seq and a.reading=b.reading and a.kanji=b.kanji
group by _id having count(*)>1)
or b.entry_n is null
order by _id

--where
--hiragana_reading=
--replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
--replace(replace(replace(replace(replace(replace(replace(replace(kanji_w_hiragana_only
--,k1,c1),k2,c2),k3,c3),k4,c4),k5,c5),k6,c6),k7,c7),k8,c8),k9,c9),k10,c10)
--,k11,c11),k12,c12),k13,c13),k14,c14),k15,c15),k16,c16),k17,c17),k18,c18)
--select jdict.*,
--from #jmdict_kanji_unwrapped_processing jdict
--join #readings r on r.literal=jdict.kanji_char
--where char_reading is not null

select distinct entry_n,ent_seq,kanji,reading from jmdict_kanji_readings_map_split_into_chars_but_incomplete where 
hiragana_reading=piecedtogetherhiragana
order by entry_n--,n



--update jmdict_kanji_unwrapped set kanji_w_hiragana_only=replace(kanji_w_hiragana_only,N'ン',N'ん')where kanji_w_hiragana_only like N'%ン%'
drop table if exists #hiragana;select distinct kana into #hiragana from kana_unwrapped where descr like'%hira%'
drop table if exists #jmdict_kanji_unwrapped
;with unwrap1 as (select row_number()over(order by entry_n,n)rn,entry_n,ent_seq,n,kanji_char,kanji_w_hiragana_only,hiragana_reading,no_kana,kanji,reading from jmdict_kanji_unwrapped)
,cte as(select b10 from miscellaneous..numbers_64k where b10 between 1 and 40
)
select distinct m.entry_n,ent_seq,dense_rank()over (partition by m.entry_n,ent_seq order by b10)n
,SUBSTRING(kanji_w_hiragana_only,b10,1)chara,kanji_w_hiragana_only kanji
,kanji_w_hiragana_only kanji2
,hiragana_reading reading,m.no_kana,' 'chara_type--,m.reading,m.kanji
into #jmdict_kanji_unwrapped
from unwrap1 m
join cte on cte.b10 <=len(kanji_w_hiragana_only) where len(no_kana)>=1
and (charindex(SUBSTRING(kanji_w_hiragana_only,b10,1),no_kana)>0 or SUBSTRING(kanji_w_hiragana_only,b10,1) in (select kana from #hiragana)
or SUBSTRING(kanji_w_hiragana_only,b10,1)=N'々')
--and entry_n=34
;with upd as(select entry_n,replace(STRING_AGG(chara,N',')within group(order by convert(bigint,n)+1),N',',N'')upd from #jmdict_kanji_unwrapped group by entry_n)
update a set a.kanji2=upd.upd from #jmdict_kanji_unwrapped a join upd on upd.entry_n=a.entry_n
update a set a.chara_type='h' from #jmdict_kanji_unwrapped a join #hiragana upd on upd.kana=a.chara
update a set a.chara_type='k' from #jmdict_kanji_unwrapped a where a.chara_type=' '
drop table if exists #jmdict;
select ent_seq,entry_n,n,chara,chara_type,kanji2 kanji,reading into #jmdict from #jmdict_kanji_unwrapped where kanji=kanji2
order by entry_n,n,chara
drop table #jmdict_kanji_unwrapped

--select ',left(['+convert(varchar(2),b10)+'],len(['+convert(varchar(2),b10)+'])-1)c'+convert(varchar(2),b10)+',right(['+convert(varchar(2),b10)+'],1)ct'+convert(varchar(2),b10)
--+',convert(nvarchar(20),nullif(['+convert(varchar(2),b10)+'],['+convert(varchar(2),b10)+']))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr'+convert(varchar(2),b10)+''
--from miscellaneous..numbers_64k where b10 between 1 and 27
--order by b10
select ent_seq,entry_n,kanji,reading
,left([1],len([1])-1)c1,right([1],1)ct1,convert(nvarchar(20),nullif([1],[1]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr1
,left([2],len([2])-1)c2,right([2],1)ct2,convert(nvarchar(20),nullif([2],[2]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr2
,left([3],len([3])-1)c3,right([3],1)ct3,convert(nvarchar(20),nullif([3],[3]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr3
,left([4],len([4])-1)c4,right([4],1)ct4,convert(nvarchar(20),nullif([4],[4]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr4
,left([5],len([5])-1)c5,right([5],1)ct5,convert(nvarchar(20),nullif([5],[5]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr5
,left([6],len([6])-1)c6,right([6],1)ct6,convert(nvarchar(20),nullif([6],[6]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr6
,left([7],len([7])-1)c7,right([7],1)ct7,convert(nvarchar(20),nullif([7],[7]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr7
,left([8],len([8])-1)c8,right([8],1)ct8,convert(nvarchar(20),nullif([8],[8]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr8
,left([9],len([9])-1)c9,right([9],1)ct9,convert(nvarchar(20),nullif([9],[9]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr9
,left([10],len([10])-1)c10,right([10],1)ct10,convert(nvarchar(20),nullif([10],[10]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr10
,left([11],len([11])-1)c11,right([11],1)ct11,convert(nvarchar(20),nullif([11],[11]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr11
,left([12],len([12])-1)c12,right([12],1)ct12,convert(nvarchar(20),nullif([12],[12]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr12
,left([13],len([13])-1)c13,right([13],1)ct13,convert(nvarchar(20),nullif([13],[13]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr13
,left([14],len([14])-1)c14,right([14],1)ct14,convert(nvarchar(20),nullif([14],[14]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr14
,left([15],len([15])-1)c15,right([15],1)ct15,convert(nvarchar(20),nullif([15],[15]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr15
,left([16],len([16])-1)c16,right([16],1)ct16,convert(nvarchar(20),nullif([16],[16]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr16
,left([17],len([17])-1)c17,right([17],1)ct17,convert(nvarchar(20),nullif([17],[17]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr17
,left([18],len([18])-1)c18,right([18],1)ct18,convert(nvarchar(20),nullif([18],[18]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr18
,left([19],len([19])-1)c19,right([19],1)ct19,convert(nvarchar(20),nullif([19],[19]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr19
,left([20],len([20])-1)c20,right([20],1)ct20,convert(nvarchar(20),nullif([20],[20]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr20
,left([21],len([21])-1)c21,right([21],1)ct21,convert(nvarchar(20),nullif([21],[21]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr21
,left([22],len([22])-1)c22,right([22],1)ct22,convert(nvarchar(20),nullif([22],[22]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr22
,left([23],len([23])-1)c23,right([23],1)ct23,convert(nvarchar(20),nullif([23],[23]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr23
,left([24],len([24])-1)c24,right([24],1)ct24,convert(nvarchar(20),nullif([24],[24]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr24
,left([25],len([25])-1)c25,right([25],1)ct25,convert(nvarchar(20),nullif([25],[25]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr25
,left([26],len([26])-1)c26,right([26],1)ct26,convert(nvarchar(20),nullif([26],[26]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr26
,left([27],len([27])-1)c27,right([27],1)ct27,convert(nvarchar(20),nullif([27],[27]))collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS cr27
--into jmdict_separated_charas
from(
select ent_seq,entry_n,kanji,reading,n,chara+chara_type collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS c_ct from #jmdict)x pivot (max(c_ct)for n in(
[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27]
))piv order by len(kanji) desc
--select 'update jmdict_separated_charas set cr'+convert(varchar(2),b10)+'=c'+convert(varchar(2),b10)+' where ct'+convert(varchar(2),b10)+'=''h'''
--from miscellaneous..numbers_64k where b10 between 1 and 27
--order by b10

--select literal,hiragana_reading reading,replace(max(r_type)+iif(min(r_type)=max(r_type),'',min(r_type)),'ja_onja_kun','both')r_type
--into kanjidic2_readings_ja_2
--from kanjidic2_readings_ja
--group by literal,hiragana_reading

select 
replace(';with cte as
(
select entry_n,c'+convert(varchar(2),main.b10)+',r.reading,ROW_NUMBER()over(partition by entry_n,c'+convert(varchar(2),main.b10)+' order by len(r.reading) desc) rn
from jmdict_separated_charas d
join kanjidic2_readings_ja_2 r
	on r.literal=d.c'+convert(varchar(2),main.b10)+'
where d.reading like d.cr'+replace(string_agg(sub.b10,'|')within group (order by sub.b10),'|','+d.cr')+'+r.reading+''%''
	and d.cr'+convert(varchar(2),main.b10)+' is null and d.ct'+convert(varchar(2),main.b10)+' = ''k''
--group by entry_n,c'+convert(varchar(2),main.b10)+'
)
update d set d.cr'+convert(varchar(2),main.b10)+' = r.reading
from jmdict_separated_charas d
join cte r on r.entry_n = d.entry_n and r.c'+convert(varchar(2),main.b10)+' = d.c'+convert(varchar(2),main.b10)+'
where rn=1 and d.cr'+convert(varchar(2),main.b10)+' is null and d.ct'+convert(varchar(2),main.b10)+' = ''k''

','d.cr0+','')
from miscellaneous..numbers_64k main
join miscellaneous..numbers_64k sub on sub.b10 between 0 and main.b10-1
where main.b10 between 1 and 27
group by main.b10
order by main.b10

drop table if exists #kanasandhi
select distinct *,len(ender)len_ender,len(starter)len_starter,right(ender,1)e,left(starter,1)s
into #kanasandhi from kana_sandhi where starter!='' and ender!='' union
 select distinct ender,starter+kana,endersandhi,startersandhi+kana,sandhitype,len(ender)len_ender,len(starter+kana)len_starter,right(ender,1)e,left(starter+kana,1)s
from kana_unwrapped join kana_sandhi on kana_sandhi.starter='' union
 select distinct ender+kana,starter,endersandhi+kana,startersandhi,sandhitype,len(ender+kana)len_ender,len(starter)len_starter,right(ender+kana,1)e,left(starter,1)s
from kana_unwrapped join kana_sandhi on kana_sandhi.ender=''
--select * from #kanasandhi
;with cte as (select distinct stuff(r.reading,len(r.reading)-len(s.ender)+1,len(s.endersandhi),s.endersandhi)upd,c.entry_n from jmdict_separated_charas c
join kanjidic2_readings_ja_2 r on r.literal=c.c1
join #kanasandhi s on s.ender=right(r.reading,len(s.ender))
	and s.startersandhi=substring(c.reading,len(r.reading)-len(s.ender)+len(s.endersandhi),len(s.startersandhi))
where c1 is not null and cr1 is null
and c.reading like stuff(r.reading,len(r.reading)-len(s.ender)+1,len(s.endersandhi),s.endersandhi)+N'%'
)update c set c.cr1=cte.upd,c.ct1='ks'
from jmdict_separated_charas c
join cte on cte.entry_n=c.entry_n
where c.cr1 is null and c.ct1='k'and c.c1 is not null

--select literal,reading,reading orig_reading,r_type,'original'r_type2 into kanjidic2_reading_tracker from kanjidic2_readings_ja_2
;with cte as (select distinct stuff(r.reading,len(r.reading)-len(s.ender)+1,len(s.endersandhi),s.endersandhi)upd,r.reading orig,r.r_type,c.c1,c.entry_n from jmdict_separated_charas c
join kanjidic2_readings_ja_2 r on r.literal=c.c1
join #kanasandhi s on s.ender=right(r.reading,len(s.ender))
	and s.startersandhi=substring(c.reading,len(r.reading)-len(s.ender)+len(s.endersandhi),len(s.startersandhi))
where c1 is not null and ct1='ks'
and c.reading like stuff(r.reading,len(r.reading)-len(s.ender)+1,len(s.endersandhi),s.endersandhi)+N'%'
)insert into kanjidic2_reading_tracker(literal,reading,orig_reading,r_type,r_type2)
select distinct cte.c1,cte.upd,cte.orig,cte.r_type,'sandhi'
--update c set c.cr1=cte.upd,c.ct1='ks'
from jmdict_separated_charas c
join cte on cte.entry_n=c.entry_n
where c.c1 is not null and c.ct1='ks'
--drop table kanjidic2_reading_tracker


--insert into kanjidic2_reading_tracker(literal,reading,orig_reading,r_type,r_type2)
--select distinct c1,
--update jmdict_separated_charas set cr1=
--replace(reading,
--isnull(cr1,'')+isnull(cr2,'')+isnull(cr3,'')+isnull(cr4,'')+isnull(cr5,'')+isnull(cr6,'')+isnull(cr7,'')+isnull(cr8,'')+isnull(cr9,'')+isnull(cr10,'')+
--isnull(cr11,'')+isnull(cr12,'')+isnull(cr13,'')+isnull(cr14,'')+isnull(cr15,'')+isnull(cr16,'')+isnull(cr17,'')+isnull(cr18,'')+isnull(cr19,'')+
--isnull(cr20,'')+isnull(cr21,'')+isnull(cr22,'')+isnull(cr23,'')+isnull(cr24,'')+isnull(cr25,'')+isnull(cr26,'')+isnull(cr27,'')
--,N'')--,null,null,'exceptn?'
--from jmdict_separated_charas where cr1 is null and c1 is not null
--and
--len(isnull(ct1,'')+isnull(ct2,'')+isnull(ct3,'')+isnull(ct4,'')+isnull(ct5,'')+isnull(ct6,'')+isnull(ct7,'')+isnull(ct8,'')+isnull(ct9,'')+isnull(ct10,'')+
--isnull(ct11,'')+isnull(ct12,'')+isnull(ct13,'')+isnull(ct14,'')+isnull(ct15,'')+isnull(ct16,'')+isnull(ct17,'')+isnull(ct18,'')+isnull(ct19,'')+
--isnull(ct20,'')+isnull(ct21,'')+isnull(ct22,'')+isnull(ct23,'')+isnull(ct24,'')+isnull(ct25,'')+isnull(ct26,'')+isnull(ct27,''))-
--len(replace(isnull(ct1,'')+isnull(ct2,'')+isnull(ct3,'')+isnull(ct4,'')+isnull(ct5,'')+isnull(ct6,'')+isnull(ct7,'')+isnull(ct8,'')+isnull(ct9,'')+isnull(ct10,'')+
--isnull(ct11,'')+isnull(ct12,'')+isnull(ct13,'')+isnull(ct14,'')+isnull(ct15,'')+isnull(ct16,'')+isnull(ct17,'')+isnull(ct18,'')+isnull(ct19,'')+
--isnull(ct20,'')+isnull(ct21,'')+isnull(ct22,'')+isnull(ct23,'')+isnull(ct24,'')+isnull(ct25,'')+isnull(ct26,'')+isnull(ct27,'')
--,'k',''))=1

--insert into kanjidic2_reading_tracker(literal,reading,orig_reading,r_type,r_type2)
;with cte as(select distinct 
--update jmdict_separated_charas set cr1=
replace(reading,
isnull(cr1,'')+isnull(cr2,'')+isnull(cr3,'')+isnull(cr4,'')+isnull(cr5,'')+isnull(cr6,'')+isnull(cr7,'')+isnull(cr8,'')+isnull(cr9,'')+isnull(cr10,'')+
isnull(cr11,'')+isnull(cr12,'')+isnull(cr13,'')+isnull(cr14,'')+isnull(cr15,'')+isnull(cr16,'')+isnull(cr17,'')+isnull(cr18,'')+isnull(cr19,'')+
isnull(cr20,'')+isnull(cr21,'')+isnull(cr22,'')+isnull(cr23,'')+isnull(cr24,'')+isnull(cr25,'')+isnull(cr26,'')+isnull(cr27,'')
,N'')upd--,null,null,'exceptn?'
,*
from jmdict_separated_charas where cr1 is null and c1 is not null
and
len(isnull(ct1,'')+isnull(ct2,'')+isnull(ct3,'')+isnull(ct4,'')+isnull(ct5,'')+isnull(ct6,'')+isnull(ct7,'')+isnull(ct8,'')+isnull(ct9,'')+isnull(ct10,'')+
isnull(ct11,'')+isnull(ct12,'')+isnull(ct13,'')+isnull(ct14,'')+isnull(ct15,'')+isnull(ct16,'')+isnull(ct17,'')+isnull(ct18,'')+isnull(ct19,'')+
isnull(ct20,'')+isnull(ct21,'')+isnull(ct22,'')+isnull(ct23,'')+isnull(ct24,'')+isnull(ct25,'')+isnull(ct26,'')+isnull(ct27,''))-
len(replace(isnull(ct1,'')+isnull(ct2,'')+isnull(ct3,'')+isnull(ct4,'')+isnull(ct5,'')+isnull(ct6,'')+isnull(ct7,'')+isnull(ct8,'')+isnull(ct9,'')+isnull(ct10,'')+
isnull(ct11,'')+isnull(ct12,'')+isnull(ct13,'')+isnull(ct14,'')+isnull(ct15,'')+isnull(ct16,'')+isnull(ct17,'')+isnull(ct18,'')+isnull(ct19,'')+
isnull(ct20,'')+isnull(ct21,'')+isnull(ct22,'')+isnull(ct23,'')+isnull(ct24,'')+isnull(ct25,'')+isnull(ct26,'')+isnull(ct27,'')
,'k',''))=2
and c1=c2
and entry_n not in (26352,60963,60964,60967,60968,60965,60969,60966,60970)
)
update c set cr1=left(upd,len(upd)/2),cr2=right(upd,len(upd)/2),ct1='k2',ct2='k2'
from cte join jmdict_separated_charas c on c.entry_n=cte.entry_n

--update c set c.reading=upd.corrected_reading
--from jmdict_separated_charas c
--join (values
--(700,N'凝乎と' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'じと' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'じぃと' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(34327,N'然う言う' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'そゆ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'そうゆう' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(56615,N'嗚呼' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ああ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(56616,N'嗚呼' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ああ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(56639,N'於乎' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ああ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(56640,N'於乎' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ああ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(56645,N'於戯' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ああ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(56646,N'於戯' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ああ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(67777,N'祖母さん' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ばさん' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ばぁさん' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(112547,N'祖母ちゃん' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ばちゃん' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ばぁちゃん' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(150931,N'祖父ちゃん' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'じちゃん' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'じぃちゃん' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(160707,N'嗚呼嗚呼' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ああああ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(160708,N'嗚呼嗚呼' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'ああああ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(205681,N'如何にかなる' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'どにかなる' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'どうにかなる' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(206902,N'美味ちい' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'おいち' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'おいちい' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(219672,N'立直をかける' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'りちかける' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'りぃちかける' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(219674,N'立直を掛ける' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'りちかける' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS,N'りぃちかける' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--)as upd (entry_n,kanji,reading,corrected_reading)
--on c.entry_n=upd.entry_n and c.kanji=upd.kanji and c.reading=upd.reading
--update c set cr1=upd.r1,cr2=upd.r2
--from jmdict_separated_charas c
--join (values
-- (60966,N'孑孑',N'ぼふら',N'ぼ',N'ふら')
--,(60967,N'孑孑',N'ぼうふら',N'ぼう',N'ふら')
--,(26352,N'一一',N'じゅういち',N'じゅう',N'いち')
--,(60969,N'孑孑',N'ぼうふり',N'ぼう',N'ふり')
--,(60970,N'孑孑',N'ぼふら',N'ぼ',N'ふら')
--,(60964,N'孑孑',N'ぼうふら',N'ぼう',N'ふら')
--,(60968,N'孑孑',N'ぼうふら',N'ぼう',N'ふら')
--,(60965,N'孑孑',N'ぼうふり',N'ぼう',N'ふり')
--,(60963,N'孑孑',N'ぼうふら',N'ぼう',N'ふら')
--)as upd (entry_n,kanji,reading,r1,r2)
--on c.entry_n=upd.entry_n and c.kanji=upd.kanji and c.reading=upd.reading

--update c set
--cr1=upd.r1,cr2=upd.r2,cr3=upd.r3,cr4=upd.r4
--from jmdict_separated_charas c
--join (values
-- (170223 ,N'疾く疾く' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'とくとく' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'と' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'く' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'と' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'く' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(160708 , N'嗚呼嗚呼' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ああああ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(66521 , N'滅茶滅茶' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'めちゃめちゃ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'め' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ちゃ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'め' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ちゃ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(153299 , N'頻く頻く' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'しくしく' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'し' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'く' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'し' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'く' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(191095 , N'何処何処' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'どこどこ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ど' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'こ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ど' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'こ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(212982 , N'為い為い' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'しいしい' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'し' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'い' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'し' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'い' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(174845 , N'東西東西' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'とざいとうざい' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'と' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ざい' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'とう' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ざい' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(495 , N'限り限り' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ぎりぎり' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ぎ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'り' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ぎ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'り' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(66522 , N'滅茶滅茶' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'めちゃめちゃ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'め' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ちゃ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'め' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ちゃ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(208134 , N'離れ離れ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'かれがれ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'が' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'れ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'が' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'れ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(7259 , N'何時何時' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'いついつ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'い' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'つ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'い' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'つ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(7263 , N'何時何時' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'いつなんどき' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'い' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'つ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'なん' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'どき' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(731 , N'然う然う' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'そうそう' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'そ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'う' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'そ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'う' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(496 , N'限り限り' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ぎりぎり' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ぎ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'り' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ぎ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'り' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(7212 , N'何れ何れ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'どれどれ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ど' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'れ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ど' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'れ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--,(160707 , N'嗚呼嗚呼' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'ああああ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS, N'あ' collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS)
--)as upd (entry_n,kanji,reading,r1,r2,r3,r4)
--on c.entry_n=upd.entry_n and c.kanji=upd.kanji and c.reading=upd.reading
--update jmdict_separated_charas set cr1=N'い'collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS
--,cr2=N'なか'collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS
--,cr4=N'ぺ'collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS
--,cr5=N''
--where entry_n=112031
--and kanji=N'田舎っ兵衛'collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS
--and reading = N'いなかっぺ'collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS
--update jmdict_separated_charas set cr1=N'お'collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS
--,cr2='',cr4=N'みず'collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS
--where entry_n=175438
--and kanji=N'変若ち水'collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS
--and reading = N'おちみず'collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS

--update jmdict_separated_charas set
--cr1=case when cr1 is null then nullif(substring(reading,1,1),'')else cr1 end,
--cr2=case when cr2 is null then nullif(substring(reading,2,1),'')else cr2 end,
--cr3=case when cr3 is null then nullif(substring(reading,3,1),'')else cr3 end,
--cr4=case when cr4 is null then nullif(substring(reading,4,1),'')else cr4 end,
--cr5=case when cr5 is null then nullif(substring(reading,5,1),'')else cr5 end,
--cr6=case when cr6 is null then nullif(substring(reading,6,1),'')else cr6 end,
--cr7=case when cr7 is null then nullif(substring(reading,7,1),'')else cr7 end,
--cr8=case when cr8 is null then nullif(substring(reading,8,1),'')else cr8 end,
--cr9=case when cr9 is null then nullif(substring(reading,9,1),'')else cr9 end,
--cr10=case when cr10 is null then nullif(substring(reading,10,1),'')else cr10 end,
--cr11=case when cr11 is null then nullif(substring(reading,11,1),'')else cr11 end,
--cr12=case when cr12 is null then nullif(substring(reading,12,1),'')else cr12 end,
--cr13=case when cr13 is null then nullif(substring(reading,13,1),'')else cr13 end,
--cr14=case when cr14 is null then nullif(substring(reading,14,1),'')else cr14 end,
--cr15=case when cr15 is null then nullif(substring(reading,15,1),'')else cr15 end,
--cr16=case when cr16 is null then nullif(substring(reading,16,1),'')else cr16 end,
--cr17=case when cr17 is null then nullif(substring(reading,17,1),'')else cr17 end,
--cr18=case when cr18 is null then nullif(substring(reading,18,1),'')else cr18 end,
--cr19=case when cr19 is null then nullif(substring(reading,19,1),'')else cr19 end,
--cr20=case when cr20 is null then nullif(substring(reading,20,1),'')else cr20 end,
--cr21=case when cr21 is null then nullif(substring(reading,21,1),'')else cr21 end,
--cr22=case when cr22 is null then nullif(substring(reading,22,1),'')else cr22 end,
--cr23=case when cr23 is null then nullif(substring(reading,23,1),'')else cr23 end,
--cr24=case when cr24 is null then nullif(substring(reading,24,1),'')else cr24 end,
--cr25=case when cr25 is null then nullif(substring(reading,25,1),'')else cr25 end,
--cr26=case when cr26 is null then nullif(substring(reading,26,1),'')else cr26 end,
--cr27=case when cr27 is null then nullif(substring(reading,27,1),'')else cr27 end
----* from jmdict_separated_charas
--where cr1 is null
--and len(kanji)=len(reading)
--and
--len(isnull(ct1,'')+isnull(ct2,'')+isnull(ct3,'')+isnull(ct4,'')+isnull(ct5,'')+isnull(ct6,'')+isnull(ct7,'')+isnull(ct8,'')+isnull(ct9,'')+isnull(ct10,'')+
--isnull(ct11,'')+isnull(ct12,'')+isnull(ct13,'')+isnull(ct14,'')+isnull(ct15,'')+isnull(ct16,'')+isnull(ct17,'')+isnull(ct18,'')+isnull(ct19,'')+
--isnull(ct20,'')+isnull(ct21,'')+isnull(ct22,'')+isnull(ct23,'')+isnull(ct24,'')+isnull(ct25,'')+isnull(ct26,'')+isnull(ct27,''))-
--len(replace(isnull(ct1,'')+isnull(ct2,'')+isnull(ct3,'')+isnull(ct4,'')+isnull(ct5,'')+isnull(ct6,'')+isnull(ct7,'')+isnull(ct8,'')+isnull(ct9,'')+isnull(ct10,'')+
--isnull(ct11,'')+isnull(ct12,'')+isnull(ct13,'')+isnull(ct14,'')+isnull(ct15,'')+isnull(ct16,'')+isnull(ct17,'')+isnull(ct18,'')+isnull(ct19,'')+
--isnull(ct20,'')+isnull(ct21,'')+isnull(ct22,'')+isnull(ct23,'')+isnull(ct24,'')+isnull(ct25,'')+isnull(ct26,'')+isnull(ct27,'')
--,'k',''))=
--len(replace(replace(replace(replace(replace(replace(replace(replace(
--replace(replace(replace(replace(replace(replace(replace(replace(replace(
--replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(reading,
--isnull(cr1,''),''),isnull(cr2,''),''),isnull(cr3,''),''),isnull(cr4,''),''),isnull(cr5,''),''),isnull(cr6,''),''),isnull(cr7,''),''),isnull(cr8,''),''),
--isnull(cr9,''),''),isnull(cr10,''),''),isnull(cr11,''),''),isnull(cr12,''),''),isnull(cr13,''),''),isnull(cr14,''),''),isnull(cr15,''),''),isnull(cr16,''),''),
--isnull(cr17,''),''),isnull(cr18,''),''),isnull(cr19,''),''),isnull(cr20,''),''),isnull(cr21,''),''),isnull(cr22,''),''),isnull(cr23,''),''),isnull(cr24,''),''),
--isnull(cr25,''),''),isnull(cr26,''),''),isnull(cr27,''),''))
--and not
--(ct1='h'and substring(reading,1,1)!=isnull(cr1,substring(reading,1,1)) or
--ct2='h'and substring(reading,2,1)!=isnull(cr2,substring(reading,2,1)) or
--ct3='h'and substring(reading,3,1)!=isnull(cr3,substring(reading,3,1)) or
--ct4='h'and substring(reading,4,1)!=isnull(cr4,substring(reading,4,1)) or
--ct5='h'and substring(reading,5,1)!=isnull(cr5,substring(reading,5,1)) or
--ct6='h'and substring(reading,6,1)!=isnull(cr6,substring(reading,6,1)) or
--ct7='h'and substring(reading,7,1)!=isnull(cr7,substring(reading,7,1)) or
--ct8='h'and substring(reading,8,1)!=isnull(cr8,substring(reading,8,1)) or
--ct9='h'and substring(reading,9,1)!=isnull(cr9,substring(reading,9,1)) or
--ct10='h'and substring(reading,10,1)!=isnull(cr10,substring(reading,10,1)) or
--ct11='h'and substring(reading,11,1)!=isnull(cr11,substring(reading,11,1)) or
--ct12='h'and substring(reading,12,1)!=isnull(cr12,substring(reading,12,1)) or
--ct13='h'and substring(reading,13,1)!=isnull(cr13,substring(reading,13,1)) or
--ct14='h'and substring(reading,14,1)!=isnull(cr14,substring(reading,14,1)) or
--ct15='h'and substring(reading,15,1)!=isnull(cr15,substring(reading,15,1)) or
--ct16='h'and substring(reading,16,1)!=isnull(cr16,substring(reading,16,1)) or
--ct17='h'and substring(reading,17,1)!=isnull(cr17,substring(reading,17,1)) or
--ct18='h'and substring(reading,18,1)!=isnull(cr18,substring(reading,18,1)) or
--ct19='h'and substring(reading,19,1)!=isnull(cr19,substring(reading,19,1)) or
--ct20='h'and substring(reading,20,1)!=isnull(cr20,substring(reading,20,1)) or
--ct21='h'and substring(reading,21,1)!=isnull(cr21,substring(reading,21,1)) or
--ct22='h'and substring(reading,22,1)!=isnull(cr22,substring(reading,22,1)) or
--ct23='h'and substring(reading,23,1)!=isnull(cr23,substring(reading,23,1)) or
--ct24='h'and substring(reading,24,1)!=isnull(cr24,substring(reading,24,1)) or
--ct25='h'and substring(reading,25,1)!=isnull(cr25,substring(reading,25,1)) or
--ct26='h'and substring(reading,26,1)!=isnull(cr26,substring(reading,26,1)) or
--ct27='h'and substring(reading,27,1)!=isnull(cr27,substring(reading,27,1))
--)
----order by len(reading) desc
----select 'ct'+convert(varchar(2),b10)+'=''h''and substring(reading,'+convert(varchar(2),b10)+',1)!=cr'+convert(varchar(2),b10)+' or'
----from miscellaneous..numbers_64k where b10 between 1 and 27
----order by b10
----select 'cr'+convert(varchar(2),b10)+'=case when cr'+convert(varchar(2),b10)+' is null then nullif(substring(reading,'+convert(varchar(2),b10)+',1),'''')else cr'+convert(varchar(2),b10)+' end,'
----from miscellaneous..numbers_64k where b10 between 1 and 27
----order by b10

select';with cte as
(
select distinct
stuff(r.reading,len(r.reading)-len(ender.ender)+1,len(ender.endersandhi),ender.endersandhi)upd
,c.entry_n
from jmdict_separated_charas c
join kanjidic2_readings_ja_2 r on r.literal=c.c'+convert(varchar(2),main.b10)+'
left join #kanasandhi ender on ender.ender=right(r.reading,len(ender.ender))
	and ender.startersandhi=substring(c.reading,len(c.cr'+convert(varchar(2),main.b10-1)+')+len(r.reading)-len(ender.ender)+len(ender.endersandhi),len(ender.startersandhi))
where cr'+convert(varchar(2),main.b10-1)+' is not null and c'+convert(varchar(2),main.b10)+' is not null and cr'+convert(varchar(2),main.b10)+' is null
and c.reading like '+replace('c.cr'+replace(string_agg(sub.b10,'|')within group (order by sub.b10),'|','+c.cr'),'c.cr0+','')+'+stuff(r.reading,len(r.reading)-len(ender.ender)+1,len(ender.endersandhi),ender.endersandhi)+N''%''
)
update c set c.cr'+convert(varchar(2),main.b10)+'=cte.upd,c.ct'+convert(varchar(2),main.b10)+'=''ks''
--select *
from jmdict_separated_charas c
join cte on cte.entry_n=c.entry_n
where c.cr'+convert(varchar(2),main.b10)+' is null and c.ct'+convert(varchar(2),main.b10)+'=''k''and c.c'+convert(varchar(2),main.b10)+' is not null and c.cr'+convert(varchar(2),main.b10-1)+' is not null
'
from miscellaneous..numbers_64k main
join miscellaneous..numbers_64k sub on sub.b10 between 0 and main.b10-1
where main.b10 between 1 and 27
group by main.b10
order by main.b10
--^possibly incorrect, but worked anyway. Following is probably the correct code:
--select';with cte as
--(
--select distinct
--stuff(r.reading,len(r.reading)-len(ender.ender)+1,len(ender.endersandhi),ender.endersandhi)upd
--,c.entry_n
--from jmdict_separated_charas c
--join kanjidic2_readings_ja_2 r on r.literal=c.c'+convert(varchar(2),main.b10)+'
--left join #kanasandhi ender on ender.ender=right(r.reading,len(ender.ender))
--	and ender.startersandhi=substring(c.reading,len('+replace('c.cr'+replace(string_agg(sub.b10,'|')within group (order by sub.b10),'|','+c.cr'),'c.cr0+','')+')+len(r.reading)-len(ender.ender)+len(ender.endersandhi),len(ender.startersandhi))
--where cr'+convert(varchar(2),main.b10-1)+' is not null and c'+convert(varchar(2),main.b10)+' is not null and cr'+convert(varchar(2),main.b10)+' is null
--and c.reading like '+replace('c.cr'+replace(string_agg(sub.b10,'|')within group (order by sub.b10),'|','+c.cr'),'c.cr0+','')+'+stuff(r.reading,len(r.reading)-len(ender.ender)+1,len(ender.endersandhi),ender.endersandhi)+N''%''
--)
--update c set c.cr'+convert(varchar(2),main.b10)+'=cte.upd,c.ct'+convert(varchar(2),main.b10)+'=''ks''
----select *
--from jmdict_separated_charas c
--join cte on cte.entry_n=c.entry_n
--where c.cr'+convert(varchar(2),main.b10)+' is null and c.ct'+convert(varchar(2),main.b10)+'=''k''and c.c'+convert(varchar(2),main.b10)+' is not null and c.cr'+convert(varchar(2),main.b10-1)+' is not null
--'
--from miscellaneous..numbers_64k main
--join miscellaneous..numbers_64k sub on sub.b10 between 0 and main.b10-1
--where main.b10 between 1 and 27
--group by main.b10
--order by main.b10



select'
;with cte as
(
select distinct
stuff(r.reading,1,len(starter.starter),starter.startersandhi)upd
,c.entry_n
from jmdict_separated_charas c
join kanjidic2_readings_ja_2 r on r.literal=c.c'+convert(varchar(2),main.b10)+'
left join #kanasandhi starter on starter.starter=left(r.reading,len(starter.starter))
	and starter.endersandhi=right(c.cr'+convert(varchar(2),main.b10-1)+',len(starter.endersandhi))
where cr'+convert(varchar(2),main.b10-1)+' is not null and c'+convert(varchar(2),main.b10)+' is not null and cr'+convert(varchar(2),main.b10)+' is null
and c.reading like '+replace('c.cr'+replace(string_agg(sub.b10,'|')within group (order by sub.b10),'|','+c.cr'),'c.cr0+','')+'+stuff(r.reading,1,len(starter.starter),starter.startersandhi)+N''%''
)
update c set c.cr'+convert(varchar(2),main.b10)+'=cte.upd,c.ct'+convert(varchar(2),main.b10)+'=''ks''
--select *
from cte
join jmdict_separated_charas c on cte.entry_n=c.entry_n
where c.cr'+convert(varchar(2),main.b10)+' is null and c.ct'+convert(varchar(2),main.b10)+'=''k''and c.c'+convert(varchar(2),main.b10)+' is not null and c.cr'+convert(varchar(2),main.b10-1)+' is not null
'
from miscellaneous..numbers_64k main
join miscellaneous..numbers_64k sub on sub.b10 between 0 and main.b10-1
where main.b10 between 1 and 27
group by main.b10
order by main.b10

--select * from jmdict_separated_charas --where cr2 is null and c2 is not null
--where reading!=
--cr1
--+iif(c2 is null,'',cr2)
--+iif(c3 is null,'',cr3)
--+iif(c4 is null,'',cr4)
--+iif(c5 is null,'',cr5)
--+iif(c6 is null,'',cr6)
--+iif(c7 is null,'',cr7)
--+iif(c8 is null,'',cr8)
--+iif(c9 is null,'',cr9)
--+iif(c10 is null,'',cr10)
--+iif(c11 is null,'',cr11)
--+iif(c12 is null,'',cr12)
--+iif(c13 is null,'',cr13)
--+iif(c14 is null,'',cr14)
--+iif(c15 is null,'',cr15)
--+iif(c16 is null,'',cr16)
--+iif(c17 is null,'',cr17)
--+iif(c18 is null,'',cr18)
--+iif(c19 is null,'',cr19)
--+iif(c20 is null,'',cr20)
--+iif(c21 is null,'',cr21)
--+iif(c22 is null,'',cr22)
--+iif(c23 is null,'',cr23)
--+iif(c24 is null,'',cr24)
--+iif(c25 is null,'',cr25)
--+iif(c26 is null,'',cr26)
--+iif(c27 is null,'',cr27)
--order by 1,2,3
select 'update jmdict_separated_charas set cr'+convert(varchar(2),b10)+'=null,ct'+convert(varchar(2),b10)+'=''k'' where ct'+convert(varchar(2),b10)+' in (''k'',''ks'',''k1'')'
from miscellaneous..numbers_64k where b10 between 1 and 27
order by b10
select N'isnull(c'+convert(varchar(2),b10)+N','''')=N''ン'' or'
from miscellaneous..numbers_64k where b10 between 1 and 27
order by b10

select'
;with cte as
(
select distinct
stuff(
	(stuff(r.reading,1,len(starter.starter),starter.startersandhi))
	,len((stuff(r.reading,1,len(starter.starter),starter.startersandhi)))-len(ender.ender)+1
	,len(ender.endersandhi)
	,ender.endersandhi
	) upd
,c.entry_n
from jmdict_separated_charas c
join kanjidic2_readings_ja_2 r on r.literal=c.c'+convert(varchar(2),main.b10)+'
left join #kanasandhi starter on starter.starter=left(r.reading,len(starter.starter))
	and starter.endersandhi=right(c.cr'+convert(varchar(2),main.b10-1)+',len(starter.endersandhi))
left join #kanasandhi ender on ender.ender=right(r.reading,len(ender.ender))
	and ender.startersandhi=substring(c.reading,len('+replace('c.cr'+replace(string_agg(sub.b10,'|')within group (order by sub.b10),'|','+c.cr'),'c.cr0+','')+')+len(r.reading)-len(starter.starter)+len(starter.startersandhi)-len(ender.ender)+len(ender.endersandhi)+1,len(ender.startersandhi))
where cr'+convert(varchar(2),main.b10-1)+' is not null and c'+convert(varchar(2),main.b10)+' is not null and cr'+convert(varchar(2),main.b10)+' is null and len(starter.starter+ender.ender)<=len(r.reading)
and c.reading like '+replace('c.cr'+replace(string_agg(sub.b10,'|')within group (order by sub.b10),'|','+c.cr'),'c.cr0+','')+'+
stuff(
	(stuff(r.reading,1,len(starter.starter),starter.startersandhi))
	,len((stuff(r.reading,1,len(starter.starter),starter.startersandhi)))-len(ender.ender)+1
	,len(ender.endersandhi)
	,ender.endersandhi
	)+N''%''
)
--update c set c.cr'+convert(varchar(2),main.b10)+'=cte.upd,c.ct'+convert(varchar(2),main.b10)+'=''ks''
select *
from cte
join jmdict_separated_charas c on cte.entry_n=c.entry_n
where c.cr'+convert(varchar(2),main.b10)+' is null and c.ct'+convert(varchar(2),main.b10)+'=''k''and c.c'+convert(varchar(2),main.b10)+' is not null and c.cr'+convert(varchar(2),main.b10-1)+' is not null
'
from miscellaneous..numbers_64k main
join miscellaneous..numbers_64k sub on sub.b10 between 0 and main.b10-1
where main.b10 between 1 and 27
group by main.b10
order by main.b10

--select 
--'update jmdict_separated_charas set ct'+convert(varchar(2),b10)+'=''h'' where c'+convert(varchar(2),b10)+'=cr'+convert(varchar(2),b10)+''
--from miscellaneous..numbers_64k where b10 between 1 and 27
--order by b10
update jmdict_separated_charas set ct1='h' where c1=cr1
update jmdict_separated_charas set ct2='h' where c2=cr2
update jmdict_separated_charas set ct3='h' where c3=cr3
update jmdict_separated_charas set ct4='h' where c4=cr4
update jmdict_separated_charas set ct5='h' where c5=cr5
update jmdict_separated_charas set ct6='h' where c6=cr6
update jmdict_separated_charas set ct7='h' where c7=cr7
update jmdict_separated_charas set ct8='h' where c8=cr8
update jmdict_separated_charas set ct9='h' where c9=cr9
update jmdict_separated_charas set ct10='h' where c10=cr10
update jmdict_separated_charas set ct11='h' where c11=cr11
update jmdict_separated_charas set ct12='h' where c12=cr12
update jmdict_separated_charas set ct13='h' where c13=cr13
update jmdict_separated_charas set ct14='h' where c14=cr14
update jmdict_separated_charas set ct15='h' where c15=cr15
update jmdict_separated_charas set ct16='h' where c16=cr16
update jmdict_separated_charas set ct17='h' where c17=cr17
update jmdict_separated_charas set ct18='h' where c18=cr18
update jmdict_separated_charas set ct19='h' where c19=cr19
update jmdict_separated_charas set ct20='h' where c20=cr20
update jmdict_separated_charas set ct21='h' where c21=cr21
update jmdict_separated_charas set ct22='h' where c22=cr22
update jmdict_separated_charas set ct23='h' where c23=cr23
update jmdict_separated_charas set ct24='h' where c24=cr24
update jmdict_separated_charas set ct25='h' where c25=cr25
update jmdict_separated_charas set ct26='h' where c26=cr26
update jmdict_separated_charas set ct27='h' where c27=cr27

select'
;with cte as
(
select entry_n,c'+convert(varchar(2),main.b10)+',r.reading upd,ROW_NUMBER()over(partition by entry_n,c'+convert(varchar(2),main.b10)+' order by len(r.reading) desc) rn,kanji,d.reading fullread
from jmdict_separated_charas d
join kanjidic2_readings_ja_2 r
	on r.literal=d.c'+convert(varchar(2),main.b10)+'
where d.reading like ''%''+r.reading
	and d.cr'+convert(varchar(2),main.b10)+' is null and d.ct'+convert(varchar(2),main.b10)+' = ''k''
	and d.cr'+convert(varchar(2),main.b10-1)+' is null and len(d.kanji)='+convert(varchar(2),main.b10)+'
--group by entry_n,c'+convert(varchar(2),main.b10)+'
)
update d set d.cr'+convert(varchar(2),main.b10)+' = r.upd
from jmdict_separated_charas d
join cte r on r.entry_n = d.entry_n and r.c'+convert(varchar(2),main.b10)+' = d.c'+convert(varchar(2),main.b10)+'
where rn=1 and d.cr'+convert(varchar(2),main.b10)+' is null and d.ct'+convert(varchar(2),main.b10)+' = ''k''
'
from miscellaneous..numbers_64k main
where main.b10 between 1 and 27
order by main.b10

--select'
--;with cte as
--(
--select entry_n,c'+convert(varchar(2),main.b10)+',r.reading upd
--,ROW_NUMBER()over(partition by entry_n,c'+convert(varchar(2),main.b10)+' order by len(r.reading) desc) rn
--,kanji,d.reading fullread
--from jmdict_separated_charas d
--join kanjidic2_readings_ja_2 r
--	on r.literal=d.c'+convert(varchar(2),main.b10)+'
--where d.reading like ''%''+r.reading+iif(d.c'+
--replace(replace(string_agg(convert(varchar(2),sub.b10)+'``'+convert(varchar(2),sub.b10),'|')within group (order by sub.b10),'``',' is not null,d.cr')
--,'|','+iif(d.c')+string_agg('',','''')')+'
--	and d.cr'+convert(varchar(2),main.b10)+' is null and d.ct'+convert(varchar(2),main.b10)+' = ''k''
----group by entry_n,c'+convert(varchar(2),main.b10)+'
--)
--update d set d.cr'+convert(varchar(2),main.b10)+' = r.upd
--from jmdict_separated_charas d
--join cte r on r.entry_n = d.entry_n and r.c'+convert(varchar(2),main.b10)+' = d.c'+convert(varchar(2),main.b10)+'
--where rn=1 and d.cr'+convert(varchar(2),main.b10)+' is null and d.ct'+convert(varchar(2),main.b10)+' = ''k''
--'
--from miscellaneous..numbers_64k main
--join miscellaneous..numbers_64k sub on sub.b10 between 0 and main.b10-1
--where main.b10 between 1 and 27
--group by main.b10
--order by main.b10
--^didn't work cuz iif/case statement can only go 10 levels. Alt logic seems to have worked:
select'
;with cte as
(
select entry_n,c'+convert(varchar(2),main.b10)+',r.reading upd
,ROW_NUMBER()over(partition by entry_n,c'+convert(varchar(2),main.b10)+' order by len(r.reading) desc) rn
,kanji,d.reading fullread
from jmdict_separated_charas d
join kanjidic2_readings_ja_2 r
	on r.literal=d.c'+convert(varchar(2),main.b10)+'
where (isnull(''|''+d.c'+replace(string_agg(convert(varchar(2),sub.b10),'|')within group (order by sub.b10),'|',',''`'')+isnull(''|''+d.c')+',''`''))not like ''%`|%''
and d.reading like ''%''+r.reading+isnull(d.c'+
replace(string_agg(convert(varchar(2),sub.b10),'|')within group (order by sub.b10),'|',','''')+isnull(d.c')+','''')
	and d.cr'+convert(varchar(2),main.b10)+' is null and d.ct'+convert(varchar(2),main.b10)+' = ''k''
--group by entry_n,c'+convert(varchar(2),main.b10)+'
)
update d set d.cr'+convert(varchar(2),main.b10)+' = r.upd
from jmdict_separated_charas d
join cte r on r.entry_n = d.entry_n and r.c'+convert(varchar(2),main.b10)+' = d.c'+convert(varchar(2),main.b10)+'
where rn=1 and d.cr'+convert(varchar(2),main.b10)+' is null and d.ct'+convert(varchar(2),main.b10)+' = ''k''
'
from miscellaneous..numbers_64k main
join miscellaneous..numbers_64k sub on sub.b10 between main.b10+1 and 27
where main.b10 between 1 and 27
group by main.b10
order by main.b10
