--drop table if exists kanjidic2_readings_ja
--select	r.literal collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS	literal
--	,	r.r_type
--	,	r.reading collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS	reading
--	,	r.reading collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS	hiragana_reading
--	------,	r.reading collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS	starter
--	------,	r.reading collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS	ender
--into kanjidic2_readings_ja
--from kanjidic2_readings_corrected r
--where r_type in ('ja_on','ja_kun')
----select * from kanjidic2_readings_corrected where literal=N'与'
--insert into kanjidic2_readings_ja(literal,r_type,reading,hiragana_reading/*,ender,starter*/)
--select distinct literal
--	,	r_type
--	,	r.reading
--	--,	left(replace(r.reading+N'.',N'-',N''),charindex(N'.',replace(r.reading+N'.',N'-',N''))-1)reading
--	,	left(replace(r.hiragana_reading+N'.',N'-',N''),charindex(N'.',replace(r.hiragana_reading+N'.',N'-',N''))-1)hiragana_reading
--/*	,	r.reading ender,	r.reading starter*/
--from kanjidic2_readings_ja r
--update r set --r.reading=replace(replace(reading,N'-',N''),N'.',N''),
--			r.hiragana_reading=replace(replace(hiragana_reading,N'-',N''),N'.',N'') from kanjidic2_readings_ja r
--update r set r.hiragana_reading=replace(hiragana_reading,N'ン',N'ん') from kanjidic2_readings_ja r
--declare @hiragana nvarchar(5)= (select min(kana) from kana_unwrapped where descr like'%hiragana%')collate Japanese_Bushu_Kakusu_140_CS_AS_KS_WS_VSS
--while exists (select 1 from kana_unwrapped where kana>@hiragana and descr like'%hiragana%')
--	begin
--	update kanjidic2_readings_ja set hiragana_reading=
--	replace(hiragana_reading collate Japanese_Bushu_Kakusu_140_CS_AS_WS_VSS,@hiragana collate Japanese_Bushu_Kakusu_140_CS_AS_WS_VSS,@hiragana collate Japanese_Bushu_Kakusu_140_CS_AS_WS_VSS)
--	set @hiragana=(select min(kana) from kana_unwrapped where descr like'%hiragana%' and kana>@hiragana)
--	end
--;with cte as (select *,row_number()over(partition by literal,r_type,reading,hiragana_reading order by hiragana_reading)rn from kanjidic2_readings_ja) delete from cte where rn=2

--select * from kanjidic2_readings_ja order by 1,2,3
--select * from jmdict_kanji_unwrapped

--drop table if exists jmdict_kanji_unwrapped_stage1
--select distinct 
--	jdict.entry_n vocab_ent_n
--	,jdict.ent_seq vocab_ent_seq
--	,jdict.kanji vocab_kanji
--	--,jdict.kanji_w_hiragana_only vocab_kanji_hiragana_only
--	--,jdict.no_kana vocab_kanji_nokana
--	--,jdict.reading vocab_reading
--	,jdict.hiragana_reading vocab_reading_hiragana
--	,jdict.n kanjichar_index
--	,r.literal kanjichar
--	,r.r_type kanjichar_r_type
--	--,r.reading kanjichar_reading
--	,r.hiragana_reading kanjichar_reading_hiragana
--into jmdict_kanji_unwrapped_stage1
--from jmdict_kanji_unwrapped jdict
--left join kanjidic2_readings_ja r on r.literal=jdict.kanji_char
--update a set kanjichar_r_type='both' from jmdict_kanji_unwrapped_stage1 a where exists
--(select 1 from jmdict_kanji_unwrapped_stage1 b
--where a.vocab_ent_n=b.vocab_ent_n and a.kanjichar_index=b.kanjichar_index and a.kanjichar_reading_hiragana=b.kanjichar_reading_hiragana
--group by vocab_ent_n,kanjichar_index,kanjichar_reading_hiragana having count(*)>1)
--;with cte as (select ROW_NUMBER()over(partition by vocab_ent_n,kanjichar_index,kanjichar_reading_hiragana order by (select 1))rn from jmdict_kanji_unwrapped_stage1)
--delete cte where rn>1
--this is the composite primary key basically:
select distinct vocab_ent_n,kanjichar_index,kanjichar_reading_hiragana from jmdict_kanji_unwrapped_stage1
--select vocab_ent_n,kanjichar_index
--,LAG(kanjichar_reading_hiragana,1,'')over(partition by vocab_ent_n,kanjichar_index order by kanjichar_reading_hiragana)prev_reading
--,ISNULL(kanjichar_reading_hiragana,'')reading
--,LEAD(kanjichar_reading_hiragana,1,'')over(partition by vocab_ent_n,kanjichar_index order by kanjichar_reading_hiragana)nxt_reading
--from jmdict_kanji_unwrapped_stage1 q
--order by vocab_ent_n,kanjichar_index,kanjichar_reading_hiragana

--if middle chars don't match then it's definitely not about sandhi, so remove such entries.. yes this means all false positive 2-char length readings, but it's a start
drop table if exists jmdict_kanji_unwrapped_stage2
select * into jmdict_kanji_unwrapped_stage2
from jmdict_kanji_unwrapped_stage1 a
left join (select distinct starter from kana_sandhi s where starter!='') s on left(a.kanjichar_reading_hiragana,1)=s.starter
left join (select distinct ender from kana_sandhi e where ender!='') e on right(a.kanjichar_reading_hiragana,1)=e.ender
where (s.starter is not null or e.ender is not null)
--and a.vocab_reading_hiragana like N'%'+replace(replace(a.kanjichar_reading_hiragana,isnull(s.starter,'~'),''),isnull(e.ender,'~'),'')+N'%'
and a.vocab_reading_hiragana like N'%'+
stuff(
	isnull(stuff(a.kanjichar_reading_hiragana,len(a.kanjichar_reading_hiragana)-len(e.ender)+1,len(e.ender),N''),a.kanjichar_reading_hiragana)
	,1,len(s.starter),'')
+N'%'
select * from jmdict_kanji_unwrapped_stage2 order by 1,2,3,4,5,6,7
--select * from kana_sandhi
--select stuff('abcd',4,0,'')
declare @n bigint =0
set nocount on;
while (@n*500 <=229000)
begin
--select count(distinct vocab_ent_n) from jmdict_kanji_unwrapped_stage2
print convert(nvarchar(10),@n)
;with kanasandhi as
(select distinct * from kana_sandhi where starter!='' and ender!='' union
 select distinct ender,starter+kana,endersandhi,startersandhi+kana,sandhitype from kana_unwrapped join kana_sandhi on kana_sandhi.starter='' union
 select distinct ender+kana,starter,endersandhi+kana,startersandhi,sandhitype from kana_unwrapped join kana_sandhi on kana_sandhi.ender='')
,sandhis as
(	select distinct stuff(enders.kanjichar_reading_hiragana,len(enders.kanjichar_reading_hiragana)-len(s.ender)+1,len(s.ender),s.endersandhi)e_hiragana
				,   stuff(starters.kanjichar_reading_hiragana,1,len(s.starter),s.startersandhi)s_hiragana
				,	enders.kanjichar_index e_kanji_index,starters.kanjichar_index s_kanji_index
				,	enders.vocab_ent_n
				,	s.ender,s.starter
				,	enders.kanjichar_reading_hiragana e_std_reading, starters.kanjichar_reading_hiragana s_std_reading
	from jmdict_kanji_unwrapped_stage2 starters
	join jmdict_kanji_unwrapped_stage2 enders on enders.vocab_ent_n=starters.vocab_ent_n and enders.kanjichar_index=starters.kanjichar_index-1
	join kanasandhi s on 
		--charindex( s.endersandhi + s.startersandhi,starters.vocab_reading_hiragana )>0
		s.ender=right(enders.kanjichar_reading_hiragana,len(s.ender))and s.starter=left(starters.kanjichar_reading_hiragana,len(s.starter))and
		charindex(stuff(enders.kanjichar_reading_hiragana,len(enders.kanjichar_reading_hiragana)-len(s.ender)+1,len(s.ender),s.endersandhi)
				+stuff(starters.kanjichar_reading_hiragana,1,len(s.starter),s.startersandhi),starters.vocab_reading_hiragana )>0
		--and s.ender=right(enders.kanjichar_reading_hiragana,len(s.ender))
		--and s.starter=left(starters.kanjichar_reading_hiragana,len(s.starter))
		--charindex( case when s.endersandhi='' then right(enders.kanjichar_reading_hiragana,1)else s.endersandhi end
		--		 + case when s.startersandhi='' then left(starters.kanjichar_reading_hiragana,1)else s.startersandhi end
		--		,starters.vocab_reading_hiragana )>0
	--maybe in another cte fill kana_sandhi with all chars whereever there's '' in ender or starter in that table.. then maybe this will work..
	--select * from kana_sandhi where starter='' or ender=''
		--and (s.ender=right(enders.kanjichar_reading_hiragana,len(s.ender)) or s.ender='')
		--and (s.starter=left(starters.kanjichar_reading_hiragana,len(s.starter)) or s.starter='')
	where starters.vocab_ent_n between @n*500+1 and (@n+1)*500--=63611--debug
) insert into jmdict_kanji_unwrapped_stage3_rev1
select * from sandhis
set @n=@n+1
end
--where sandhitype='handakuten'
--select * from jmdict_kanji_unwrapped_stage3


------following is attempt to make sure that readings who have sandhis on both ends at same time won't be missed which I think will be missed above:
set nocount on;
drop table if exists #kanasandhi
select distinct *,len(ender)len_ender,len(starter)len_starter,right(ender,1)e,left(starter,1)s
into #kanasandhi from kana_sandhi where starter!='' and ender!='' union
 select distinct ender,starter+kana,endersandhi,startersandhi+kana,sandhitype,len(ender)len_ender,len(starter+kana)len_starter,right(ender,1)e,left(starter+kana,1)s
from kana_unwrapped join kana_sandhi on kana_sandhi.starter='' union
 select distinct ender+kana,starter,endersandhi+kana,startersandhi,sandhitype,len(ender+kana)len_ender,len(starter)len_starter,right(ender+kana,1)e,left(starter,1)s
from kana_unwrapped join kana_sandhi on kana_sandhi.ender=''

drop table if exists #jmdict_kanji_unwrapped_stage2_e_m_s
select 
middles.kanjichar_index middleskanjichar_index,
middles.vocab_ent_n middlesvocab_ent_n,
middles.vocab_reading_hiragana middlesvocab_reading_hiragana,
CASE CHARINDEX(middles.kanjichar,middles.vocab_kanji) WHEN 1 THEN 's' WHEN len(middles.vocab_kanji) THEN 'e' ELSE 'm' END m_position,

isnull(enders.kanjichar_reading_hiragana,substring(middles.vocab_kanji,charindex(middles.kanjichar,middles.vocab_kanji)-1,1)) enderskanjichar_reading_hiragana,
middles.kanjichar_reading_hiragana middleskanjichar_reading_hiragana,
isnull(starters.kanjichar_reading_hiragana,substring(middles.vocab_kanji,charindex(middles.kanjichar,middles.vocab_kanji)+1,1)) starterskanjichar_reading_hiragana,

isnull(right(enders.kanjichar_reading_hiragana,1),substring(middles.vocab_kanji,charindex(middles.kanjichar,middles.vocab_kanji)-1,1))ee,
left(middles.kanjichar_reading_hiragana,1)ms,
right(middles.kanjichar_reading_hiragana,1)me,
isnull(left(starters.kanjichar_reading_hiragana,1),substring(middles.vocab_kanji,charindex(middles.kanjichar,middles.vocab_kanji)+1,1))ss

into #jmdict_kanji_unwrapped_stage2_e_m_s
from jmdict_kanji_unwrapped_stage2 middles
	left join jmdict_kanji_unwrapped_stage2 enders on enders.vocab_ent_n=middles.vocab_ent_n and enders.kanjichar_index=middles.kanjichar_index-1
	left join jmdict_kanji_unwrapped_stage2 starters on middles.vocab_ent_n=starters.vocab_ent_n and middles.kanjichar_index=starters.kanjichar_index-1

--drop table if exists #jmdict_kanji_unwrapped_stage2_e_m_s_2
--select #jmdict_kanji_unwrapped_stage2_e_m_s.*,
--ender_sandhi.starter ender_sandhistarter,
--ender_sandhi.startersandhi ender_sandhistartersandhi,
--ender_sandhi.endersandhi ender_sandhiendersandhi,
--starter_sandhi.ender starter_sandhiender,
--starter_sandhi.startersandhi starter_sandhistartersandhi,
--starter_sandhi.endersandhi starter_sandhiendersandhi
--into #jmdict_kanji_unwrapped_stage2_e_m_s_2
--from #jmdict_kanji_unwrapped_stage2_e_m_s
--join #kanasandhi ender_sandhi	on  (enderskanjichar_reading_hiragana is null or ender_sandhi.e=ee) and ender_sandhi.s=ms
--join #kanasandhi starter_sandhi	on	starter_sandhi.e=me	and (starterskanjichar_reading_hiragana is null or starter_sandhi.s=ss)
--select 
--					stuff(
--						 stuff(middleskanjichar_reading_hiragana,1,len(ender_sandhi.starter),ender_sandhi.startersandhi)
--						,len(stuff(middleskanjichar_reading_hiragana,1,len(ender_sandhi.starter),ender_sandhi.startersandhi))-len(starter_sandhi.ender)+1
--						,len(starter_sandhi.ender),starter_sandhi.endersandhi)
--					,middleskanjichar_reading_hiragana)
--from #jmdict_kanji_unwrapped_stage2_e_m_s
declare @n bigint =0
while (@n*500 <=229000)
begin
--select count(distinct vocab_ent_n) from jmdict_kanji_unwrapped_stage2
print convert(nvarchar(10),@n)
--;with kanasandhi as
;with sandhis as
(	select distinct 
	--	stuff(enders.kanjichar_reading_hiragana,len(enders.kanjichar_reading_hiragana)-len(ender_sandhi.ender)+1,len(ender_sandhi.ender),ender_sandhi.endersandhi) e_hiragana
		stuff(stuff(middleskanjichar_reading_hiragana,1,ender_sandhi.len_starter,ender_sandhi.startersandhi)
			,len(stuff(middleskanjichar_reading_hiragana,1,ender_sandhi.len_starter,ender_sandhi.startersandhi))-starter_sandhi.len_ender+1
			,starter_sandhi.len_ender,starter_sandhi.endersandhi) m_hiragana
	--,	stuff(starters.kanjichar_reading_hiragana,1,len(starter_sandhi.starter),starter_sandhi.startersandhi) s_hiragana
	--,	enders.kanjichar_index e_kanji_index
	,	middleskanjichar_index m_kanji_index
	--,	starters.kanjichar_index s_kanji_index
	,	middlesvocab_ent_n
	,	middlesvocab_reading_hiragana
	--,	enders.kanjichar_reading_hiragana e_std_reading
	,	middleskanjichar_reading_hiragana m_std_reading
	--,	starters.kanjichar_reading_hiragana s_std_reading
	,	iif(m_position = 's','', ender_sandhi.endersandhi) endersandhi, ender_sandhi.startersandhi m_starter
	,	starter_sandhi.endersandhi m_ender, iif(m_position = 'e','',starter_sandhi.startersandhi) startersandhi
	from #jmdict_kanji_unwrapped_stage2_e_m_s
	join #kanasandhi ender_sandhi	on  (enderskanjichar_reading_hiragana is null or ender_sandhi.e=ee) and ender_sandhi.s=ms
	join #kanasandhi starter_sandhi	on	starter_sandhi.e=me	and (starterskanjichar_reading_hiragana is null or starter_sandhi.s=ss)
	where middlesvocab_ent_n between @n*500+1 and (@n+1)*500
	and	charindex(
			--	stuff(enders.kanjichar_reading_hiragana,len(enders.kanjichar_reading_hiragana)-len(ender_sandhi.ender)+1,len(ender_sandhi.ender),ender_sandhi.endersandhi)
				iif(m_position = 's','', ender_sandhi.endersandhi)
			+	nullif(stuff(
						 stuff(middleskanjichar_reading_hiragana,1,ender_sandhi.len_starter,ender_sandhi.startersandhi)
						,len(stuff(middleskanjichar_reading_hiragana,1,ender_sandhi.len_starter,ender_sandhi.startersandhi))-starter_sandhi.len_ender+1
						,starter_sandhi.len_ender,starter_sandhi.endersandhi)
					,middleskanjichar_reading_hiragana)
			+	iif(m_position = 'e','',starter_sandhi.startersandhi)
			--	+stuff(starters.kanjichar_reading_hiragana,1,len(starter_sandhi.starter),ender_sandhi.endersandhi)
		,middlesvocab_reading_hiragana)>0
)
insert into jmdict_kanji_unwrapped_stage3_rev2
select * from sandhis
set @n=@n+1
end
